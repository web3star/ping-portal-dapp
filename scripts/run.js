const main = async () => {
  const pingContractFactory = await hre.ethers.getContractFactory("PingPortal");
  const pingContract = await pingContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await pingContract.deployed();
  console.log("Contract address:", pingContract.address);

  /*
   * Get Contract balance
   */
  let contractBalance = await hre.ethers.provider.getBalance(
    pingContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  /*
   * Let's try two pings now
   */
  const pingTxn = await pingContract.ping("This is ping #1");
  await pingTxn.wait();

  const pingTxn2 = await pingContract.ping("This is ping #2");
  await pingTxn2.wait();

  /*
   * Get Contract balance to see what happened!
   */
  contractBalance = await hre.ethers.provider.getBalance(pingContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allPings = await pingContract.getAllPings();
  console.log(allPings);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
