// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

/**
* @dev A custom revert error is used in this implementation
*      to save on gas associated with longer strings in require statements.
*/
error ReentrantCall();

/**
* @title PreventReentrant
*/

abstract contract PreventReentrant {

    /**
    * @dev Having both uint128 constants declared next to eachother 
    *      allows them both fit into a single 256 bit slot. Unisgned integers
    *      are used in this implementation to avoid the extra SLOAD required for the 
    *      read, replace, and write operations of a boolean.
    */

    uint128 private constant NOT_ENTERED = 1;
    uint128 private constant IS_ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = NOT_ENTERED;
    }

    modifier nonReentrant {
        /**
        * @dev To prevent reentrancy, the modifier first checks that the status
        *      is not entered and throws a custom revert error if the call is reentrant.
        */
        if (_status == IS_ENTERED) revert ReentrantCall();
        // The modifier sets the status to entered for the duration of function execution.
        _status = IS_ENTERED;
        _;
        // Restores the default value to not entered. 
        _status = NOT_ENTERED;
    }

}

