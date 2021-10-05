//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

/// @dev A marketplace for selling/purchasing NFTs to/from other users.
interface IMarket {
  /// @dev The status of a listing
  enum Status { Canceled, Active, Sold }

  /// @dev The data stored for each listing on this Market
  struct Listing {
    address contract_; 
    uint token;
    address seller;
    uint price;
    Status status;
  }

  /// @dev Event that is emitted when a listing is created.
  event ListingCreated(
    address indexed _contract,
    uint indexed _token,
    address indexed _seller,
    uint _price
  );

  /// @dev Event that is emitted when a listing is canceled.
  event ListingCanceled(uint indexed _listing);

  /// @dev Event that is emitted when a listing is sold.
  event ListingSold(uint indexed _listing);

  /// @dev The price of creating a new listing.
  function listingCreationPrice() external view returns(uint);

  /// @dev Percentage of the purchasing price that is retained by the Market operator.
  function listingPurchaseFee() external view returns(uint);

  /// @dev Get all active listings.
  function activeListings() external view returns(uint[] memory);

  /// @dev Get the details of a listing.
  function getListing(uint _listing) external view returns(Listing memory);

  /// @dev Create a new listing.
  function createListing(address _contract, uint _token, uint _price) external payable returns(uint listing);

  /// @dev Cancel an active listing.
  function cancelListing(uint _listing) external;

  /// @dev Purchase an active listing.
  function purchase(uint _listing) external payable;
}