pragma solidity 0.5.12;

contract Workable{
    
     modifier isWorkable(uint age){
        require(age <= 75);
        _; //continue execution
    }
 
}