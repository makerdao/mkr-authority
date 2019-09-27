pragma solidity >=0.5.10;

import "ds-test/test.sol";

import "./MkrAuthority.sol";
import "./flop.sol";
// import "./flap.sol";

interface ERC20 {
    function setAuthority(address whom) external;
    function setOwner(address whom) external;
    function owner() external returns(address);
    function authority() external returns(address);
    function balanceOf( address who ) external view returns (uint value);
    function mint(address usr, uint256 wad) external;
    function burn(address usr, uint256 wad) external;
    function stop() external;
}

contract OwnerUpdate is DSTest {

    // Test with this:
    // It uses the Multisig as the caller
    // dapp build
    // DAPP_TEST_TIMESTAMP=$(seth block latest timestamp) DAPP_TEST_NUMBER=$(seth block latest number) DAPP_TEST_ADDRESS=0x8EE7D9235e01e6B42345120b5d270bdB763624C7 hevm dapp-test --rpc=$ETH_RPC_URL --json-file=out/dapp.sol.json
    function testChangeOwners() public {
        MkrAuthority authority = new MkrAuthority();

        authority.rely(msg.sender);
        authority.rely(address(this));

        ERC20 mkr = ERC20(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);

        mkr.setAuthority(address(authority));
        assertTrue(address(mkr.authority()) == address(authority));
        mkr.setOwner(address(0));
        assertTrue(address(mkr.owner()) == address(0));

        uint balance = mkr.balanceOf(address(this));

        mkr.mint(address(this), 10);
        assertEq(balance + 10, mkr.balanceOf(address(this)));

        mkr.burn(address(this), 1);
        assertEq(balance + 9, mkr.balanceOf(address(this)));

        //create a flopper
        Flopper flop = new Flopper(address(this), 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);
        authority.rely(address(flop));

        flop.kick(address(this), 1, 1);

        flop.deal(1);
    }
}