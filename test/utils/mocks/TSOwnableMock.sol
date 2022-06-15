// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import {TSOwnable} from "src/TSOwnable.sol";

contract TSOwnableMock is TSOwnable {

    constructor() {
        // NO-OP
    }

    function onlyCallableByOwner() public onlyOwner {
        // NO-OP
    }

}
