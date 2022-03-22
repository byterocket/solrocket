// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

interface HEVM {
    // Set block.timestamp.
    function warp(uint256) external;

    // Set block.number.
    function roll(uint256) external;

    function fee(uint256) external;

    function load(address, bytes32) external returns (bytes32);

    function store(
        address,
        bytes32,
        bytes32
    ) external;

    function sign(uint256, bytes32)
        external
        returns (
            uint8,
            bytes32,
            bytes32
        );

    function addr(uint256) external returns (address);

    function ffi(string[] calldata) external returns (bytes memory);

    // Set msg.sender for next call.
    function prank(address) external;

    // Set msg.sender until `stopPrank` is called.
    function startPrank(address) external;

    function prank(address, address) external;

    function startPrank(address, address) external;

    // Set msg.sender back to address(this).
    function stopPrank() external;

    function deal(address, uint256) external;

    function etch(address, bytes calldata) external;

    function expectRevert(bytes calldata) external;

    function expectRevert(bytes4) external;

    function record() external;

    function accesses(address) external returns (bytes32[] memory reads, bytes32[] memory writes);

    function expectEmit(
        bool,
        bool,
        bool,
        bool
    ) external;

    function mockCall(
        address,
        bytes calldata,
        bytes calldata
    ) external;

    function clearMockedCalls() external;

    function expectCall(address, bytes calldata) external;

    function getCode(string calldata) external returns (bytes memory);
}
