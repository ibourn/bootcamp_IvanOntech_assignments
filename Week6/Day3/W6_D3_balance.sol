pragma solidity 0.5.12;

contract HelloWorld{
    //variables
    struct Person{
        uint id;
        string name;
        uint age;
        uint height;
        bool senior;
       // address walletAddress;
    }
    
    address public owner;
    uint currentBalance;
    
    //arrays and mapping
    mapping(address => Person) private people;
    address[] private creators;
    
    //events
    event personCreated(string name, bool  senior);
    event personDeleted(string name, bool senior, address creator);
    
    //modifiers
    modifier onlyOwner(){
        require(msg.sender == owner);
        _; //continue execution
    }
    
    //constructor
    constructor() public{
        owner = msg.sender;
    }
    
    //functions
    //setters
    function createPerson(string memory name, uint age, uint height) public payable{
        require(age <= 150, "Age needs to be below 150");
        require(msg.value >= 1 ether); //wei
        
        currentBalance += msg.value;
  
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;

        if(age > 65){
            newPerson.senior = true;
        } 
        else {
            newPerson.senior = false;
        }
       
        insertPerson(newPerson);
        creators.push(msg.sender);

        assert(
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name, 
                    people[msg.sender].age, 
                    people[msg.sender].height, 
                    people[msg.sender].senior
                    )
                    )
                    ==
            keccak256(
                abi.encodePacked(
                    newPerson.name,
                    newPerson.age,
                    newPerson.height, 
                    newPerson.senior
                    )
                    )
         );
         emit personCreated(newPerson.name, newPerson.senior);
    }
    
    function insertPerson(Person memory newPerson) private{
        address creator = msg.sender;
        people[creator] = newPerson;
    }
    
    function deletePerson(address creator) public onlyOwner{
        string memory name = people[creator].name;
        bool senior = people[creator].senior;

        delete people[creator]; 

        assert(people[creator].age == 0);
        emit personDeleted(name, senior, msg.sender);
    }
    
    //getters
    function getPerson() public view returns(string memory name, uint age, uint height, bool senior){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }
    
    function getCreator(uint index) public view onlyOwner returns(address){
        return creators[index];
    }
    
    function getCurrentBalance() public view onlyOwner returns(uint balance){
        return currentBalance;
    }