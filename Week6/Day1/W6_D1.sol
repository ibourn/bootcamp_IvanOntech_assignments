//Assignment W6_D1
/*
-Instead of having a mapping where we store people, create a new array where we can store the people. 
-When someone creates a new person, add the Person object to the people array instead of the mapping.
-Create a public get function where we can input an index and retrieve the Person object with that index in the array.
-Modify the Person struct and  add an address property Creator. Make sure to edit the createPerson function
so that it sets this property to the msg.sender.
Bonus Assignments
-Create a new mapping (address to uint) which stores the index position of the last person added to the array by an address.
-Modify the createPerson function to set/update this mapping for every new person created. 
(HINT: The return value of the array push() function could help you)
Bonus Assignment #2 [Difficult]
-Create a function that returns an array of all the ID's that the msg.sender has created.
*/
pragma solidity 0.5.12;
//pragma experimental ABIEncoderV2; //si on veut return un struct pour 0.5.12

contract HelloWorld{
    
    struct Person{
        //uint id;
        string name;
        uint age;
        uint height;
        bool senior;
        address creator;
    }
    // => assignment#1
    //arrays
    Person[] private people;
    //mappings
    // => assignment#1
    mapping(address => uint) private indexOfAddresses;
    // => assignment#2
    mapping(address => uint[]) private indexArrOfAddresses;

    //functions
    function createPerson(string memory name, uint age, uint height) public {
        //creates a new Person
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        newPerson.creator = msg.sender;

        if(age > 65){
            newPerson.senior = true;
        } 
        else {
            newPerson.senior = false;
        }
        
        //add the newPerson
        insertPerson(newPerson);
    }
    
    function insertPerson(Person memory newPerson) private{
        //newPerson.id = people.length;
        
        // => assignment#1 (map to the last index created by add)
        indexOfAddresses[msg.sender] = (people.push(newPerson) - 1);
        
        // => assignment#2 (map to an array of all indexes created by add)
        indexArrOfAddresses[msg.sender].push(indexOfAddresses[msg.sender]);
    }
    
    // => assignment#1 : get a Person by index
    function getPerson(uint index) public view returns(string memory name, uint age, uint height, bool senior, address creator){
        return (people[index].name, people[index].age, people[index].height, people[index].senior, people[index].creator);
    }
    // => assignment#2 : get all indexes created by msg.sender
    function getIndexArr() public view returns(uint[]  memory indexArray){
        return indexArrOfAddresses[msg.sender];
    }
   
}