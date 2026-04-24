-- Auto-generated SQL and Answers for Diagram: Normal (221)

-- Question: What node immediately follows 'Initialize X < 0'?
SELECT T2.LabelText FROM Edges AS T1 INNER JOIN Nodes AS T2 ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID WHERE T1.DiagramID = 'Normal (221)' AND T1.SourceNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Normal (221)' AND LabelText LIKE 'Initialize X % 0');;

-- Verifiable Database Answer:
-- ('X=X+2',)

============================================================

-- Question: If 'X < 20' evaluates to 'YES', exactly which node does the process loop back to?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (221)' AND LabelText LIKE 'X < 20%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (221)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (221)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (
          (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'YES') -- For the first hop from 'X < 20', must take 'YES' path
          OR
          (PathTraversal.HopCount > 0) -- For subsequent hops, follow all paths as no specific condition is given
      )
)
SELECT
    PathTraversal.StepDescription
FROM PathTraversal
WHERE PathTraversal.IsCycle = 1
ORDER BY PathTraversal.HopCount
LIMIT 1;;

-- Verifiable Database Answer:
-- ('X < 20',)

============================================================

-- Question: Trace the sequence of events if 'X < 20' evaluates to 'NO'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (221)' AND LabelText LIKE 'X % 20'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (221)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (221)'
    WHERE PathTraversal.IsCycle = 0 
      AND PathTraversal.HopCount < 15
      AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'NO') -- Apply 'NO' condition only for the first hop
            OR PathTraversal.HopCount > 0                             -- For subsequent hops, allow any condition
          )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'X < 20', 0)
-- (1, 'NO', 'END', 0)

============================================================

-- Question: What shape is used for the 'Print X' step?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (221)' AND LabelText LIKE 'Print X';

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

