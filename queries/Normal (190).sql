-- Auto-generated SQL and Answers for Diagram: Normal (190)

-- Question: If the review decision is 'Rejected because of missing documents', what is the next step?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        Edges.TargetNodeID AS CurrentNode, 
        NextNode.LabelText AS StepDescription, 
        Edges.ConditionLabel AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (190)'
    WHERE Edges.DiagramID = 'Normal (190)'
      AND Edges.ConditionLabel LIKE '%Rejected because of missing documents%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (190)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (190)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Rejected because of missing documents', 'Process Terminates', 0)

============================================================

-- Question: Trace the sequence of events if the 'Documents are complete' path is taken.
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (190)'
    WHERE Edges.DiagramID = 'Normal (190)' AND Edges.ConditionLabel LIKE '%Documents are complete%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (190)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (190)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Documents are complete', 'Forward to Bank Manager', 0)
-- (1, 'Straight', 'Profile Done', 0)
-- (2, 'Straight', 'Process Terminates', 0)

============================================================

-- Question: What node immediately precedes 'Profile Done'?
SELECT T1.LabelText
FROM Nodes AS T1
INNER JOIN Edges AS T2
  ON T1.NodeID = T2.SourceNodeID
WHERE
  T2.DiagramID = 'Normal (190)' AND T1.DiagramID = 'Normal (190)' AND T2.TargetNodeID IN (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Normal (190)' AND LabelText LIKE '%Profile Done%'
  );;

-- Verifiable Database Answer:
-- ('Forward to Bank Manager',)

============================================================

-- Question: What is the ultimate final step regardless of the review outcome?
SELECT LabelText FROM Nodes WHERE DiagramID = 'Normal (190)' AND NodeID NOT IN (SELECT SourceNodeID FROM Edges WHERE DiagramID = 'Normal (190)');;

-- Verifiable Database Answer:
-- ('Process Terminates',)

============================================================

