-- Auto-generated SQL and Answers for Diagram: Break (41)

-- Question: What shape represents 'Take Input'?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (41)' AND LabelText = 'Take Input';

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: If 'Number%2==0' is 'True', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        TargetNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        1 AS HopCount,
        ',' || SourceNode.NodeID || ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS SourceNode
    JOIN Edges ON SourceNode.NodeID = Edges.SourceNodeID AND SourceNode.DiagramID = Edges.DiagramID
    JOIN Nodes AS TargetNode ON Edges.TargetNodeID = TargetNode.NodeID AND Edges.DiagramID = TargetNode.DiagramID
    WHERE SourceNode.DiagramID = 'Break (41)'
      AND SourceNode.LabelText LIKE 'If%Number%2==0%'
      AND Edges.ConditionLabel = 'True'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (41)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (41)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'True', 'Print result', 0)
-- (2, 'Straight', 'End', 0)

============================================================

-- Question: Trace the sequence of events if 'Number%2==0' is 'False'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (41)' AND LabelText LIKE 'If%Number%2==0%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (41)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (41)'
    WHERE PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 15
        -- For the first hop (from the initial 'If' node), we must follow the 'False' branch.
        -- For subsequent hops, we follow any path, as the question only specifies the initial condition.
        AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'False')
            OR
            (PathTraversal.HopCount > 0)
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'If\\Number%2==0', 0)
-- (1, 'False', 'Print: "Number\\is odd"', 0)

============================================================

-- Question: What is the final step after 'Print result'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (41)' AND LabelText LIKE '%Print result%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (41)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (41)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT DISTINCT PT.StepDescription
FROM PathTraversal PT
LEFT JOIN Edges E ON PT.CurrentNode = E.SourceNodeID AND E.DiagramID = 'Break (41)'
WHERE E.EdgeID IS NULL;;

-- Verifiable Database Answer:
-- ('End',)

============================================================

