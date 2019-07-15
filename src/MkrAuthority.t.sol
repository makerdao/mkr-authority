pragma solidity ^0.5.10;

import "ds-test/test.sol";

import "./MkrAuthority.sol";

contract MkrAuthorityTest is DSTest {
    MkrAuthority authority;

    function setUp() public {
        authority = new MkrAuthority();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
