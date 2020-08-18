import "./W6_D3_People.sol";
pragma solidity 0.5.12;

/*
-Only owner can create bosses
-Only bosses can create workers
-A boss is a Person and is true in map 'isBoss'
*/
contract Bosses is People{
    /*
    variables
    */
    mapping(address => bool) private isBoss;

    /*
    modifiers
    */
    modifier onlyBoss(address bossAddress){
        require(isBoss[bossAddress]);
        _;
    }

    /*
    functions
    */
    function createBoss(string memory name, uint age, uint height, address bossAddress) public onlyOwner payable costs(100 wei){
        require(isBoss[bossAddress] == false);

        isBoss[bossAddress] = true;
        createPerson(name, age, height, bossAddress);
    }
}