-- Auto-generated SQL and Answers for Diagram: Connect (86)

-- Question: What shape is used for the 'Checktime' step?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Connect (86)' AND LabelText LIKE '%Checktime%';;

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: If 'Late?' evaluates to 'Yes', what is the exact next action?
SELECT T2.LabelText FROM Edges AS T1 INNER JOIN Nodes AS T2 ON T1.TargetNodeID = T2.NodeID WHERE T1.DiagramID = 'Connect (86)' AND T2.DiagramID = 'Connect (86)' AND T1.SourceNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Connect (86)' AND LabelText LIKE '%Late?%') AND T1.ConditionLabel = 'Yes';;

-- Verifiable Database Answer:
-- ('Take bus',)

============================================================

-- Question: Trace the path if the 'Late?' condition evaluates to 'No'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS N WHERE N.DiagramID = 'Connect (86)' AND N.LabelText LIKE '%Late?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight') AS ConditionToGetHere,
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (86)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (86)'
    WHERE PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 15
        AND (
            -- If the current node being processed (PathTraversal.StepDescription) is 'Late?',
            -- then only follow edges with ConditionLabel 'No'.
            (PathTraversal.StepDescription LIKE '%Late?%' AND Edges.ConditionLabel = 'No')
            -- Otherwise (if the current node is not 'Late?'), follow any edge.
            OR (PathTraversal.StepDescription NOT LIKE '%Late?%')
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Late?', 0)
-- (1, 'No', 'Take góvany', 0)
-- (2, 'Straight', 'Reach school', 0)

============================================================



