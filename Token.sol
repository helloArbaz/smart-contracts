//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;

abstract contract ERC20Token {
    function name() public virtual view returns(string memory);
    function symbol() public virtual view returns(string memory);
    function decimals() public virtual view returns(uint8);
    function totalSupply() public virtual view returns(uint256);
    function balanceOf(address _owner) public virtual view returns(uint256 balance);
    function transfer(address _to , uint _value) public virtual returns (bool success);
    function transferFrom(address _from, address _to,uint256 _value) public virtual returns(bool success);
    function approve(address _spender, uint256 _value ) public virtual returns (bool success);
    function allowance(address _owner, address _spender) public virtual returns (uint256 remaning);

    event Transfer(address indexed _from , address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract ASB_Token  {
    address public owner; 
    address public newOwner;

    event OwnerShipChanged(address indexed _from , address indexed _to);

    constructor(){
        owner= msg.sender;
    }

    function transferOwnerShip(address _to) public  {
        require(owner == msg.sender);
        newOwner = _to;
    }

    function acceptOwnerShip() public  {
        require(msg.sender == newOwner);
        emit OwnerShipChanged(owner,newOwner);
        owner = newOwner;
        newOwner = address(0);
    }

}

contract Token is ERC20Token, ASB_Token {
    string public _symbol;
    string public _name;
    uint8 public _decimal;
    uint public _totalSupply;
    address public _minter; 

    mapping(address=>uint) balances;

    constructor(){
        _symbol="ABS";
        _name="Token";
        _decimal=0;
        _totalSupply=100000000;
        // testing address
        // _minter=0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

        balances[_minter]=_totalSupply;
        emit Transfer(address(0),_minter,_totalSupply);
    }

    function name() public override view returns(string memory){
        return _name;
    }
    
    function symbol() public override view returns(string memory){
        return _symbol;
    }
    
    function decimals() public override view returns(uint8){
        return _decimal;
    }
    
    function totalSupply() public override view returns(uint256){
        return _totalSupply;
    }
    
    function balanceOf(address _owner) public override view returns(uint256){
        return balances[_owner];
    }

    function transfer(address _to , uint _value) public override returns (bool success){
        // require(balances[msg.sender] > _value);
        // balances[msg.sender]-= _value;
        // balances[_to]+=_value;
        // emit Transfer(msg.sender,_to,_value);
        // return true;
        return transferFrom(msg.sender,_to,_value);
    }
    
    function transferFrom(address _from, address _to,uint256 _value) public override returns(bool success){
        require(balances[msg.sender] > _value);
        balances[_from]-= _value;
        balances[_to]+=_value;
        emit Transfer(msg.sender,_to,_value);
        return true;
    }


    function approve(address _spender, uint256 _value ) public pure override returns (bool success){return true;}
    
    function allowance(address _owner, address _spender) public pure override returns (uint256){return 0;}

    function minit(uint _amount) public returns(bool){
        require(msg.sender== _minter);
        balances[_minter]+=_amount;
        _totalSupply+=_amount;
        return true;
    }

}