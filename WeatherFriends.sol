//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract WeatherFriends is ERC721Enumerable, Ownable {
    // NFT Variables
    string public constant TOKEN_URI =
        "ipfs://bafkreidd7uq2xsfg6prxf2r6p4utjqbry57snbknjyy3uxbi56myu4ftf4";
    uint256 private s_tokenCounter;
    uint256 public s_maxTokenSupply = 100;
    uint256 private i_mintPrice = 0.02 ether;
    bool public saleStarted;

    // Events

    constructor() ERC721("WeatherFriends", "WFDS") {
        s_tokenCounter = 0;
    }

    // Functions

    function mintWeatherFriend(uint256 quantityToMint) public payable {
        uint256 supply = totalSupply();
        require(saleStarted, "Sale must be active to mint");
        require(
            quantityToMint > 0 && quantityToMint <= 3,
            "Invalid purchase amount"
        );
        require(
            (supply + quantityToMint) <= s_maxTokenSupply,
            "Purchase would exceed max supply of WeatherFriends"
        );
        require(
            (i_mintPrice * quantityToMint) == msg.value,
            "Ether value sent is not correct"
        );

        for (uint256 i; i < quantityToMint; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    // Helper Functions

    function tokenURI(
        uint256 /*tokenId*/
    ) public view override returns (string memory) {
        return TOKEN_URI;
    }

    function checkTokenCounter() public view returns (uint256) {
        return s_tokenCounter;
    }

    function startSale(bool _hasStarted) external onlyOwner {
        saleStarted = _hasStarted;
    }

    function checkSaleStatus() public view returns (bool) {
        return saleStarted;
    }
}
