// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

/**
 * @title Ownable contract using Two-Step Ownership Transfer pattern.
 *
 * @dev Contract module which provides a basic access controler mechanism,
 *      where there is an account (an owner) that can be granted exclusive
 *      access specific functions.
 *
 *      The contract owner is changeable through a two-step transfer pattern,
 *      in which a pending owner is assigned by the owner. Afterwards the
 *      pending owner can accept the contract's ownership.
 *
 *      Note that the contract's owner can NOT be set to the zero address,
 *      i.e. the contract can not be without ownership.
 *
 *      The contract's initial owner is the contract deployer.
 *
 *      This module is used through inheritance. It will make available the
 *      modifier `onlyOwner`, which can be applied to your functions to
 *      restrict their use to the owner.
 *
 *      This contract is heavily inspired by OpenZeppelin's `Ownable` contract.
 *      For more info see https://github.com/OpenZeppelin/openzeppelin-contracts.
 *
 * @author byterocket
 */
abstract contract Ownable {

    //--------------------------------------------------------------------------
    // Storage

    /// @notice The contract's owner.
    address public owner;

    /// @notice The contract's pending owner.
    address public pendingOwner;

    //--------------------------------------------------------------------------
    // Events

    /// @notice Event emitted when new pending owner set.
    event NewPendingOwner(address indexed previousPendingOwner,
                          address indexed newPendingOwner);

    /// @notice Event emitted when new owner set.
    event NewOwner(address indexed previousOwner, address indexed newOwner);

    //--------------------------------------------------------------------------
    // Errors

    /// @notice Function is only callable by contract's owner.
    error OnlyCallableByOwner();

    /// @notice Function is only callable by contract's pending owner.
    error OnlyCallableByPendingOwner();

    /// @notice Address for new pending owner is invalid.
    error InvalidPendingOwner();

    //--------------------------------------------------------------------------
    // Modifiers

    modifier onlyOwner() {
        if (msg.sender != owner) {
            revert OnlyCallableByOwner();
        }
        _;
    }

    // Note that there is no `onlyPendingOwner` modifier because downstream
    // contracts should not build authentication upon the pending owner.

    //--------------------------------------------------------------------------
    // Constructor

    constructor() {
        owner = msg.sender;
        // pendingOwner = address(0);
    }

    //--------------------------------------------------------------------------
    // Mutating Functions

    /// @notice Set a new pending owner.
    /// @dev Only callable by current owner.
    /// @dev Current owner as pending owner is invalid.
    /// @param pendingOwner_ The new pending owner.
    function setPendingOwner(address pendingOwner_) external onlyOwner {
        if (pendingOwner_ == msg.sender) {
            revert InvalidPendingOwner();
        }

        emit NewPendingOwner(pendingOwner, pendingOwner_);

        pendingOwner = pendingOwner_;
    }

    /// @notice Accept the contract's ownership as current pending owner.
    /// @dev Only callable by current pending owner.
    function acceptOwnership() external {
        if (msg.sender != pendingOwner) {
            revert OnlyCallableByPendingOwner();
        }

        emit NewOwner(owner, msg.sender);

        owner = msg.sender;
        pendingOwner = address(0);
    }
}
