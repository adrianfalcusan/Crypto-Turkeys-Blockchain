const TurkeyFactory = artifacts.require("TurkeyFactory");
const utils = require("./helpers/utils");
const turkeyNames = ["ronaldo", "messi"];

contract("TurkeyFactory", accounts => {
  let [alice, bob] = accounts;
  let contractInstance;

  beforeEach(async function () {
    contractInstance = await TurkeyFactory.new();
  });

  it("should be able to create a new turkey", async function () {
    const result = await contractInstance.generateRandomTurkey(turkeyNames[0], {
      from: alice,
    });
    assert.equal(result.receipt.status, true);
    assert.equal(result.logs[0].args._name, turkeyNames[0]);
  });

  it("should generate random turkey dna", async function () {
    const result = await contractInstance.generateRandomTurkey(turkeyNames[0], {
      from: alice,
    });
    assert.equal(result.receipt.status, true);
  });

  it("should have one turkey ", async function () {
    await contractInstance.generateRandomTurkey(turkeyNames[0], {
      from: alice,
    });
    const result = await contractInstance.balanceOf(alice);
    assert.equal(result, 1);
  });

  it("should return alice as the owner of generated turkey", async function () {
    await contractInstance.generateRandomTurkey(turkeyNames[0], {
      from: alice,
    });
    const result = await contractInstance.ownerOf(0);
    assert.equal(result, alice);
  });

  it("should throw if alice is not the owner", async function () {
    await contractInstance.generateRandomTurkey(turkeyNames[0], {
      from: alice,
    });
    const result = await contractInstance.ownerOf(0);
    await utils.shouldThrow(result == alice);
  });
});
