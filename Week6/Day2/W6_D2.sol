//Data location assignment

pragma solidity 0.5.1;
contract MemoryAndStorage {

    mapping(uint => User) users;

    struct User{
        uint id;
        uint balance;
    }

    function addUser(uint id, uint balance) public {
        users[id] = User(id, balance);
    }

    function updateBalance(uint id, uint balance) public  {
         //original :
         //User memory user = users[id];
         //correction :
         User storage user = users[id];
         user.balance = balance;
         
         /*
         as 'user' was declared with 'memory', it was not persistent and 
         at the end of the execution of the function we lose 
         the value stored within
         */
    }

    function getBalance(uint id) view public returns (uint) {
        return users[id].balance;
    }

}