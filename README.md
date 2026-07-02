# SimpleBank.sol

A simple Ethereum smart contract built with Solidity and Foundry.

## About

This project is part of my Solidity learning journey.

The goal is to understand smart contract development by building a simple bank contract from scratch using Solidity and Foundry. Instead of copying existing contracts, I am implementing every feature step by step while learning how Ethereum smart contracts work.

This is my first Solidity project.

## Status

🚧 Work in progress — new features, security improvements, and tests will be added as I continue learning Solidity and smart contract development.

## Features

- Deposit ETH
- Withdraw ETH
- Track user balances
- Deposit and withdraw events
- Unit tests with Foundry

## Dependencies

This project uses **forge-std**, Foundry's standard library for testing.

The dependency is managed as a Git submodule.

## Project Structure

```text
src/        Smart contracts
test/       Foundry tests
script/     Deployment scripts
lib/        Project dependencies (forge-std)
```

## Build

```bash
forge build
```

## Run Tests

```bash
forge test
```

## Clone

Clone the repository with its submodules:

```bash
git clone --recurse-submodules https://github.com/pate026/SimpleBank.sol.git
```

If you already cloned the repository without submodules:

```bash
git submodule update --init --recursive
```

## Roadmap

- [x] Deposit
- [x] Withdraw
- [x] Events
- [x] Basic tests
- [ ] Access control
- [ ] Reentrancy protection
- [ ] Pausable contract
- [ ] Gas optimizations
- [ ] More unit tests
- [ ] Documentation improvements

## License

MIT License
