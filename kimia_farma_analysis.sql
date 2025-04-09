SELECT * FROM `rakamin-kf-analytics-456312.Kimia_Farma.kf_final_transaction` LIMIT 10;
SELECT * FROM `rakamin-kf-analytics-456312.Kimia_Farma.kf_product` LIMIT 10;
SELECT * FROM `rakamin-kf-analytics-456312.Kimia_Farma.kf_kantor_cabang` LIMIT 10;
SELECT * FROM `rakamin-kf-analytics-456312.Kimia_Farma.kf_inventory` LIMIT 10;


CREATE OR REPLACE TABLE `rakamin-kf-analytics-456312.Kimia_Farma.kimia_farma_analysis` AS
SELECT
  t.transaction_id,
  t.date,
  t.branch_id,
  cb.branch_name,
  cb.kota,
  cb.provinsi,
  cb.rating,
  t.customer_name,
  t.product_id,
  p.product_name,
  p.price,
  t.discount_percentage,

  -- Hitung persentase gross laba
  CASE 
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price <= 100000 THEN 0.15
    WHEN p.price <= 300000 THEN 0.20
    WHEN p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Harga setelah diskon
  (p.price * (1 - t.discount_percentage)) AS nett_sales,

  -- Keuntungan bersih (nett profit)
  (p.price * (1 - t.discount_percentage)) * 
  CASE 
    WHEN p.price <= 50000 THEN 0.10
    WHEN p.price <= 100000 THEN 0.15
    WHEN p.price <= 300000 THEN 0.20
    WHEN p.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS nett_profit,

FROM 
  `rakamin-kf-analytics-456312.Kimia_Farma.kf_final_transaction` t
JOIN 
  `rakamin-kf-analytics-456312.Kimia_Farma.kf_product` p 
  ON t.product_id = p.product_id
JOIN 
  `rakamin-kf-analytics-456312.Kimia_Farma.kf_kantor_cabang` cb 
  ON t.branch_id = cb.branch_id;
