pragma solidity 0.5.12;

contract Ownable{
    address public owner;
    
     modifier onlyOwner(){
        require(msg.sender == owner);
        _; //continue execution
    }
    
    //chils inherit of constructor
    constructor() public{
        owner = msg.sender;
    }
    
}