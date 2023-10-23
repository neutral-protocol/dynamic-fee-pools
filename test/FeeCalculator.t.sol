// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {FeeCalculator} from "../src/FeeCalculator.sol";
import {IPool} from "../src/interfaces/IPool.sol";

contract MockPool is IPool {
    uint256 public override totalSupply;
    mapping(address => uint256) public override tokenBalances;

    function setTotalSupply(uint256 _totalSupply) public {
        totalSupply = _totalSupply;
    }

    function setTokenBalance(address token, uint256 balance) public {
        tokenBalances[token] = balance;
    }
}

contract FeeCalculatorTest is Test {
    FeeCalculator public feeCalculator;
    MockPool public mockPool;

    function setUp() public {
        feeCalculator = new FeeCalculator();
        mockPool = new MockPool();
    }

    function testCalculateDepositFeesNormalCase() public {
        // Arrange
        // Set up your test data
        address tco2 = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2; // Example address
        uint256 depositAmount = 100*1e18;

        // Set up mock pool
        mockPool.setTotalSupply(1000*1e18);
        mockPool.setTokenBalance(tco2, 500*1e18);

        // Act
        (address[] memory recipients, uint256[] memory fees) = feeCalculator.calculateDepositFees(tco2, address(mockPool), depositAmount);

        // Assert
        assertEq(recipients[0], tco2);
        assertEq(fees[0], 42930021838396800000);
    }
}
