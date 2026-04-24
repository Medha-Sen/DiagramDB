-- Auto-generated SQL and Answers for Diagram: Break (17)

-- Question: What shape is used for the 'Case base'?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (17)' AND LabelText LIKE '%Case base%';;

-- Verifiable Database Answer:
-- ('cylinder',)

============================================================

-- Question: Trace the process starting from a 'New case'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (17)' AND LabelText LIKE '%New case%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (17)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (17)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'New case', 0)
-- (1, 'Input', 'Case retrieval', 0)
-- (2, 'Obtain', 'Similar cases', 0)
-- (3, 'Input', 'Case reuse', 0)
-- (4, 'Output', 'Print Result', 0)
-- (5, 'Evaluate', 'Case revise', 0)
-- (6, 'Straight', 'Case update', 0)
-- (7, 'Store', 'Case base', 0)
-- (8, 'Retrieve', 'Case retrieval', 1)

============================================================

-- Question: What sequence of events happens after 'Case retrieval'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (17)' AND LabelText LIKE '%Case retrieval%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (17)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (17)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Case retrieval', 0)
-- (1, 'Obtain', 'Similar cases', 0)
-- (2, 'Input', 'Case reuse', 0)
-- (3, 'Output', 'Print Result', 0)
-- (4, 'Evaluate', 'Case revise', 0)
-- (5, 'Straight', 'Case update', 0)
-- (6, 'Store', 'Case base', 0)
-- (7, 'Retrieve', 'Case retrieval', 1)

============================================================

