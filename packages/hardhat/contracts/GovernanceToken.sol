// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ------------------------------------------------------------
// GovernanceToken.sol
// ERC-20 token used for DAO voting rights
// Each token = 1 vote in the DAO
// ------------------------------------------------------------

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GovernanceToken is ERC20, Ownable {

    // ---- State Variables ----
    uint256 public constant MAX_SUPPLY = 1_000_000 * 10 ** 18; // 1 million tokens max
    mapping(address => bool) public hasClaimed;                 // track free claim

    // ---- Events ----
    event TokensClaimed(address indexed claimant, uint256 amount);
    event TokensMinted(address indexed to, uint256 amount);

    // ---- Constructor ----
    // Mints 100,000 tokens to deployer on deploy
    constructor() ERC20("GovernanceToken", "GOV") Ownable(msg.sender) {
        _mint(msg.sender, 100_000 * 10 ** 18);
    }

    // ---- Modifier ----
    // Prevents minting beyond max supply
    modifier withinMaxSupply(uint256 amount) {
        require(totalSupply() + amount <= MAX_SUPPLY, "Exceeds max supply");
        _;
    }

    // ---- Functions ----

    // Owner can mint tokens to any address (for testing/distribution)
    function mint(address to, uint256 amount)
        external
        onlyOwner
        withinMaxSupply(amount)
    {
        _mint(to, amount);
        emit TokensMinted(to, amount);
    }

    // Anyone can claim 1000 GOV tokens once for free (faucet)
    function claimTokens() external withinMaxSupply(1000 * 10 ** 18) {
        require(!hasClaimed[msg.sender], "Already claimed");
        hasClaimed[msg.sender] = true;
        _mint(msg.sender, 1000 * 10 ** 18);
        emit TokensClaimed(msg.sender, 1000 * 10 ** 18);
    }

    // Check token balance of any address
    function getBalance(address account) external view returns (uint256) {
        return balanceOf(account);
    }
}
