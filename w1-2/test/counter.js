const { expect } = require("chai");

describe("Counter", function () {
  let Counter;
  let counter;
  /**
   * 前置函数beforeEach()在每个测试运行之前都会部署新的Counter实例。
   */
  beforeEach(async function () {
    Counter = await ethers.getContractFactory("Counter");
    counter = await Counter.deploy();
    await counter.deployed();
  });

  it("Should return the initial counter value of zero", async function () {
    expect(await counter.counter()).to.equal(0);
  });

  it("Should increase the counter value by one when using count()", async function () {
    await counter.count();
    expect(await counter.counter()).to.equal(1);
  });

  it("Should add a given value to the counter value when using add()", async function () {
    await counter.add(5);
    expect(await counter.counter()).to.equal(5);
  });

  it("Should only allow the deployer to use count()", async function () {
    // 参考：Testing from a different account：https://hardhat.org/hardhat-runner/docs/other-guides/waffle-testing#testing-from-a-different-account
    const [deployer, other] = await ethers.getSigners(); // 测试网络node节点中账户列表中的第一个和第二个账户，和起什么名字无关。再加一个参数就是会返回第三个账户。
    // console.log(">>",deployer);
    
    // Attempt to call count() with a non-deployer account
    await expect(counter.connect(deployer).count()).to.be.revertedWith("Only the contract depoyer can perform this action");

    // Call add() with a non-deployer account
    await counter.connect(other).add(5);
    expect(await counter.counter()).to.equal(5);
  });
});
