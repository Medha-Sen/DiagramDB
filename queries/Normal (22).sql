-- Auto-generated SQL and Answers for Diagram: Normal (22)

-- Question: What shape is used for the 'Go the first dose?' step?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (22)' AND LabelText LIKE 'Go the first%dose?%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

-- Question: If 'Go the first dose?' is 'Yes', what is the result?
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start at the "Go the first dose?" node
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (22)' AND LabelText LIKE 'Go the first%dose%?'

    UNION ALL

    -- Recursive member: Traverse paths
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (22)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (22)'
    WHERE
        PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 15
        -- Apply the 'Yes' condition ONLY for the first hop (from the initial starting node)
        -- For subsequent hops (HopCount > 0), any condition is followed.
        AND (
               (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'Yes')
            OR (PathTraversal.HopCount > 0)
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Go the first\\dose?', 0)
-- (1, 'Yes', '1 dose', 0)

============================================================

-- Question: Trace the sequence of events if both dose questions are answered 'No/Don't know'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        0 AS FirstDoseNoMet, -- Flag: 1 if 'Go the first dose?' answered 'No/Don't know'
        0 AS SecondDoseNoMet -- Flag: 1 if 'Go second dose?' answered 'No/Don't know'
    FROM Nodes 
    WHERE DiagramID = 'Normal (22)' 
      AND LabelText LIKE 'Go the first%dose%' -- Start tracing from the first dose question
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        -- Update FirstDoseNoMet flag: carry forward if already met, or set if current edge meets condition
        CASE 
            WHEN PathTraversal.FirstDoseNoMet = 1 THEN 1 
            WHEN PathTraversal.StepDescription LIKE 'Go the first%dose%' AND Edges.ConditionLabel LIKE '%No%Don%' THEN 1 
            ELSE 0 
        END AS FirstDoseNoMet,
        -- Update SecondDoseNoMet flag: carry forward if already met, or set if current edge meets condition
        CASE 
            WHEN PathTraversal.SecondDoseNoMet = 1 THEN 1 
            WHEN PathTraversal.StepDescription LIKE 'Go second%dose%' AND Edges.ConditionLabel LIKE '%No%Don%' THEN 1 
            ELSE 0 
        END AS SecondDoseNoMet
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (22)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (22)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription 
FROM PathTraversal 
WHERE FirstDoseNoMet = 1 AND SecondDoseNoMet = 1 -- Only show steps where both conditions have been met
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (2, "No/\\Don't know", '2 doses')

============================================================

-- Question: What happens if 'Go the first dose?' is 'No/Don't know' but 'Go second dose?' is 'Yes'?
WITH RECURSIVE PathTraversal AS (
    -- ANCHOR MEMBER: Start after "Go the first dose?" -> "No/Don't know"
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        CASE
            WHEN NextNode.LabelText LIKE '%Go second%dose?%' THEN 1 -- Set state to 1 if the very first node encountered is 'Go second dose?'
            ELSE 0 -- Otherwise, we are still searching (state 0)
        END AS PathState -- 0: Searching for 'Go second dose?'. 1: At 'Go second dose?', about to take 'Yes'. 2: After 'Go second dose?'->'Yes'.
    FROM Nodes
    JOIN Edges ON Nodes.NodeID = Edges.SourceNodeID AND Nodes.DiagramID = Edges.DiagramID
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = Edges.DiagramID
    WHERE
        Nodes.DiagramID = 'Normal (22)'
        AND Nodes.LabelText LIKE '%Go the first%dose?%'
        AND Edges.ConditionLabel LIKE '%No/Don%t know%'

    UNION ALL

    -- RECURSIVE MEMBER: Continue traversal based on PathState
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        CASE
            -- If current state is 0 (searching for 'Go second dose?'):
            WHEN PathTraversal.PathState = 0 AND NextNode.LabelText LIKE '%Go second%dose?%' THEN 1 -- Found 'Go second dose?', transition to state 1
            WHEN PathTraversal.PathState = 0 THEN 0 -- Still searching for 'Go second dose?', remain in state 0

            -- If current state is 1 (at 'Go second dose?', about to take 'Yes'):
            WHEN PathTraversal.PathState = 1 AND Edges.ConditionLabel LIKE '%Yes%' THEN 2 -- Took 'Yes' branch, transition to state 2
            WHEN PathTraversal.PathState = 1 AND NOT (Edges.ConditionLabel LIKE '%Yes%') THEN PathTraversal.PathState -- Don't take other paths, effectively terminating non-Yes paths here

            -- If current state is 2 (after 'Go second dose?' -> 'Yes'):
            WHEN PathTraversal.PathState = 2 THEN 2 -- Continue traversing normally, remain in state 2
            ELSE PathTraversal.PathState -- Fallback (should not be reached)
        END AS PathState
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (22)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (22)'
    WHERE
        PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 15
        -- Conditional edge selection based on PathState
        AND (
            PathTraversal.PathState = 0 -- If still searching for 'Go second dose?', traverse any edge
            OR (PathTraversal.PathState = 1 AND Edges.ConditionLabel LIKE '%Yes%') -- If at 'Go second dose?', ONLY take the 'Yes' edge
            OR PathTraversal.PathState = 2 -- If already past 'Go second dose?' via 'Yes', traverse any subsequent edge
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
WHERE PathState = 2 -- Only show the steps that occur AFTER the 'Go second dose?' -> 'Yes' condition has been met
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (No matching results found in the diagram topology)

============================================================

