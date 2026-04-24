-- Auto-generated SQL and Answers for Diagram: Break (18)

-- Question: What is the shape of the 'Ready to Get Up?' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (18)' AND LabelText LIKE 'Ready to Get Up?';;

-- Verifiable Database Answer:
-- ('diamond',)

============================================================

-- Question: If 'Ready to Get Up?' is 'YES', what is the next step?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (18)' AND LabelText LIKE '%Ready to Get Up?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (18)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (18)'
    WHERE PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 1 -- Limit to the immediate next step (HopCount = 1)
        AND Edges.ConditionLabel = 'YES' -- Apply the condition for the edge
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
WHERE HopCount = 1 -- Select only the next step
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'YES', 'Wakeup', 0)

============================================================

-- Question: What steps occur if you are not ready to get up?
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        TargetNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS SourceNode
    JOIN Edges ON SourceNode.NodeID = Edges.SourceNodeID AND Edges.DiagramID = 'Break (18)'
    JOIN Nodes AS TargetNode ON Edges.TargetNodeID = TargetNode.NodeID AND TargetNode.DiagramID = 'Break (18)'
    WHERE SourceNode.DiagramID = 'Break (18)'
      AND SourceNode.LabelText LIKE '%Ready to Get Up%'
      AND Edges.ConditionLabel LIKE '%No%'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (18)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (18)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'NO', 'Ignore bell', 0)
-- (1, 'Straight', 'Relay', 0)
-- (2, 'Straight', 'Door Bell', 0)
-- (3, 'Straight', 'Ready to Get Up?', 0)
-- (4, 'YES', 'Wakeup', 0)
-- (4, 'NO', 'Ignore bell', 1)
-- (5, 'Straight', 'End', 0)

============================================================

-- Question: Trace the path starting from 'Ignore bell'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (18)' AND LabelText LIKE '%Ignore bell%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (18)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (18)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Ignore bell', 0)
-- (1, 'Straight', 'Relay', 0)
-- (2, 'Straight', 'Door Bell', 0)
-- (3, 'Straight', 'Ready to Get Up?', 0)
-- (4, 'YES', 'Wakeup', 0)
-- (4, 'NO', 'Ignore bell', 1)
-- (5, 'Straight', 'End', 0)

============================================================

