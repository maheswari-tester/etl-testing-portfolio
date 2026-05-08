-- ================================================
-- Project 1: US Healthcare Claims DWH - BCBS NC
-- Author: Maheswari Santhakumar
-- Purpose: Staging layer data quality validation
-- ================================================

-- 1. Baseline count check (source vs staging)
SELECT COUNT(*) AS total_claims 
FROM practice_claims;

-- 2. Duplicate claim check
-- Expected: No claim_id should appear more than once
SELECT claim_id, COUNT(*) AS duplicate_count
FROM practice_claims
GROUP BY claim_id
HAVING COUNT(*) > 1;

-- 3. Data quality check - NULL and invalid values
-- Expected: 0 rows returned
SELECT * FROM practice_claims
WHERE paid_amt IS NULL
OR member_id LIKE '% %';

-- 4. Claim type breakdown check
-- Expected: Only HCFA, UB04, DENTAL allowed
SELECT claim_type, COUNT(*) AS claim_count
FROM practice_claims
GROUP BY claim_type
ORDER BY claim_count DESC;

-- 5. MINUS query -- records in source missing from staging
-- Most important reconciliation query in ETL testing
SELECT claim_id FROM practice_claims
MINUS
SELECT claim_id FROM practice_claims_staging;
-- If any rows returned = data loss = High defect
