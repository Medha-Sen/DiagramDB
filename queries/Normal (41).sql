-- Auto-generated SQL and Answers for Diagram: Normal (41)

-- Question: What node immediately follows 'A = 1'?
SELECT T2.LabelText
FROM Nodes AS T1
JOIN Edges AS T3
  ON T1.NodeID = T3.SourceNodeID
JOIN Nodes AS T2
  ON T3.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (41)' AND T3.DiagramID = 'Normal (41)' AND T2.DiagramID = 'Normal (41)' AND T1.LabelText LIKE 'A = 1';;

-- Verifiable Database Answer:
-- ('A≤10?',)

============================================================

-- Question: If 'A<=10?' evaluates to 'T', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (41)' AND LabelText LIKE '%A<=10?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        Edges.ConditionLabel,
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (41)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (41)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15 AND Edges.ConditionLabel = 'T'
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal WHERE HopCount > 0 ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (No matching results found in the diagram topology)

============================================================

-- Question: Trace the sequence of events inside the loop if the condition is 'T'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start: Loop condition check' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes 
    WHERE DiagramID = 'Normal (41)' AND LabelText LIKE 'A%10%' -- Anchor: Start at the loop condition node 'A≤10?'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight') AS ConditionToGetHere, 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (41)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (41)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'T') OR -- For the first hop from the loop condition, take only the 'T' branch
            (PathTraversal.HopCount > 0 AND NextNode.LabelText NOT LIKE 'A%10%') -- For subsequent hops, trace the loop body but stop before returning to the loop condition node itself
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start: Loop condition check', 'A≤10?', 0)
-- (1, 'T', 'Print A', 0)
-- (2, 'Straight', 'A = A + 1', 0)
-- (3, 'Straight', 'End', 0)

============================================================

-- Question: What is the final step if 'A<=10?' evaluates to 'F'?
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Identify the starting node after 'A<=10?' evaluates to 'F'.
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        1 AS HopCount, -- This is the first step AFTER the condition evaluation
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS StartNode
    JOIN Edges ON StartNode.NodeID = Edges.SourceNodeID AND Edges.DiagramID = 'Normal (41)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (41)'
    WHERE
        StartNode.DiagramID = 'Normal (41)'
        AND StartNode.LabelText LIKE 'A%10%?' -- Matches 'A≤10?'
        AND Edges.ConditionLabel = 'F' -- Specific condition for the edge
    
    UNION ALL
    
    -- Recursive member: Traverse subsequent steps from the current path
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'), -- Default condition if not specified on edge
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (41)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (41)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
-- Select the final step, which is a node from which no further edges originate within this path.
SELECT StepDescription
FROM PathTraversal
WHERE NOT EXISTS (
    SELECT 1 FROM Edges
    WHERE Edges.SourceNodeID = PathTraversal.CurrentNode
    AND Edges.DiagramID = 'Normal (41)'
)
ORDER BY HopCount DESC
LIMIT 1;;

-- Verifiable Database Answer:
-- ('End',)

============================================================

