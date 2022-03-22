// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import "ds-test/test.sol";

import {WhitelistedMock} from "./utils/mocks/WhitelistedMock.sol";

import {HEVM} from "./utils/HEVM.sol";

contract WhitelistedTest is DSTest {
    HEVM internal constant EVM = HEVM(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // SuT
    WhitelistedMock sut;

    function setUp() public {
        sut = new WhitelistedMock();
    }

    function testAddToWhitelist(address who) public {
        sut.addToWhitelist(who);
        // Function should be idempotent.
        sut.addToWhitelist(who);

        assertTrue(sut.whitelist(who));
    }

    function testRemoveFromWhitelist(address who) public {
        sut.addToWhitelist(who);

        sut.removeFromWhitelist(who);
        // Function should be idempotent.
        sut.removeFromWhitelist(who);

        assertTrue(!sut.whitelist(who));
    }

    function testModifier(address who, bool addToWhitelist) public {
        if (addToWhitelist) {
            sut.addToWhitelist(who);

            EVM.prank(who);
            sut.onlyCallableByWhitelistedAddress();
        } else {
            EVM.prank(who);

            try sut.onlyCallableByWhitelistedAddress() {
                revert();
            } catch {
                // Fails with OnlyCallableByWhitelistedAddress.
            }
        }
    }

}
