-- Auto-generated SQL and Answers for Diagram: Connect (55)

-- Question: What shape is used for the 'INPUT' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Connect (55)' AND LabelText LIKE 'INPUT';;

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: If 'count <= 3' evaluates to 'No', what is the next step?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'StartNode' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (55)' AND LabelText LIKE '%count <= 3%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        Edges.ConditionLabel,
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (55)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (55)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 1 -- We only want the immediate next step
      AND Edges.ConditionLabel = 'No' -- Filter for the 'No' condition
)
SELECT StepDescription
FROM PathTraversal
WHERE HopCount = 1 AND ConditionToGetHere = 'No';;

-- Verifiable Database Answer:
-- ('STOP',)

============================================================

-- Question: Trace the sequence of events inside the loop if 'count <= 3' is 'Yes'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        Nodes.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes ON Nodes.NodeID = Edges.TargetNodeID AND Nodes.DiagramID = Edges.DiagramID
    WHERE
        Edges.DiagramID = 'Connect (55)'
        AND Edges.SourceNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Connect (55)' AND LabelText LIKE '%count <= 3%')
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
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (55)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (55)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Yes', 'INPUT', 0)
-- (1, 'Straight', 'p * n * r / 100', 0)
-- (2, 'Straight', 'PRINT', 0)
-- (3, 'Straight', 'count = count + 1', 0)
-- (4, 'Straight', 'count <= 3', 0)
-- (5, 'Yes', 'INPUT', 1)
-- (5, 'No', 'STOP', 0)

============================================================

-- Question: After 'count = count + 1', exactly which node does the process return to?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (55)' AND LabelText LIKE '%count = count + 1%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (55)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (55)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription
FROM PathTraversal
WHERE IsCycle = 1
ORDER BY HopCount
LIMIT 1;;

-- Verifiable Database Answer:
-- ('count = count + 1',)

============================================================

