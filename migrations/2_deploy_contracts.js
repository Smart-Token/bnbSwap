const Token = artifacts.require("Token");
const EthSwap = artifacts.require("EthSwap");

function tokens(n){
    return web3.utils.toWei(n,'ether');
}

module.exports = async function(deployer) {

    // Deploy Token
    await deployer.deploy(Token);
    const token = await Token.deployed();

    // Deploy EthSwap
    await deployer.deploy(EthSwap, token.address);
    const ethSwap = await EthSwap.deployed();

    // Transfer all tokens to EthSwap (100 million)
    await token.transfer(ethSwap.address, tokens('10000000'));
    //await token.transfer(, '5000000000000000000')
}
/*
token = await Token.deployed()
ethSwap = await EthSwap.deployed()
balance = await token.balanceOf(ethSwap.address)
*/