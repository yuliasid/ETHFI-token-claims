/*
  name: Claimed ETHFI by Wallet
  viz: Table
*/
SELECT
    tx.block_time AS claim_time,
    tx."from" AS claimer,
    evt.value / 1e18 AS ethfi_claimed
FROM
    ethereum.transactions AS tx
JOIN
    erc20_ethereum.evt_Transfer AS evt
ON
    tx.hash = evt.evt_tx_hash
WHERE
    tx."to" = 0x93fff4028927f53f708534397ed349b9cd4e2f9f --ethfi smart contract
    AND CAST(tx.data AS VARCHAR) LIKE '0x2e7ba6ef%' -- Transfer method
--    AND tx.block_time >= TIMESTAMP ''
ORDER BY
    claim_time DESC;
