// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract AddLiquid {
    /**
     *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 WETH.
     *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
     *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
     *
     */
    function addLiquidity(
        address usdc,
        address weth,
        address pool,
        uint256 usdcReserve,
        uint256 wethReserve
    ) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        // // your code start here

        // // see available functions here: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol       

        // // pair.getReserves();
        // // pair.mint(...);

        // Calculate the amount of WETH to match the USDC amount
        uint256 usdcAmount = IERC20(usdc).balanceOf(address(this));
        uint256 wethAmount = (usdcAmount * wethReserve) / usdcReserve;

        // Ensure the contract has enough WETH
        uint256 wethBalance = IERC20(weth).balanceOf(address(this));
        require(wethAmount <= wethBalance, "Insufficient WETH balance"); // here than we can change with amount of USDC to match the WETH amount

        // Approve the pool to spend the required amounts of USDC and WETH
        IERC20(usdc).approve(pool, usdcAmount);
        IERC20(weth).approve(pool, wethAmount);

        // Transfer the tokens to the pool
        IERC20(usdc).transfer(pool, usdcAmount);
        IERC20(weth).transfer(pool, wethAmount);

        // Mint the liquidity tokens
        pair.mint(address(this));

        // Transfer the liquidity tokens to the sender
        IERC20(pool).transfer(msg.sender, IERC20(pool).balanceOf(address(this)));
          
    }

  
}
