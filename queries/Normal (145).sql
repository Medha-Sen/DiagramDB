-- Auto-generated SQL and Answers for Diagram: Normal (145)

-- Question: If 'Sufficient Data?' evaluates to 'No', which node does the process return to?
SELECT T2.LabelText
FROM Nodes AS T1
INNER JOIN Edges AS T3
  ON T1.NodeID = T3.SourceNodeID
INNER JOIN Nodes AS T2
  ON T3.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (145)' AND T3.DiagramID = 'Normal (145)' AND T2.DiagramID = 'Normal (145)' AND T1.LabelText LIKE '%Sufficient Data?%' AND T3.ConditionLabel LIKE '%No%';;

-- Verifiable Database Answer:
-- ('Data Collection',)

============================================================

-- Question: Trace the sequence of events if 'Sufficient Data?' is 'Yes' but 'Liberal?' is 'No'.
WITH RECURSIVE PathTraversal AS (
    -- Base Case: Start at 'Sufficient Data?'
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (145)' AND LabelText LIKE '%Sufficient Data?%'

    UNION ALL

    -- Recursive Step: Traverse edges
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'), -- Store the condition that led to NextNode
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (145)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (145)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        AND (
            -- If the current node is 'Sufficient Data?', it MUST take the 'Yes' path
            (PathTraversal.StepDescription LIKE '%Sufficient Data?%' AND Edges.ConditionLabel = 'Yes')
            -- If the current node is 'Liberal?', it MUST take the 'No' path
            OR (PathTraversal.StepDescription LIKE '%Liberal?%' AND Edges.ConditionLabel = 'No')
            -- For any other node in the path, follow any available edge
            OR (PathTraversal.StepDescription NOT LIKE '%Sufficient Data?%' AND PathTraversal.StepDescription NOT LIKE '%Liberal?%')
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Sufficient Data?', 0)
-- (1, 'Yes', 'Groundwater Flow', 0)
-- (2, 'Straight', 'Liberal?', 0)
-- (3, 'No', 'Groundwater Flow', 1)

============================================================

-- Question: What happens after the 'Adequate?' condition evaluates to 'Yes'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (145)' AND LabelText LIKE '%Adequate?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (145)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (145)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15
      -- For the very first hop from 'Adequate?', we must take the 'Yes' branch.
      -- For subsequent hops, follow all paths (no specific condition stated for them).
      AND (
          (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'Yes')
          OR PathTraversal.HopCount > 0
      )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Adequate?', 0)
-- (1, 'Yes', 'Predictive Simulations', 0)

============================================================

-- Question: What shape is used for the 'Predictive Simulations' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (145)' AND LabelText LIKE '%Predictive Simulations%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

