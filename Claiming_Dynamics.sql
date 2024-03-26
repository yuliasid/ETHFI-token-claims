/*
  name: Claiming Dynamics
  viz: Line chart
*/

SELECT
    date(tx.block_time) AS claim_time,
  --  date_format(tx.block_time, '%d.%m %H.%i') AS claim_time,
    count(tx."from") AS claimer
FROM
    ethereum.transactions AS tx
WHERE
    tx."to" = 0x93fff4028927f53f708534397ed349b9cd4e2f9f --ethfi smart contract
    AND CAST(tx.data AS VARCHAR) LIKE '0x2e7ba6ef%' -- claim method
--    AND tx.block_time >= TIMESTAMP ''
GROUP BY
    1
ORDER BY
    1 ;
