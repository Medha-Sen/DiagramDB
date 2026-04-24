-- Auto-generated SQL and Answers for Diagram: Connect (4)

-- Question: What shape is used for the 'Read Value' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Connect (4)' AND LabelText LIKE 'Read%Value%';

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: If the condition is 'Yes', what is the next action?
SELECT T2.LabelText FROM Edges AS T1 INNER JOIN Nodes AS T2 ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID WHERE T1.DiagramID = 'Connect (4)' AND T1.ConditionLabel = 'Yes';;

-- Verifiable Database Answer:
-- ('Print\\[0.5em] Cold',)

============================================================

-- Question: Trace the entire path if the condition is 'No'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (4)' AND LabelText LIKE '%Start%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (4)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (4)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (Edges.ConditionLabel = 'No' OR Edges.ConditionLabel IS NULL OR Edges.ConditionLabel = '') -- Follow 'No' condition or unconditional paths
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Start', 0)
-- (1, 'Straight', 'Read\\[0.3em]Value', 0)
-- (2, 'Straight', 'Temp\\[0.2em]< 32?', 0)
-- (3, 'No', 'Print\\[0.5em] Not Cold', 0)
-- (4, 'Straight', 'End', 0)

============================================================

-- Question: What is the final step for both branches of the condition?
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start from the direct children of the conditional node 'Temp < 32?'
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS InitialBranchCondition, -- This identifies which specific branch (e.g., 'True' or 'False') was taken
        0 AS HopCount,
        -- VisitedNodes includes the source (conditional node) and the immediate target (first node in the branch)
        -- This helps track the path taken for the branch and detect cycles
        ',' || Edges.SourceNodeID || ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS ConditionalNode
    JOIN Edges ON ConditionalNode.NodeID = Edges.SourceNodeID AND ConditionalNode.DiagramID = Edges.DiagramID
    JOIN Nodes AS NextNode ON Edges.TargetNodeID = NextNode.NodeID AND Edges.DiagramID = NextNode.DiagramID
    WHERE ConditionalNode.DiagramID = 'Connect (4)' AND ConditionalNode.LabelText LIKE 'Temp%< 32?%' -- Identify the conditional node
    
    UNION ALL
    
    -- Recursive member: Traverse subsequent nodes from the branched paths
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        PathTraversal.InitialBranchCondition, -- Propagate the initial branch condition identifier
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (4)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (4)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15 -- Prevent infinite loops and limit path length
)
-- Select the StepDescription (LabelText) of nodes that are:
-- 1. Terminal (have no outgoing edges), indicating a potential "final step".
-- 2. Reached by ALL distinct initial branches originating from the 'Temp < 32?' conditional node.
SELECT StepDescription
FROM PathTraversal
WHERE CurrentNode NOT IN (SELECT SourceNodeID FROM Edges WHERE DiagramID = 'Connect (4)') -- Filter for nodes that have no outgoing edges
GROUP BY StepDescription
HAVING COUNT(DISTINCT InitialBranchCondition) = (
    -- Subquery to determine the total number of distinct branches (condition labels)
    -- originating from the 'Temp < 32?' conditional node.
    SELECT COUNT(DISTINCT Edges.ConditionLabel)
    FROM Nodes
    JOIN Edges ON Nodes.NodeID = Edges.SourceNodeID AND Nodes.DiagramID = Edges.DiagramID
    WHERE Nodes.DiagramID = 'Connect (4)' AND Nodes.LabelText LIKE 'Temp%< 32?%'
);;

-- Verifiable Database Answer:
-- ('End',)

============================================================

