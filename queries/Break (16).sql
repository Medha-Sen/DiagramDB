-- Auto-generated SQL and Answers for Diagram: Break (16)

-- Question: What node immediately follows 'Start'?
SELECT T2.LabelText FROM Edges AS T1 JOIN Nodes AS T2 ON T1.TargetNodeID = T2.NodeID AND T1.DiagramID = T2.DiagramID JOIN Nodes AS T3 ON T1.SourceNodeID = T3.NodeID AND T1.DiagramID = T3.DiagramID WHERE T1.DiagramID = 'Break (16)' AND T3.LabelText LIKE '%Start%';;

-- Verifiable Database Answer:
-- ('Step 1',)

============================================================

-- Question: What happens if the 'Decision' is 'Yes'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (16)' AND LabelText LIKE '%Decision%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (16)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (16)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (PathTraversal.HopCount > 0 OR Edges.ConditionLabel LIKE '%Yes%')
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Decision', 0)
-- (1, 'Yes', 'End', 0)

============================================================

-- Question: Does the process ever loop back to 'Step 1'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        N.NodeID AS CurrentNode, 
        N.LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle -- This flag will be 1 if a cycle back to 'Step 1' is detected
    FROM Nodes AS N WHERE N.DiagramID = 'Break (16)' AND N.LabelText LIKE '%Step 1%'
    
    UNION ALL
    
    SELECT 
        E.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(E.ConditionLabel, 'Straight'), 
        PT.HopCount + 1, 
        PT.VisitedNodes || E.TargetNodeID || ',',
        CASE 
            WHEN NextNode.LabelText LIKE '%Step 1%' AND PT.VisitedNodes LIKE '%,' || E.TargetNodeID || ',%' THEN 1 
            ELSE 0 
        END AS IsCycle -- Set to 1 if the current node (NextNode) is 'Step 1' and its NodeID was already visited in this path
    FROM PathTraversal AS PT
    JOIN Edges AS E ON E.SourceNodeID = PT.CurrentNode AND E.DiagramID = 'Break (16)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = E.TargetNodeID AND NextNode.DiagramID = 'Break (16)'
    WHERE PT.IsCycle = 0 AND PT.HopCount < 15 -- Stop exploring this path if a cycle is already found or hop limit reached
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle 
FROM PathTraversal 
WHERE IsCycle = 1 -- Select only the records where a loop back to 'Step 1' was detected
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (3, 'Straight', 'Step 1', 1)

============================================================

-- Question: What sequence of events happens after 'Update'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (16)' AND LabelText LIKE '%Update%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (16)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (16)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Update', 0)
-- (1, 'Straight', 'Step 1', 0)
-- (2, 'Straight', 'Decision', 0)
-- (3, 'Yes', 'End', 0)
-- (3, 'No', 'Update', 1)

============================================================

