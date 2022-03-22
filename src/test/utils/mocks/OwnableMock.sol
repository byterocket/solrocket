// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import {Ownable} from "../../../Ownable.sol";

contract OwnableMock is Ownable {

    constructor() {
        // NO-OP
    }

    function onlyCallableByOwner() public onlyOwner {
        // NO-OP
    }

}
