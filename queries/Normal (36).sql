-- Auto-generated SQL and Answers for Diagram: Normal (36)

-- Question: What node immediately follows 'Start'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID
INNER JOIN Nodes AS T3
  ON T1.SourceNodeID = T3.NodeID AND T1.DiagramID = T3.DiagramID
WHERE
  T1.DiagramID = 'Normal (36)' AND T3.LabelText LIKE 'Start';;

-- Verifiable Database Answer:
-- ('Fill the bath with water',)

============================================================

-- Question: What step comes immediately after 'Get into bath'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (36)' AND T2.DiagramID = 'Normal (36)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Normal (36)' AND LabelText LIKE '%Get into bath%'
  );;

-- Verifiable Database Answer:
-- ('Watch',)

============================================================

-- Question: Trace the entire sequence of events from 'Watch' to 'End'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        CASE WHEN LabelText LIKE '%End%' THEN 1 ELSE 0 END AS ReachedEndFlag
    FROM Nodes WHERE DiagramID = 'Normal (36)' AND LabelText LIKE '%Watch%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        CASE WHEN NextNode.LabelText LIKE '%End%' THEN 1 ELSE PathTraversal.ReachedEndFlag END AS ReachedEndFlag
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (36)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (36)'
    WHERE
        PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 15
        AND PathTraversal.ReachedEndFlag = 0 -- Stop extending paths once 'End' is reached
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
WHERE ReachedEndFlag = 1 -- Select only the paths that successfully lead to 'End'
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (4, 'Straight', 'End', 0)

============================================================

-- Question: Is there any decision-based branching in this linear process?
SELECT
    Nodes.LabelText
FROM Nodes
JOIN Edges ON Nodes.NodeID = Edges.SourceNodeID AND Nodes.DiagramID = Edges.DiagramID
WHERE Nodes.DiagramID = 'Normal (36)'
GROUP BY Nodes.NodeID
HAVING COUNT(Edges.EdgeID) > 1;;

-- Verifiable Database Answer:
-- (No matching results found in the diagram topology)

============================================================

