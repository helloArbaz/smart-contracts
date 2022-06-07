//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract MyTokenERC20 is ERC20 {
    address public admin;
    
    constructor() ERC20("MyCollectible", "MCO") {
        _mint(msg.sender,10000 * 10 ** 18 );
        admin =msg.sender;
    }

    function burn(uint _amount) external{
        require(admin==msg.sender,"Only Admin Acccess");
        _burn(msg.sender,_amount);
    }
}