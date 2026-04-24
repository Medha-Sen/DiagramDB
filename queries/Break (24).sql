-- Auto-generated SQL and Answers for Diagram: Break (24)

-- Question: What step comes immediately after 'Identify Problem'?
SELECT T2.LabelText FROM Nodes AS T1 JOIN Edges AS T3 ON T1.NodeID = T3.SourceNodeID AND T1.DiagramID = T3.DiagramID JOIN Nodes AS T2 ON T3.TargetNodeID = T2.NodeID AND T3.DiagramID = T2.DiagramID WHERE T1.DiagramID = 'Break (24)' AND T1.LabelText LIKE '%Identify Problem%';;

-- Verifiable Database Answer:
-- ('work on it',)

============================================================

-- Question: Trace the sequence of events before 'Ask for assistant'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Target Node' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (24)' AND LabelText LIKE '%Ask for assistant%'

    UNION ALL

    SELECT
        Edges.SourceNodeID,
        PrevNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.SourceNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.SourceNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.TargetNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (24)'
    JOIN Nodes AS PrevNode ON PrevNode.NodeID = Edges.SourceNodeID AND PrevNode.DiagramID = 'Break (24)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
ORDER BY HopCount DESC;;

-- Verifiable Database Answer:
-- (4, 'Straight', 'Start', 0)
-- (3, 'Straight', 'Identify Problem', 0)
-- (2, 'Straight', 'work on it', 0)
-- (2, 'Straight', 'Ask for assistant', 1)
-- (1, 'Straight', 'Note them down in a diagram or\\table.', 0)
-- (1, 'No', 'Need more help?', 0)
-- (0, 'Target Node', 'Ask for assistant', 0)

============================================================

-- Question: If 'Need more help?' is 'Yes', what is the next action?
SELECT TargetNode.LabelText FROM Nodes AS SourceNode JOIN Edges ON SourceNode.NodeID = Edges.SourceNodeID AND SourceNode.DiagramID = Edges.DiagramID JOIN Nodes AS TargetNode ON Edges.TargetNodeID = TargetNode.NodeID AND Edges.DiagramID = TargetNode.DiagramID WHERE SourceNode.DiagramID = 'Break (24)' AND SourceNode.LabelText LIKE '%Need more help?%' AND Edges.ConditionLabel = 'Yes';

-- Verifiable Database Answer:
-- ('Find solutions to the root causes\\identified.',)

============================================================

-- Question: Does the process loop back to a previous step if 'Need more help?' is 'No'?
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start the traversal from the node reached when 'Need more help?' is 'No'
    SELECT 
        Edges.TargetNodeID AS CurrentNode, 
        TargetNodes.LabelText AS StepDescription, 
        Edges.ConditionLabel AS ConditionToGetHere, -- This will be 'No'
        0 AS HopCount, 
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes AS SourceNodes ON Edges.SourceNodeID = SourceNodes.NodeID AND Edges.DiagramID = SourceNodes.DiagramID
    JOIN Nodes AS TargetNodes ON Edges.TargetNodeID = TargetNodes.NodeID AND Edges.DiagramID = TargetNodes.DiagramID
    WHERE Edges.DiagramID = 'Break (24)'
      AND SourceNodes.LabelText LIKE '%Need more help?%'
      AND Edges.ConditionLabel LIKE '%No%'
    
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
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (24)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (24)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'No', 'Ask for assistant', 0)
-- (1, 'Straight', 'Need more help?', 0)
-- (2, 'Yes', 'Find solutions to the root causes\\identified.', 0)
-- (2, 'No', 'Ask for assistant', 1)
-- (3, 'Straight', 'End', 0)

============================================================

