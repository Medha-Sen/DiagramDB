-- Auto-generated SQL and Answers for Diagram: Normal (187)

-- Question: What edge label connects the 'Camera' node to the 'Cache' node?
SELECT T1.ConditionLabel
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.SourceNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID
INNER JOIN Nodes AS T3
  ON T1.TargetNodeID = T3.NodeID AND T1.DiagramID = T3.DiagramID
WHERE
  T1.DiagramID = 'Normal (187)' AND T2.LabelText LIKE 'Camera%' AND T3.LabelText LIKE 'Cache%';;

-- Verifiable Database Answer:
-- ('Video',)

============================================================

-- Question: What step comes immediately after 'Object Detection'?
SELECT T2.LabelText
FROM Edges AS T1
JOIN Nodes AS T2
ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID
WHERE T1.DiagramID = 'Normal (187)'
AND T1.SourceNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Normal (187)' AND LabelText LIKE '%Object%Detection%');;

-- Verifiable Database Answer:
-- ('Tracking',)

============================================================

-- Question: Trace the entire linear sequence from 'Tracking' to 'Result'.
WITH RECURSIVE PathTraversal AS (
    -- Initial step: Start from 'Tracking'
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        -- VisitedNodes tracks the path taken to detect cycles and identify unique paths
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (187)' AND LabelText LIKE '%Tracking%'

    UNION ALL

    -- Recursive step: Find the next nodes
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        -- Check if the target node has already been visited in this path (cycle detection)
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (187)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (187)'
    -- Stop if a cycle is detected or if the path becomes too long (to prevent infinite loops)
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
),
-- Identify all distinct complete paths that successfully end at 'Result'
SuccessfulPaths AS (
    SELECT DISTINCT VisitedNodes AS CompletedPath
    FROM PathTraversal
    WHERE StepDescription LIKE '%Result%' AND IsCycle = 0
)
-- Select all nodes that are part of any identified successful path
SELECT
    PT.HopCount,
    PT.ConditionToGetHere,
    PT.StepDescription,
    PT.IsCycle
FROM PathTraversal PT
-- Join with SuccessfulPaths to filter for nodes belonging to a path ending at 'Result'
-- PT.VisitedNodes is a prefix of SP.CompletedPath means PT.CurrentNode is part of SP.CompletedPath
JOIN SuccessfulPaths SP ON SP.CompletedPath LIKE PT.VisitedNodes || '%'
-- Order results to show each path sequentially, then steps within that path
ORDER BY SP.CompletedPath, PT.HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Tracking', 0)
-- (1, 'Obj Characteristic', 'Vehicle\\Identify', 0)
-- (2, 'Obj classification', 'Result', 0)

============================================================

-- Question: What edge label connects 'Tracking' to 'Vehicle Identify'?
SELECT T1.ConditionLabel
FROM Edges AS T1
INNER JOIN Nodes AS T2 ON T1.SourceNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID
INNER JOIN Nodes AS T3 ON T1.TargetNodeID = T3.NodeID AND T1.DiagramID = T3.DiagramID
WHERE T1.DiagramID = 'Normal (187)'
  AND T2.LabelText LIKE '%Tracking%'
  AND T3.LabelText LIKE '%Vehicle%Identify%';;

-- Verifiable Database Answer:
-- ('Obj Characteristic',)

============================================================

