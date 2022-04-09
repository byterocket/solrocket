<h1 align=center><code>
🚀 solrocket 🚀
</code></h1>

A small set of smart contracts.

## Contracts

-   `Ownable` : An ownable contract using the Two-Step Transfer Pattern
-   `Whitelisted` : Implementation of a whitelist as access control mechanism
-   `PreventReentrant` : Gas efficient implementation for reentrancy protection

## Installation

To install with [**Foundry**](https://github.com/gakonst/foundry):

```sh
forge install byterocket/solrocket
```

## Getting Started

Clone or fork `byterocket/solrocket`

```sh
git clone https://github.com/byterocket/solrocket.git
```

Install dependencies

```sh
forge install
```

Test compilation

```sh
forge build
```

## Usage

Common tasks are executed through a `Makefile`:

```
make help
> build         Build project
> clean         Remove build artifacts
> test          Run testsuite
```

## Safety

This is experimental software and is provided on an "as is" and "as available" basis.

We do not give any warranties and will not be liable for any loss incurred through any use of this codebase.
