// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import {Whitelisted} from "../../../Whitelisted.sol";

contract WhitelistedMock is Whitelisted {

    function addToWhitelist(address who) external {
        super._addToWhitelist(who);
    }

    function removeFromWhitelist(address who) external {
        super._removeFromWhitelist(who);
    }

    function onlyCallableByWhitelistedAddress() external onlyWhitelisted {
        // NO-OP
    }

}
