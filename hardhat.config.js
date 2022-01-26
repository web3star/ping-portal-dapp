require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
const { API_URL, PRIVATE_KEY } = process.env;
module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: API_URL,
      accounts: [PRIVATE_KEY],
    },
  },
};
