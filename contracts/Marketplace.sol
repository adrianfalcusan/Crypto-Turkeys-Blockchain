//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "./IMarket.sol";
import "./TurkeyFactory.sol";
import "./Ownable.sol";

//import "./MyToken.sol";
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";




contract Marketplace is IMarket, TurkeyFactory, Ownable{
    
    Listing[] public listings; 
    mapping(uint => uint) public idToListing;
    
    constructor(){
        
    }
    
    function listingsLength() public view returns(uint){
        return listings.length;
    }
    /// @dev The price of creating a new listing.
    function listingCreationPrice() external override pure returns(uint){
          return 2;
    }

    /// @dev Percentage of the purchasing price that is retained by the Market operator.
    function listingPurchaseFee() external override pure returns(uint){
          return 5;
    }

    /// @dev Get all active listings.
    function activeListings() external override view returns(uint[] memory){
    uint256[] memory _activeListings = new uint256[](listings.length);
        for(uint i=0; i <= listings.length; i++){
            if(listings[i].status == Status.Active){
                _activeListings[i] = i;
                i++;
            }
        }
        return _activeListings;
    }

    /// @dev Get the details of a listing.
    function getListing(uint _listing) external override view returns(Listing memory){
        return listings[_listing];
    }
    
    /// @dev Create a new listing.
    function createListing(address _contract, uint _token, uint _price) external override payable returns(uint listing){
        listings.push(Listing(_contract, _token, msg.sender, _price, Status.Active));
        listing = listings.length-1;
        idToListing[_token] = listing;
        return listing;
    }

    /// @dev Cancel an active listing.
    function cancelListing(uint _listing) external override{
        listings[_listing].status = Status.Canceled;
    }

    /// @dev Purchase an active listing.
    function purchase(uint _token) external override payable{
        uint _listing = idToListing[_token];
        transferFrom(listings[_listing].seller, msg.sender, listings[_listing].token);
        listings[_listing].status = Status.Sold;
        require(listings[_listing].price == msg.value);
        payable(listings[_listing].seller).transfer(msg.value);
    }

}
