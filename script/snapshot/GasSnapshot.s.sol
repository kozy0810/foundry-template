// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {strings} from "solidity-stringutils/strings.sol";
import {Script, VmSafe} from "forge-std/Script.sol";

contract GasSnapshot is Script {
    using strings for *;

    string public IMPORT_DIR = ".forge-snapshots";
    string public OUTPUT_FILE = ".gas-snapshots.md";

    function run() external {
        string memory markdownTable = string(
            abi.encodePacked(
                "| Contract Name | Function Name | Execution Cost |\n",
                "| -------------- | -------------- | -------------- |\n"
            )
        );

        VmSafe.DirEntry[] memory dirEntries = vm.readDir(IMPORT_DIR);
        uint256 length = dirEntries.length;

        string memory outputData;
        for (uint256 i = 0; i < length; i++) {
            string memory fileName = _getFileNameFromPath(dirEntries[i].path);
            string[] memory data = _splitText(fileName, string("-"));

            string memory executionGas = vm.readFile(dirEntries[i].path);
            if (i == 0) {
                outputData = markdownTable;
            }
            string memory data2 = string(
                abi.encodePacked(
                    "| ",
                    data[0],
                    "| ",
                    data[1],
                    "| ",
                    executionGas,
                    "|\n"
                )
            );
            outputData = string(abi.encodePacked(outputData, data2));
        }
        vm.writeFile(OUTPUT_FILE, outputData);
    }

    function _getFileNameFromPath(
        string memory _filePath
    ) private pure returns (string memory) {
        strings.slice memory s1 = _filePath.toSlice();
        strings.slice memory delim1 = "/".toSlice();
        string[] memory parts = new string[](s1.count(delim1) + 1);
        for (uint256 i = 0; i < parts.length; i++) {
            parts[i] = s1.split(delim1).toString();
        }

        strings.slice memory s2 = parts[parts.length - 1].toSlice();
        strings.slice memory delim2 = ".".toSlice();
        return s2.split(delim2).toString();
    }

    function _splitText(
        string memory _data,
        string memory _separator
    ) private pure returns (string[] memory) {
        strings.slice memory s = _data.toSlice();
        strings.slice memory delim = _separator.toSlice();
        string[] memory parts = new string[](s.count(delim) + 1);
        for (uint256 i = 0; i < parts.length; i++) {
            parts[i] = s.split(delim).toString();
        }
        return parts;
    }
}
