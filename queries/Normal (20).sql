-- Auto-generated SQL and Answers for Diagram: Normal (20)

-- Question: What node immediately follows 'Analog Retrieval'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (20)' AND T2.DiagramID = 'Normal (20)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Normal (20)' AND LabelText LIKE 'Analog Retrieval'
  );;

-- Verifiable Database Answer:
-- ('Sampling',)

============================================================

-- Question: Trace the entire linear process from start to finish.
WITH RECURSIVE PathTraversal AS (
    -- Base case: Find nodes that have no incoming edges (these are considered start nodes)
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS N
    WHERE N.DiagramID = 'Normal (20)'
    AND N.NodeID NOT IN (
        SELECT DISTINCT TargetNodeID
        FROM Edges
        WHERE DiagramID = 'Normal (20)'
    )

    UNION ALL

    -- Recursive step: Traverse to connected nodes
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (20)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (20)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Analog Retrieval', 0)
-- (1, 'learning', 'Sampling', 0)
-- (2, 'Self-supervised learning', 'Analogical Inference', 0)
-- (3, 'Intersection', 'End', 0)

============================================================

-- Question: What edge label connects 'Sampling' to 'Analogical Inference'?
SELECT T1.ConditionLabel FROM Edges AS T1 INNER JOIN Nodes AS T2 ON T1.SourceNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID INNER JOIN Nodes AS T3 ON T1.TargetNodeID = T3.NodeID AND T1.DiagramID = T3.DiagramID WHERE T1.DiagramID = 'Normal (20)' AND T2.LabelText LIKE '%Sampling%' AND T3.LabelText LIKE '%Analogical Inference%';

-- Verifiable Database Answer:
-- ('Self-supervised learning',)

============================================================

-- Question: What is the final step after 'Analogical Inference'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes 
    WHERE DiagramID = 'Normal (20)' AND LabelText LIKE '%Analogical Inference%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (20)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (20)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT DISTINCT StepDescription
FROM PathTraversal pt
WHERE NOT EXISTS (
    SELECT 1
    FROM Edges e
    WHERE e.SourceNodeID = pt.CurrentNode
    AND e.DiagramID = 'Normal (20)'
)
OR pt.StepDescription LIKE '%End%';;

-- Verifiable Database Answer:
-- ('End',)

============================================================

