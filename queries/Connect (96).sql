-- Auto-generated SQL and Answers for Diagram: Connect (96)

-- Question: What node immediately follows the 'Input A,B,C' step?
SELECT T2.LabelText
FROM Nodes AS T1
JOIN Edges AS T3
  ON T1.NodeID = T3.SourceNodeID AND T1.DiagramID = T3.DiagramID
JOIN Nodes AS T2
  ON T3.TargetNodeID = T2.NodeID AND T3.DiagramID = T2.DiagramID
WHERE
  T1.DiagramID = 'Connect (96)' AND T1.LabelText LIKE '%Input A,B,C%';;

-- Verifiable Database Answer:
-- ('IS A>B?',)

============================================================

-- Question: Trace the path if 'IS A>B?' is 'YES' and 'IS A>C?' is 'NO'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes 
    WHERE DiagramID = 'Connect (96)' AND LabelText LIKE '%Input A,B,C%' -- Assuming 'Input A,B,C' is a logical starting point for comparison logic
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (96)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (96)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        -- Apply conditional filtering for the edges based on the current node's label
        AND (
            -- If the current node is 'IS A>B?', then only follow the 'YES' branch
            (PathTraversal.StepDescription LIKE '%IS A>B%' AND Edges.ConditionLabel = 'YES')
            OR
            -- If the current node is 'IS A>C?', then only follow the 'NO' branch
            (PathTraversal.StepDescription LIKE '%IS A>C%' AND Edges.ConditionLabel = 'NO')
            OR
            -- For any other node not specifically mentioned, follow all outgoing edges (default behavior)
            (
                PathTraversal.StepDescription NOT LIKE '%IS A>B%'
                AND PathTraversal.StepDescription NOT LIKE '%IS A>C%'
            )
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Input A,B,C', 0)
-- (1, 'Straight', 'IS A>B?', 0)
-- (2, 'YES', 'IS A>C?', 0)
-- (3, 'NO', 'PRINT C', 0)
-- (4, 'Straight', 'Stop', 0)

============================================================

-- Question: If 'IS A>B?' evaluates to 'NO', which decision node is evaluated next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        N.ShapeType AS CurrentShapeType
    FROM Nodes AS N
    WHERE N.DiagramID = 'Connect (96)' AND N.LabelText LIKE '%IS A%B%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        Edges.ConditionLabel,
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        NextNode.ShapeType
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (96)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (96)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount = 0 -- Only consider the direct hop from the starting node
      AND Edges.ConditionLabel = 'NO'
)
SELECT StepDescription
FROM PathTraversal
WHERE PathTraversal.HopCount = 1
  AND PathTraversal.CurrentShapeType = 'diamond';;

-- Verifiable Database Answer:
-- ('IS B>C?',)

============================================================

-- Question: What is the final destination step for all the 'PRINT' nodes?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (96)' AND LabelText LIKE '%PRINT%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (96)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (96)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT DISTINCT PathTraversal.StepDescription
FROM PathTraversal
LEFT JOIN Edges ON PathTraversal.CurrentNode = Edges.SourceNodeID AND Edges.DiagramID = 'Connect (96)'
WHERE Edges.EdgeID IS NULL;;

-- Verifiable Database Answer:
-- ('Stop',)

============================================================

