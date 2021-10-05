//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./ERC721.sol";



contract TurkeyFactory is ERC721{

    using SafeMath for uint256;
    constructor() ERC721() {}

    uint dnaDigits = 10;
    uint dnaModulus = 10 ** dnaDigits;
    uint _turkeysCounter;

    mapping (uint => address) public turkeyToOwner;
    mapping (address => uint) public ownerTurkeyCount;

    struct Turkey{
        uint id;
        string name;
        uint dna;
        address owner;
    }
    Turkey[] public turkeys;

    event NewTurkey(uint id, string _name, uint _dna);
    

    function createTurkey(string memory _name, uint _dna) private {
        uint id = turkeys.length;
        turkeys.push(Turkey(id, _name, _dna, msg.sender));
        turkeyToOwner[id] = msg.sender;
        ownerTurkeyCount[msg.sender] = ownerTurkeyCount[msg.sender].add(1);
        emit NewTurkey(id, _name, _dna);
    }
    
    function turkeysLength() public view returns(uint){
        return turkeys.length;
    }

    function generateRandomDna(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % dnaModulus;
    }
    
    function getTurkeyDna(uint _turkeyId) private view returns(uint){
        return turkeys[_turkeyId].dna;
    }

    function generateRandomTurkey(string memory _name) public {
        uint randDna = generateRandomDna(_name);
        createTurkey(_name, randDna);
    }
/////////////////////////////////////////////////////////////////////////////////
    mapping (uint => address) turkeyApprovals;

    function balanceOf(address _owner) external view override returns (uint256) {
        return ownerTurkeyCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view override returns (address) {
        return turkeyToOwner[_tokenId];
    }

    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerTurkeyCount[_to]++;
        ownerTurkeyCount[_from]--;
        turkeyToOwner[_tokenId] = _to;
        turkeys[_tokenId].owner = msg.sender;
        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override payable {
        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external override payable {
        turkeyApprovals[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
  
    

}
