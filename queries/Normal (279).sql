-- Auto-generated SQL and Answers for Diagram: Normal (279)

-- Question: What node immediately follows 'Surgery'?
SELECT T2.LabelText FROM Edges AS T1 INNER JOIN Nodes AS T2 ON T1.TargetNodeID = T2.NodeID WHERE T1.DiagramID = 'Normal (279)' AND T2.DiagramID = 'Normal (279)' AND T1.SourceNodeID = ( SELECT NodeID FROM Nodes WHERE DiagramID = 'Normal (279)' AND LabelText LIKE '%Surgery%' );

-- Verifiable Database Answer:
-- ('Discuss with Doctor',)

============================================================

-- Question: If the patient 'Still has concerns', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (279)' AND LabelText LIKE '%Still has concerns%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (279)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (279)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Still has concerns', 0)
-- (1, 'Straight', 'Contact Again', 0)
-- (2, 'Straight', 'No longer has concerns', 0)
-- (2, 'Straight', 'Concerns remain', 0)
-- (3, 'Straight', 'No further CP action', 0)
-- (3, 'Straight', 'Ensure documentation is complete', 0)
-- (4, 'Straight', 'Ensure documentation complete', 0)
-- (4, 'Straight', 'Assessment made. CP procedures follow', 0)

============================================================

-- Question: Trace the sequence of events from 'Contact Again' if the patient 'No longer has concerns'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (279)' AND LabelText LIKE '%Contact Again%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (279)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (279)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
    AND (PathTraversal.HopCount = 0 OR Edges.ConditionLabel LIKE '%No longer has concerns%')
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Contact Again', 0)
-- (1, 'Straight', 'No longer has concerns', 0)
-- (1, 'Straight', 'Concerns remain', 0)

============================================================

-- Question: What are the two final destination nodes in this process?
SELECT T1.LabelText FROM Nodes AS T1 WHERE T1.DiagramID = 'Normal (279)' AND NOT EXISTS (SELECT 1 FROM Edges AS T2 WHERE T2.SourceNodeID = T1.NodeID AND T2.DiagramID = T1.DiagramID);;

-- Verifiable Database Answer:
-- ('Assessment made. CP procedures follow',)
-- ('Ensure documentation complete',)

============================================================

