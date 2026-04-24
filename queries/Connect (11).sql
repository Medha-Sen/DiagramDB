-- Auto-generated SQL and Answers for Diagram: Connect (11)

-- Question: What shape represents the 'Feature Extraction' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Connect (11)' AND LabelText LIKE '%Feature Extraction%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

-- Question: Trace the sequence of events from 'Pre-processing using' to 'Classification'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        NodeID AS PathRootNodeID, -- Identifier for the start of this specific path traversal
        ',' || NodeID || ',' AS VisitedNodes,
        ',' || NodeID || ',' AS PathSegmentNodeIDs, -- Stores comma-separated NodeIDs forming the path segment up to CurrentNode
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (11)' AND LabelText LIKE '%Pre-processing using%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PT.HopCount + 1,
        PT.PathRootNodeID,
        PT.VisitedNodes || Edges.TargetNodeID || ',',
        PT.PathSegmentNodeIDs || Edges.TargetNodeID || ',',
        CASE WHEN PT.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal PT
    JOIN Edges ON Edges.SourceNodeID = PT.CurrentNode AND Edges.DiagramID = 'Connect (11)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (11)'
    WHERE PT.IsCycle = 0 AND PT.HopCount < 15
),
-- Identify all unique sequences of NodeIDs that successfully lead to 'Classification'
SuccessfulPaths AS (
    SELECT DISTINCT PathSegmentNodeIDs AS FullPathIDs
    FROM PathTraversal
    WHERE StepDescription LIKE '%Classification%'
)
-- Select the details of each step that belongs to any of these successful paths
SELECT DISTINCT
    PT.HopCount,
    PT.ConditionToGetHere,
    PT.StepDescription,
    PT.IsCycle
FROM PathTraversal PT
JOIN SuccessfulPaths SP ON SP.FullPathIDs LIKE PT.PathSegmentNodeIDs || '%'
ORDER BY PT.HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Pre-processing using', 0)
-- (1, 'Straight', 'Feature Extraction', 0)
-- (2, 'Straight', 'Parameter\\Optimization', 0)
-- (3, 'Straight', 'Classification', 0)

============================================================

-- Question: What are the four distinct destination nodes after 'Classification'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (11)' AND LabelText LIKE '%Classification%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (11)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (11)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT DISTINCT StepDescription
FROM PathTraversal
WHERE HopCount > 0 -- Exclude the starting node itself
LIMIT 4;;

-- Verifiable Database Answer:
-- ('Pure speech',)
-- ('Music',)
-- ('Environmental\\sound',)
-- ('Amplifier',)

============================================================

-- Question: Is there any decision-based branching before the 'Classification' step?
WITH RECURSIVE BackwardTraversal AS (
    -- Anchor member: Start from the 'Classification' node.
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        NULL AS EdgeCondition, -- No condition for the starting node itself
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        0 AS FoundDecisionBranching -- Flag to track if a decision branch was found on this path
    FROM Nodes
    WHERE DiagramID = 'Connect (11)' AND LabelText LIKE '%Classification%'

    UNION ALL

    -- Recursive member: Traverse backwards through the edges
    SELECT
        Edges.SourceNodeID,
        PrevNode.LabelText,
        Edges.ConditionLabel, -- The condition label of the edge leading from SourceNodeID to TargetNodeID
        BackwardTraversal.HopCount + 1,
        BackwardTraversal.VisitedNodes || Edges.SourceNodeID || ',',
        CASE WHEN BackwardTraversal.VisitedNodes LIKE '%,' || Edges.SourceNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        CASE
            -- If the current edge has a non-NULL and non-'Straight' ConditionLabel, it's a decision branch
            WHEN Edges.ConditionLabel IS NOT NULL AND Edges.ConditionLabel != 'Straight' THEN 1
            -- Otherwise, propagate the FoundDecisionBranching flag from previous hops
            ELSE BackwardTraversal.FoundDecisionBranching
        END AS FoundDecisionBranching
    FROM BackwardTraversal
    JOIN Edges ON Edges.TargetNodeID = BackwardTraversal.CurrentNode AND Edges.DiagramID = 'Connect (11)'
    JOIN Nodes AS PrevNode ON PrevNode.NodeID = Edges.SourceNodeID AND PrevNode.DiagramID = 'Connect (11)'
    WHERE BackwardTraversal.IsCycle = 0 AND BackwardTraversal.HopCount < 15
)
-- Final selection: Check if any decision-based branching was found in any path leading to 'Classification'
SELECT EXISTS (SELECT 1 FROM BackwardTraversal WHERE FoundDecisionBranching = 1);;

-- Verifiable Database Answer:
-- (0,)

============================================================

