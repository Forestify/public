/*
   _____                       ____                  _   __  __      _            
  / ____|                     |  _ \                | | |  \/  |    | |           
 | |  __ _ __ ___  ___ _ __   | |_) | ___  _ __   __| | | \  / | ___| |_ ___ _ __ 
 | | |_ | '__/ _ \/ _ \ '_ \  |  _ < / _ \| '_ \ / _` | | |\/| |/ _ \ __/ _ \ '__|
 | |__| | | |  __/  __/ | | | | |_) | (_) | | | | (_| | | |  | |  __/ ||  __/ |   
  \_____|_|  \___|\___|_| |_| |____/ \___/|_| |_|\__,_| |_|  |_|\___|\__\___|_|   
                                                                                                                                                                  
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract GBMland is ERC721Enumerable, Ownable {

    using SafeMath for uint256; 
    using Strings for uint256;
        
    bool private mintStarted = true;

    mapping(uint256 => string) private _baseURIs;
    mapping(uint256 => string) private _tokenURIs;
    mapping(string => uint256) private _codeList;
    mapping(uint256 => address) private _addressList;
 
    constructor() ERC721("GBM Land", "GBML") { 
      
        _baseURIs[1] = "https://gis.gbmland.io/Gbmlf608e3feb03fc7cab8c8f9c054d56123dddb/";
        _baseURIs[2] = "https://gis.gbmland.io/Gbmlc1c149afbf4c8996fb92427ae41e4649b934/";
        
    }

    function getBaseURI(uint256 _type) public view returns(string memory){
        require(bytes(_baseURIs[_type]).length > 0, "the type does not exist");
        return _baseURIs[_type];
    }

    function updateBaseURI(uint256 _type, string memory _baseURI) public onlyOwner{
        require(bytes(_baseURIs[_type]).length > 0, "the type does not exist");
        _baseURIs[_type] = _baseURI;
    }

    function addBaseURI(uint256 _type, string memory _baseURI) public onlyOwner{
        require(bytes(_baseURIs[_type]).length == 0,"the type exists");
        _baseURIs[_type] = _baseURI;
    }  


    function mint(uint256 _type, string[] memory _code, address _receiver) public onlyOwner returns (uint256, uint256){
                
        require(mintStarted == true, "The mint is paused");
        require(msg.sender != address(0x0), "sender address is not correct");
        require(_receiver != address(0x0), "receiver address is not correct");
                        
        uint256 newItem;    
        string memory uniqueCode;
        uint256 newItemInit = totalSupply() + 1;

        uint256 i;
        for(i=0;i<_code.length;i++){
            newItem = totalSupply() + 1;   
            totalSupply() + 1;
                       
            uniqueCode = string(abi.encodePacked(_type.toString(),_code[i]));

            _safeMint(_receiver, newItem);
            _setTokenURI(newItem, uniqueCode);
            _setTokenIdWithCode(uniqueCode, newItem);
            _addressList[newItem] = _receiver;
        }
        
        return (newItemInit,newItem);
    }

    function withdraw() public onlyOwner {        
        payable(msg.sender).transfer(address(this).balance);
    }

    function startMint() public onlyOwner {
        mintStarted = true;
    }

    function pauseMint() public onlyOwner {
        mintStarted = false;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "URI query for nonexistent token");
        
        string memory uniqueCode = _tokenURIs[tokenId];
    
        uint256 _type = toNum(substring(uniqueCode, 0, 1));
        string memory code = substring(uniqueCode, 1, bytes(uniqueCode).length);
        string memory uri = string(abi.encodePacked(_baseURIs[_type], code,'.json' ));
    
        return uri;
    
    }
    
    function substring(string memory str, uint startIndex, uint endIndex) private pure returns (string memory ) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }

    function toNum(string memory numString) private pure returns(uint) {
        uint  val=0;
        bytes   memory stringBytes = bytes(numString);
        for (uint  i =  0; i<stringBytes.length; i++) {
            uint exp = stringBytes.length - i;
            bytes1 ival = stringBytes[i];
            uint8 uval = uint8(ival);
           uint jval = uval - uint(0x30);
   
           val +=  (uint(jval) * (10**(exp-1))); 
        }
      return val;
    }

  
    function _setTokenURI(uint256 _tokenId, string memory _uniqueCode) private onlyOwner{
        _tokenURIs[_tokenId] = _uniqueCode;
    }
    
    function _setTokenIdWithCode(string memory _uniqueCode, uint256 _tokenId) private onlyOwner{
        _codeList[_uniqueCode] = _tokenId;
    }

    function getCodeWithTokenId(uint256 _tokenId) public view returns (string memory) {
        
        require(_exists(_tokenId), "URI query for nonexistent token");
        string memory code = substring(_tokenURIs[_tokenId],1,bytes(_tokenURIs[_tokenId]).length);

        return code;
    }

    function codeURI(uint256 _type, string memory _code) public view returns (string memory) {
        require(_type > 0, "type null");
        require(bytes(_code).length > 0, "code null" );
        require(bytes(_baseURIs[_type]).length > 0, "the type does not exist");
        
        string memory uri = string(abi.encodePacked(_baseURIs[_type], _code, '.json' ));
    
        return uri;
    
    }

    function getTokenIDWithCode(uint256 _type, string memory _code) public view returns(uint256){
       uint256 tokenId = _codeList[string(abi.encodePacked(_type.toString(), _code ))];

       return tokenId;
       
    }

    function getAddressWithTokenId(uint256 _tokenId) public view returns(address){
        return _addressList[_tokenId];
    }

}