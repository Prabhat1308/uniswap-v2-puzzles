// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract ExactSwap {
    /**
     *  PERFORM AN SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    
        /* 
        Calculation

        AB=L
        A = usdc reserve
        B = weth reserve
        L = constant product

        fee = 0.3% (3/1000)
        
        (A-1337)(B+x) = L
        where x = 997/1000 * weth_to_be_deposited

        weth_to_be_deposited = 1000 * 1337 * B / (997 * (A-1337))

        */

        // while this is conceptually correct . to avoid the rounding error, we can add 1 to the result of the division

    function performExactSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */
    
        // // your code start here
        IUniswapV2Pair _pool = IUniswapV2Pair(pool);
             
        // Get reserves
        (uint112 reserve0, uint112 reserve1, ) = _pool.getReserves();
        
        // Identify which token is USDC and which is WETH
        address token0 = _pool.token0();
        address token1 = _pool.token1();
        
        uint256 reserveUSDC;
        uint256 reserveWETH;
        
        if (token0 == usdc) {
            reserveUSDC = reserve0;
            reserveWETH = reserve1;
        } else {
            reserveUSDC = reserve1;
            reserveWETH = reserve0;
        }
    
       
        uint256 amountOut = 1337 * 1e6; 
        uint256 fee = 997; // 0.3% fee adjustment
        uint256 numerator = reserveWETH * amountOut * 1000;
        uint256 denominator = (reserveUSDC - amountOut) * fee;
        uint256 amountIn = (numerator / denominator) + 1; // Adding 1 to ensure rounding up
    
        // Approve and transfer WETH to the pool
        IERC20(weth).approve(address(pool), amountIn);
        IERC20(weth).transfer(address(pool), amountIn);
    
        // Perform the swap
        _pool.swap(amountOut, 0, address(this), "");
    }
    
}
