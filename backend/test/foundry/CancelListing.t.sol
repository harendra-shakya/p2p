// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import "../../contracts/P2P.sol";
import "../../contracts/test-token/GenericERC20.sol";
import "forge-std/console.sol";
import {Utils} from "./utils/Utils.sol";
import {BaseSetup} from "./BaseSetup.t.sol";

contract BuyTokenTest is BaseSetup {
    function setUp() public virtual override {
        BaseSetup.setUp();
        p2p.listToken(address(weth), address(dai), PRICE, AMOUNT, LIMIT);
    }

    function testRevertIfNotListed() public {
        this.setUp();
        vm.prank(user2);
        vm.expectRevert(abi.encodePacked("P2P: Not listed"));
        p2p.cancelListing(address(weth), address(dai));
    }

    function testCancelListing() public {
        this.setUp();
        vm.prank(user);
        P2P.Listing memory listing = p2p.getListing(user, address(weth), address(dai));
        assertEq(listing.seller, user);

        p2p.cancelListing(address(weth), address(dai));
        listing = p2p.getListing(user, address(weth), address(dai));

        assertEq(listing.seller, address(0));
    }
}
