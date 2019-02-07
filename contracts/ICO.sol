pragma solidity ^0.5.0;

import "./Token.sol";
import "./ERC223Interface.sol";
import "./AccessControl.sol";

contract ICO is ERC223Receiver, Ownable {

    Token public token;
    uint public rate;
    uint256 private _openingTime;
    uint256 private _closingTime;
    uint256 private _preSale_openingTime;
    uint256 private _preSale_closingTime;


    modifier timedICO{
        require(preSale_isOpen());
        require(isOpen());
        _;
        
    }

    constructor (address _tokenAddress, uint256 preSale_openingTime, uint256 preSale_closingTime, uint256 openingTime, uint256 closingTime) public {
        token = Token(_tokenAddress);
//        token.transfer(address(this), 50000000);

        require(openingTime >= block.timestamp);
        require(closingTime > openingTime);

        _openingTime = openingTime;
        _closingTime = closingTime;
        _preSale_closingTime = preSale_closingTime;
        _preSale_openingTime = preSale_openingTime;
    }


//    function icoBalanceTransfer() internal {
//
//        emit Transfer(address(0), msg.sender, _value);
//        emit Transfer(address(0), msg.sender, _value);
//
//    }

    function tokenFallback(address _sender, address _origin, uint _value, bytes memory _data ) public returns(bool) {
        require(_sender == owner);
//        buyToken(msg.sender);
    }

//    function buyToken() public payable onlyWhileOpen{
//        require((msg.value * rate) <= token.balanceOf(address(this)));
//        token.transfer(msg.sender, (msg.value * rate));
//    }

    function buyToken() public payable timedICO{
        if(preSale_isOpen()){
            rate = 8;
        }
        else if(isOpen()){
            rate = 10;
        }

        require((msg.value * rate) <= token.balanceOf(address(this)));
        token.transfer(msg.sender, (msg.value * rate));
    }

    function tokenWithdraw() public onlyOwner {
        token.transfer(owner, token.balanceOf(address(this)));
    }

    function getBalance() public view returns (uint) {
        return token.balanceOf(msg.sender);
    }

    function getICOBalance() public view returns (uint) {
        return token.balanceOf(address(this));
    }

    function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
        uint256 etherAmount = _weiAmount / 1000000000000000000;
        return etherAmount*rate;
    }

    //timed ICO
    function openingTime() public view returns (uint256) {
        return _openingTime;
    }
    /**
  * @return the crowdsale closing time.
  */
    function closingTime() public view returns (uint256) {
        return _closingTime;
    }

    function preSale_openingTime() public view returns (uint256) {
        return _preSale_openingTime;
    }

    function preSale_closingTime() public view returns (uint256) {
        return _preSale_closingTime;
    }



    /**
     * @return true if the crowdsale is open, false otherwise.
     */
    function isOpen() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
    }

    /**
     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
     * @return Whether crowdsale period has elapsed
     */
    function hasClosed() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp > _closingTime;
    }

    function preSale_isOpen() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp >= _preSale_openingTime && block.timestamp <= _preSale_closingTime;
    }

    /**
     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
     * @return Whether crowdsale period has elapsed
     */
    function preSale_hasClosed() public view returns (bool) {
        // solhint-disable-next-line not-rely-on-time
        return block.timestamp > _preSale_closingTime;
    }

}
