-- Auto-generated SQL and Answers for Diagram: Break (31)

-- Question: What shape represents the 'Initialize' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (31)' AND LabelText LIKE '%Initialize%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

-- Question: If 'Decision' is 'Yes', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS DecisionNode
    JOIN Edges ON Edges.SourceNodeID = DecisionNode.NodeID AND Edges.DiagramID = 'Break (31)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (31)'
    WHERE
        DecisionNode.DiagramID = 'Break (31)'
        AND DecisionNode.LabelText LIKE '%Decision%'
        AND Edges.ConditionLabel = 'Yes'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (31)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (31)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Yes', 'Print result', 0)
-- (1, 'Straight', 'End', 0)

============================================================

-- Question: Trace the sequence of events if 'Decision' is 'No'.
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start at the 'Decision' node itself.
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere, -- Initial state for the 'Decision' node
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (31)' AND LabelText LIKE '%Decision%'

    UNION ALL

    -- Recursive member: Traverse subsequent nodes
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (31)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (31)'
    WHERE
        PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 15
        -- Apply the condition "if 'Decision' is 'No'" only to the immediate outgoing edge from the 'Decision' node (HopCount = 0)
        AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel LIKE 'No%')
            OR
            (PathTraversal.HopCount > 0) -- For subsequent hops, all outgoing edges are followed
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Decision', 0)
-- (1, 'No', 'Process', 0)
-- (2, 'Straight', 'Delay', 0)
-- (3, 'Straight', 'Initialize', 0)
-- (4, 'Straight', 'Decision', 1)

============================================================

-- Question: Does the process loop back to a previous step after 'Delay'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (31)' AND LabelText LIKE '%Delay%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (31)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (31)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT EXISTS (SELECT 1 FROM PathTraversal WHERE IsCycle = 1);;

-- Verifiable Database Answer:
-- (1,)

============================================================

