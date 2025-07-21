// Query untuk menghitung jumlah total elemen
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WITH COUNT(r) AS totalElemen

// Query untuk menghitung jumlah elemen yang sesuai
MATCH (doc:BussDoc)
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source 
  AND n.element = doc.target 
  AND r.relation IN doc.relation
WITH totalElemen, COUNT(r) AS jumlahSesuai

// Menghitung jumlah elemen yang tidak sesuai sebagai selisih
WITH totalElemen, jumlahSesuai, 
     (totalElemen - jumlahSesuai) AS jumlahTidakSesuai

// Menghitung persentase sesuai dan tidak sesuai
RETURN 
  totalElemen AS TotalElemen,
  jumlahSesuai AS ElemenSesuai, 
  jumlahTidakSesuai AS ElemenTidakSesuai,
  (toFloat(jumlahSesuai) / totalElemen) * 100 AS PersenSesuai,
  (toFloat(jumlahTidakSesuai) / totalElemen) * 100 AS PersenTidakSesuai