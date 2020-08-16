import "./W6_D3_Ownable.sol";
pragma solidity 0.5.12;

contract Destroyable is Ownable{
    
   function destroy() public onlyOwner { 
    address payable  owner = msg.sender;
    selfdestruct(owner);  
}
    
}