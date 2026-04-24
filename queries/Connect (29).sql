-- Auto-generated SQL and Answers for Diagram: Connect (29)

-- Question: What happens if 'identity verification' is 'N'?
WITH RECURSIVE PathTraversal AS (
    -- Base case: Identify the node(s) reached immediately after 'identity verification' if the outcome is 'N'.
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        TargetNodes.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        1 AS HopCount, -- This marks the first step after the 'N' condition is met
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS SourceNodes
    JOIN Edges ON Edges.SourceNodeID = SourceNodes.NodeID AND Edges.DiagramID = 'Connect (29)'
    JOIN Nodes AS TargetNodes ON TargetNodes.NodeID = Edges.TargetNodeID AND TargetNodes.DiagramID = 'Connect (29)'
    WHERE SourceNodes.DiagramID = 'Connect (29)'
      AND SourceNodes.LabelText LIKE '%identity verification%'
      AND Edges.ConditionLabel LIKE '%N%'

    UNION ALL

    -- Recursive step: Find subsequent steps from the current nodes
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (29)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (29)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'N', 'Try Again', 0)
-- (2, 'Straight', 'identity verification', 0)
-- (3, 'N', 'Try Again', 1)
-- (3, 'Y', 'Profile', 0)
-- (4, 'N', 'User', 0)
-- (4, 'Y', 'identity management', 0)

============================================================

-- Question: Trace the path if the 'Profile' condition evaluates to 'Y'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (29)' AND LabelText LIKE '%Profile%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (29)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (29)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND ( (PathTraversal.HopCount = 0 AND Edges.ConditionLabel LIKE '%Y%') OR PathTraversal.HopCount > 0 )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Profile', 0)
-- (1, 'Y', 'identity management', 0)

============================================================

-- Question: Does the process loop back to 'identity authentication' if verification fails?
WITH RECURSIVE PathTraversal AS (
    -- Base case: Identify the starting node(s) for the traversal.
    -- These are the nodes reached immediately after 'identity verification' fails.
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes
    FROM Nodes AS VerificationNode
    JOIN Edges ON Edges.SourceNodeID = VerificationNode.NodeID AND Edges.DiagramID = 'Connect (29)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (29)'
    WHERE VerificationNode.DiagramID = 'Connect (29)'
      AND VerificationNode.LabelText LIKE '%identity verification%'
      -- Assuming 'Fail' or 'No' in ConditionLabel indicates verification failure.
      AND (Edges.ConditionLabel LIKE '%Fail%' OR Edges.ConditionLabel LIKE '%No%')
),
PathWalker AS (
    -- Initialize PathWalker with the starting points from PathTraversal.
    -- Add flags for cycle detection and target specific loop detection.
    SELECT
        CurrentNode,
        StepDescription,
        ConditionToGetHere,
        HopCount,
        VisitedNodes,
        0 AS IsCycle, -- Flag for any cycle detection
        CASE WHEN CurrentNode = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Connect (29)' AND LabelText LIKE '%identity authentication%') THEN 1 ELSE 0 END AS LoopsToTarget -- Flag if this is the target node and it's part of a loop
    FROM PathTraversal

    UNION ALL

    -- Recursive step: Traverse subsequent nodes
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathWalker.HopCount + 1,
        PathWalker.VisitedNodes || Edges.TargetNodeID || ',',
        -- Check for any cycle: Is the target node already in the visited path?
        CASE WHEN PathWalker.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        -- Check for a loop specifically back to 'identity authentication':
        -- The target node must be 'identity authentication' AND it must have been visited before in this path.
        CASE WHEN Edges.TargetNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Connect (29)' AND LabelText LIKE '%identity authentication%')
                  AND PathWalker.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS LoopsToTarget
    FROM PathWalker
    JOIN Edges ON Edges.SourceNodeID = PathWalker.CurrentNode AND Edges.DiagramID = 'Connect (29)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (29)'
    WHERE PathWalker.IsCycle = 0 AND PathWalker.HopCount < 15 -- Prevent infinite loops and limit depth
)
-- Final selection: Determine if there is a path that loops back to 'identity authentication'.
SELECT
    CASE WHEN EXISTS (
        SELECT 1
        FROM PathWalker
        WHERE PathWalker.LoopsToTarget = 1
          AND PathWalker.HopCount > 0 -- Ensure it's a true loop (at least one hop occurred before looping back)
    ) THEN 'Yes' ELSE 'No' END;;

-- Verifiable Database Answer:
-- ('No',)

============================================================

-- Question: What is the final destination step if 'Profile' is 'N'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes AS SourceNode ON SourceNode.NodeID = Edges.SourceNodeID AND SourceNode.DiagramID = 'Connect (29)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (29)'
    WHERE Edges.DiagramID = 'Connect (29)'
      AND SourceNode.LabelText LIKE '%Profile%'
      AND Edges.ConditionLabel LIKE '%N%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (29)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (29)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT DISTINCT StepDescription
FROM PathTraversal
WHERE CurrentNode NOT IN (
    SELECT SourceNodeID
    FROM Edges
    WHERE DiagramID = 'Connect (29)'
);;

-- Verifiable Database Answer:
-- ('User',)

============================================================

