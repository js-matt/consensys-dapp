# Consensys Hometask

This project is a simple decentralized application (dApp) that demonstrates how to use ConsenSys products (Infura, MetaMask, and Truffle) to deploy and interact with a smart contract on the Ethereum blockchain.

## Prerequisites

- Node.js and npm installed
- MetaMask extension installed in your browser
- An Ethereum test network account (e.g., Goerli)
- Infura account and project

## Setup

### Step 1: Install Dependencies

First, clone the repository and install the necessary dependencies:

```bash
git https://github.com/js-matt/consensys-dapp
cd consensys-dapp
npm install
```

### Step 2: Configure Infura

1. Sign up at Infura.
2. Create a new project.
3. Note the project's endpoint URL and API key.

### Step 3: Configure Environment
Copy `.env.sample` to `.env` and add required API key and URL.

### Step 4: Compile and Deploy Smart Contract

Compile and deploy the smart contract to the Goerli network:

```
truffle compile
truffle migrate --network goerli
```
