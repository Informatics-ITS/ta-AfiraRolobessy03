MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE m.name = "Antarmuka pencarian buku" AND n.name = "Service pencarian buku"
RETURN m,n,r


MATCH (doc:AppDoc)
MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE m.element = doc.source 
  AND n.element = doc.target 
  AND r.relation IN doc.relation
  AND m.name = "Antarmuka pencarian buku" AND n.name = "Service pencarian buku"
RETURN m, n, r


