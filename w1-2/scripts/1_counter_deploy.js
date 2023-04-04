async function main() {
    // await hre.run('compile');
    const Counter = await ethers.getContractFactory("Counter");
    const counter = await Counter.deploy();

    await counter.deployed();
    console.log("Counter deployed to:", counter.address);
}
main();