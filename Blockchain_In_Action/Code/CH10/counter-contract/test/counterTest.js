const Counter = artifacts.require('../contracts/Counter.sol')
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

contract('Counter', function () {
  let counter
  const negativeCounterError = 'Counter cannot become negative';
  const negativeValueError = 'Value must be greater than zero';

  beforeEach('Setup contract for each test', async function () {
    counter = await Counter.new()
    await counter.initialize(100)
  })

  it('Success on initialization of counter.', async function () {
    assert.equal(await counter.get(), 100)
  })

  it('Success on decrement of counter.', async function () {
    await counter.decrement(5)
    assert.equal(await counter.get(), 95)
  })

  it('Success on increment of counter.', async function () {
    await counter.increment(5)
    assert.equal(await counter.get(), 105)
  })

  it('Failure on initialization of counter with negative number.', async function () {
    await truffleAssert.reverts(
      counter.initialize(-1),
      truffleAssert.ErrorType.REVERT,
      negativeValueError,
      negativeValueError
    )
  })

  it('Failure on underflow of counter.', async function () {
    await truffleAssert.reverts(
      counter.decrement(105),
      truffleAssert.ErrorType.REVERT,
      negativeCounterError,
      negativeCounterError
    )
  })

  it('Failure on increment with negative numbers.', async function () {
    await truffleAssert.reverts(
      counter.increment(-2),
      truffleAssert.ErrorType.REVERT,
      negativeValueError,
      negativeValueError
    )
  })

  it('Failure on decrement with negative numbers.', async function () {
    await truffleAssert.reverts(
      counter.decrement(-2),
      truffleAssert.ErrorType.REVERT,
      negativeValueError,
      negativeValueError
    )
  })
})
