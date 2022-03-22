// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

/**
 * @title Whitelisted contract
 *
 * @dev Contract module which provides a basic whitelist access controler
 *      mechanism where an account can be added to a whitelist that can be
 *      granted exclusive access to specific functions.
 *
 *      Accounts in the whitelist are changeable through the internal
 *      _addToWhitelist and _removeFromWhitelist functions.
 *
 *      This module is used through inheritance. It will make available the
 *      onlyWhitelisted modifier, which can be applied to your functions to
 *      restrict their use to the whitelisted accounts.
 *
 * @author byterocket
 */
abstract contract Whitelisted {

    //--------------------------------------------------------------------------
    // Errors

    /// @notice Function is only callable by whitelisted address.
    error OnlyCallableByWhitelistedAddress();

    //--------------------------------------------------------------------------
    // Events

    /// @notice Event emitted when a new address is added to the whitelist.
    event AddressAddedToWhitelist(address indexed who);

    /// @notice Event emitted when an address is removed from the whitelist.
    event AddressRemovedFromWhitelist(address indexed who);

    //--------------------------------------------------------------------------
    // Modifiers

    /// @notice Modifier to guarantee function is only callable by whitelisted
    ///         addresses.
    modifier onlyWhitelisted() {
        if (!whitelist[msg.sender]) {
            revert OnlyCallableByWhitelistedAddress();
        }
        _;
    }

    //--------------------------------------------------------------------------
    // Storage

    /// @notice The whitelisted address mapping.
    mapping(address => bool) public whitelist;

    //--------------------------------------------------------------------------
    // Internal Mutating Functions

    /// @dev Adds an address to the whitelist.
    /// @param who The address to add to the whitelist.
    function _addToWhitelist(address who) internal {
        if (whitelist[who]) {
            return;
        }

        whitelist[who] = true;
        emit AddressAddedToWhitelist(who);
    }

    /// @dev Removes an address from the whitelist.
    /// @param who The address to remove from the whitelist.
    function _removeFromWhitelist(address who) internal {
        if (!whitelist[who]) {
            return;
        }

        whitelist[who] = false;
        emit AddressRemovedFromWhitelist(who);
    }

}
