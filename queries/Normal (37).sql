-- Auto-generated SQL and Answers for Diagram: Normal (37)

-- Question: If 'Are you happy?' evaluates to 'Yes', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (37)' AND LabelText LIKE 'Are you happy?'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        Edges.ConditionLabel,
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (37)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (37)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15 AND Edges.ConditionLabel = 'Yes'
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal WHERE HopCount = 1 ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'Yes', 'Make others happy', 0)

============================================================

-- Question: Trace the path if you are not happy, but you answer 'Yes' to 'Want to be happy?'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        TargetNode.NodeID AS CurrentNode,
        TargetNode.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || TargetNode.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS SourceNode
    JOIN Edges ON SourceNode.NodeID = Edges.SourceNodeID AND Edges.DiagramID = 'Normal (37)'
    JOIN Nodes AS TargetNode ON Edges.TargetNodeID = TargetNode.NodeID AND TargetNode.DiagramID = 'Normal (37)'
    WHERE
        SourceNode.DiagramID = 'Normal (37)' AND
        SourceNode.LabelText LIKE '%Want to be happy?%' AND
        Edges.ConditionLabel = 'Yes'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (37)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (37)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Ask someone', 0)
-- (1, 'Straight', 'Stop', 0)

============================================================

-- Question: Does the process loop back to a previous step if you answer 'No' to both questions?
WITH RECURSIVE PathTraversal AS (
    -- Initial state: Start from the 'Start' node
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        0 AS Q1NoTaken, -- 0: 'Are you happy?' No not yet taken, 1: Taken
        0 AS Q2NoTaken  -- 0: 'Want to be happy?' No not yet taken, 1: Taken
    FROM Nodes N
    WHERE N.DiagramID = 'Normal (37)' AND N.LabelText LIKE 'Start%'

    UNION ALL

    -- Recursive step
    SELECT
        E.TargetNodeID,
        NextNode.LabelText,
        IFNULL(E.ConditionLabel, 'Straight'),
        PT.HopCount + 1,
        PT.VisitedNodes || E.TargetNodeID || ',',
        -- IsCycle: A cycle is detected if the TargetNodeID has been visited before *AND* both Q1NoTaken and Q2NoTaken are true in the current path
        CASE
            WHEN PT.Q1NoTaken = 1 AND PT.Q2NoTaken = 1 AND PT.VisitedNodes LIKE '%,' || E.TargetNodeID || ',%' THEN 1
            ELSE 0
        END AS IsCycle,
        -- Update Q1NoTaken status: becomes 1 if it was already 1, OR if the current step is 'Are you happy?' and the 'No' branch is taken
        CASE
            WHEN PT.Q1NoTaken = 1 THEN 1
            WHEN PT.StepDescription LIKE 'Are you happy%' AND E.ConditionLabel = 'No' THEN 1
            ELSE 0
        END AS Q1NoTaken,
        -- Update Q2NoTaken status: becomes 1 if it was already 1, OR if the current step is 'Want to be happy?' and the 'No' branch is taken, *AND* Q1NoTaken was already 1 (ensuring order)
        CASE
            WHEN PT.Q2NoTaken = 1 THEN 1
            WHEN PT.Q1NoTaken = 1 AND PT.StepDescription LIKE 'Want to be happy%' AND E.ConditionLabel = 'No' THEN 1
            ELSE 0
        END AS Q2NoTaken
    FROM PathTraversal PT
    JOIN Edges E ON E.SourceNodeID = PT.CurrentNode AND E.DiagramID = 'Normal (37)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = E.TargetNodeID AND NextNode.DiagramID = 'Normal (37)'
    -- Continue recursion as long as no cycle has been detected (or before cycle conditions are met) AND within hop limits
    WHERE PT.IsCycle = 0 AND PT.HopCount < 50
)
-- Final selection: Check if any path in PathTraversal detected a cycle after both 'No' conditions were met
SELECT
    CASE WHEN EXISTS (SELECT 1 FROM PathTraversal WHERE IsCycle = 1 AND Q1NoTaken = 1 AND Q2NoTaken = 1) THEN 'Yes, a loop is detected.'
    ELSE 'No loop detected under these conditions.' END AS LoopDetected
FROM PathTraversal LIMIT 1;;

-- Verifiable Database Answer:
-- ('Yes, a loop is detected.',)

============================================================

-- Question: What node do the 'Make others happy' and 'Ask someone' paths converge on?
WITH RECURSIVE PathFromMakeOthersHappy AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (37)' AND LabelText LIKE '%Make others happy%'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        PFMOH.HopCount + 1,
        PFMOH.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PFMOH.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathFromMakeOthersHappy AS PFMOH
    JOIN Edges ON Edges.SourceNodeID = PFMOH.CurrentNode AND Edges.DiagramID = 'Normal (37)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (37)'
    WHERE PFMOH.IsCycle = 0 AND PFMOH.HopCount < 15
),
PathFromAskSomeone AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (37)' AND LabelText LIKE '%Ask someone%'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        PFAS.HopCount + 1,
        PFAS.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PFAS.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathFromAskSomeone AS PFAS
    JOIN Edges ON Edges.SourceNodeID = PFAS.CurrentNode AND Edges.DiagramID = 'Normal (37)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (37)'
    WHERE PFAS.IsCycle = 0 AND PFAS.HopCount < 15
)
SELECT DISTINCT N.LabelText
FROM PathFromMakeOthersHappy PFMOH
JOIN PathFromAskSomeone PFAS ON PFMOH.CurrentNode = PFAS.CurrentNode
JOIN Nodes N ON N.NodeID = PFMOH.CurrentNode AND N.DiagramID = 'Normal (37)'
WHERE PFMOH.HopCount > 0 OR PFAS.HopCount > 0
ORDER BY (PFMOH.HopCount + PFAS.HopCount)
LIMIT 1;;

-- Verifiable Database Answer:
-- ('Stop',)

============================================================

