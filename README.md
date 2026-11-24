# Praise Board

Commuters tip Ifeoma's bus-timetable site with a short note. No platform, no cut.

**Deployed contract (Sepolia):** `0x98156cAF5904DDcA945830449c34D6466734eD62`  
https://sepolia.etherscan.io/address/0x98156cAF5904DDcA945830449c34D6466734eD62  
**Live page:** PASTE_PAGES_URL_HERE

## Design decisions
- **Where the record lives:** every tip is stored in the contract and emitted as a `Tipped` event. The wall is rebuilt in the browser from those events only, via a public Sepolia RPC. There is no backend or database, so nobody (including Ifeoma) can fake or delete an entry.
- **Who can withdraw:** `owner` is `immutable`, set at deploy. Only the owner can call `withdraw()`, and it only pays the owner. No admin, no upgrade, no fee.
- **Failure handling:** no wallet, wrong network (auto-switch prompt), rejected prompt, insufficient funds, reverted tx, zero amount, and notes over 140 bytes (checked in the page and enforced by the contract).
- **Notes are rendered with `textContent`**, so a hostile note can't inject HTML.
- Plain transfers to the contract revert, so every tip comes with a record.

## Run it
```
npm install
cp .env.example .env     # add QuickNode Sepolia URL + BURNER wallet key (never a real wallet)
npm run compile
npm run deploy           # writes deployed.json
npx serve .              # or push to GitHub Pages
```
Fund the burner with Sepolia ETH from a faucet first. Don't commit `.env`.
