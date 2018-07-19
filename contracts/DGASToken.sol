pragma solidity ^0.4.23;

import './zeppelin/token/PausableToken.sol';

contract POPToken is PausableToken {
    string  public  constant name = "POP Token";
    string  public  constant symbol = "POP";
    uint8   public  constant decimals = 18;

    modifier validDestination( address to )
    {
        require(to != address(0x0));
        require(to != address(this));
        _;
    }
    constructor( address _admin, uint _totalTokenAmount ) public
    {
        // assign the admin account
        admin = _admin;

        // assign the total tokens to POP
        totalSupply = _totalTokenAmount;
        balances[msg.sender] = _totalTokenAmount;
        emit Transfer(address(0x0), msg.sender, _totalTokenAmount);
    }

    function transfer(address _to, uint _value) validDestination(_to) public returns (bool) 
    {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint _value) validDestination(_to) public returns (bool) 
    {
        return super.transferFrom(_from, _to, _value);
    }

    event Burn(address indexed _burner, uint _value);

    function burn(uint _value) public returns (bool)
    {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        totalSupply = totalSupply.sub(_value);
        emit Burn(msg.sender, _value);
        emit Transfer(msg.sender, address(0x0), _value);
        return true;
    }

    // save some gas by making only one contract call
    function burnFrom(address _from, uint256 _value) public returns (bool) 
    {
        assert( transferFrom( _from, msg.sender, _value ) );
        return burn(_value);
    }

    function emergencyERC20Drain( ERC20 token, uint amount ) onlyOwner public {
        // owner can drain tokens that are sent here by mistake
        token.transfer( owner, amount );
    }

    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);

    function changeAdmin(address newAdmin) onlyOwner public {
        // owner can re-assign the admin
        emit AdminTransferred(admin, newAdmin);
        admin = newAdmin;
    }
}
