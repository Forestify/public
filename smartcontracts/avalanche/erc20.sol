/*
   _____                       ____                  _   __  __      _            
  / ____|                     |  _ \                | | |  \/  |    | |           
 | |  __ _ __ ___  ___ _ __   | |_) | ___  _ __   __| | | \  / | ___| |_ ___ _ __ 
 | | |_ | '__/ _ \/ _ \ '_ \  |  _ < / _ \| '_ \ / _` | | |\/| |/ _ \ __/ _ \ '__|
 | |__| | | |  __/  __/ | | | | |_) | (_) | | | | (_| | | |  | |  __/ ||  __/ |   
  \_____|_|  \___|\___|_| |_| |____/ \___/|_| |_|\__,_| |_|  |_|\___|\__\___|_|   
                                                                                                                                                                  
*/



// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract GBMCoin is ERC20, ERC20Burnable {
    constructor() ERC20("GBM Coin", "GBM") {
        _mint(msg.sender, 10000000000 * 10 ** decimals());
    }
}
