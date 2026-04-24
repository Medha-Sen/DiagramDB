-- Auto-generated SQL and Answers for Diagram: Break (33)

-- Question: What node immediately follows 'Input Total Score'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (33)' AND LabelText LIKE 'Input Total%Score%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (33)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (33)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal WHERE HopCount = 1 ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'Straight', 'If total score >\\800', 0)

============================================================

-- Question: If the total score condition is 'Yes', what is the next action?
WITH RECURSIVE PathTraversal AS (
    -- Initial step: Find the target node when the condition 'Yes' is met from the 'If total score >\800' node
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        TargetNodes.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        1 AS HopCount, -- This is the first action resulting from the condition
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS SourceNodes
    JOIN Edges ON SourceNodes.NodeID = Edges.SourceNodeID AND Edges.DiagramID = SourceNodes.DiagramID
    JOIN Nodes AS TargetNodes ON Edges.TargetNodeID = TargetNodes.NodeID AND Edges.DiagramID = TargetNodes.DiagramID
    WHERE
        SourceNodes.DiagramID = 'Break (33)'
        AND SourceNodes.LabelText LIKE 'If total score%' -- Identify the decision node
        AND Edges.ConditionLabel = 'Yes' -- Identify the specific condition for the edge

    UNION ALL

    -- Recursive step: Find subsequent steps (though for "next action", only HopCount = 1 is relevant in the final SELECT)
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (33)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (33)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
-- Select only the description of the immediate next action (HopCount = 1)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1 ORDER BY HopCount;;

-- Verifiable Database Answer:
-- ('Good college',)

============================================================

-- Question: Trace the entire path if the total score condition evaluates to 'No'.
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start at the 'If total score >\800' node, which is the point of condition evaluation.
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Condition evaluation point' AS ConditionToGetHere, -- Special label for the starting decision point
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (33)' AND LabelText LIKE '%If total score%800%'

    UNION ALL

    -- Recursive member: Traverse subsequent nodes.
    -- The first hop *must* follow an edge with ConditionLabel = 'No'.
    -- Subsequent hops follow any outgoing edge.
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        CASE
            WHEN PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'No' THEN Edges.ConditionLabel -- This is the specific 'No' branch from the starting node
            WHEN PathTraversal.HopCount > 0 THEN IFNULL(Edges.ConditionLabel, 'Straight') -- For subsequent hops, take any path, label as Straight if no condition
            ELSE NULL -- This case captures other branches from the starting node (HopCount=0 and ConditionLabel != 'No'), which we filter out.
        END AS ConditionToGetHere,
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (33)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (33)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'No') -- Only take the 'No' branch from the starting node
            OR
            (PathTraversal.HopCount > 0) -- For subsequent hops, take any outgoing edge
          )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal
WHERE ConditionToGetHere IS NOT NULL -- Filter out paths that didn't follow the 'No' branch initially
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Condition evaluation point', 'If total score >\\800', 0)
-- (1, 'No', 'Not good\\college', 0)
-- (2, 'Straight', 'End', 0)

============================================================

-- Question: What is the final step for both branches of the condition?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (33)' AND LabelText LIKE '%If total score >\%800%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (33)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (33)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT DISTINCT StepDescription FROM PathTraversal WHERE StepDescription LIKE '%End%';;

-- Verifiable Database Answer:
-- ('End',)

============================================================

