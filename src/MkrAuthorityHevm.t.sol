pragma solidity >=0.5.10;

import "ds-test/test.sol";

interface ERC20 {
    function setAuthority(address whom) external;
    function setOwner(address whom) external;
    function owner() external returns(address);
    function authority() external returns(address);
}

contract OwnerUpdate is DSTest {
    // Test with this:
    // It uses the Multisig as the caller
    // dapp build && DAPP_TEST_TIMESTAMP=$(seth block latest timestamp) DAPP_TEST_NUMBER=$(seth block latest number) DAPP_TEST_ADDRESS=0x8EE7D9235e01e6B42345120b5d270bdB763624C7 hevm dapp-test --rpc=$ETH_RPC_URL --json-file=out/dapp.sol.json
    function testChangeOwners() public {
        address auth = 0x9eF05f7F6deB616fd37aC3c959a2dDD25A54E4F5;
        ERC20 mkr = ERC20(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);

        mkr.setAuthority(auth);

        assertTrue(mkr.authority() == auth);

        mkr.setOwner(address(0));

        assertTrue(mkr.owner() == address(0));
    }
}