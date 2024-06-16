// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

contract ExactSwapWithRouter {
    /**
     *  PERFORM AN SIMPLE SWAP WITH ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using UniswapV2 router.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performExactSwapWithRouter(address weth, address usdc) public {
        IUniswapV2Router _router = IUniswapV2Router(router);

        uint amountIn = 1 ether;

        // Define the path for WETH to USDC swap
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = usdc;

        // Approve the router to spend the WETH
        IERC20(weth).approve(router, amountIn);

        // Perform the swap
        _router.swapExactTokensForTokens(
            amountIn,
            1337 * 1e6,
            path,
            address(this),
            block.timestamp + 1000
        );
    }
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount of input tokens to swap.
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses. In our case, WETH and USDC.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}
