# OceanEconomy Smart Contract

A comprehensive synthetic assets smart contract for tracking marine resources, shipping routes, and blue economy investments on the Stacks blockchain.

## 🌊 Overview

OceanEconomy is a Clarity smart contract that enables the creation, management, and trading of synthetic assets representing various aspects of the ocean economy. The contract facilitates investment in marine sustainability, shipping efficiency, and blue economy projects while providing transparent tracking and valuation mechanisms.

## ✨ Features

- **Marine Resources Management**: Track and tokenize marine resources with sustainability scoring
- **Shipping Route Optimization**: Register and manage shipping routes with carbon footprint tracking
- **Blue Economy Investments**: Create and monitor sustainable ocean economy investment opportunities
- **Synthetic Asset Trading**: Purchase tokens representing shares in ocean economy assets
- **Dynamic Pricing**: Real-time asset valuation with owner-controlled price updates
- **Emergency Controls**: Contract pause/unpause functionality for security
- **Portfolio Management**: Calculate and track user portfolio values
- **Ownership Tracking**: Secure asset ownership and transfer mechanisms

## 🔧 Technical Specifications

- **Blockchain**: Stacks
- **Language**: Clarity v2
- **Contract Version**: 1.0.0
- **Epoch**: 2.5
- **Token Standard**: Fungible Token (SIP-10)

### Asset Types

The contract supports three main asset categories:

1. **Marine Resources** (`MARINE-RESOURCE = 1`)
   - Fish stocks, coral reefs, protected areas
   - Sustainability scoring (0-100)
   - Location-based tracking

2. **Shipping Routes** (`SHIPPING-ROUTE = 2`)
   - Origin and destination tracking
   - Fuel efficiency metrics
   - Carbon footprint calculations

3. **Blue Economy Investments** (`BLUE-INVESTMENT = 3`)
   - Renewable energy projects
   - Sustainable aquaculture
   - Ocean cleanup initiatives

## 🚀 Installation

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) CLI tool
- Node.js (v16+)
- Stacks wallet for interaction

### Setup

1. Clone the repository:
```bash
git clone <repository-url>
cd OceanEconomy
```

2. Install dependencies:
```bash
cd OceanEconomy_contract
npm install
```

3. Check contract syntax:
```bash
clarinet check
```

4. Run tests:
```bash
npm test
```

## 📖 Usage Examples

### Initializing the Contract

```clarity
;; Deploy and initialize the contract (owner only)
(contract-call? .OceanEconomy initialize)
```

### Adding Marine Resources

```clarity
;; Add a new marine resource
(contract-call? .OceanEconomy add-marine-resource
  u1                           ;; asset-id
  "Pacific Tuna Stock"         ;; name
  "North Pacific Ocean"        ;; location
  "Fish Stock"                 ;; resource-type
  u500000                      ;; estimated-value (in micro-STX)
  u85                          ;; sustainability-score (0-100)
)
```

### Registering Shipping Routes

```clarity
;; Add a shipping route
(contract-call? .OceanEconomy add-shipping-route
  u1                           ;; route-id
  "Los Angeles"                ;; origin
  "Shanghai"                   ;; destination
  u11000                       ;; distance-km
  u14                          ;; avg-transit-time (days)
  u75                          ;; fuel-efficiency (0-100)
  u45000                       ;; carbon-footprint (kg CO2)
)
```

### Creating Blue Economy Investments

```clarity
;; Add a blue economy investment
(contract-call? .OceanEconomy add-blue-investment
  u1                           ;; investment-id
  "Offshore Wind Farm"         ;; project-name
  "Renewable Energy"           ;; investment-type
  u10000000                    ;; total-funding
  u12000000                    ;; current-valuation
  u95                          ;; environmental-impact (0-100)
  u15                          ;; roi-percentage
  u2050                        ;; maturity-date (block height)
)
```

### Trading Synthetic Assets

```clarity
;; Purchase tokens representing an asset
(contract-call? .OceanEconomy purchase-asset-tokens
  u1                           ;; asset-id
  u1                           ;; asset-type (MARINE-RESOURCE)
  u100                         ;; amount of tokens
)
```

