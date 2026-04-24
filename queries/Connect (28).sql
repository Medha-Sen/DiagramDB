-- Auto-generated SQL and Answers for Diagram: Connect (28)

-- Question: What node immediately follows the initial 'Candidate' step?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (28)' AND LabelText LIKE '%Candidate%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (28)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (28)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1 ORDER BY HopCount;;

-- Verifiable Database Answer:
-- ('Are two candidate\\left?',)
-- ('Finish',)
-- ('Eliminate last\\place candidate',)
-- ('Recount all\\ballots',)

============================================================

-- Question: If 'Are two candidate left?' is 'yes', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (28)' AND LabelText LIKE '%Are two candidate%left%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (28)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (28)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15
      AND Edges.ConditionLabel = 'yes'
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
WHERE HopCount = 1
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'yes', 'Finish', 0)

============================================================

-- Question: Trace the complete loop sequence if 'Are two candidate left?' evaluates to 'no'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (28)' AND LabelText LIKE 'Are two candidate%left%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (28)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (28)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15 AND Edges.ConditionLabel = 'no'
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Are two candidate\\left?', 0)
-- (1, 'no', 'Eliminate last\\place candidate', 0)

============================================================

-- Question: Does the process loop back to the 'Candidate' node or a different node?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        NodeID AS InitialStartNode
    FROM Nodes
    WHERE DiagramID = 'Connect (28)'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        PathTraversal.InitialStartNode
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (28)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (28)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT
    CASE
        WHEN EXISTS (
            SELECT 1 FROM PathTraversal
            WHERE IsCycle = 1
            AND CurrentNode = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Connect (28)' AND LabelText LIKE '%Candidate%')
        ) THEN 'Yes, the process loops back to the Candidate node.'
        WHEN EXISTS (
            SELECT 1 FROM PathTraversal
            WHERE IsCycle = 1
        ) THEN 'Yes, the process loops back to a different node.'
        ELSE 'No loops detected in the process.'
    END AS LoopStatus;;

-- Verifiable Database Answer:
-- ('Yes, the process loops back to a different node.',)

============================================================

