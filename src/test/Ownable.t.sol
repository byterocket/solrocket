// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import "ds-test/test.sol";

import {HEVM} from "./utils/HEVM.sol";
import {OwnableMock} from "./utils/mocks/OwnableMock.sol";

contract OwnableTest is DSTest {
    HEVM internal constant EVM = HEVM(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // SuT
    OwnableMock sut;

    function setUp() public {
        sut = new OwnableMock();
    }

    function testDeploymentInvariants() public {
        assertEq(sut.owner(), address(this));
        assertEq(sut.pendingOwner(), address(0));
    }

    function testModifier() public {
        sut.onlyCallableByOwner();
    }

    function testFailModifier(address caller) public {
        if (caller == sut.owner()) return;

        // Fails with OnlyCallableByOwner.
        EVM.prank(caller);
        sut.onlyCallableByOwner();
    }

    function testSetPendingOwner(address to) public {
        if (to == sut.owner()) return;

        sut.setPendingOwner(to);
        assertEq(sut.pendingOwner(), to);
    }

    function testFailSetPendingOwnerByNonOwner(address caller, address to) public {
        if (to == sut.owner()) return;

        // Fails with OnlyCallableByOwner.
        EVM.prank(caller);
        sut.setPendingOwner(to);
    }

    function testFailSetPendingOwnerToCurrentOwner() public {
        // Fails with InvalidPendingOwner.
        sut.setPendingOwner(sut.owner());
    }

    function testAcceptOwnership(address pendingOwner) public {
        if (pendingOwner == sut.owner()) return;

        sut.setPendingOwner(pendingOwner);

        EVM.prank(pendingOwner);
        sut.acceptOwnership();

        assertEq(sut.owner(), pendingOwner);
        assertEq(sut.pendingOwner(), address(0));
    }

    function testFailAcceptOwnershipByNonPendingOwner(address caller) public {
        if (caller == sut.pendingOwner()) return;

        // Fails with OnlyCallableByPendingOwner.
        EVM.prank(caller);
        sut.acceptOwnership();
    }

}
