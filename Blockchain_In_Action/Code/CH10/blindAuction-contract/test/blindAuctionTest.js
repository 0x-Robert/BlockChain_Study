const BlindAuction = artifacts.require('../contracts/BlindAuction.sol')
const truffleAssert = require('truffle-assertions');

//
// Mocha is the testing framework (it, describe, beforeEach)
// Chai is the assertion library used
// truffle-assertion is used to check the reverts by the contract
//
// describe() are:
// - commonly known as test suites, which contains test cases
// - merely groups, and you can have groups within groups
//
// it() is a test case
//
// beforeEach() is a hooks that runs before each it() or describe().
//
// Async and Await are extensions of promises
// An async function can contain an await expression that pauses the execution of
// the async function and waits for the passed Promise's resolution, and then
// resumes the async function's execution and returns the resolved value.
// Remember, the await keyword is only valid inside async functions.
//
// Good links to understand Async Await and event proposal -
// - https://hackernoon.com/understanding-async-await-in-javascript-1d81bb079b2c
// - https://www.youtube.com/watch?v=XzXIMZMN9k4
//


// Can not reset ethers of the accounts before each unit test as truffle does not
// support this. Hence using different accounts when needed for testing.
contract('BlindAuction', function (accounts) {

  const success = '0x01'
  let blindAuction
  const onlyBeneficiaryError = 'Only beneficiary can perform this action'
  const validPhaseError = 'Invalid phase'
  const badRevealError = 'not matching bid'

  // Bidding ammount placeholders in ether for fast modification.
  let BID1 = 1
  let BID2 = 2
  let BID3 = 3

  // Account placeholders to circulate user accounts for testing.
  let BEN = accounts[0]
  let ACC1 = accounts[3]
  let ACC2 = accounts[4]
  let ACC3 = accounts[5]

  beforeEach('Setup contract for each test', async function () {
    blindAuction = await BlindAuction.new();
  });

  describe('Initialization and Phase Change.', async ()=>{
    it('Success on initialization to bidding phase.', async function () {
      let phase = await blindAuction.currentPhase();
      assert.equal(phase, 1);
    });

    it('Success on phase change by beneficiary.', async function () {
      // Advancing phase to REVEAL
      let result = await blindAuction.advancePhase();
      assert.equal(result.receipt.status, success);
      let phase = await blindAuction.currentPhase();
      assert.equal(phase, 2);

      // Advancing phase to DONE
      result = await blindAuction.advancePhase();
      assert.equal(result.receipt.status, success);
      phase = await blindAuction.currentPhase();
      assert.equal(phase, 3);
    });

    it('Success on change from DONE phase to INIT phase.', async function () {
      
      //BIDDING -> REVEAL
      await blindAuction.advancePhase();

      //REVEAL -> DONE
      await blindAuction.advancePhase();

      //DONE -> INIT
      await blindAuction.advancePhase();
      let phase = await blindAuction.currentPhase();
      assert.equal(phase, 0);
    });

    it('Failure on phase change by a non-beneficiary.', async function () {
      await truffleAssert.fails(
        blindAuction.advancePhase({ from: accounts[1]}),
        // Below line is important as this method should fail only by reversion.
        truffleAssert.ErrorType.REVERT,
        onlyBeneficiaryError,
        onlyBeneficiaryError
      );
    });

  });

  describe('Bidding Phase.', async ()=>{

    it('Success on single bid.', async function () {
      // Before bidding
      let balanceBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));
      
      // Bidding
      let bidInWei = web3.utils.toWei(String(BID1), 'ether');
      let valueInWei = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValue = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidInWei, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue, { from: ACC1, value: valueInWei});

      // After bidding
      let balanceAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));

      assert.isAbove(balanceBefore - balanceAfter, BID1+1);
      assert.isBelow(balanceBefore - balanceAfter, BID1+2);

      // TODO: Sending back ethers for account reusability.

    });

    it('Failure on bid in invalid state.', async function () {
      
      //BIDDING -> REVEAL
      await blindAuction.advancePhase();
      
      // Bidding
      let bidInWei = web3.utils.toWei(String(BID1), 'ether');
      let valueInWei = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValue = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidInWei, web3.utils.fromAscii('key')]));
      // await blindAuction.bid(hashValue, { from: ACC1, value: valueInWei});

      await truffleAssert.fails(
        blindAuction.bid(hashValue, { from: ACC1, value: valueInWei}),
        // Below line is important as this method should fail only by reversion.
        truffleAssert.ErrorType.REVERT,
        null,       // No error reason given in contract, hence null
        validPhaseError
      );

    });

  });

  describe('Reveal Phase.', async ()=>{

    it('Success on refund of difference when sent value is greater than bid amount.', async function () {
      
      // Before bidding
      let balanceBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));
      
      // Bidding
      let bidInWei = web3.utils.toWei(String(BID1), 'ether');
      let valueInWei = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValue = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidInWei, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue, { from: ACC1, value: valueInWei});

      // After bidding
      let balanceMid = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));

      assert.closeTo(balanceBefore - balanceMid, BID1+1, 0.1, 'Ethers sent')

      //BIDDING -> REVEAL
      await blindAuction.advancePhase();

      let result = await blindAuction.reveal(bidInWei, web3.utils.fromAscii('key'), { from: ACC1 });
      assert.equal(result.receipt.status, success)
      let balanceAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));

      assert.closeTo(balanceAfter - balanceMid, 1, 0.01, 'Difference recieved')

    });

    it('Success on refund when sent value is less than bid amount.', async function () {
      // Before bidding
      let balanceBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));
      
      // Bidding
      let bidInWei = web3.utils.toWei(String(BID1+1), 'ether');
      let valueInWei = web3.utils.toWei(String(BID1), 'ether');
      let hashValue = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidInWei, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue, { from: ACC1, value: valueInWei});

      // After bidding
      let balanceMid = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));

      assert.closeTo(balanceBefore - balanceMid, BID1, 0.1, 'Ethers sent')

      //BIDDING -> REVEAL
      await blindAuction.advancePhase();

      // Reveal
      let result = await blindAuction.reveal(bidInWei, web3.utils.fromAscii('key'), { from: ACC1 });
      assert.equal(result.receipt.status, success)
      let balanceAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));

      assert.closeTo(balanceAfter - balanceMid, BID1, 0.01, 'Full value recieved')

    });

    it('Success on refund if bid amount is less than highest bid.', async function () {
      
      // Bidding for bigger amount
      let bidBig = web3.utils.toWei(String(BID2), 'ether');
      let valueBig = web3.utils.toWei(String(BID2+1), 'ether');
      let hashValueBig = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidBig, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValueBig, { from: ACC1, value: valueBig});

      // Bidding for smaller amount
      let bidSmall = web3.utils.toWei(String(BID1), 'ether');
      let valueSmall = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValueSmall = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidSmall, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValueSmall, { from: ACC2, value: valueSmall});
      
      //BIDDING -> REVEAL
      await blindAuction.advancePhase();
      
      // Before bidding
      let balanceBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC2), 'ether'));
      
      // Reveal
      await blindAuction.reveal(bidBig, web3.utils.fromAscii('key'), { from: ACC1 });
      await blindAuction.reveal(bidSmall, web3.utils.fromAscii('key'), { from: ACC2 });
      
      // After bidding
      let balanceAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC2), 'ether'));

      assert.closeTo(balanceAfter - balanceBefore, BID1+1, 0.01, 'Full value recieved')

    });

    it('Failure on incorrect key for reveal.', async function () {
      
      // Bidding
      let bidInWei = web3.utils.toWei(String(BID1), 'ether');
      let valueInWei = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValue = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidInWei, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue, { from: ACC1, value: valueInWei});

      //BIDDING -> REVEAL
      await blindAuction.advancePhase();

      // Reveal
      await truffleAssert.fails(
        blindAuction.reveal(bidInWei, web3.utils.fromAscii('wrongKey'), { from: ACC1 }),
        truffleAssert.ErrorType.REVERT,
        badRevealError,
        badRevealError
      );

    });

    it('Failure on incorrect bid value for reveal.', async function () {
      
      // Bidding
      let bidInWei = web3.utils.toWei(String(BID1), 'ether');
      let badBid = web3.utils.toWei(String(BID1+100), 'ether');
      let valueInWei = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValue = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidInWei, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue, { from: ACC1, value: valueInWei});

      //BIDDING -> REVEAL
      await blindAuction.advancePhase();

      // Reveal
      await truffleAssert.fails(
        blindAuction.reveal(badBid, web3.utils.fromAscii('key'), { from: ACC1 }),
        truffleAssert.ErrorType.REVERT,
        badRevealError,
        badRevealError
      );

    });

    it('Failure on reveal in invalid state.', async function () {
      
      // Bidding
      let bidInWei = web3.utils.toWei(String(BID1), 'ether');
      let badBid = web3.utils.toWei(String(BID1+100), 'ether');
      let valueInWei = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValue = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidInWei, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue, { from: ACC1, value: valueInWei});

      // Reveal
      await truffleAssert.fails(
        blindAuction.reveal(badBid, web3.utils.fromAscii('key'), { from: ACC1 }),
        truffleAssert.ErrorType.REVERT,
        null,       // No error reason given in contract, hence null
        validPhaseError
      );

    });
    
  });

  describe('Withdraw.', async ()=>{

    it('Success on withdraw on loosing bid.', async function () {
      
      // Bidding for bigger amount
      let bidBig = web3.utils.toWei(String(BID2), 'ether');
      let valueBig = web3.utils.toWei(String(BID2+1), 'ether');
      let hashValueBig = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidBig, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValueBig, { from: ACC1, value: valueBig});

      // Bidding for smaller amount
      let bidSmall = web3.utils.toWei(String(BID1), 'ether');
      let valueSmall = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValueSmall = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidSmall, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValueSmall, { from: ACC2, value: valueSmall});
      
      //BIDDING -> REVEAL
      await blindAuction.advancePhase();
      
      // Before bidding
      let balanceBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC2), 'ether'));
      
      // Reveal
      await blindAuction.reveal(bidSmall, web3.utils.fromAscii('key'), { from: ACC2 });
      await blindAuction.reveal(bidBig, web3.utils.fromAscii('key'), { from: ACC1 });
      
      // Withdraw
      await blindAuction.withdraw({ from: ACC2 });
      
      // After withdraw
      let balanceAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC2), 'ether'));

      assert.closeTo(balanceAfter - balanceBefore, BID1+1, 0.01, 'Full value recieved')

    });

  });

  describe('Auction end.', async ()=>{

    it('Success on end of auction on single bid.', async function () {
      
      // Bidding
      let bidInWei = web3.utils.toWei(String(BID1), 'ether');
      let valueInWei = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValue = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bidInWei, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue, { from: ACC1, value: valueInWei});

      //BIDDING -> REVEAL
      await blindAuction.advancePhase();

      // Reveal
      await blindAuction.reveal(bidInWei, web3.utils.fromAscii('key'), { from: ACC1 });

      //REVEAL -> DONE
      await blindAuction.advancePhase();

      // Auction ended
      let result = await blindAuction.auctionEnd();

      // Winner
      assert.equal(result.logs[0].args.winner, ACC1)
      assert.equal(result.logs[0].args.highestBid, bidInWei)

    });

    it('Failure of end of auction in invalid phase.', async function () {

      // Auction ended prematurely
      await truffleAssert.fails(
        blindAuction.auctionEnd(),
        truffleAssert.ErrorType.REVERT,
        null,       // No error reason given in contract, hence null
        validPhaseError
      );

    });

  });
  
  describe('Full Auction Run.', async ()=>{

    it('Success on simulated auction with 3 bidders (accounts).', async function () {

      // Before bidding
      let acc1BalBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));
      let acc2BalBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC2), 'ether'));
      let acc3BalBefore = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC3), 'ether'));
      
      
      // Bidding for account 1
      let bid1 = web3.utils.toWei(String(BID1), 'ether');
      let value1 = web3.utils.toWei(String(BID1+1), 'ether');
      let hashValue1 = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bid1, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue1, { from: ACC1, value: value1});

      // Bidding for account 2
      let bid2 = web3.utils.toWei(String(BID2), 'ether');
      let value2 = web3.utils.toWei(String(BID2+1), 'ether');
      let hashValue2 = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bid2, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue2, { from: ACC2, value: value2});

      // Bidding for account 3
      let bid3 = web3.utils.toWei(String(BID3), 'ether');
      let value3 = web3.utils.toWei(String(BID3+1), 'ether');
      let hashValue3 = web3.utils.keccak256(web3.eth.abi.encodeParameters(['uint','bytes32'],[bid3, web3.utils.fromAscii('key')]));
      await blindAuction.bid(hashValue3, { from: ACC3, value: value3});
      
      //BIDDING -> REVEAL
      await blindAuction.advancePhase();
      
      // Reveal
      await blindAuction.reveal(bid1, web3.utils.fromAscii('key'), { from: ACC1 });
      await blindAuction.reveal(bid2, web3.utils.fromAscii('key'), { from: ACC2 });
      await blindAuction.reveal(bid3, web3.utils.fromAscii('key'), { from: ACC3 });

      //REVEAL -> DONE
      await blindAuction.advancePhase();

      // Auction ended
      let result = await blindAuction.auctionEnd();

      // Withdraw
      await blindAuction.withdraw({ from: ACC1 });
      await blindAuction.withdraw({ from: ACC2 });
      await blindAuction.withdraw({ from: ACC3 });
      
      // After withdraw
      let acc1BalAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC1), 'ether'));
      let acc2BalAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC2), 'ether'));
      let acc3BalAfter = Number(web3.utils.fromWei(await web3.eth.getBalance(ACC3), 'ether'));
      
      // ASSERTIONS

      // Winner
      assert.equal(result.logs[0].args.winner, ACC3)
      assert.equal(result.logs[0].args.highestBid, bid3)

      // Balance
      assert.closeTo(acc1BalBefore, acc1BalAfter, 0.1, 'Full value recieved')
      assert.closeTo(acc2BalBefore, acc2BalAfter, 0.1, 'Full value recieved')
      assert.closeTo(acc3BalBefore - acc3BalAfter, BID3, 0.1, 'Difference recieved')

    });

  });

})
