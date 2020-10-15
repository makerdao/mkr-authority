pragma solidity >=0.5.12;

// import "ds-test/test.sol";
// import "./MkrAuthority.sol";

// import "./MkrAuthority.sol";
// import "./flop.sol";
// import "./flap.sol";

// interface ERC20 {
//     function setAuthority(address whom) external;
//     function setOwner(address whom) external;
//     function owner() external returns(address);
//     function authority() external returns(address);
//     function balanceOf( address who ) external view returns (uint value);
//     function mint(address usr, uint256 wad) external;
//     function burn(address usr, uint256 wad) external;
//     function burn(uint256 wad) external;
//     function stop() external;
//     function approve(address whom, uint256 wad) external returns (bool);
//     function transfer(address whom, uint256 wad) external returns (bool);
// }

// contract User {
//     ERC20 mkr;
//     GemPit pit;

//     constructor(ERC20 mkr_, GemPit pit_) public {
//         mkr = mkr_;
//         pit = pit_;
//     }

//     function doApprove(address whom, uint256 wad) external returns (bool) {
//         mkr.approve(whom, wad);
//     }

//     function doMint(uint256 wad) external {
//         mkr.mint(address(this), wad);
//     }

//     function doBurn(uint256 wad) external {
//         mkr.burn(wad);
//     }

//     function doBurn(address whom, uint256 wad) external {
//         mkr.burn(whom, wad);
//     }

//     function burnPit() external {
//         pit.burn(address(mkr));
//     }
// }

// contract GemPit {
//     function burn(address gem) external;
// }

// contract MkrAuthorityTest is DSTest {
//     // Test with this:
//     // It uses the Multisig as the caller
//     // dapp build
//     // DAPP_TEST_TIMESTAMP=$(seth block latest timestamp) DAPP_TEST_NUMBER=$(seth block latest number) DAPP_TEST_ADDRESS=0x8EE7D9235e01e6B42345120b5d270bdB763624C7 hevm dapp-test --rpc=$ETH_RPC_URL --json-file=out/dapp.sol.json

//     ERC20 mkr;
//     GemPit pit;
//     User user1;
//     User user2;
//     MkrAuthority auth;

//     function setUp() public {
//         mkr = ERC20(0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2);
//         pit = GemPit(0x69076e44a9C70a67D5b79d95795Aba299083c275);
//         user1 = new User(mkr, pit);
//         user2 = new User(mkr, pit);

//         auth = new MkrAuthority();
//         mkr.setAuthority(address(auth));
//         mkr.setOwner(address(0));
//     }

//     function testCanChangeAuthority() public {
//         MkrAuthority newAuth = new MkrAuthority();
//         mkr.setAuthority(address(newAuth));
//         assertTrue(MkrAuthority(mkr.authority()) == newAuth);
//     }

//     function testCanChangeOwner() public {
//         mkr.setOwner(msg.sender);
//         assertTrue(mkr.owner() == msg.sender);
//     }

//     function testCanBurnOwn() public {
//         assertTrue(MkrAuthority(mkr.authority()) == auth);

//         assertTrue(mkr.owner() == address(0));

//         mkr.transfer(address(user1), 1);
//         user1.doBurn(1);
//     }

//     function testCanBurnFromOwn() public {
//         mkr.transfer(address(user1), 1);
//         user1.doBurn(address(user1), 1);
//     }

//     function testCanBurnPit() public {
//         assertEq(mkr.balanceOf(address(user1)), 0);

//         uint256 pitBalance = mkr.balanceOf(address(pit));
//         assertTrue(pitBalance > 0);

//         user1.burnPit();
//         assertEq(mkr.balanceOf(address(pit)), 0);
//     }

//     function testFailNoApproveAndBurn() public {
//         mkr.transfer(address(user1), 1);

//         assertEq(mkr.balanceOf(address(user1)), 1);
//         assertEq(mkr.balanceOf(address(user2)), 0);

//         user2.doBurn(address(user1), 1);
//     }

//     function testFailNoMint() public {
//         user1.doMint(1);
//     }

//     function testApproveAndBurn() public {
//         mkr.transfer(address(user1), 1);

//         assertEq(mkr.balanceOf(address(user1)), 1);
//         assertEq(mkr.balanceOf(address(user2)), 0);

//         user1.doApprove(address(user2), 1);
//         user2.doBurn(address(user1), 1);

//         assertEq(mkr.balanceOf(address(user1)), 0);
//         assertEq(mkr.balanceOf(address(user2)), 0);
//     }

//     function testFullMkrAuthTest() public {
//         //update the authority
//         //this works because HEVM allows us to set the caller address
//         mkr.setAuthority(address(auth));
//         assertTrue(address(mkr.authority()) == address(auth));
//         mkr.setOwner(address(0));
//         assertTrue(address(mkr.owner()) == address(0));

//         //get the balance of this contract for some asserts
//         uint balance = mkr.balanceOf(address(this));

//         //test that we are allowed to mint
//         mkr.mint(address(this), 10);
//         assertEq(balance + 10, mkr.balanceOf(address(this)));

//         //test that we are allowed to burn
//         mkr.burn(address(this), 1);
//         assertEq(balance + 9, mkr.balanceOf(address(this)));

//         //create a flopper
//         Flopper flop = new Flopper(address(this), address(mkr));
//         auth.rely(address(flop));

//         //call flop.kick() and flop.deal() which will in turn test the mkr.burn() function
//         flop.kick(address(this), 1, 1);
//         flop.deal(1);

//         //create a flapper
//         Flapper flap = new Flapper(address(this), address(mkr));
//         auth.rely(address(flop));

//         //call flap.kick() and flap.deal() which will in turn test the mkr.mint() function
//         flap.kick(1, 1);
//         flop.deal(1);
//     }
// }
