pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC721/ERC721Full.sol";

contract EcoToken is ERC721Full {
  struct EcoArt {
    string artist;
    string title;
    string createdDate;
    string imgURI;
    string descURI;
  }

  mapping (uint256 => EcoArt) EcoArts;
  mapping (bytes => uint256) EcoArtsCreated;

  constructor(string memory name, string memory symbol) ERC721Full(name, symbol) public {}

  function mintECO(
    string memory _artist,
    string memory _title,
    string memory _createdDate,
    string memory _imgURI,
    string memory _descURI
  )
    public
  {

    bytes memory checksum = abi.encodePacked(_title, _artist);
    require(EcoArtsCreated[checksum] == 0, "Token has already been created");
    uint256 tokenId = totalSupply().add(1);

    EcoArts[tokenId] = EcoArt(_artist, _title, _createdDate, _imgURI, _descURI);
    EcoArtsCreated[checksum] = tokenId;

    _mint(msg.sender, tokenId);
  }

  function getECO(uint256 _tokenId) public view returns( string memory, string memory, string memory, string memory, string memory) {
    return ( EcoArts[_tokenId].artist, EcoArts[_tokenId].title, EcoArts[_tokenId].createdDate, EcoArts[_tokenId].imgURI, EcoArts[_tokenId].descURI);
  }

  function isTokenAlreadyCreated(string memory _title, string memory _artist) public view returns (bool) {
    return EcoArtsCreated[abi.encodePacked(_title, _artist)] != 0 ? true : false;
  }

  function removeECO(uint _tokenId) external {
    _burn(_tokenId);
  }
}
