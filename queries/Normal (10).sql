-- Auto-generated SQL and Answers for Diagram: Normal (10)

-- Question: What node immediately follows 'START'?
SELECT T2.LabelText FROM Edges AS T1 INNER JOIN Nodes AS T2 ON T1.TargetNodeID = T2.NodeID WHERE T1.DiagramID = 'Normal (10)' AND T2.DiagramID = 'Normal (10)' AND T1.SourceNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Normal (10)' AND LabelText LIKE 'START%');;

-- Verifiable Database Answer:
-- ('K is equal to 0',)

============================================================

-- Question: What action is taken after 'K is equal to 0'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (10)' AND LabelText LIKE '%K is equal to 0%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (10)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (10)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'K is equal to 0', 0)
-- (1, 'Straight', 'Calculate K as K+1', 0)
-- (2, 'Straight', 'PRINT K', 0)
-- (3, 'Straight', 'STOP', 0)

============================================================

-- Question: Trace the entire process from 'Calculate K as K+1' to 'STOP'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (10)' AND LabelText LIKE '%Calculate K as K+1%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (10)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (10)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal WHERE StepDescription LIKE '%STOP%' ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (2, 'Straight', 'STOP', 0)

============================================================

-- Question: Does this flowchart contain any decision-based branching or loops?
SELECT
    CASE
        WHEN EXISTS (
            -- Check for branching: a node has more than one distinct outgoing edge target.
            SELECT 1
            FROM Edges
            WHERE DiagramID = 'Normal (10)'
            GROUP BY SourceNodeID
            HAVING COUNT(DISTINCT TargetNodeID) > 1
        ) OR EXISTS (
            -- Check for loops: use a recursive CTE to traverse paths and detect cycles.
            WITH RECURSIVE PathTraversal AS (
                SELECT
                    NodeID AS CurrentNode,
                    0 AS HopCount,
                    ',' || NodeID || ',' AS VisitedNodes,
                    0 AS IsCycle
                FROM Nodes
                WHERE DiagramID = 'Normal (10)'

                UNION ALL

                SELECT
                    E.TargetNodeID,
                    PT.HopCount + 1,
                    PT.VisitedNodes || E.TargetNodeID || ',',
                    CASE WHEN PT.VisitedNodes LIKE '%,' || E.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
                FROM PathTraversal AS PT
                JOIN Edges AS E ON E.SourceNodeID = PT.CurrentNode AND E.DiagramID = 'Normal (10)'
                WHERE PT.IsCycle = 0 AND PT.HopCount < 50 -- Limit depth to prevent infinite loops in non-cyclic paths
            )
            SELECT 1 FROM PathTraversal WHERE IsCycle = 1
        ) THEN 'Yes'
        ELSE 'No'
    END AS ContainsBranchingOrLoops;;

-- Verifiable Database Answer:
-- ('No',)

============================================================

