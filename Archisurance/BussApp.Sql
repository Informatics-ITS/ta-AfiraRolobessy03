MATCH (m:ApplicationLayer)-[r]->(n:BusinessLayer)
WHERE m.name = "CRM System"
      AND n.name = "Insurance Application Service"
RETURN m,n,r

MATCH (doc:BussAppDoc)
MATCH (m:ApplicationLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source AND n.element = doc.target AND r.relation IN doc.relation
      AND m.name = "CRM System"
      AND n.name = "Insurance Application Service"
RETURN 'Sesuai' AS description, 
       m.element AS source, 
       m.name AS sourceName, 
       n.element AS target, 
       n.name AS targetName, 
       r.relation AS relation

MATCH (doc:BussAppDoc)
MATCH (m:ApplicationLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source 
  AND n.element = doc.target 
  AND r.relation IN doc.relation
  AND m.name = "CRM System"
  AND n.name = "Insurance Application Service"
RETURN m, n, r