// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';



contract SMTKToken is ERC20 {

    uint256 private _circulatingSupply;

  constructor() ERC20('Smart Token', 'SMKT') {
    uint256 totalSupply = 63963963 * 10 ** 18;
    _circulatingSupply = (totalSupply*59)/100;
    _mint(msg.sender, totalSupply);
  }

    function circulatingSupply() public view returns (uint256){
        return _circulatingSupply;
    }

    // TODO: Change function visibility
    function addCirculatingSupply(uint256 _value)
        external
        returns (bool success)
    {
        if (_value + _circulatingSupply <= this.totalSupply()) {
            _circulatingSupply += _value;
            return _value > 0;
        }
        return false;
    }

    // TODO: Change function visibility
    function removeCirculatingSupply(uint256 _value)
        external
        returns (bool success)
    {
        if (_circulatingSupply >= _value) {
            _circulatingSupply -= _value;
            return _value > 0;
        }
        return false;
    }

}
