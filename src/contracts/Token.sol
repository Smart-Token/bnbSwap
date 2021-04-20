pragma solidity ^0.5.16;

contract Token {
    string public name;
    string public symbol;
    uint256 public totalSupply;
    uint8 public decimals;
    uint256 public circulatingSupply;

    constructor() public {
        name = "Smart Token";
        symbol = "SMTK";        
        decimals = 18;
        totalSupply = 63963963 * 10 ** 18; // 100 million tokens
        circulatingSupply = (totalSupply * 49) / 100;
        balanceOf[msg.sender] = totalSupply;
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    function transfer(address _to, uint256 _value)
        public
        returns (bool success)
    {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        public
        returns (bool success)
    {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    // TODO: Change function visibility
    function addCirculatingSupply(uint256 _value)
        public
        returns (bool success)
    {
        if (_value + circulatingSupply <= totalSupply) {
            circulatingSupply += _value;
            return _value > 0;
        }
        return false;
    }

    // TODO: Change function visibility
    function removeCirculatingSupply(uint256 _value)
        public
        returns (bool success)
    {
        if (circulatingSupply >= _value) {
            circulatingSupply -= _value;
            return _value > 0;
        }
        return false;
    }

    function getCirculatingSupply() public view returns (uint256){
            return circulatingSupply;
    }

    function getTotalSupply() public view returns (uint256){
        return totalSupply;
    }

    function getDecimals() public view returns (uint256){
        return decimals;
    }
}
