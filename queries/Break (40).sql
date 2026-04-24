-- Auto-generated SQL and Answers for Diagram: Break (40)

-- Question: What shape is used for 'Input image'?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (40)' AND LabelText LIKE '%Input image%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

-- Question: What step immediately follows 'Description'?
SELECT T2.LabelText FROM Nodes AS T1 JOIN Edges ON T1.NodeID = Edges.SourceNodeID AND T1.DiagramID = Edges.DiagramID JOIN Nodes AS T2 ON Edges.TargetNodeID = T2.NodeID AND Edges.DiagramID = T2.DiagramID WHERE T1.DiagramID = 'Break (40)' AND T1.LabelText LIKE '%Description%';;

-- Verifiable Database Answer:
-- ('Segmentation',)

============================================================

-- Question: Trace the entire process from 'Program' to 'Obstacle/Non-obstacle decision'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (40)' AND LabelText LIKE '%Program%'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (40)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (40)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal pt
WHERE EXISTS (
    -- Subquery to check if 'Obstacle/Non-obstacle decision' is reachable from the current node in PathTraversal
    WITH RECURSIVE ReachableFromCurrent AS (
        SELECT
            NodeID AS SubCurrentNode,
            ',' || NodeID || ',' AS SubVisitedNodes
        FROM Nodes
        WHERE NodeID = pt.CurrentNode AND DiagramID = 'Break (40)'
        
        UNION ALL
        
        SELECT
            Edges.TargetNodeID,
            ReachableFromCurrent.SubVisitedNodes || Edges.TargetNodeID || ','
        FROM ReachableFromCurrent
        JOIN Edges ON Edges.SourceNodeID = ReachableFromCurrent.SubCurrentNode AND Edges.DiagramID = 'Break (40)'
        WHERE ReachableFromCurrent.SubVisitedNodes NOT LIKE '%,' || Edges.TargetNodeID || ',%'
    )
    SELECT 1
    FROM ReachableFromCurrent
    WHERE SubCurrentNode IN (SELECT NodeID FROM Nodes WHERE DiagramID = 'Break (40)' AND LabelText LIKE '%Obstacle/Non-obstacle decision%')
)
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Program', 0)
-- (1, 'Straight', 'Input image', 0)
-- (2, 'Straight', 'Description', 0)
-- (3, 'Straight', 'Segmentation', 0)
-- (4, 'Straight', 'Obstacle/Non-obstacle decision', 0)

============================================================

-- Question: What is the starting node of this linear flowchart?
SELECT NodeID, LabelText FROM Nodes WHERE DiagramID = 'Break (40)' AND NodeID NOT IN (SELECT TargetNodeID FROM Edges WHERE DiagramID = 'Break (40)');;

-- Verifiable Database Answer:
-- ('prog', 'Program')

============================================================