## 📋 Contract Functions

### Public Functions

| Function | Description | Parameters |
|----------|-------------|------------|
| `initialize` | Initialize contract with initial token supply | None |
| `add-marine-resource` | Register a new marine resource | asset-id, name, location, resource-type, estimated-value, sustainability-score |
| `add-shipping-route` | Register a new shipping route | route-id, origin, destination, distance-km, avg-transit-time, fuel-efficiency, carbon-footprint |
| `add-blue-investment` | Create a new blue economy investment | investment-id, project-name, investment-type, total-funding, current-valuation, environmental-impact, roi-percentage, maturity-date |
| `update-asset-price` | Update asset pricing (owner only) | asset-id, asset-type, new-price |
| `purchase-asset-tokens` | Buy synthetic tokens for an asset | asset-id, asset-type, amount |
| `pause-contract` | Emergency pause (owner only) | None |
| `unpause-contract` | Remove emergency pause (owner only) | None |

### Read-Only Functions

| Function | Description | Returns |
|----------|-------------|---------|
| `get-marine-resource` | Retrieve marine resource details | Resource data or none |
| `get-shipping-route` | Retrieve shipping route details | Route data or none |
| `get-blue-investment` | Retrieve investment details | Investment data or none |
| `get-asset-owner` | Get asset ownership information | Owner principal or none |
| `get-asset-price` | Get current asset pricing | Price data or none |
| `get-user-balance` | Get user's token balance | Balance amount |
| `get-total-assets` | Get total number of assets | Asset count |
| `get-contract-paused` | Check if contract is paused | Boolean status |
| `calculate-portfolio-value` | Calculate user's portfolio value | Total value |

## 🚢 Deployment Guide

### Local Development (Clarinet)

1. Start local development environment:
```bash
clarinet console
```

2. Deploy contract:
```clarity
::deploy_contract OceanEconomy contracts/OceanEconomy.clar
```

3. Initialize contract:
```clarity
(contract-call? .OceanEconomy initialize)
```

### Testnet Deployment

1. Configure testnet settings in `settings/Testnet.toml`
2. Deploy using Clarinet:
```bash
clarinet deployments generate --testnet
clarinet deployments apply --testnet
```

### Mainnet Deployment

1. Configure mainnet settings in `settings/Mainnet.toml`
2. Ensure thorough testing on testnet
3. Deploy using Clarinet:
```bash
clarinet deployments generate --mainnet
clarinet deployments apply --mainnet
```

## 🔒 Security Features

### Access Controls

- **Contract Owner**: Exclusive rights to initialize, pause/unpause contract
- **Asset Owners**: Can update pricing for their owned assets
- **User Validation**: All transactions require valid principal authentication

### Safety Mechanisms

- **Emergency Pause**: Contract can be paused to prevent operations during security incidents
- **Input Validation**: All user inputs are validated for type and range
- **Asset Existence Checks**: Prevents duplicate asset creation
- **Balance Verification**: Ensures sufficient funds before token transfers

### Error Handling

The contract implements comprehensive error codes:

- `u100`: Owner-only operation attempted by non-owner
- `u101`: Insufficient balance for transaction
- `u102`: Invalid amount specified
- `u103`: Asset not found
- `u104`: Unauthorized operation
- `u105`: Asset already exists

## 🧪 Testing

Run the test suite to verify contract functionality:

```bash
# Run all tests
npm test

# Run tests with coverage report
npm run test:report

# Watch mode for development
npm run test:watch
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/new-feature`
3. Make your changes and add tests
4. Ensure all tests pass: `npm test`
5. Commit your changes: `git commit -am 'Add new feature'`
6. Push to the branch: `git push origin feature/new-feature`
7. Create a Pull Request

## 📄 License

This project is licensed under the ISC License.

## 🌐 Resources

- [Stacks Documentation](https://docs.stacks.co/)
- [Clarity Language Reference](https://docs.stacks.co/clarity/)
- [Clarinet Documentation](https://github.com/hirosystems/clarinet)
- [SIP-10 Fungible Token Standard](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md)

---

*Built with 🌊 for a sustainable ocean economy*