-- Auto-generated SQL and Answers for Diagram: Break (77)

-- Question: What step immediately follows 'Check needs for project'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (77)' AND LabelText LIKE 'Check needs%for project%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (77)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (77)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1 ORDER BY StepDescription;;

-- Verifiable Database Answer:
-- ('Is project\\well-\\defined?',)

============================================================

-- Question: If the project is well-defined, what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        1 AS HopCount,
        ',' || Edges.SourceNodeID || ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes AS SourceNode ON Edges.SourceNodeID = SourceNode.NodeID AND Edges.DiagramID = SourceNode.DiagramID
    JOIN Nodes AS NextNode ON Edges.TargetNodeID = NextNode.NodeID AND Edges.DiagramID = NextNode.DiagramID
    WHERE Edges.DiagramID = 'Break (77)'
      AND SourceNode.LabelText LIKE 'Is project%well%defined%'
      AND Edges.ConditionLabel = 'Yes'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (77)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (77)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'Yes', 'Build\\prototype', 0)
-- (2, 'Straight', 'END', 0)

============================================================

-- Question: Trace the entire path if the project is not well-defined.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (77)' AND LabelText LIKE '%Is project%well%defined%?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (77)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (77)'
    WHERE
        PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 15
        AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel LIKE 'No%')
            OR
            (PathTraversal.HopCount > 0)
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Is project\\well-\\defined?', 0)
-- (1, 'No', 'Re-evaluate\\needs', 0)
-- (2, 'Straight', 'Build\\prototype', 0)
-- (3, 'Straight', 'END', 0)

============================================================

-- Question: What is the final step after building the prototype?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (77)' AND LabelText LIKE 'Build%prototype%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (77)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (77)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription FROM PathTraversal WHERE StepDescription LIKE '%END%';;

-- Verifiable Database Answer:
-- ('END',)

============================================================

