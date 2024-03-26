/*
  name: Claimed ETHFI 
  viz: Pie Chart
*/

WITH AirdropAllocation AS (
    SELECT
        1000000000 AS total_supply,
        1000000000 * 0.068 AS airdrop_allocation
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
),
Result AS (
    SELECT 'yes' AS status, total_ethfi_claimed AS claimed
    FROM ClaimedAmount
    UNION ALL
    SELECT 'no' AS status, total_ethfi_unclaimed AS claimed
    FROM UnclaimedAmount
)
SELECT status, claimed
FROM Result;
