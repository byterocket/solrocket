// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import "ds-test/test.sol";

import "forge-std/stdlib.sol";
import "forge-std/Vm.sol";

import {WhitelistedMock} from "./utils/mocks/WhitelistedMock.sol";

/**
 * Errors library for Whitelisted's custom errors.
 * Enables checking for errors with vm.expectRevert(Errors.<Error>).
 */
library Errors {
    bytes internal constant OnlyCallableByWhitelistedAddress
        = abi.encodeWithSignature("OnlyCallableByWhitelistedAddress()");
}

contract WhitelistedTest is DSTest {
    Vm internal constant vm = Vm(HEVM_ADDRESS);

    // SuT
    WhitelistedMock sut;

    // Events copied from SuT.
    // Note that the Event declarations are needed to test for emission.
    event AddressAddedToWhitelist(address indexed who);
    event AddressRemovedFromWhitelist(address indexed who);

    function setUp() public {
        sut = new WhitelistedMock();
    }

    function testAddToWhitelist(address who) public {
        vm.expectEmit(true, true, true, true);
        emit AddressAddedToWhitelist(who);

        sut.addToWhitelist(who);
        // Function should be idempotent.
        sut.addToWhitelist(who);

        assertTrue(sut.whitelist(who));
    }

    function testRemoveFromWhitelist(address who) public {
        sut.addToWhitelist(who);

        vm.expectEmit(true, true, true, true);
        emit AddressRemovedFromWhitelist(who);

        sut.removeFromWhitelist(who);
        // Function should be idempotent.
        sut.removeFromWhitelist(who);

        assertTrue(!sut.whitelist(who));
    }

    function testModifierOnlyWhitelisted(address who, bool addToWhitelist)
        public
    {
        if (addToWhitelist) {
            sut.addToWhitelist(who);

            vm.prank(who);

            sut.onlyCallableByWhitelistedAddress();
        } else {
            vm.prank(who);

            vm.expectRevert(Errors.OnlyCallableByWhitelistedAddress);
            sut.onlyCallableByWhitelistedAddress();
        }
    }

}
