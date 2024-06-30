// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NFTLending {
    struct Loan {
        address borrower;
        uint256 amount;
        uint256 interest;
        uint256 duration;
        uint256 startTime;
        address nftAddress;
        uint256 tokenId;
        bool repaid;
    }

    uint256 public loanCounter;
    mapping(uint256 => Loan) public loans;

    IERC20 public stableCoin;

    event LoanCreated(uint256 loanId, address borrower, uint256 amount, uint256 duration, address nftAddress, uint256 tokenId);
    event LoanRepaid(uint256 loanId, address borrower, uint256 amount);

    constructor(address _stableCoin) {
        stableCoin = IERC20(_stableCoin);
    }

    function collateralizeAndBorrow(address _nftAddress, uint256 _tokenId, uint256 _amount, uint256 _duration) external {
        IERC721 nft = IERC721(_nftAddress);
        require(nft.ownerOf(_tokenId) == msg.sender, "Not the owner of the NFT");
        nft.transferFrom(msg.sender, address(this), _tokenId);

        loanCounter++;
        loans[loanCounter] = Loan({
            borrower: msg.sender,
            amount: _amount,
            interest: calculateInterest(_amount, _duration),
            duration: _duration,
            startTime: block.timestamp,
            nftAddress: _nftAddress,
            tokenId: _tokenId,
            repaid: false
        });

        stableCoin.transfer(msg.sender, _amount);

        emit LoanCreated(loanCounter, msg.sender, _amount, _duration, _nftAddress, _tokenId);
    }

    function repayLoan(uint256 _loanId) external {
        Loan storage loan = loans[_loanId];
        require(msg.sender == loan.borrower, "Not the borrower");
        require(!loan.repaid, "Loan already repaid");
        require(block.timestamp <= loan.startTime + loan.duration, "Loan duration has passed");

        uint256 repaymentAmount = loan.amount + loan.interest;
        stableCoin.transferFrom(msg.sender, address(this), repaymentAmount);

        IERC721(loan.nftAddress).transferFrom(address(this), msg.sender, loan.tokenId);

        loan.repaid = true;

        emit LoanRepaid(_loanId, msg.sender, repaymentAmount);
    }

    function calculateInterest(uint256 _amount, uint256 _duration) internal pure returns (uint256) {
        return (_amount * _duration) / 10000;
    }
}
