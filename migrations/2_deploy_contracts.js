const Token = artifacts.require("SMTKToken");
const BnbSwap = artifacts.require("BnbSwap");

function tokens(n){
    return web3.utils.toWei(n,'ether');
}

module.exports = async function(deployer) {

    // Deploy Token
    await deployer.deploy(Token);
    const token = await Token.deployed();

    // Deploy BnbSwap
    await deployer.deploy(BnbSwap, token.address);
    const bnbSwap = await BnbSwap.deployed();

    // Transfer all tokens to BnbSwap (100 million)
    //console.log(es.toString());
    await token.transfer(bnbSwap.address, tokens('6396396.3'));
    //await token.transfer(, '5000000000000000000')
}
/*
token = await Token.deployed()
bnbSwap = await BnbSwap.deployed()
balance = await token.balanceOf(bnbSwap.address)
*/