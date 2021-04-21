// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import "./SMTKToken.sol";

 contract BnbSwap {
    string public name = "BnbSwap Instant Exchange";
    SMTKToken public token;
    uint256 public upRate;
    uint256 public rate;
    uint256 public minTokenTrade;
    uint128 constant decimalPart = 1 * 10 ** 18;
    // Redention rate = # of token they receive from 1 ether

    event TokenPurchase(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    event TokenSold(
        address account,
        address token,
        uint256 amount,
        uint256 rate
    );

    constructor(SMTKToken _token){
        token = _token;
        upRate = 9192;
        minTokenTrade = token.totalSupply()/upRate;
    }

    function buyTokens() public payable{
        // tokenAmount = Amount of etheriem * Redemption rate
        uint256[2] memory buyInfo = this.getBuyInfo(msg.value);

        require(buyInfo[0] <= token.balanceOf(address(this)), "Invalid amount of tokens purchased are greater than exhange funds");

        token.transfer(msg.sender, buyInfo[0]);
        SMTKToken(token).addCirculatingSupply(buyInfo[0]);
        emit TokenPurchase(msg.sender, address(token), buyInfo[0], buyInfo[1]);
    }

    function sellTokens(uint256 _amountSMTK) public{
        // User can sell more tokens than they have
        require(token.balanceOf(msg.sender) >= _amountSMTK, "User does not have such amount of tokens");

        // Calculate the ether amount to redeem
        uint256[2] memory sellInfo = this.getSellInfo(_amountSMTK);

        require(sellInfo[0] <= address(this).balance, "Invalid amount of tokens sold are greater than exhange funds");

        token.transferFrom(msg.sender, address(this), _amountSMTK);
        token.removeCirculatingSupply(_amountSMTK);
        payable(msg.sender).transfer(sellInfo[0]);
        emit TokenSold(msg.sender, address(token), _amountSMTK, sellInfo[1]);
        
    }

    function getBuyInfo(uint256 _AmountBNB) public view returns (uint256[2] memory sellInfo){
        uint256 estimatedRate = getEstimatedRateBuySell(token.circulatingSupply()+(getEstimatedRateBuySell()*_AmountBNB)/2);
        sellInfo = [_AmountBNB*estimatedRate, estimatedRate];
        return sellInfo;
    }

    function getSellInfo(uint256 _amountSMTK) public view returns (uint256[2] memory buyInfo){
        uint256 estimatedRate = getEstimatedRateBuySell(token.circulatingSupply()-(_amountSMTK/2));
        buyInfo = [_amountSMTK/estimatedRate, estimatedRate];
        return buyInfo;
    }

    // estimated rate to buy [totalSupply/upRate] SMTK --> minToken SMTK (minimum by default)
    function getEstimatedRateBuySell(uint256 _circulatingSupply) public view returns(uint256){
        require(_circulatingSupply <= token.totalSupply());
        return upRate*(token.totalSupply()-_circulatingSupply)/token.totalSupply();
    }

    function getEstimatedRateBuySell() public view returns(uint256){
        return this.getEstimatedRateBuySell(token.circulatingSupply());
    }

}