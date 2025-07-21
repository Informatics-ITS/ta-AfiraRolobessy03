--dasar
LOAD CSV WITH HEADERS FROM "file:///elements.csv" AS line
CREATE (:elements 
    { 
        element:line.Type,
        name:line.Name,
        id:line.ID 
    }
)

LOAD CSV WITH HEADERS FROM "file:///relations.csv" AS line
MATCH (n {id: line.Source})
MATCH (m {id: line.Target})
CALL apoc.create.relationship(n, line.Type, 
    {id: line.ID, relation: line.Type, documentation: line.Documentation, name: line.Type}, m)
YIELD rel
RETURN rel

MATCH (n:elements)
CALL apoc.create.addLabels(n, [ n.element ]) YIELD node
RETURN node
--dasar

--Buat lebel BusinessLayer
MATCH (n:elements)
WHERE "BusinessActor" IN labels(n) OR "BusinessRole" IN labels(n) OR 
      "BusinessCollaboration" IN labels(n) OR "BusinessInterface" IN labels(n) OR
      "BusinessProcess" IN labels(n) OR "BusinessFunction" IN labels(n) OR
      "BusinessInteraction" IN labels(n) OR "BusinessEvent" IN labels(n) OR
      "BusinessService" IN labels(n) OR "BusinessObject" IN labels(n) OR
      "Contract" IN labels(n) OR "Representation" IN labels(n) OR
      "Product" IN labels(n)
CALL apoc.create.addLabels(n, ["BusinessLayer"])
YIELD node
RETURN node

--Buat lebel AplikasiLayer
MATCH (n:elements)
WHERE "DataObject" IN labels(n) OR "ApplicationComponent" IN labels(n) OR 
      "ApplicationCollaboration" IN labels(n) OR "ApplicationFunction" IN labels(n) OR 
      "ApplicationInterface" IN labels(n) OR "ApplicationInteraction" IN labels(n) OR 
      "ApplicationProcess" IN labels(n) OR "ApplicationEvent" IN labels(n) OR  
      "ApplicationService" IN labels(n)
CALL apoc.create.addLabels(n, ["ApplicationLayer"])
YIELD node 
RETURN node


-- import CSV 
--BussDoc, AppDoc, BussAppDoc
LOAD CSV WITH HEADERS FROM "file:///BussDoc.csv" AS line
WITH line, apoc.convert.fromJsonList(line.Relation) AS relations

UNWIND relations AS rel
MERGE (doc:BussDoc { name: line.Source + '_' + line.Target })
SET doc.source = line.Source, 
    doc.target = line.Target, 
    doc.relation = relations

-----
LOAD CSV WITH HEADERS FROM "file:///AppDoc.csv" AS line
WITH line, apoc.convert.fromJsonList(line.Relation) AS relations
UNWIND relations AS rel
MERGE (doc:AppDoc { name: line.Source + '_' + line.Target })
SET doc.source = line.Source, 
    doc.target = line.Target, 
    doc.relation = relations

--memodelkan studikasus 
--visualisasi graph
--Sesuai kebutuhan,bisa sesuikan dengan yang dicari : AppDOc, BussAppDoc
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
RETURN m,n,r
--visualisasi tabel
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
RETURN n.element, n.name , r.relation, m.element, m.name

--mencari yang sesuai
-- bisa sesuikan dengan yang dicari : AppDOc, BussAppDoc
MATCH (doc:BussDoc)
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source AND n.element = doc.target AND r.relation IN doc.relation
RETURN 'Sesuai' AS description, 
       m.element AS source, 
       m.name AS sourceName, 
       n.element AS target, 
       n.name AS targetName, 
       r.relation AS relation

--bentuk graf bisa sesuikan dengan yang dicari : AppDOc, BussAppDoc
MATCH (doc:BussDoc)
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source 
  AND n.element = doc.target 
  AND r.relation IN doc.relation
RETURN m, n, r


--query untuk tidak sesuai
// Mengumpulkan pasangan elemen yang sesuai
MATCH (doc:AppDoc)
MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE m.element = doc.source 
  AND n.element = doc.target 
  AND r.relation IN doc.relation
WITH collect({
  source: m.element, 
  target: n.element, 
  relation: r.relation
}) AS validPairs

// Memeriksa elemen yang tidak sesuai
MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE NOT ({source: m.element, target: n.element, relation: r.relation} IN validPairs)
RETURN DISTINCT 
  'Tidak Sesuai' AS description,
  m.element AS source, 
  m.name AS sourceName,
  n.element AS target, 
  n.name AS targetName,
  r.relation AS relation



-- dalam bentuk node 
// Query pertama: Mengumpulkan pasangan elemen yang sesuai
MATCH (doc:AppDoc)
MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE m.element = doc.source AND n.element = doc.target AND r.relation IN doc.relation
WITH collect({
  source: m.element, 
  target: n.element, 
  relation: r.relation
}) AS validPairs

// Query kedua: Memeriksa elemen yang tidak sesuai dan belum dicek pada query pertama
MATCH (doc:AppDoc)
MATCH (m:ApplicationLayer)-[r]->(n:ApplicationLayer)
WHERE ((m.element = doc.source AND n.element <> doc.target)
       OR (m.element <> doc.source AND n.element = doc.target))
  AND NOT ({source: m.element, target: n.element, relation: r.relation} IN validPairs)
RETURN DISTINCT 
  m AS sourceNode, 
  n AS targetNode, 
  r AS relationship

---
// Query pertama: Mengumpulkan pasangan elemen yang sesuai
MATCH (doc:BussDoc)
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source AND n.element = doc.target AND r.relation IN doc.relation
WITH collect({
  source: m.element, 
  target: n.element, 
  relation: r.relation
}) AS validPairs

// Query kedua: Memeriksa elemen yang tidak sesuai dan belum dicek pada query pertama
MATCH (doc:BussDoc)
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE ((m.element = doc.source AND n.element <> doc.target)
       OR (m.element <> doc.source AND n.element = doc.target))
  AND NOT ({source: m.element, target: n.element, relation: r.relation} IN validPairs)
RETURN DISTINCT 
  m AS sourceNode, 
  n AS targetNode, 
  r AS relationship
---
MATCH (doc:BussDoc)
MATCH (m:BusinessLayer)-[r]->(n:BusinessLayer)
WHERE m.element = doc.source AND n.element = doc.target AND r.relation IN doc.relation AND m.name="Register"--
RETURN 'Sesuai' AS description, 
       m.element AS source, 
       m.name AS sourceName, 
       n.element AS target, 
       n.name AS targetName, 
       r.relation AS relation