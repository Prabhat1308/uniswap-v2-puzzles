// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract BurnLiquid {
    /**
     *  BURN LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 0.01 UNI-V2-LP tokens.
     *  Burn a position (remove liquidity) from USDC/ETH pool to this contract.
     *  The challenge is to use the `burn` function in the pool contract to remove all the liquidity from the pool.
     *
     */
    function burnLiquidity(address pool) public {
        /**
         *     burn(address to);
         *
         *     to: recipient address to receive tokenA and tokenB.
         */
        // your code here

    // Get the pool contract
    IUniswapV2Pair poolContract = IUniswapV2Pair(pool);

    uint256 liquidity = IERC20(pool).balanceOf(address(this));

    // Approve the pool to spend the liquidity tokens
    IERC20(pool).approve(pool, liquidity);
    IERC20(pool).transfer(pool, liquidity);

    // Burn the liquidity tokens and receive the underlying assets (USDC and ETH)
    poolContract.burn(address(this));

    }
}
