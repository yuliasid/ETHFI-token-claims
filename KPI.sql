/*
  name: KPI
  viz: Counters (KPI objects)
*/

with AirdropAllocation as (
    SELECT
        1000000000                  AS total_supply,
        1000000000 * 0.068          AS airdrop_allocation
    ),
ClaimedAmount AS (
    SELECT
        SUM(evt.value / 1e18) AS total_ethfi_claimed
    FROM
        ethereum.transactions AS tx
    JOIN
        erc20_ethereum.evt_Transfer AS evt
    ON
        tx.hash = evt.evt_tx_hash
    WHERE
        tx."to" = 0x93fff4028927f53f708534397ed349b9cd4e2f9f -- etherfi airdrop smart contract
        AND CAST(tx.data AS VARCHAR) LIKE '0x2e7ba6ef%' -- Transfer method
        
),
UnclaimedAmount AS (
    SELECT
        airdrop_allocation - total_ethfi_claimed AS total_ethfi_unclaimed
    FROM
        AirdropAllocation,
        ClaimedAmount
)
SELECT
    total_supply, 
    airdrop_allocation AS total_airdrop_allocation,
    total_ethfi_claimed AS total_claimed,
    (total_ethfi_claimed / airdrop_allocation) * 100 AS total_claimed_percent,
    total_ethfi_unclaimed AS total_unclaimed,
    (total_ethfi_unclaimed / airdrop_allocation) * 100 AS total_unclaimed_percent
FROM
    AirdropAllocation,
    ClaimedAmount,
    UnclaimedAmount;
