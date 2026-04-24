-- Auto-generated SQL and Answers for Diagram: Normal (195)

-- Question: What shape is used for the 'INPUT bears' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (195)' AND LabelText LIKE '%INPUT bears%';;

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: What calculation step immediately follows 'hourwage = hours * 7'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (195)' AND LabelText LIKE '%hourwage % hours % 7%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (195)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (195)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1 ORDER BY HopCount;;

-- Verifiable Database Answer:
-- ('bearswage = bears * 0.45',)

============================================================

-- Question: Trace the entire linear process from 'Initialization' to 'Stop'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (195)' AND LabelText LIKE '%Initialization%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (195)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (195)'
    WHERE PathTraversal.IsCycle = 0 
      AND PathTraversal.HopCount < 15
      AND PathTraversal.StepDescription NOT LIKE '%Stop%'
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Initialization', 0)
-- (1, 'Straight', 'INPUT bears', 0)
-- (2, 'Straight', 'hourwage = hours * 7', 0)
-- (3, 'Straight', 'bearswage = bears * 0.45', 0)
-- (4, 'Straight', 'total = hourswage + bearswage', 0)
-- (5, 'Straight', 'Print Result', 0)
-- (6, 'Straight', 'Stop', 0)

============================================================

-- Question: What step occurs right before the 'Stop' node?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'TargetNode' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (195)' AND LabelText LIKE '%Stop%'

    UNION ALL

    SELECT
        Edges.SourceNodeID,
        PrevNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.SourceNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.SourceNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.TargetNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (195)'
    JOIN Nodes AS PrevNode ON PrevNode.NodeID = Edges.SourceNodeID AND PrevNode.DiagramID = 'Normal (195)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1;;

-- Verifiable Database Answer:
-- ('Print Result',)

============================================================

