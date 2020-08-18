import "./W6_D3_People.sol";
import "./W6_D3_Workable.sol";
pragma solidity 0.5.12;

/*
-Only bosses can create workers
-An Employee is a Person with a salary and a boss
-He can't be is own boss
-Only his boss can fire him
*/
contract Employees is People, Workable{

    /*
    variables
    */
    mapping(address => uint) private salaryOfWorker;
    mapping(address => address) private bossOfWorker;

    /*
    modifiers
    */
    modifier notOwnBoss(address addOfWorker){
        require(msg.sender != addOfWorker);
        _;
    }
    modifier onlyByHisBoss(address addOfWorker){
        require(msg.sender == bossOfWorker[addOfWorker]);
        _;
    }
    
    /*
    functions
    */
    function createEmployee(string memory name, uint age, uint height, uint workerSalary, address workerAddress) internal isWorkable(age) notOwnBoss(workerAddress){
        
        createPerson(name, age, height, workerAddress);

        salaryOfWorker[workerAddress] = workerSalary;
        bossOfWorker[workerAddress] = msg.sender;
    }
    

    function fire(address workerAddress)public onlyByHisBoss(workerAddress){
        
        deletePerson(workerAddress);
        delete salaryOfWorker[workerAddress];
        
    }

  

    
}