-- Auto-generated SQL and Answers for Diagram: Normal (24)

-- Question: What step comes immediately after 'Prepare Custom Script/Clients'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (24)' AND T2.DiagramID = 'Normal (24)' AND T1.SourceNodeID IN (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Normal (24)' AND LabelText LIKE 'Prepare Custom%Script/Clients%'
  );;

-- Verifiable Database Answer:
-- ('Run Tests and\\analyze',)

============================================================

-- Question: Trace the path from 'Application' down to 'Run Tests and analyze'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        LabelText AS FullPathDescription,
        CASE WHEN LabelText LIKE '%Run Tests and%analyze%' THEN 1 ELSE 0 END AS IsTargetReached,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (24)' AND LabelText LIKE '%Application%'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        PathTraversal.FullPathDescription || ' -> (' || IFNULL(Edges.ConditionLabel, 'Straight') || ') -> ' || NextNode.LabelText,
        CASE WHEN NextNode.LabelText LIKE '%Run Tests and%analyze%' THEN 1 ELSE 0 END,
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (24)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (24)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15 AND PathTraversal.IsTargetReached = 0
)
SELECT FullPathDescription FROM PathTraversal
WHERE IsTargetReached = 1 AND IsCycle = 0
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- ('Application -> (Straight) -> Plan & design worload & jobs\\to be executed -> (Straight) -> Prepare Custom\\Script/Clients -> (Straight) -> Run Tests and\\analyze',)

============================================================

-- Question: If an 'Error' occurs, what is the sequence of events for 'Revising'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (24)' AND LabelText LIKE '%Error%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (24)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (24)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
WHERE VisitedNodes LIKE '%,' || (SELECT NodeID FROM Nodes WHERE DiagramID = 'Normal (24)' AND LabelText LIKE '%Revising%') || ',%'
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'Straight', 'Revising', 0)
-- (2, 'Straight', 'Run Tests and\\analyze', 0)
-- (3, 'Straight', 'Error', 1)

============================================================

-- Question: What is the final destination node after 'Error' if the configuration is finalized?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        CASE WHEN LabelText LIKE '%Finalize Configuration%' THEN 1 ELSE 0 END AS HasFinalizedConfig
    FROM Nodes
    WHERE DiagramID = 'Normal (24)' AND LabelText LIKE '%Error%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        CASE WHEN PathTraversal.HasFinalizedConfig = 1 OR NextNode.LabelText LIKE '%Finalize Configuration%' THEN 1 ELSE 0 END AS HasFinalizedConfig
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (24)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (24)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT DISTINCT T1.StepDescription
FROM PathTraversal AS T1
LEFT JOIN Edges AS T2 ON T1.CurrentNode = T2.SourceNodeID AND T2.DiagramID = 'Normal (24)'
WHERE T1.HasFinalizedConfig = 1
  AND T2.EdgeID IS NULL
  AND T1.IsCycle = 0;;

-- Verifiable Database Answer:
-- ('Finalize Configuration',)

============================================================

