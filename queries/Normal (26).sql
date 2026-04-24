-- Auto-generated SQL and Answers for Diagram: Normal (26)

-- Question: What are the three child nodes directly connected to 'board'?
SELECT T2.LabelText FROM Edges AS T1 INNER JOIN Nodes AS T2 ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID WHERE T1.DiagramID = 'Normal (26)' AND T1.SourceNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Normal (26)' AND LabelText LIKE '%board%') LIMIT 3;

-- Verifiable Database Answer:
-- ('Lighting',)
-- ('Power',)
-- ('General power',)

============================================================

-- Question: Trace the entire downward path starting from 'Power'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (26)' AND LabelText LIKE '%Power%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (26)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (26)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'General power', 0)
-- (0, 'Start', 'Power', 0)
-- (1, 'Straight', 'Conveyer 1', 0)
-- (2, 'Straight', 'Processing', 0)
-- (3, 'Straight', 'Conveyer', 0)

============================================================

-- Question: What step immediately precedes 'Processing'?
SELECT T1.LabelText FROM Nodes AS T1 INNER JOIN Edges AS T2 ON T1.NodeID = T2.SourceNodeID AND T1.DiagramID = T2.DiagramID INNER JOIN Nodes AS T3 ON T2.TargetNodeID = T3.NodeID AND T2.DiagramID = T3.DiagramID WHERE T1.DiagramID = 'Normal (26)' AND T3.LabelText LIKE '%Processing%';;

-- Verifiable Database Answer:
-- ('Conveyer 1',)

============================================================

-- Question: Are there any loops or converging branches in this hierarchical diagram?
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start traversal from every node in the diagram.
    -- Each node starts a potential path.
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS CurrentNodeLabel,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS PathHistory, -- String of visited NodeIDs for cycle detection
        0 AS IsCycle,
        '' AS PathToCurrentExcludingSelf -- Path string leading to CurrentNode, without CurrentNode itself.
                                        -- Empty for starting nodes as they have no predecessor path.
    FROM Nodes N
    WHERE N.DiagramID = 'Normal (26)'

    UNION ALL

    -- Recursive member: Traverse edges to find subsequent nodes.
    SELECT
        E.TargetNodeID AS CurrentNode,
        TargetN.LabelText AS CurrentNodeLabel,
        PT.HopCount + 1 AS HopCount,
        PT.PathHistory || E.TargetNodeID || ',' AS PathHistory,
        CASE
            -- Check if the TargetNodeID is already present in the PathHistory, indicating a cycle.
            WHEN PT.PathHistory LIKE '%,' || E.TargetNodeID || ',%' THEN 1
            ELSE 0
        END AS IsCycle,
        PT.PathHistory AS PathToCurrentExcludingSelf -- The PathHistory from the previous step is the path
                                                    -- leading to the current TargetNodeID.
    FROM PathTraversal PT
    JOIN Edges E ON E.SourceNodeID = PT.CurrentNode AND E.DiagramID = 'Normal (26)'
    JOIN Nodes TargetN ON TargetN.NodeID = E.TargetNodeID AND TargetN.DiagramID = 'Normal (26)'
    -- Stop traversing if a cycle is detected or if the path becomes too long to prevent infinite loops
    -- and excessive computation in complex graphs.
    WHERE PT.IsCycle = 0 AND PT.HopCount < 50
)
SELECT
    -- Determine if any loops (cycles) exist in the diagram.
    CASE
        WHEN EXISTS (SELECT 1 FROM PathTraversal WHERE IsCycle = 1) THEN 'Yes'
        ELSE 'No'
    END AS HasLoops,
    -- Determine if any converging branches exist.
    -- A convergence point is a node reached by more than one distinct predecessor path.
    CASE
        WHEN EXISTS (
            SELECT 1
            FROM PathTraversal
            WHERE IsCycle = 0 -- Only consider non-cyclic paths for convergence detection
            GROUP BY CurrentNode
            -- If a node is reached by more than one unique sequence of predecessor nodes, it's a convergence.
            HAVING COUNT(DISTINCT PathToCurrentExcludingSelf) > 1
        ) THEN 'Yes'
        ELSE 'No'
    END AS HasConvergingBranches;;

-- Verifiable Database Answer:
-- ('No', 'Yes')

============================================================

