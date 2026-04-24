-- Auto-generated SQL and Answers for Diagram: Normal (252)

-- Question: What node immediately follows 'Begin'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID
INNER JOIN Nodes AS T3
  ON T1.SourceNodeID = T3.NodeID AND T1.DiagramID = T3.DiagramID
WHERE
  T1.DiagramID = 'Normal (252)' AND T3.LabelText LIKE '%Begin%';;

-- Verifiable Database Answer:
-- ('Input length, width',)

============================================================

-- Question: What calculation step happens right after 'Input length, width'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (252)' AND LabelText LIKE '%Input length, width%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (252)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (252)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1 AND StepDescription LIKE '%Perimeter%' ORDER BY HopCount;;

-- Verifiable Database Answer:
-- ('Perimeter = 2 * (length + width)',)

============================================================

-- Question: Trace the sequence of events from the perimeter calculation to the end.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (252)' AND LabelText LIKE 'Perimeter%2 *%length + width%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (252)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (252)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Perimeter = 2 * (length + width)', 0)
-- (1, 'Straight', 'Print output', 0)
-- (2, 'Straight', 'Stop', 0)

============================================================

-- Question: What shape is used for the 'Print output' step?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (252)' AND LabelText LIKE 'Print output';;

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

