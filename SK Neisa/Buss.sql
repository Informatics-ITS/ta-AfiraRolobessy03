MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE m.name = "Mencari koleksi buku" AND n.name = "Pencarian koleksi buku"
RETURN m,n,r

MATCH (doc:BussDoc)
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source AND n.element = doc.target AND r.relation IN doc.relation
      AND  m.name = "Mencari koleksi buku" AND n.name = "Pencarian koleksi buku"
RETURN 'Sesuai' AS description, 
       m.element AS source, 
       m.name AS sourceName, 
       n.element AS target, 
       n.name AS targetName, 
       r.relation AS relation


MATCH (doc:BussDoc)
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source 
  AND n.element = doc.target 
  AND r.relation IN doc.relation
  AND m.name = "Mencari koleksi buku" AND n.name = "Pencarian koleksi buku"
RETURN m, n, r

