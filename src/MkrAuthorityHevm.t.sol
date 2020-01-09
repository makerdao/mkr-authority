pragma solidity >=0.5.10;

import "ds-test/test.sol";
import "./MkrAuthority.sol";

interface ERC20 {
    function setAuthority(address whom) external;
    function setOwner(address whom) external;
    function owner() external returns(address);
    function authority() external returns(address);
    function balanceOf(address whom) external view returns (uint256);
    function burn(address whom, uint256 wad) external;
    function transfer(address whom, uint256 wad) external returns (bool);
}

contract GemPit {
    function burn(address gem) external;
}

contract User {
    ERC20 mkr;
    GemPit pit;

    constructor(ERC20 mkr_, GemPit pit_) public {
        mkr = mkr_;
        pit = pit_;
    }

    function doBurn(uint256 wad) external {
        mkr.burn(address(this), wad);
    }

    function burnPit() external {
        pit.burn(address(mkr));
    }
}

contract OwnerUpdate is DSTest {
    ERC20 mkr;
    GemPit pit;
    User user;
    MkrAuthority auth;

    function setUp() public {
        mkr = ERC20(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);
        pit = GemPit(0x69076e44a9C70a67D5b79d95795Aba299083c275);
        user = new User(mkr, pit);

        auth = new MkrAuthority();
        // auth.setRoot(address(this));
        mkr.setAuthority(address(auth));
    }
    // Test with this:
    // It uses the Multisig as the caller
    // dapp build && DAPP_TEST_TIMESTAMP=$(seth block latest timestamp) DAPP_TEST_NUMBER=$(seth block latest number) DAPP_TEST_ADDRESS=0x8EE7D9235e01e6B42345120b5d270bdB763624C7 hevm dapp-test --rpc=$ETH_RPC_URL --json-file=out/dapp.sol.json
    function testChangeOwners() public {
        assertTrue(MkrAuthority(mkr.authority()) == auth);

        mkr.setOwner(address(0));

        assertTrue(mkr.owner() == address(0));

        mkr.transfer(address(user), 1);
        user.doBurn(1);
    }

    function testBurn() public {
        mkr.transfer(address(user), 1);
        user.doBurn(1);
        user.burnPit();
        assertEq(mkr.balanceOf(address(pit)), 0);
    }
}