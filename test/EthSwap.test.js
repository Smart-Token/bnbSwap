const { assert } = require('chai');
const { default: Web3 } = require('web3')

const Token = artifacts.require('Token')
const EthSwap = artifacts.require('EthSwap')

require('chai')
.use(require('chai-as-promised'))
.should()

function tokens(n){
    return web3.utils.toWei(n,'ether');
}

contract ('EthSwap', ([deployer, investor]) => {
    let ethSwap, token, ethSwapBalanceAfter, result;

    before(async () => {
        token = await Token.new();
        ethSwap = await EthSwap.new(token.address);
        await token.transfer(ethSwap.address, tokens('10000000'));
    })

    describe('Token deployement', async => {
        it('contract has a name', async () => {
            const name = await token.name();
            assert.equal(name, 'Smart Token')
            
        })
    })

    describe('EthSwap deployement', async => {
        it('contract has a name', async () => {
            const name = await ethSwap.name();
            assert.equal(name, 'EthSwap Instant Exchange');
        })
        it('ethSwap has tokens', async () => {            
            let balance = await token.balanceOf(ethSwap.address);
            assert.equal(balance.toString(), tokens('10000000'));
         })
        })

    describe('buyToken()', async => {
        before(async () => {
            // Purchase tokens before each exameple
            ethSwapBalanceAfter = await token.balanceOf(ethSwap.address);

            result = await ethSwap.buyTokens({from: investor, value: web3.utils.toWei('100', 'ether')});
        }) 
        it('Allows user to instantly purchase tokens from ethSwap for a calculated price', async () => {            
            // Check investor token balance after purchase
            let investorBalance = await token.balanceOf(investor);
            /*
            let initalRate = await ethSwap.getEstimatedRateBuySell();
            console.log(initalRate.toString());
            */
            console.log(investorBalance.toString());
            
           //let amountTokens_Surplus = await ethSwap.getRateBuy(web3.utils.toWei('1', 'ether'));
           //console.log(amountTokens_Surplus.toString());
            assert.notEqual(investorBalance.toString(), '0');
            let ethSwapBalanceBefore = await token.balanceOf(ethSwap.address);
            assert.notEqual(ethSwapBalanceAfter, ethSwapBalanceBefore);

            const event = result.logs[0].args;
            assert.equal(event.account, investor);
            assert.equal(event.token, token.address);
            //console.log(result.logs)
            
        })
    })

})