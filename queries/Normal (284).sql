-- Auto-generated SQL and Answers for Diagram: Normal (284)

-- Question: What shape represents the 'Fan doesn't work' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (284)' AND LabelText LIKE 'Fan doesn''t work%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

-- Question: If 'Fan plugged in?' evaluates to 'No', what is the next action?
SELECT TargetNode.LabelText
FROM Nodes AS SourceNode
JOIN Edges ON SourceNode.NodeID = Edges.SourceNodeID AND SourceNode.DiagramID = Edges.DiagramID
JOIN Nodes AS TargetNode ON Edges.TargetNodeID = TargetNode.NodeID AND Edges.DiagramID = TargetNode.DiagramID
WHERE SourceNode.DiagramID = 'Normal (284)'
  AND SourceNode.LabelText LIKE '%Fan plugged in?%'
  AND Edges.ConditionLabel = 'No';;

-- Verifiable Database Answer:
-- ('Plug in Fan',)

============================================================

-- Question: Trace the path if 'Fan plugged in?' is 'Yes' and 'Bulb burned out?' is 'Yes'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        NULL AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS N
    WHERE N.DiagramID = 'Normal (284)' AND N.LabelText LIKE '%Fan plugged in?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (284)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (284)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        AND (
            -- If the current node is 'Fan plugged in?', only allow the 'Yes' edge.
            (PathTraversal.StepDescription LIKE '%Fan plugged in?%' AND Edges.ConditionLabel = 'Yes')
            OR
            -- If the current node is 'Bulb burned out?', only allow the 'Yes' edge.
            (PathTraversal.StepDescription LIKE '%Bulb burned out?%' AND Edges.ConditionLabel = 'Yes')
            OR
            -- For any other node not explicitly mentioned, allow any outgoing edge.
            (PathTraversal.StepDescription NOT LIKE '%Fan plugged in?%' AND PathTraversal.StepDescription NOT LIKE '%Bulb burned out?%')
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, None, 'Fan plugged in?', 0)
-- (1, 'Yes', 'Bulb burned out?', 0)
-- (2, 'Yes', 'Replace bulb', 0)

============================================================

-- Question: What sequence of events leads to the 'Repair Fan' node?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Goal' AS ConditionToGetHere, -- This marks the target node of the path
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (284)' AND LabelText LIKE '%Repair Fan%'

    UNION ALL

    SELECT
        Edges.SourceNodeID,
        PrevNode.LabelText,
        -- The condition on the edge from SourceNodeID to CurrentNode explains how CurrentNode was reached from SourceNodeID
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.SourceNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.SourceNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.TargetNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (284)'
    JOIN Nodes AS PrevNode ON PrevNode.NodeID = Edges.SourceNodeID AND PrevNode.DiagramID = 'Normal (284)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
ORDER BY HopCount DESC;;

-- Verifiable Database Answer:
-- (3, 'Straight', "Fan doesn't work", 0)
-- (2, 'Yes', 'Fan plugged in?', 0)
-- (1, 'No', 'Bulb burned out?', 0)
-- (0, 'Goal', 'Repair Fan', 0)

============================================================

