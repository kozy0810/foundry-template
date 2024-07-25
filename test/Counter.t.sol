// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";

import {Counter} from "../src/Counter.sol";

contract CounterTest is Test, GasSnapshot {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        snapStart("Counter-setNumber");
        counter.setNumber(0);
        snapEnd();
    }

    function test_Increment() public {
        snapStart("Counter-increment");
        counter.increment();
        snapEnd();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
