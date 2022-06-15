// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.10;

import "forge-std/Test.sol";

import {TSOwnableMock} from "./utils/mocks/TSOwnableMock.sol";

/**
 * Errors library for Ownable's custom errors.
 * Enables checking for errors with vm.expectRevert(Errors.<Error>).
 */
library Errors {
    bytes internal constant OnlyCallableByOwner
        = abi.encodeWithSignature("OnlyCallableByOwner()");

    bytes internal constant OnlyCallableByPendingOwner
        = abi.encodeWithSignature("OnlyCallableByPendingOwner()");

    bytes internal constant InvalidPendingOwner
        = abi.encodeWithSignature("InvalidPendingOwner()");
}

contract TSOwnableTest is Test {
    // SuT
    TSOwnableMock sut;

    // Events copied from SuT.
    // Note that the Event declarations are needed to test for emission.
    event NewPendingOwner(address indexed previousPendingOwner,
                          address indexed newPendingOwner);
    event NewOwner(address indexed previousOwner, address indexed newOwner);

    function setUp() public {
        sut = new TSOwnableMock();
    }

    function testDeploymentInvariants() public {
        assertEq(sut.owner(), address(this));
        assertEq(sut.pendingOwner(), address(0));
    }

    function testModifierOnlyOwner(address caller) public {
        vm.startPrank(caller);

        // Fail if non-owner tries to call onlyOwner protected function.
        if (caller != sut.owner()) {
            vm.expectRevert(Errors.OnlyCallableByOwner);
            sut.onlyCallableByOwner();

            return;
        }

        sut.onlyCallableByOwner();
    }

    function testSetPendingOwner(address caller, address to) public {
        vm.startPrank(caller);

        // Fail if non-owner tries to set pending owner.
        if (caller != sut.owner()) {
            vm.expectRevert(Errors.OnlyCallableByOwner);
            sut.setPendingOwner(to);

            return;
        }

        // Fail if pending owner is set to current owner.
        if (to == sut.owner()) {
            vm.expectRevert(Errors.InvalidPendingOwner);
            sut.setPendingOwner(to);

            return;
        }

        vm.expectEmit(true, true, true, true);
        emit NewPendingOwner(address(0), to);

        sut.setPendingOwner(to);
        assertEq(sut.pendingOwner(), to);
    }

    function testAcceptOwnership(address pendingOwner) public {
        address owner = sut.owner();

        vm.assume(pendingOwner != owner);

        sut.setPendingOwner(pendingOwner);

        vm.expectEmit(true, true, true, true);
        emit NewOwner(owner, pendingOwner);

        vm.prank(pendingOwner);
        sut.acceptOwnership();

        assertEq(sut.owner(), pendingOwner);
        assertEq(sut.pendingOwner(), address(0));
    }

}
