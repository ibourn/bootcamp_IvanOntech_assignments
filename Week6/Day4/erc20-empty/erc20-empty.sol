import "./W6_D3_Ownable";
pragma solidity 0.5.12;

contract ERC20 is Ownable {

    mapping (address => uint256) private _balances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }


    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSuppply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function mint(address account, uint256 amount) public onlyOwner {
        require(account != address(0));

        uint256 oldSupply = _totalSupply;

        _totalSupply += amount;
        _balances[account] += amount;

        /*to prevent from overflow*/
        assert(oldSupply <= _totalSupply);
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        require(recipient != address(0));

        bool succes = true;
        uint256 oldSenderBalance = _balances[msg.sender];
        uint256 oldRecipientBalance = _balances[recipient];

        if(_balances[msg.sender] >= amount){
            _balances[msg.sender] -= amount;
            _balances[recipient] += amount;
        } else {
            success = false;
        }

        /*to prevent from over/underflow*/
        assert(oldSenderBalance >= _balances[msg.sender]);
        assert(oldRecipientBalance <= _balances[recipient]);
        return success;
    }
}
