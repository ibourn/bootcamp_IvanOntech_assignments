import "./W6_D3_Destroyable.sol";
//import "./W6_D3_Ownable.sol";
pragma solidity 0.5.12;


contract People is Destroyable{ //=>corriger à is Destroyable!
   
   /*
   variables
   */
    struct Person{
        string name;
        uint age;
        uint height;
        bool senior;
    }
    uint public balance;

    mapping(address => Person) private people;              //map each Person 
    mapping(address => address[]) private peopleByCreator;  //map array of Person addresses created by a creator (owner or bosses)
    address[] private creators;                             //log each creation of Person with the address of the creator

    /*
    events
    */
    event personCreated(string name, bool  senior);
    event personDeleted(string name, bool senior, address creator);
    
    /*
    modifiers
    */
    modifier costs(uint cost){
        require(msg.value >= cost);
        _;
    }
    
   /*
   CREATION FUNCTION
   */
    function createPerson(string memory name, uint age, uint height, address personAddress) internal{
        require(people[personAddress].age == 0);
        require(age <= 150, "Age needs to be below 150");

        balance += msg.value;
      
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
       
        insertPerson(newPerson, personAddress);
        insertPersonForCreator(personAddress);
        logCreator();

        assert(
            keccak256(
                abi.encodePacked(
                    people[personAddress].name, 
                    people[personAddress].age, 
                    people[personAddress].height, 
                    people[personAddress].senior
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
    /*
   CREATION HELPERS
   */
    function insertPerson(Person memory newPerson, address personAddress) private{
        people[personAddress] = newPerson;
    }
    function insertPersonForCreator(address personAddress) private{
        address creator = msg.sender;
        peopleByCreator[creator].push(personAddress);
    }
    function logCreator() private{
        creators.push(msg.sender);
    }


    /*
   GETTERS
   */
    function getPerson() public view returns(string memory name, uint age, uint height, bool senior){
        address person = msg.sender;
        return (people[person].name, people[person].age, people[person].height, people[person].senior);
    }
    function getListOfPersonByCreator() public view returns(address[] memory listOfPersonAdd){
        address creator = msg.sender;
        return (peopleByCreator[creator]);
    }
     function getCreator(uint index) public view onlyOwner returns(address){
        return creators[index];
    }
    
    /*
   DELETE FUNCTION
   */
    function deletePerson(address person) internal{
        string memory name = people[person].name;
        bool senior = people[person].senior;

        removeFromListOfPerson(person);   
        delete people[person]; 

        assert(people[person].age == 0);
        emit personDeleted(name, senior, msg.sender);
    }   
    /*
   DELETE HELPER
   */
   function removeFromListOfPerson(address person) private {
       address[] memory listOfPerson = peopleByCreator[msg.sender];

        bool found = false;
        for (uint i = 0; i < listOfPerson.length-1; i++){
            if(person == listOfPerson[i]){
                found = true;
            }
            if(found){
                listOfPerson[i] = listOfPerson[i+1];
            }
        }
        delete listOfPerson[listOfPerson.length-1];

        peopleByCreator[msg.sender] = listOfPerson;
        peopleByCreator[msg.sender].length--;
    }

   
    /*
   WHITHDRAW FUNCTION
   */    
    function withdrawAll() public onlyOwner returns(uint) {
        uint toTransfer = balance;
        balance = 0;

        msg.sender.transfer(toTransfer); 
        return toTransfer;
        
    }
    
}