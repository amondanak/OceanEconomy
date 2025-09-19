
;; title: OceanEconomy
;; version: 1.0.0
;; summary: A synthetic assets smart contract for tracking marine resources, shipping, and blue economy investments
;; description: This contract manages synthetic assets representing various aspects of the ocean economy,
;;              including marine resources, shipping routes, and blue economy investment opportunities.

;; traits
;;

;; token definitions
;; Define synthetic asset token
(define-fungible-token ocean-economy-token)

;; constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-insufficient-balance (err u101))
(define-constant err-invalid-amount (err u102))
(define-constant err-asset-not-found (err u103))
(define-constant err-unauthorized (err u104))
(define-constant err-asset-exists (err u105))

;; Asset types
(define-constant MARINE-RESOURCE u1)
(define-constant SHIPPING-ROUTE u2)
(define-constant BLUE-INVESTMENT u3)

;; data vars
(define-data-var total-assets uint u0)
(define-data-var contract-paused bool false)

;; data maps
;; Marine Resources tracking
(define-map marine-resources
  { asset-id: uint }
  {
    name: (string-ascii 50),
    location: (string-ascii 100),
    resource-type: (string-ascii 30),
    estimated-value: uint,
    sustainability-score: uint,
    last-updated: uint
  }
)

;; Shipping Routes tracking
(define-map shipping-routes
  { route-id: uint }
  {
    origin: (string-ascii 50),
    destination: (string-ascii 50),
    distance-km: uint,
    avg-transit-time: uint,
    fuel-efficiency: uint,
    carbon-footprint: uint,
    active: bool
  }
)

;; Blue Economy Investments tracking
(define-map blue-investments
  { investment-id: uint }
  {
    project-name: (string-ascii 100),
    investment-type: (string-ascii 50),
    total-funding: uint,
    current-valuation: uint,
    environmental-impact: uint,
    roi-percentage: uint,
    maturity-date: uint
  }
)

;; Asset ownership tracking
(define-map asset-owners
  { asset-id: uint, asset-type: uint }
  { owner: principal }
)

;; User balances for synthetic tokens
(define-map user-balances
  { user: principal }
  { balance: uint }
)

;; Asset price tracking
(define-map asset-prices
  { asset-id: uint, asset-type: uint }
  { price-per-unit: uint, last-price-update: uint }
)

;; public functions

;; Initialize contract (can only be called once by owner)
(define-public (initialize)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (try! (ft-mint? ocean-economy-token u1000000 contract-owner))
    (ok true)
  )
)

;; Add a new marine resource
(define-public (add-marine-resource
  (asset-id uint)
  (name (string-ascii 50))
  (location (string-ascii 100))
  (resource-type (string-ascii 30))
  (estimated-value uint)
  (sustainability-score uint))
  (begin
    (asserts! (not (get-contract-paused)) err-unauthorized)
    (asserts! (is-none (map-get? marine-resources { asset-id: asset-id })) err-asset-exists)
    (asserts! (<= sustainability-score u100) err-invalid-amount)

    (map-set marine-resources
      { asset-id: asset-id }
      {
        name: name,
        location: location,
        resource-type: resource-type,
        estimated-value: estimated-value,
        sustainability-score: sustainability-score,
        last-updated: block-height
      }
    )

    (map-set asset-owners
      { asset-id: asset-id, asset-type: MARINE-RESOURCE }
      { owner: tx-sender }
    )

    (map-set asset-prices
      { asset-id: asset-id, asset-type: MARINE-RESOURCE }
      { price-per-unit: estimated-value, last-price-update: block-height }
    )

    (var-set total-assets (+ (var-get total-assets) u1))
    (ok asset-id)
  )
)

;; Add a new shipping route
(define-public (add-shipping-route
  (route-id uint)
  (origin (string-ascii 50))
  (destination (string-ascii 50))
  (distance-km uint)
  (avg-transit-time uint)
  (fuel-efficiency uint)
  (carbon-footprint uint))
  (begin
    (asserts! (not (get-contract-paused)) err-unauthorized)
    (asserts! (is-none (map-get? shipping-routes { route-id: route-id })) err-asset-exists)

    (map-set shipping-routes
      { route-id: route-id }
      {
        origin: origin,
        destination: destination,
        distance-km: distance-km,
        avg-transit-time: avg-transit-time,
        fuel-efficiency: fuel-efficiency,
        carbon-footprint: carbon-footprint,
        active: true
      }
    )

    (map-set asset-owners
      { asset-id: route-id, asset-type: SHIPPING-ROUTE }
      { owner: tx-sender }
    )

    ;; Calculate route value based on efficiency and distance
    (let ((route-value (/ (* distance-km fuel-efficiency) u100)))
      (map-set asset-prices
        { asset-id: route-id, asset-type: SHIPPING-ROUTE }
        { price-per-unit: route-value, last-price-update: block-height }
      )
    )

    (var-set total-assets (+ (var-get total-assets) u1))
    (ok route-id)
  )
)

