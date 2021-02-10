// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Burnable.sol";
contract Deflate is ERC20, ERC20Burnable {
    uint256 TOTAL_SUPPLY = 50000000;
    string TOKEN_NAME = "Deflate";
    string TOKEN_SYMBOL = "DEF";
    uint BURN_PERCENTAGE = 1;

    
    constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL) {
        _mint(msg.sender, TOTAL_SUPPLY * (10**uint256(decimals())));
    }
    
    function transfer(address to, uint256 amount) virtual override public returns (bool) {
        return super.transfer(to, _partialBurn(amount));
    }

    function transferFrom(address from, address to, uint256 amount) virtual override public returns (bool) {
        return super.transferFrom(from, to, _partialBurn(amount));
    }
    
    function _partialBurn(uint256 amount) internal returns (uint256) {
        uint256 burnAmount = _calculateBurnAmount(amount);

        if (burnAmount > 0) {
            _burn(msg.sender, burnAmount);
        }
        
        return amount;
    }

    function _calculateBurnAmount(uint256 amount) internal view returns (uint256) {
        uint256 burnAmount = 0;

        if (totalSupply() > amount) {
            burnAmount = (totalSupply() - amount) * BURN_PERCENTAGE / 100;
        }

        return burnAmount;
    }
}