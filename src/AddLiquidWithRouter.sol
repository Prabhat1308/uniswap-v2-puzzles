// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract AddLiquidWithRouter {
    /**
     *  ADD LIQUIDITY WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 ETH.
     *  Mint a position (deposit liquidity) in the pool USDC/ETH to `msg.sender`.
     *  The challenge is to use Uniswapv2 router to add liquidity to the pool.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function addLiquidityWithRouter(address usdcAddress) public {
        // your code start here

        IUniswapV2Router uniswapRouter = IUniswapV2Router(router);
        
        uint256 tokenBalance = IERC20(usdcAddress).balanceOf(address(this));
        uint256 ethBalance = address(this).balance;

        require(tokenBalance > 0, "Insufficient USDC balance");
        require(ethBalance > 0, "Insufficient ETH balance");

        // Approve the Uniswap router to spend the USDC
        IERC20(usdcAddress).approve(router, tokenBalance);

        // Add liquidity to the Uniswap pool
        uniswapRouter.addLiquidityETH{value: ethBalance}(
            usdcAddress,
            tokenBalance,
            0, // putting these 0 is not safe, but for the sake of the exercise
            0,
            msg.sender,
            block.timestamp + 1000
        );
    }

    receive() external payable {}
}

interface IUniswapV2Router {
    /**
     *     token: the usdc address
     *     amountTokenDesired: the amount of USDC to add as liquidity.
     *     amountTokenMin: bounds the extent to which the ETH/USDC price can go up before the transaction reverts. Must be <= amountUSDCDesired.
     *     amountETHMin: bounds the extent to which the USDC/ETH price can go up before the transaction reverts. Must be <= amountETHDesired.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
}
