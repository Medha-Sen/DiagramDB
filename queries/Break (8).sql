-- Auto-generated SQL and Answers for Diagram: Break (8)

-- Question: What is the starting node of the flowchart?
SELECT NodeID, LabelText, ShapeType FROM Nodes WHERE DiagramID = 'Break (8)' AND LabelText LIKE '%Start%';;

-- Verifiable Database Answer:
-- ('start', 'Start', 'rounded_rectangle')

============================================================

-- Question: Trace the path starting from 'Sign up'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (8)' AND LabelText LIKE '%Sign up%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (8)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (8)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Sign up', 0)
-- (1, 'Straight', 'Give info', 0)
-- (2, 'Straight', 'Submit', 0)
-- (3, 'Straight', 'Log in', 0)
-- (4, 'Straight', 'Enter e-mail\\and password', 0)
-- (5, 'Straight', 'Authentication', 0)
-- (6, 'yes', 'loged in to the\\system', 0)
-- (6, 'no', 'Log in', 1)
-- (7, 'Straight', 'end', 0)

============================================================

-- Question: If 'have an account' is 'yes', what is the next step?
WITH RECURSIVE PathTraversal AS (
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS N
    WHERE N.DiagramID = 'Break (8)' AND N.LabelText LIKE 'have%an account%'
    
    UNION ALL
    
    SELECT
        E.TargetNodeID,
        NextNode.LabelText,
        IFNULL(E.ConditionLabel, 'Straight'),
        PT.HopCount + 1,
        PT.VisitedNodes || E.TargetNodeID || ',',
        CASE WHEN PT.VisitedNodes LIKE '%,' || E.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal AS PT
    JOIN Edges AS E ON E.SourceNodeID = PT.CurrentNode AND E.DiagramID = 'Break (8)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = E.TargetNodeID AND NextNode.DiagramID = 'Break (8)'
    WHERE PT.IsCycle = 0
        AND PT.HopCount < 15
        AND (PT.HopCount = 0 AND E.ConditionLabel = 'yes') -- Apply condition only for the first hop from the starting node
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
WHERE HopCount = 1 -- Select only the immediate next step
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'yes', 'Log in', 0)

============================================================

-- Question: If 'Authentication' fails, does the process loop back to a previous step?
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start from the node(s) that are reached immediately when 'Authentication' fails.
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        IFNULL(Edges.ConditionLabel, 'Straight') AS ConditionToGetHere,
        0 AS HopCount, -- This is the first step *after* 'Authentication' fails.
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS AuthNode
    JOIN Edges ON Edges.SourceNodeID = AuthNode.NodeID AND Edges.DiagramID = 'Break (8)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (8)'
    WHERE
        AuthNode.DiagramID = 'Break (8)'
        AND AuthNode.LabelText LIKE '%Authentication%'
        AND Edges.ConditionLabel LIKE '%No%' -- Assuming 'No' represents the 'fail' condition from 'Authentication'.
                                            -- Other possibilities could be '%Fail%', '%False%', etc., depending on the diagram's conventions.

    UNION ALL

    -- Recursive member: Traverse subsequent steps from the current path.
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (8)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (8)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
-- Final selection: Display the path traversal results. The 'IsCycle' column will indicate if a loop occurred.
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'no', 'Log in', 0)
-- (1, 'Straight', 'Enter e-mail\\and password', 0)
-- (2, 'Straight', 'Authentication', 0)
-- (3, 'yes', 'loged in to the\\system', 0)
-- (3, 'no', 'Log in', 1)
-- (4, 'Straight', 'end', 0)

============================================================

