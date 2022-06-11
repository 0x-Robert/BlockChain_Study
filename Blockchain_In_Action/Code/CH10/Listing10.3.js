const Ballot = artifacts.require('../contracts/Ballot.sol')
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

contract('Ballot', function (accounts) {

  // These are the list of revert responses by the modifiers
  const success = '0x01'
  const validPhaseError = 'Not the required phase'
  const onlyChairpersonError = 'Only chairperson can perform this operation'
  const changeStateError = 'Can only move to greater state'
  const votedError = 'Voter has already voted'
  const wrongProposalError = 'Proposal number over limit'

  let ballot

  // Before execution of each test case we deploy a new ballot contract
  beforeEach('Setup contract for each test', async function () {
    ballot = await Ballot.new(3)
  });

  it('Success on initialization to registration phase.', async function () {
    let state = await ballot.state()
    assert.equal(state, 1)
  });

  describe('Voter registration', function() {
    it('Success on registration of voters by chairperson.', async function () {
      //Allows chairperson to register account 1
      let result = await ballot.register(accounts[1], { from: accounts[0]})
      assert.equal(result.receipt.status, success)
    });

    it('Failure on registration of voters by non-chairperson entity.', async function () {
      //Does not allow account 1 to register account 2
      await truffleAssert.reverts(
        ballot.register(accounts[2], { from: accounts[1]}),
        truffleAssert.ErrorType.REVERT,
        onlyChairpersonError,
        onlyChairpersonError
      )
    });

    it('Failure on registration of voters in invalid phase.', async function () {
      // We change the ballot's state to 2 and 3 and verify that registration is not permitted.
      // vote phase is 2
      // done phase is 3
      var phase = [2, 3];
      for (i of phase) {
        await ballot.changeState(i)
        await truffleAssert.reverts(
          ballot.register(accounts[1], { from: accounts[0]}),
          truffleAssert.ErrorType.REVERT,
          validPhaseError,
          validPhaseError
        )
      }
    });
  });

  describe('Voting', function() {
    beforeEach('Setup contract for each voting test', async function () {
      await ballot.register(accounts[1], { from: accounts[0]})
      await ballot.register(accounts[2], { from: accounts[0]})
    });

    it('Success on vote.', async function () {
      //Registration -> Vote
      await ballot.changeState(2)
      let result = await ballot.vote(1, { from: accounts[1]})
      assert.equal(result.receipt.status, success)
      result = await ballot.vote(1, { from: accounts[2]})
      assert.equal(result.receipt.status, success)
    });

    it('Failure on voting for invalid candidate.', async function () {
      //Registration -> Vote
      await ballot.changeState(2)

      //We have initialized number of proposals to be 3. Must fail when trying to vote for 10.
      await truffleAssert.reverts(
        ballot.vote(10, { from: accounts[1]}), wrongProposalError
      )
    });

    it('Failure on repeat vote.', async function () {
      //Registration -> Vote
      await ballot.changeState(2)

      //Account 1 votes for 1 the first time
      await ballot.vote(1, { from: accounts[1]})

      //Should not allow Account 1 to vote again
      await truffleAssert.reverts(
        ballot.vote(1, { from: accounts[1]}), votedError
      )
    });

    it('Failure on vote by an unregistered user.', async function () {
      //Account 4 is not registered by the chairperson, hence must not be allowed to vote
      await truffleAssert.reverts(
        ballot.vote(1, { from: accounts[4]})
      )
    });

    it('Failure on vote in invalid phase.', async function () {
      // We change the ballot's state to 1 and 2 and verify that voting is not permitted.
      // reg phase is 1
      // done phase is 3
      await truffleAssert.reverts(
        ballot.vote(1, { from: accounts[1]}),
        truffleAssert.ErrorType.REVERT,
        validPhaseError,
        validPhaseError
      )
      await ballot.changeState(3);
      await truffleAssert.reverts(
        ballot.vote(1, { from: accounts[1]}),
        truffleAssert.ErrorType.REVERT,
        validPhaseError,
        validPhaseError
      )
    });
  });

  describe('Phase Change', function() {

    it('Success on phase increment', async function () {
      //registration -> voting
      let result = await ballot.changeState(2)
      assert.equal(result.receipt.status, success)

      //voting -> done
      result = await ballot.changeState(3)
      assert.equal(result.receipt.status, success)
    });

    it('Failure on phase decrement.', async function () {
      //Currently in registration state
      //Should not allow to change state from registration to initial 
      await truffleAssert.reverts(
        ballot.changeState(0),
        truffleAssert.ErrorType.REVERT,
        changeStateError,
        changeStateError
      )
    });

    it('Failure on phase change by non-chairperson entity.', async function () {
      await ballot.register(accounts[1], { from: accounts[0]})
      //Checking with a non-chairperson but registered user
      await truffleAssert.reverts(
        ballot.changeState(2, { from: accounts[1]}),
        truffleAssert.ErrorType.REVERT,
        onlyChairpersonError,
        onlyChairpersonError
      )
      //Checking with a non-chairperson and non-registered user
      await truffleAssert.reverts(
        ballot.changeState(2, { from: accounts[4]}),
        truffleAssert.ErrorType.REVERT,
        onlyChairpersonError,
        onlyChairpersonError
      )
    });
  });

  describe('Requesting winner', function() {
    beforeEach('Setup contract for each request winner test', async function () {
      await ballot.register(accounts[1], { from: accounts[0]})
      await ballot.register(accounts[2], { from: accounts[0]})
    });

    it('Success on query of winner with majority.', async function () {
      //registration -> voting
      await ballot.changeState(2)
      
      //Chairperson's vote (if {from: account[?]} is not mentioned, it defaults to account[0])
      await ballot.vote(2)

      //Account 1 votes for 1
      await ballot.vote(1, { from: accounts[1]})

      //Account 2 votes for 2
      await ballot.vote(2, { from: accounts[2]})

      //voting -> done
      await ballot.changeState(3)

      let result = await ballot.reqWinner()
      assert.equal(result, 2)
    });

    it('Success on query for the winner by a non-chairperson entity.', async function () {
      //registration -> voting
      await ballot.changeState(2)

      //Chairperson's vote (if {from: account[?]} is not mentioned, it defaults to account[0])
      await ballot.vote(2)

      //Account 1 votes for 1      
      await ballot.vote(1, { from: accounts[1]})

      //Account 2 votes for 2
      await ballot.vote(2, { from: accounts[2]})

      //voting -> done
      await ballot.changeState(3)

      //Account 1 requests winner
      let result = await ballot.reqWinner({from: accounts[1]})
      assert.equal(result, 2)
    });

    it('Success on tie-breaker when multiple candidates tied for the majority.', async function () {
      //Account 3 and 4 are registered by the chairperson
      await ballot.register(accounts[3], { from: accounts[0]})
      await ballot.register(accounts[4], { from: accounts[0]})

      //registration -> voting
      await ballot.changeState(2)

      //Chairperson votes for 2 (has a weight of 2) -> 2 votes of 2
      await ballot.vote(2)

      //1 vote for 1
      await ballot.vote(1, { from: accounts[1]})

      //2 vote for 1
      await ballot.vote(1, { from: accounts[2]})
      
      //3 vote for 1
      await ballot.vote(1, { from: accounts[3]})

      //3 vote for 2
      await ballot.vote(2, { from: accounts[4]})
      
      //Here we can see that 1 and 2 have 3 votes each, but as 1 had the majority first 1 is the winner
      await ballot.changeState(3)
      let result = await ballot.reqWinner()
      assert.equal(result, 1)
    });

    it('Failure on request for winner with majority vote less than three.', async function () {
      //registration -> voting
      await ballot.changeState(2)

      //Chairperson votes for 2 (has a weight of 2) -> 2 votes of 2
      await ballot.vote(2)

      //1 vote for 1
      await ballot.vote(1, { from: accounts[1]})

      //voting -> done
      await ballot.changeState(3)

      //Does not reveal the winner as none got at least 3 votes
      await truffleAssert.fails(ballot.reqWinner())
    });

    it('Failure on request for winner in invalid phase.', async function () {
      // We change the ballot's state to 1 and 2 and verify that voting is not permitted.
      // reg phase is 1
      // voting phase is 2
      await truffleAssert.reverts(
        ballot.reqWinner(),
        truffleAssert.ErrorType.REVERT,
        validPhaseError,
        validPhaseError
      )
      
      //registration -> voting
      await ballot.changeState(2)
      
      await truffleAssert.reverts(
        ballot.reqWinner(),
        truffleAssert.ErrorType.REVERT,
        validPhaseError,
        validPhaseError
      )
    });
  });
})
