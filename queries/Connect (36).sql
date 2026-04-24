-- Auto-generated SQL and Answers for Diagram: Connect (36)

-- Question: What node immediately follows 'Calculate all the values'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (36)' AND LabelText LIKE '%Calculate all the values%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (36)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (36)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1;;

-- Verifiable Database Answer:
-- ('Finding out the optimal fitness value',)

============================================================

-- Question: If 'Are optimazation criteria met?' is 'Yes', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        NodeID AS InitialNodeID,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (36)' AND LabelText LIKE 'Are optimazation%criteria met?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        PathTraversal.InitialNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (36)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (36)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (
            -- For the very first hop from the initial conditional node, require ConditionLabel = 'Yes'
            (PathTraversal.CurrentNode = PathTraversal.InitialNodeID AND Edges.ConditionLabel = 'Yes')
            OR
            -- For all subsequent hops, follow all paths as no further condition is specified
            (PathTraversal.CurrentNode <> PathTraversal.InitialNodeID)
          )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Are optimazation\\criteria met?', 0)
-- (1, 'Yes', 'Finish', 0)

============================================================

-- Question: Trace the loop sequence if the optimization criteria are not met.
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start at the decision node "Are optimazation criteria met?"
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes 
    WHERE DiagramID = 'Connect (36)' 
      AND LabelText LIKE 'Are optimazation%criteria met%'
    
    UNION ALL
    
    -- Recursive member: Traverse edges
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (36)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (36)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        -- CRITICAL: Apply the 'No' condition ONLY for the first hop from the starting node.
        -- For subsequent hops, trace the loop regardless of condition labels until a cycle is detected.
        AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel LIKE '%No%')
            OR
            (PathTraversal.HopCount > 0)
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Are optimazation\\criteria met?', 0)
-- (1, 'No', 'Generating new group by\\evolutionary operation', 0)
-- (2, 'Straight', 'Randomly generating a group of\\parameters of SVM model', 0)
-- (3, 'Straight', 'Calculate all the values', 0)
-- (4, 'Straight', 'Finding out the optimal fitness value', 0)
-- (5, 'Straight', 'Are optimazation\\criteria met?', 1)

============================================================

-- Question: Does the process ever return to the very first 'Randomly generating...' node?
WITH RECURSIVE PathTraversal AS (
    SELECT
        N.NodeID AS CurrentNode,
        N.NodeID AS StartNodeID,
        N.LabelText AS StepDescription,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycleToStart
    FROM Nodes AS N
    WHERE N.DiagramID = 'Connect (36)'
      AND N.LabelText LIKE 'Randomly generating a group of%parameters of SVM model'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        PathTraversal.StartNodeID,
        NextNode.LabelText,
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN Edges.TargetNodeID = PathTraversal.StartNodeID THEN 1 ELSE 0 END AS IsCycleToStart
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (36)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (36)'
    WHERE PathTraversal.HopCount < 15
      AND PathTraversal.IsCycleToStart = 0
      AND (Edges.TargetNodeID = PathTraversal.StartNodeID OR PathTraversal.VisitedNodes NOT LIKE '%,' || Edges.TargetNodeID || ',%')
)
SELECT
    CASE WHEN MAX(IsCycleToStart) = 1 THEN 'Yes' ELSE 'No' END AS DoesReturnToStart
FROM PathTraversal;;

-- Verifiable Database Answer:
-- ('Yes',)

============================================================

