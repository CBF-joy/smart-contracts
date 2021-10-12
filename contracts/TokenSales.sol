pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

contract TokenSales {

  ERC721Full public nftAddress;
  mapping (uint256 => uint256) public tokenPrice;
  mapping (uint256 => string) public toDate;
  mapping (uint256 => string) public fromDate;
  
  constructor(address _tokenAddress) public {
    nftAddress = ERC721Full(_tokenAddress);
  }


  //판매
  //nft 매도 (하나씩)
  function setForSaleEach(uint256 _tokenId, uint256 _price, string memory _fromDate, string memory _toDate) public {
    address tokenOwner = nftAddress.ownerOf(_tokenId);
    require(tokenOwner == msg.sender, "caller is not token owner");
    require(_price >= 0, "price is lower than zero");
    require(keccak256(abi.encodePacked(_toDate)) != keccak256(abi.encodePacked("0")), "auction date is wrong");
    require(nftAddress.getApproved(_tokenId) == address(this), "token owner did not approve TokenSales contract");
    
    tokenPrice[_tokenId] = _price;
    toDate[_tokenId] = _toDate;
    fromDate[_tokenId] = _fromDate;
  }

  //구매
  //nft 매수
  function purchaseToken(uint256 _tokenId) public payable {
    uint256 price = tokenPrice[_tokenId];
    address tokenSeller = nftAddress.ownerOf(_tokenId);
    require(msg.value >= price, "caller sent klay lower than price");
    require(msg.sender != tokenSeller, "caller is token seller");

    address payable payableTokenSeller = address(uint160(tokenSeller));
    payableTokenSeller.transfer(msg.value);
    nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);
    
    tokenPrice[_tokenId] = 0;
    toDate[_tokenId] = 'null';
    fromDate[_tokenId] = 'null';
  }

  //판매취소
  //nft 매도 (하나씩) (토큰 price 0으로 초기화)
  function removeTokenOnSaleEach(uint256 _tokenId) public {
    require(_tokenId > 0, "tokenId is null");
    address tokenSeller = nftAddress.ownerOf(_tokenId);
    require(msg.sender == tokenSeller, "caller is not token seller");

    tokenPrice[_tokenId] = 0;
    toDate[_tokenId] = 'null';
    fromDate[_tokenId] ='null';
  }
}
