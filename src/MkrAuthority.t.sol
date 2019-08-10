// Copyright (C) 2019 Maker Ecosystem Growth Holdings, INC.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./MkrAuthority.sol";

contract Tester {
  MkrAuthority authority;
  constructor(MkrAuthority authority_) public { authority = authority_; }
  function setRoot(address usr) public { authority.setRoot(usr); }
  function rely(address usr) public { authority.rely(usr); }
  function deny(address usr) public { authority.deny(usr); }

  modifier auth {
    require(authority.canCall(msg.sender, address(this), msg.sig));
    _;
  }

  function mint(address usr, uint256 wad) auth public {}
  function burn(address usr, uint256 wad) auth public {}
  function stop() auth public {}
}

contract MkrAuthorityTest is DSTest {
  MkrAuthority authority;
  Tester tester;

  function setUp() public {
    authority = new MkrAuthority();
    tester = new Tester(authority);
  }

  function testSetRoot() public {
    assertTrue(authority.root() == address(this));
    authority.setRoot(address(tester));
    assertTrue(authority.root() == address(tester));
  }

  function testFailSetRoot() public {
    assertTrue(authority.root() != address(tester));
    tester.setRoot(address(tester));
  }

  function testRely() public {
    assertEq(authority.wards(address(tester)), 0);
    authority.rely(address(tester));
    assertEq(authority.wards(address(tester)), 1);
  }  

  function testFailRely() public {
    // tester is not authority's root, so cannot call rely
    tester.rely(address(tester));
  }

  function testDeny() public {
    authority.rely(address(tester));
    authority.deny(address(tester));
    assertEq(authority.wards(address(tester)), 0);
  }

  function testFailDeny() public {
    // tester is not authority's root, so cannot call deny
    tester.deny(address(tester));
  }

  function testMintAuthorization() public {
    authority.rely(address(this));
    tester.mint(address(this), 1);
  }

  function testFailMintAuthroization() public {
    tester.mint(address(this), 1);
  }

  function testBurnAuthorization() public {
    authority.rely(address(this));
    tester.burn(address(this), 1);    
    authority.deny(address(this));
    tester.burn(address(this), 1);    
  }

  function testFailAuthorizedNotBurnOrMint() public {
    authority.rely(address(this));
    tester.stop();
  }

  function testFailUnauthorizedNotBurnOrMint() public {
    authority.deny(address(this));
    tester.stop();
  }
}
