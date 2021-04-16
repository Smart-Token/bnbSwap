pragma solidity ^0.5.16;

import "./Token.sol";

 contract EthSwap {
    string public name = "EthSwap Instant Exchange";
    Token public token;
    uint256 public upRate;
    uint256 public rate;
    uint256 public minTokenTrade;
    uint128 constant decimalPart = 1000000000000000000;
    // Redention rate = # of token they receive from 1 ether

    event TokenPurchase(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    constructor(Token _token) public{
        token = _token;
        upRate = 1000000;
        minTokenTrade = token.totalSupply()/upRate;
    }

    function buyTokens() payable public {
        // tokenAmount = Amount of etheriem * Redemption rate
        uint256[2] memory purchaseInfo = this.getBuyInfo(msg.value);

        require(purchaseInfo[0] <= token.balanceOf(address(this)), "Invalid amount of tokens purchased are greater than exhange funds");

        // If minimun eth sended
        if (purchaseInfo[0] > 0){
            token.transfer(msg.sender, purchaseInfo[0]);
            token.addcirculatingSupply(purchaseInfo[0]);
        }
        emit TokenPurchase(msg.sender, address(token), purchaseInfo[0], purchaseInfo[1]);
    }

    function getBuyInfo(uint256 _amount) public view returns (uint256[2] memory purchaseInfo){
        uint256 estimatedRate = getEstimatedRateBuySell();
        uint256 tokenAmount = (estimatedRate*_amount);
        estimatedRate = getEstimatedRateBuySell(token.circulatingSupply()+tokenAmount/2);
        tokenAmount = (estimatedRate*_amount);
        purchaseInfo = [tokenAmount, estimatedRate];
        return purchaseInfo;
    }

    // estimated rate to buy [totalSupply/upRate] SMTK --> minToken SMTK (minimum by default)
    function getEstimatedRateBuySell(uint256 _circulatingSupply) public view returns(uint256){
        return (token.totalSupply()*upRate/_circulatingSupply);
    }

    function getEstimatedRateBuySell() public view returns(uint256){
        return this.getEstimatedRateBuySell(token.circulatingSupply());
    }

}