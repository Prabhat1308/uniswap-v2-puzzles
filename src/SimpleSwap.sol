// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract SimpleSwap {
    /**
     *  PERFORM A SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap any amount of WETH for USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        // your code start here
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        uint wethBalance = IERC20(weth).balanceOf(address(this));
        
        // approve the pool to spend the WETH
        IERC20(weth).approve(pool, wethBalance);
        IERC20(weth).transfer(pool, wethBalance);

        
        // // get balance of reserves in pool
        // (uint112 reserve0, uint112 reserve1, ) = pair.getReserves();

        // //get token0
        // address token0 = pair.token0();
        
        // uint256 amount
        // if (token0 == usdc)

        pair.swap(1000, wethBalance/2, address(this), "");
    }
}
