const main = async () => {
  const pingContractFactory = await hre.ethers.getContractFactory("PingPortal");
  const pingContract = await pingContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });

  await pingContract.deployed();

  console.log("PingPortal address: ", pingContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();
