// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract PingPortal {
    uint256 totalPings;

    /*
     * We will be using this below to help generate a random number
     */
    uint256 private seed;

    event NewPing(address indexed from, uint256 timestamp, string message);

    struct Ping {
        address pinger; // The address of the user who pinged.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user pingedf.
    }

    Ping[] pings;

    /*
     * This is an address => uint mapping, meaning I can associate an address with a number!
     * In this case, I'll be storing the address with the last time the user pinged us.
     */
    mapping(address => uint256) public lastPingedAt;

    constructor() payable {
        console.log("Here comes a new era of Smart Contracts");

        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function ping(string memory _message) public {
        
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastPingedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        /*
         * Update the current timestamp we have for the user
         */
        lastPingedAt[msg.sender] = block.timestamp;
        
        totalPings += 1;
        console.log("%s pinged w/ message %s", msg.sender, _message);
        pings.push(Ping(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a ping
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        console.log("Random # generated: %d", seed);

        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            /*
             * The same code we had before to send the prize.
             */
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewPing(msg.sender, block.timestamp, _message);
    }

    function getAllPings() public view returns (Ping[] memory) {
        return pings;
    }

    function getTotalPings() public view returns (uint256) {
        console.log("We have %d total pings!", totalPings);
        return totalPings;
    }
}
