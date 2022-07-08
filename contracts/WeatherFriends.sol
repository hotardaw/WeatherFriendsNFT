//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error WeatherFriends__SaleNotStarted();
error WeatherFriends__NeedMoreETHSent();
error WeatherFriends__TotalSupplyExceeded();

contract WeatherFriends is ERC721, Ownable {
    // NFT Variables
    uint256 public s_tokenCounter;
    uint256 public s_maxTokenSupply = 100;
    uint256 private i_mintFee = 0.02 ether;
    bool public saleStarted;

    // Events

    constructor() ERC721("WeatherFriends", "WFRNDS") {
        s_tokenCounter = 0;
    }

    // Functions

    function mintWeatherFriend(uint256 _count) external payable {
        if (!saleStarted) {
            revert WeatherFriends__SaleNotStarted();
        }
        if (msg.value <= i_mintFee) {
            revert WeatherFriends__NeedMoreETHSent();
        }
        if (s_tokenCounter + _count <= s_maxTokenSupply) {
            revert WeatherFriends__TotalSupplyExceeded();
        }
        for (uint256 i = 1; i <= _count; i++) {
            _safeMint(msg.sender, s_tokenCounter);
        }
    }

    // Helper Functions

    function startSale(bool _hasStarted) external onlyOwner {
        saleStarted = _hasStarted;
    }

    function checkSaleStatus() public view returns (bool) {
        return saleStarted;
    }
}
