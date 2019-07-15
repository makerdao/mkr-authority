pragma solidity ^0.5.10;

contract MkrAuthority {
  address public root;
  modifier sudo { require(msg.sender == root); _; }
  function setRoot(address usr) public note sudo { root = usr; }

  mapping (address => uint) public wards;
  function rely(address usr) public note sudo { wards[usr] = 1; }
  function deny(address usr) public note sudo { wards[usr] = 0; }
  modifier auth { require(wards[msg.sender] == 1); _; }

  bytes4 constant mint = bytes4(keccak256(abi.encodePacked('mint(address,uint256)')));
  bytes4 constant burn = bytes4(keccak256(abi.encodePacked('burn(address,uint256)')));

  function canCall(address src, address dst, bytes4 sig)
      public view returns (bool)
  {
    if (sig == burn) {
      return true;
    } else if (sig == mint) {
      return (wards[src] == 1);
    } else {
      return false;
    }
  }
}
