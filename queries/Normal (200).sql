-- Auto-generated SQL and Answers for Diagram: Normal (200)

-- Question: What node immediately follows 'Read B'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID
INNER JOIN Nodes AS T3
  ON T1.SourceNodeID = T3.NodeID AND T1.DiagramID = T3.DiagramID
WHERE
  T1.DiagramID = 'Normal (200)' AND T3.LabelText LIKE 'Read B';;

-- Verifiable Database Answer:
-- ('Calculate Sum as A + B',)

============================================================

-- Question: Trace the sequence of events starting from 'Calculate Sum as A + B'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (200)' AND LabelText LIKE 'Calculate Sum as A + B'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (200)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (200)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Calculate Sum as A + B', 0)
-- (1, 'Straight', 'Output', 0)
-- (2, 'Straight', 'End', 0)

============================================================

-- Question: What shape is used for the 'Output' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (200)' AND LabelText = 'Output';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

-- Question: Does this flowchart contain any loops or decision branches?
SELECT
    (EXISTS (
        WITH RECURSIVE PathTraversal AS (
            -- Anchor member: Start from ALL nodes in the diagram to detect any possible cycle
            SELECT
                NodeID AS CurrentNode,
                LabelText AS StepDescription,
                'Start' AS ConditionToGetHere,
                0 AS HopCount,
                ',' || NodeID || ',' AS VisitedNodes,
                0 AS IsCycle
            FROM Nodes
            WHERE DiagramID = 'Normal (200)'

            UNION ALL

            -- Recursive member: Traverse to next nodes, detecting cycles
            SELECT
                Edges.TargetNodeID,
                NextNode.LabelText,
                IFNULL(Edges.ConditionLabel, 'Straight'),
                PathTraversal.HopCount + 1,
                PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
                CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
            FROM PathTraversal
            JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (200)'
            JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (200)'
            WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15 -- Limit hop count to prevent infinite recursion and large paths
        )
        SELECT 1 FROM PathTraversal WHERE IsCycle = 1
    ))
    OR
    (EXISTS (
        -- Check for decision branches: a node with more than one outgoing edge
        SELECT 1
        FROM Edges
        WHERE DiagramID = 'Normal (200)'
        GROUP BY SourceNodeID
        HAVING COUNT(DISTINCT TargetNodeID) > 1
    ));;

-- Verifiable Database Answer:
-- (0,)

============================================================

