// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";

contract SimpleSwapWithRouter {
    /**
     *  PERFORM A SIMPLE SWAP USING ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 ETH.
     *  The challenge is to swap any amount of ETH for USDC token using Uniswapv2 router.
     *
     */
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performSwapWithRouter(address[] calldata path) public {
        // your code start here

        IUniswapV2Router uniswapRouter = IUniswapV2Router(router);

        //approve ETH to router (we dont have to transfer to router)
        uint256 ethBalance = address(this).balance;

        uniswapRouter.swapExactETHForTokens{value: ethBalance}(
            1,
            path,
            address(this),
            block.timestamp + 1000
        );
    }

    receive() external payable {}
}

interface IUniswapV2Router {
    /**
     *     amountOutMin: the minimum amount of output tokens that must be received for the transaction not to revert.
     *     path: an array of token addresses. In our case, WETH and USDC.
     *     to: recipient address to receive the liquidity tokens.
     *     deadline: timestamp after which the transaction will revert.
     */
    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);
}
