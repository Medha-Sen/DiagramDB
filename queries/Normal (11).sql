-- Auto-generated SQL and Answers for Diagram: Normal (11)

-- Question: What shape is used for the 'Input Variable: K' step?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (11)' AND LabelText LIKE 'Input Variable: K';;

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: If 'If K%2==0' evaluates to 'True', what happens next?
WITH RECURSIVE PathTraversal AS (
    -- Anchor Member: Start the traversal from the node reached when 'If K%2==0' evaluates to 'True'
    SELECT 
        T2.NodeID AS CurrentNode, 
        T2.LabelText AS StepDescription, 
        T1.ConditionLabel AS ConditionToGetHere, -- This will be 'True' for the first step
        1 AS HopCount, -- This is the first 'next' step
        ',' || T1.SourceNodeID || ',' || T2.NodeID || ',' AS VisitedNodes, -- Trace the path from the decision node
        0 AS IsCycle
    FROM Edges AS T1
    JOIN Nodes AS T2 ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID
    JOIN Nodes AS StartNode ON T1.SourceNodeID = StartNode.NodeID AND T1.DiagramID = StartNode.DiagramID
    WHERE T1.DiagramID = 'Normal (11)' 
      AND StartNode.LabelText LIKE '%If K%2==0%'
      AND T1.ConditionLabel = 'True'
    
    UNION ALL
    
    -- Recursive Member: Traverse all subsequent steps from this new starting point
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (11)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (11)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'True', 'Print: K is Even', 0)
-- (2, 'Straight', 'STOP', 0)

============================================================

-- Question: Trace the sequence of events if the condition evaluates to 'False'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start: Evaluate False Branch' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (11)' AND LabelText LIKE '%If K%2==0%'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (11)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (11)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (
          (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'False')
          OR (PathTraversal.HopCount > 0)
      )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start: Evaluate False Branch', 'If K%2==0', 0)
-- (1, 'False', 'Print: K is odd', 0)

============================================================

-- Question: Which node does the 'Print: K is Even' step lead to?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (11)' AND T2.DiagramID = 'Normal (11)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Normal (11)' AND LabelText LIKE 'Print: K is Even'
  );;

-- Verifiable Database Answer:
-- ('STOP',)

============================================================

