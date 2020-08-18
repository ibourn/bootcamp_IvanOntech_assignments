import "./W6_D3_Employees.sol";
import "./W6_D3_Bosses.sol";

pragma solidity 0.5.12;

/*
-A workers is an employee hired only by bosses
*/
contract Workers is Employees, Bosses{

    function createWorker(string memory name, uint age, uint height, uint workerSalary, address workerAddress) public onlyBoss(msg.sender) payable costs(100 wei){
        
        createEmployee(name, age, height, workerSalary, workerAddress);
    }
    
   

}