;; Add a new blue economy investment
(define-public (add-blue-investment
  (investment-id uint)
  (project-name (string-ascii 100))
  (investment-type (string-ascii 50))
  (total-funding uint)
  (current-valuation uint)
  (environmental-impact uint)
  (roi-percentage uint)
  (maturity-date uint))
  (begin
    (asserts! (not (get-contract-paused)) err-unauthorized)
    (asserts! (is-none (map-get? blue-investments { investment-id: investment-id })) err-asset-exists)

    (map-set blue-investments
      { investment-id: investment-id }
      {
        project-name: project-name,
        investment-type: investment-type,
        total-funding: total-funding,
        current-valuation: current-valuation,
        environmental-impact: environmental-impact,
        roi-percentage: roi-percentage,
        maturity-date: maturity-date
      }
    )

    (map-set asset-owners
      { asset-id: investment-id, asset-type: BLUE-INVESTMENT }
      { owner: tx-sender }
    )

    (map-set asset-prices
      { asset-id: investment-id, asset-type: BLUE-INVESTMENT }
      { price-per-unit: current-valuation, last-price-update: block-height }
    )

    (var-set total-assets (+ (var-get total-assets) u1))
    (ok investment-id)
  )
)

;; Update asset price
(define-public (update-asset-price (asset-id uint) (asset-type uint) (new-price uint))
  (begin
    (asserts! (not (get-contract-paused)) err-unauthorized)
    (let ((asset-owner-data (map-get? asset-owners { asset-id: asset-id, asset-type: asset-type })))
      (asserts! (is-some asset-owner-data) err-asset-not-found)
      (asserts! (is-eq (get owner (unwrap-panic asset-owner-data)) tx-sender) err-unauthorized)

      (map-set asset-prices
        { asset-id: asset-id, asset-type: asset-type }
        { price-per-unit: new-price, last-price-update: block-height }
      )
      (ok true)
    )
  )
)

;; Purchase synthetic tokens representing an asset
(define-public (purchase-asset-tokens (asset-id uint) (asset-type uint) (amount uint))
  (begin
    (asserts! (not (get-contract-paused)) err-unauthorized)
    (asserts! (> amount u0) err-invalid-amount)

    (let ((price-data (map-get? asset-prices { asset-id: asset-id, asset-type: asset-type })))
      (asserts! (is-some price-data) err-asset-not-found)

      (let ((price-per-unit (get price-per-unit (unwrap-panic price-data)))
            (total-cost (* amount price-per-unit))
            (user-balance (default-to u0 (get balance (map-get? user-balances { user: tx-sender })))))

        (try! (ft-transfer? ocean-economy-token total-cost tx-sender contract-owner))

        (map-set user-balances
          { user: tx-sender }
          { balance: (+ user-balance amount) }
        )

        (ok amount)
      )
    )
  )
)

;; Emergency pause contract (owner only)
(define-public (pause-contract)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (var-set contract-paused true)
    (ok true)
  )
)

;; Unpause contract (owner only)
(define-public (unpause-contract)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (var-set contract-paused false)
    (ok true)
  )
)

;; read only functions

;; Get marine resource details
(define-read-only (get-marine-resource (asset-id uint))
  (map-get? marine-resources { asset-id: asset-id })
)

;; Get shipping route details
(define-read-only (get-shipping-route (route-id uint))
  (map-get? shipping-routes { route-id: route-id })
)

;; Get blue investment details
(define-read-only (get-blue-investment (investment-id uint))
  (map-get? blue-investments { investment-id: investment-id })
)

;; Get asset owner
(define-read-only (get-asset-owner (asset-id uint) (asset-type uint))
  (map-get? asset-owners { asset-id: asset-id, asset-type: asset-type })
)

;; Get asset price
(define-read-only (get-asset-price (asset-id uint) (asset-type uint))
  (map-get? asset-prices { asset-id: asset-id, asset-type: asset-type })
)

;; Get user balance
(define-read-only (get-user-balance (user principal))
  (default-to u0 (get balance (map-get? user-balances { user: user })))
)

;; Get total assets count
(define-read-only (get-total-assets)
  (var-get total-assets)
)

;; Get contract pause status
(define-read-only (get-contract-paused)
  (var-get contract-paused)
)

;; Get contract owner
(define-read-only (get-contract-owner)
  contract-owner
)

;; Calculate portfolio value for a user
(define-read-only (calculate-portfolio-value (user principal))
  (let ((balance (get-user-balance user)))
    (* balance u1000) ;; Simplified calculation
  )
)

;; private functions

;; Helper function to validate asset type
(define-private (is-valid-asset-type (asset-type uint))
  (or (is-eq asset-type MARINE-RESOURCE)
      (or (is-eq asset-type SHIPPING-ROUTE)
          (is-eq asset-type BLUE-INVESTMENT)))
)
