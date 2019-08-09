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
}
