# BT Solidity Learning

A hands-on learning project focused on Ethereum smart contract development and decentralized application (dApp) development using modern Web3 technologies.

## Overview

This project utilizes an open-source toolkit for building decentralized applications on the Ethereum blockchain. It provides a complete development environment for writing, deploying, testing, and interacting with smart contracts through a modern frontend.

## Tech Stack

* Next.js
* TypeScript
* RainbowKit
* Wagmi
* Viem
* Foundry
* Hardhat
* Ethereum

## Features

* **Contract Hot Reload** – Automatically updates the frontend when smart contracts are modified.
* **Custom Hooks** – Simplifies contract interactions with reusable React hooks and TypeScript autocompletion.
* **Reusable Web3 Components** – Pre-built components for faster dApp development.
* **Burner Wallet & Local Faucet** – Enables rapid local testing and development.
* **Wallet Integration** – Connect and interact with popular Ethereum wallet providers.
* **Local Development Environment** – Supports end-to-end smart contract development and testing.

## Prerequisites

Before running the project, ensure the following tools are installed:

* Node.js (v20.18.3 or later)
* Yarn (v1 or v2+)
* Git

## Installation

Clone the repository:

```bash
git clone <repository-url>
cd <project-folder>
```

Install dependencies:

```bash
yarn install
```

## Running the Project

### 1. Start Local Blockchain

```bash
yarn chain
```

### 2. Deploy Smart Contracts

```bash
yarn deploy
```

### 3. Launch Frontend Application

```bash
yarn start
```

The application will be available locally after startup.

## Learning Outcomes

Through this project, the following concepts were explored:

* Ethereum Blockchain Fundamentals
* Smart Contract Development with Solidity
* Contract Deployment and Testing
* Web3 Frontend Development
* Wallet Integration
* Decentralized Application Architecture
* Blockchain Development Workflows

## Project Structure

```text
├── packages/
│   ├── hardhat/
│   └── nextjs/
├── contracts/
├── deploy/
├── components/
├── hooks/
└── README.md
```

## References

* Scaffold-ETH 2
* Ethereum Documentation
* Hardhat Documentation
* Foundry Documentation
* Wagmi Documentation
* RainbowKit Documentation
