  /*
  I'm not sure about the statement of the assignment (about the original contract)
  As i understood, i took Fillip's contract as it is in the course about events with 
  the same variables (the important point being that we keep the people mapping and creators array).
  
  We assume that an address can create only one Person for the assignment.
  And in the creators array we keep each entry, i.e. if a creator creates a Person
  then deletes it and creates a new one then creator address will have two entries (as a log of creations)
  However id of the Person is deleted.
  */
pragma solidity 0.5.12;

contract HelloWorld{

    /*
    variables
    */
    struct Person {
      uint id;
      string name;
      uint age;
      uint height;
      bool senior;
    }
    address public owner;
    
    mapping (address => Person) private people;
    address[] private creators;
    uint[] private personIds;


    /*
    events
    */
    event personCreated(string name, bool senior);
    event personDeleted(string name, bool senior, address deletedBy);
    event personUpdated(string item, string oldValue, string newValue);
    event personUpdated(string item, uint oldValue, uint newValue);


    /*
    modifier
    */
    modifier onlyOwner(){
        require(msg.sender == owner);
        _; //Continue execution
    }
    
    
    /*
    constructor
    */
    constructor() public{
        owner = msg.sender;
    }


    /*
    creation function : if the creator has already created a Person : update
    */
    function createPerson(string memory name, uint age, uint height) public {
      require(age < 150, "Age needs to be below 150");
      
        if(checkForCreation(name, age, height)) {
            Person memory newPerson;
            newPerson.name = name;
            newPerson.age = age;
            newPerson.height = height;
    
            if(age >= 65){
               newPerson.senior = true;
           }
           else{
               newPerson.senior = false;
           }
    
            /*
            as there's only one person/creator, we can use index of creators as Id for people
            */
            newPerson.id = creators.push(msg.sender) - 1;
            
            personIds.push(newPerson.id);
            insertPerson(newPerson);
    
            assert(
                keccak256(
                    abi.encodePacked(
                        people[msg.sender].id,
                        people[msg.sender].name,
                        people[msg.sender].age,
                        people[msg.sender].height,
                        people[msg.sender].senior
                    )
                )
                ==
                keccak256(
                    abi.encodePacked(
                        (creators.length - 1),
                        newPerson.name,
                        newPerson.age,
                        newPerson.height,
                        newPerson.senior
                    )
                )
            );
            emit personCreated(newPerson.name, newPerson.senior);
        }
    }
    /*
    Helpers for creation 
    */
    function insertPerson(Person memory newPerson) private {
        address creator = msg.sender;
        people[creator] = newPerson;
    }
    function checkForCreation(string memory name, uint age, uint height) private returns(bool doCreation){
        address creator = msg.sender;
        if(people[creator].age == 0){
            return true;
        }
        else {
            updateAll(name, age, height);
            return false;
        }
    }
    
    
    /*
    delete function
    */
    function deletePerson(address creator) public onlyOwner {
      uint id = people[creator].id;
      string memory name = people[creator].name;
      bool senior = people[creator].senior;

       removeFromIdArray(id);
       delete people[creator];
       
       assert(people[creator].age == 0);
       emit personDeleted(name, senior, owner);
   }
   /*
   Helper for delete
   */
   function removeFromIdArray(uint index) private {
        require(index < personIds.length);

        for (uint i = index; i<personIds.length-1; i++){
            personIds[i] = personIds[i+1];
        }
        delete personIds[personIds.length-1];
        personIds.length--;
    }
    
    
   /*
   Getters
   */
   function getPerson() public view returns(string memory name, uint age, uint height, bool senior){
        address creator = msg.sender;
        return (people[creator].name, people[creator].age, people[creator].height, people[creator].senior);
    }
   function getCreator(uint index) public view onlyOwner returns(address){
       return creators[index];
   }
   function getAllId() public view onlyOwner returns(uint[] memory idsArray){
      return personIds;
   }
   
   
   /*
   Updaters
   */
   function updateName(string memory newName) public {
       address creator = msg.sender;
       string memory currentName = people[creator].name;
       
       people[creator].name = newName;
       assert(
            keccak256(abi.encodePacked(people[msg.sender].name))
            ==
            keccak256(abi.encodePacked(newName))
        );
        emit personUpdated("name", currentName, newName);
   }
   
   function updateAge(uint newAge) public {
       address creator = msg.sender;
       uint currentAge = people[creator].age;
       
       people[creator].age = newAge;
       assert(
            keccak256(abi.encodePacked(people[msg.sender].age))
            ==
            keccak256(abi.encodePacked(newAge))
        );
        emit personUpdated("age", currentAge, newAge);
   }
   
   function updateHeight(uint newHeight) public {
       address creator = msg.sender;
       uint currentHeight = people[creator].height;

       people[creator].height = newHeight;
       assert(
            keccak256(abi.encodePacked(people[msg.sender].height))
            ==
            keccak256(abi.encodePacked(newHeight))
        );
        emit personUpdated("height", currentHeight, newHeight);
   }
   
   function updateAll(string memory newName, uint newAge, uint newHeight) public {
       updateName(newName);
       updateAge(newAge);
       updateHeight(newHeight);
   }
   

}