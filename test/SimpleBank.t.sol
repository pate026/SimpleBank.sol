// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test} from "forge-std/Test.sol";
import {SimpleBank} from "../src/SimpleBank.sol";

contract SimpleBankTest is Test {
    SimpleBank bank;

    function setUp() public {
        bank = new SimpleBank();
    }

    function testContractDeploys() public {
        assertTrue(address(bank) != address(0));
    }

    function testDepositUpdatesBalance() public {
        address user = makeAddr("user");
        vm.deal(user, 1 ether);

        vm.prank(user);
        bank.deposit{value: 1 ether}();

        assertEq(bank.balances(user), 1 ether);
        assertEq(bank.totalDeposits(), 1 ether);
        assertEq(address(bank).balance, 1 ether);
    }

    function testWithdrawUpdatesBalance() public {
        address user = makeAddr("user");
        vm.deal(user, 1 ether);

        vm.prank(user);
        bank.deposit{value: 1 ether}();

        uint256 userBalanceBefore = user.balance;

        vm.prank(user);
        bank.withdraw(0.4 ether);

        assertEq(bank.balances(user), 0.6 ether);
        assertEq(bank.totalDeposits(), 0.6 ether);
        assertEq(address(bank).balance, 0.6 ether);
        assertEq(user.balance, userBalanceBefore + 0.4 ether);
    }

    function testCannotWithdrawMoreThanBalance() public {
        vm.expectRevert(bytes("Insufficient balance"));
        bank.withdraw(1 ether);
    }

    function testPausedBankRejectsDeposit() public {
        bank.setPaused(true);
        vm.deal(address(this), 1 ether);

        vm.expectRevert(bytes("Bank is paused"));
        bank.deposit{value: 1 ether}();
    }

    function testWithdrawAllClearsBalance() public {
        address user = makeAddr("user");
        vm.deal(user, 1 ether);

        vm.prank(user);
        bank.deposit{value: 1 ether}();

        vm.prank(user);
        bank.withdrawAll();

        assertEq(bank.balances(user), 0);
        assertEq(bank.totalDeposits(), 0);
        assertEq(address(bank).balance, 0);
    }

    function testNonOwnerCannotPauseBank() public {
        address user = makeAddr("user");

        vm.prank(user);
        vm.expectRevert();
        bank.setPaused(true);

        assertFalse(bank.paused());
    }

    function testDirectTransferUpdatesBalance() public {
        address user = makeAddr("user");
        vm.deal(user, 1 ether);

        vm.prank(user);
        (bool success, ) = address(bank).call{value: 1 ether}("");

        assertTrue(success);
        assertEq(bank.balances(user), 1 ether);
        assertEq(bank.totalDeposits(), 1 ether);
        assertEq(address(bank).balance, 1 ether);
    }

    function testCannotDepositZero() public {
        vm.expectRevert(bytes("Zero deposit"));
        bank.deposit();
    }

    function testCannotWithdrawAllWithoutBalance() public {
        vm.expectRevert(bytes("Nothing to withdraw"));
        bank.withdrawAll();
    }
}
