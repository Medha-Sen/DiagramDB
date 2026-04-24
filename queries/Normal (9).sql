-- Auto-generated SQL and Answers for Diagram: Normal (9)

-- Question: What shape represents the 'Read A' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (9)' AND LabelText LIKE '%Read A%';;

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: What step immediately follows 'Read B'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID
INNER JOIN Nodes AS T3
  ON T1.SourceNodeID = T3.NodeID AND T1.DiagramID = T3.DiagramID
WHERE
  T1.DiagramID = 'Normal (9)' AND T3.LabelText LIKE '%Read B%';;

-- Verifiable Database Answer:
-- ('Calculate sum as A+B',)

============================================================

-- Question: Trace the entire linear process from 'Start' to 'End'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (9)' AND LabelText LIKE '%Start%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (9)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (9)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Start', 0)
-- (1, 'Straight', 'Read A', 0)
-- (2, 'Straight', 'Read B', 0)
-- (3, 'Straight', 'Calculate sum as A+B', 0)
-- (4, 'Straight', 'Print Sum', 0)
-- (5, 'Straight', 'End', 0)

============================================================

-- Question: What action is taken right before the 'End' node?
SELECT T1.LabelText FROM Nodes AS T1 INNER JOIN Edges AS T2 ON T1.NodeID = T2.SourceNodeID WHERE T2.DiagramID = 'Normal (9)' AND T2.TargetNodeID IN (SELECT NodeID FROM Nodes WHERE DiagramID = 'Normal (9)' AND LabelText LIKE '%End%');;

-- Verifiable Database Answer:
-- ('Print Sum',)

============================================================

