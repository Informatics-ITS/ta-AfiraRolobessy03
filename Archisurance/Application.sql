MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE m.name = "CRM System"
      AND n.name = "CIS"
RETURN m,n,r


MATCH (doc:AppDoc)
MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE m.element = doc.source AND n.element = doc.target AND r.relation IN doc.relation AND m.name = "CRM System"
      AND n.name = "CIS"
RETURN 'Sesuai' AS description, 
       m.element AS source, 
       m.name AS sourceName, 
       n.element AS target, 
       n.name AS targetName, 
       r.relation AS relation


MATCH (doc:AppDoc)
MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE m.element = doc.source 
  AND n.element = doc.target 
  AND r.relation IN doc.relation
  AND m.name = "CRM System"
      AND n.name = "CIS"
RETURN m, n, r