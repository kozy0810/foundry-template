// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Base} from "./Base.sol";
import {Counter} from "../../src/Counter.sol";

contract DeployCounter is Base {
    constructor() Base() {}

    function run() external broadcast {
        new Counter();
    }
}
