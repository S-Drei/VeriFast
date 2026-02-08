# VeriFast

VeriFast is a Flare-powered loan verification system designed to drastically reduce mortgage approval times by automating real-world data verification.

## Problem

Mortgage loan applications often take weeks or even months to process. 
The delays aren’t due to complex transactions — they are caused by repeated manual verification:
- Buyer identity (KYC)
- Proof of income
- Proof of funds
- Credit checks
- Employment verification

These steps are slow, repetitive, and prone to errors, causing stress for both lenders and borrowers.

## Solution

VeriFast uses Flare’s Data Connector to verify real-world loan application data and provide trusted information to lenders instantly.

Instead of manually checking each document or data point, lenders can rely on verified data to move applications forward automatically.

## How Flare Is Used

Flare’s Data Connector allows smart contracts to access verified off-chain data without relying on a single middleman. 

In VeriFast, the Data Connector confirms:
- Identity verification
- Proof of income and employment
- Credit check confirmations
- Proof of funds

Once verified, the loan approval workflow progresses automatically, reducing delays and increasing transparency.

## Why This Matters

By automating verification with trusted data:
- Mortgage approval timelines shrink from weeks to days
- Borrowers experience faster, more transparent approvals
- Lenders reduce administrative workload and risk
- Fraud and errors are minimized

VeriFast does not replace lenders or regulatory processes but streamlines verification so humans spend less time waiting and more time approving loans.

## Project Status

This repository represents a concept design and system architecture submitted as a solo hackathon project. 

Smart contracts and integrations are represented at a conceptual level due to time and solo constraints.

## Future Development

- Integration with national credit bureaus and financial institutions
- Real-time loan status tracking
- Automated compliance verification
- Role-based access for banks and lenders


## Built on Flare

- **Network:** Coston2 Testnet
- **Integrations:** Flare Data Connector (FDC)
- **Demo:** [Watch the demo video](LINK_TO_YOUR_VIDEO)
- **Setup:** 
  1. Clone the repo
  2. Install dependencies: `npm install`
  3. Deploy contract on Flare Coston2 using MetaMask
  4. Interact with the contract via Remix or your frontend

- **Smart Contracts:**
  - VeriFastMortgage.sol
  - Deployed Contract Address: 0xdE25697F0CAd864fdAd35fBf0D05009B3FA47E13
  - Explorer link: [Coston2 Explorer](https://coston2-explorer.flare.network/address/0xdE25697F0CAd864fdAd35fBf0D05009B3FA47E13?tab=txs)

### Environment Variables

To deploy and interact with the contracts, create a `.env` file based on `.env.example`:

- `PRIVATE_KEY` — Your wallet private key (used to sign transactions). **Do not commit this key.**
- `RPC_URL` — The URL of the Flare Coston2 Testnet RPC.


---

Built for the ETH Oxford Hackathon.
