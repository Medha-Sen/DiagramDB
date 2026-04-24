-- Auto-generated SQL and Answers for Diagram: Connect (72)

-- Question: What node comes immediately after 'Begin'?
SELECT T2.LabelText
FROM Nodes AS T1
JOIN Edges AS T3
  ON T1.NodeID = T3.SourceNodeID
JOIN Nodes AS T2
  ON T3.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Connect (72)' AND T1.LabelText LIKE '%Begin%' AND T3.DiagramID = 'Connect (72)' AND T2.DiagramID = 'Connect (72)';;

-- Verifiable Database Answer:
-- ('Is target sector\n<\nmax sector?',)

============================================================

-- Question: Trace the path if 'Is target sector < max sector?' evaluates to 'Yes'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (72)' AND LabelText LIKE 'Is target sector%<%'max sector%?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (72)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (72)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'Yes')
            OR
            (PathTraversal.HopCount > 0)
          )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- SQL Execution Error: near "max": syntax error

============================================================

-- Question: If 'Is the target head < than max head?' is 'No', what sequence of events follows?
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        1 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS StartNode
    JOIN Edges ON StartNode.NodeID = Edges.SourceNodeID AND Edges.DiagramID = 'Connect (72)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (72)'
    WHERE
        StartNode.DiagramID = 'Connect (72)'
        AND StartNode.LabelText LIKE 'Is the target%head%<%than%max%head%'
        AND Edges.ConditionLabel = 'No'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (72)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (72)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'No', 'Target head = 0', 0)
-- (2, 'Straight', 'Increase Value', 0)
-- (3, 'Straight', 'End', 0)

============================================================

-- Question: What specific node do all of the diverging branches converge on before 'End'?
WITH RECURSIVE PredecessorsOfEnd AS (
    -- Base case: direct predecessors of 'End'
    SELECT 
        SourceNodeID AS NodeID,
        1 AS HopsToEnd,
        ',' || SourceNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    WHERE DiagramID = 'Connect (72)' AND TargetNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Connect (72)' AND LabelText LIKE '%End%')
    
    UNION ALL
    
    -- Recursive step: find predecessors of current predecessors
    SELECT
        Edges.SourceNodeID,
        P.HopsToEnd + 1,
        P.VisitedNodes || Edges.SourceNodeID || ',',
        CASE WHEN P.VisitedNodes LIKE '%,' || Edges.SourceNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM Edges
    JOIN PredecessorsOfEnd P ON Edges.TargetNodeID = P.NodeID AND Edges.DiagramID = 'Connect (72)'
    WHERE P.IsCycle = 0 AND P.HopsToEnd < 15
),
MinHopsToEnd AS (
    SELECT NodeID, MIN(HopsToEnd) AS MinHops
    FROM PredecessorsOfEnd
    GROUP BY NodeID
),
NodesWithMultipleIncomingEdges AS (
    SELECT TargetNodeID AS NodeID
    FROM Edges
    WHERE DiagramID = 'Connect (72)'
    GROUP BY TargetNodeID
    HAVING COUNT(SourceNodeID) > 1
)
SELECT N.LabelText
FROM Nodes N
JOIN MinHopsToEnd MH ON N.NodeID = MH.NodeID
JOIN NodesWithMultipleIncomingEdges M ON N.NodeID = M.NodeID
WHERE N.DiagramID = 'Connect (72)'
ORDER BY MH.MinHops ASC
LIMIT 1;;

-- Verifiable Database Answer:
-- ('Increase Value',)

============================================================

