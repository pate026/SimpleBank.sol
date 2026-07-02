// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract SimpleBank is Ownable, ReentrancyGuard {

    mapping(address => uint256) public balances;
    uint256 public totalDeposits;
    bool public paused;

    event Deposit(address indexed user, uint256 amount, uint256 newBalance);
    event Withdraw(address indexed user, uint256 amount, uint256 newBalance);
    event Paused(bool status);

    modifier whenNotPaused() {
        require(!paused, "Bank is paused");
        _;
    }

    constructor() Ownable(msg.sender) {}

    receive() external payable {
        _deposit(msg.sender, msg.value);
    }

    function deposit() external payable whenNotPaused {
        require(msg.value > 0, "Zero deposit");
        _deposit(msg.sender, msg.value);
    }

    function _deposit(address user, uint256 amount) internal {
        balances[user] += amount;
        totalDeposits += amount;
        emit Deposit(user, amount, balances[user]);
    }

    function withdraw(uint256 amount) external nonReentrant {
        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount;
        totalDeposits -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(msg.sender, amount, balances[msg.sender]);
    }

    function withdrawAll() external nonReentrant {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "Nothing to withdraw");

        balances[msg.sender] = 0;
        totalDeposits -= amount;

        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdraw(msg.sender, amount, 0);
    }

    function balanceOf(address user) external view returns (uint256) {
        return balances[user];
    }

    function contractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function setPaused(bool status) external onlyOwner {
        paused = status;
        emit Paused(status);
    }
}
