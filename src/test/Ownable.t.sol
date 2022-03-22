// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import "ds-test/test.sol";

import {HEVM} from "./utils/HEVM.sol";
import {OwnableMock} from "./utils/mocks/OwnableMock.sol";

contract OwnableTest is DSTest {
    HEVM internal constant EVM = HEVM(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

    // SuT
    OwnableMock ownable;

    function setUp() public {
        ownable = new OwnableMock();
    }

    function testDeploymentInvariants() public {
        assertEq(ownable.owner(), address(this));
        assertEq(ownable.pendingOwner(), address(0));
    }

    function testFailModifierOnlyOwner(address caller) public {
        if (caller == ownable.owner()) return;

        // Fails with OnlyCallableByOwner.
        EVM.prank(caller);
        ownable.onlyCallableByOwner();
    }

    function testSetPendingOwner(address to) public {
        if (to == ownable.owner()) return;

        ownable.setPendingOwner(to);
        assertEq(ownable.pendingOwner(), to);
    }

    function testFailSetPendingOwnerByNonOwner(address caller, address to) public {
        if (to == ownable.owner()) return;

        // Fails with OnlyCallableByOwner.
        EVM.prank(caller);
        ownable.setPendingOwner(to);
    }

    function testFailSetPendingOwnerToCurrentOwner() public {
        // Fails with InvalidPendingOwner.
        ownable.setPendingOwner(ownable.owner());
    }

    function testAcceptOwnership(address pendingOwner) public {
        if (pendingOwner == ownable.owner()) return;

        ownable.setPendingOwner(pendingOwner);

        EVM.prank(pendingOwner);
        ownable.acceptOwnership();

        assertEq(ownable.owner(), pendingOwner);
        assertEq(ownable.pendingOwner(), address(0));
    }

    function testFailAcceptOwnershipByNonPendingOwner(address caller) public {
        if (caller == ownable.pendingOwner()) return;

        // Fails with OnlyCallableByPendingOwner.
        EVM.prank(caller);
        ownable.acceptOwnership();
    }
}
