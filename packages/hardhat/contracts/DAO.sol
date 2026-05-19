// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// ------------------------------------------------------------
// DAO.sol
// Decentralized Autonomous Organization contract
// Members holding GOV tokens can create proposals,
// vote on them, and execute approved ones.
// ------------------------------------------------------------

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DAO {

    // ---- State Variables ----
    IERC20 public governanceToken;          // reference to GOV token
    address public owner;                   // deployer / admin
    uint256 public proposalCount;           // total proposals created
    uint256 public votingDuration = 3 days; // how long voting stays open
    uint256 public quorum = 100 * 10 ** 18; // min votes needed to pass (100 GOV)

    // ---- Proposal Struct ----
    struct Proposal {
        uint256 id;
        address proposer;
        string title;
        string description;
        uint256 votesFor;
        uint256 votesAgainst;
        uint256 deadline;
        bool executed;
        bool passed;
    }

    // ---- Mappings ----
    mapping(uint256 => Proposal) public proposals;
    // proposalId => voter => hasVoted
    mapping(uint256 => mapping(address => bool)) public hasVoted;

    // ---- Events ----
    event ProposalCreated(
        uint256 indexed proposalId,
        address indexed proposer,
        string title,
        uint256 deadline
    );
    event VoteCast(
        uint256 indexed proposalId,
        address indexed voter,
        bool support,
        uint256 weight
    );
    event ProposalExecuted(
        uint256 indexed proposalId,
        bool passed
    );
    event QuorumUpdated(uint256 newQuorum);
    event VotingDurationUpdated(uint256 newDuration);

    // ---- Modifiers ----

    // Only token holders can participate
    modifier onlyTokenHolder() {
        require(
            governanceToken.balanceOf(msg.sender) > 0,
            "Must hold GOV tokens to participate"
        );
        _;
    }

    // Only owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    // Proposal must exist
    modifier proposalExists(uint256 proposalId) {
        require(proposalId > 0 && proposalId <= proposalCount, "Proposal does not exist");
        _;
    }

    // Voting must still be open
    modifier votingOpen(uint256 proposalId) {
        require(block.timestamp < proposals[proposalId].deadline, "Voting period ended");
        _;
    }

    // ---- Constructor ----
    constructor(address _governanceToken) {
        require(_governanceToken != address(0), "Invalid token address");
        governanceToken = IERC20(_governanceToken);
        owner = msg.sender;
    }

    // ---- Core Functions ----

    // Create a new proposal (token holders only)
    function createProposal(string calldata title, string calldata description)
        external
        onlyTokenHolder
        returns (uint256)
    {
        require(bytes(title).length > 0, "Title cannot be empty");
        require(bytes(description).length > 0, "Description cannot be empty");

        proposalCount++;
        uint256 deadline = block.timestamp + votingDuration;

        proposals[proposalCount] = Proposal({
            id: proposalCount,
            proposer: msg.sender,
            title: title,
            description: description,
            votesFor: 0,
            votesAgainst: 0,
            deadline: deadline,
            executed: false,
            passed: false
        });

        emit ProposalCreated(proposalCount, msg.sender, title, deadline);
        return proposalCount;
    }

    // Cast a vote — weight = your token balance
    function vote(uint256 proposalId, bool support)
        external
        onlyTokenHolder
        proposalExists(proposalId)
        votingOpen(proposalId)
    {
        require(!hasVoted[proposalId][msg.sender], "Already voted on this proposal");

        uint256 weight = governanceToken.balanceOf(msg.sender);
        hasVoted[proposalId][msg.sender] = true;

        if (support) {
            proposals[proposalId].votesFor += weight;
        } else {
            proposals[proposalId].votesAgainst += weight;
        }

        emit VoteCast(proposalId, msg.sender, support, weight);
    }

    // Execute a proposal after voting ends
    function executeProposal(uint256 proposalId)
        external
        proposalExists(proposalId)
    {
        Proposal storage proposal = proposals[proposalId];

        require(block.timestamp >= proposal.deadline, "Voting still in progress");
        require(!proposal.executed, "Proposal already executed");

        proposal.executed = true;

        // Passes if: votesFor > votesAgainst AND total votes >= quorum
        if (
            proposal.votesFor > proposal.votesAgainst &&
            (proposal.votesFor + proposal.votesAgainst) >= quorum
        ) {
            proposal.passed = true;
        }

        emit ProposalExecuted(proposalId, proposal.passed);
    }

    // ---- View Functions ----

    // Get full proposal details
    function getProposal(uint256 proposalId)
        external
        view
        proposalExists(proposalId)
        returns (Proposal memory)
    {
        return proposals[proposalId];
    }

    // Check if a specific voter has voted on a proposal
    function didVote(uint256 proposalId, address voter)
        external
        view
        returns (bool)
    {
        return hasVoted[proposalId][voter];
    }

    // Get current vote counts for a proposal
    function getVotes(uint256 proposalId)
        external
        view
        proposalExists(proposalId)
        returns (uint256 votesFor, uint256 votesAgainst)
    {
        return (proposals[proposalId].votesFor, proposals[proposalId].votesAgainst);
    }

    // ---- Admin Functions ----

    // Owner can update quorum threshold
    function updateQuorum(uint256 newQuorum) external onlyOwner {
        require(newQuorum > 0, "Quorum must be > 0");
        quorum = newQuorum;
        emit QuorumUpdated(newQuorum);
    }

    // Owner can update voting duration
    function updateVotingDuration(uint256 newDuration) external onlyOwner {
        require(newDuration >= 1 hours, "Duration too short");
        votingDuration = newDuration;
        emit VotingDurationUpdated(newDuration);
    }
}
