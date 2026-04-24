-- Auto-generated SQL and Answers for Diagram: Connect (70)

-- Question: What node immediately follows 'Create a store'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (70)' AND LabelText LIKE 'Create a store%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (70)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (70)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1;;

-- Verifiable Database Answer:
-- ('Create a store type',)
-- ('Add items to a store',)
-- ('Create an item category',)
-- ('Create a store',)

============================================================

-- Question: Trace the sequence of events down the 'Purchase' path.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        CASE 
            WHEN LabelText LIKE '%Purchase%' THEN 1 
            ELSE 0 
        END AS HasPurchaseElement
    FROM Nodes 
    WHERE DiagramID = 'Connect (70)' AND LabelText LIKE '%Start%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        CASE 
            WHEN PathTraversal.HasPurchaseElement = 1 THEN 1
            WHEN Edges.ConditionLabel LIKE '%Purchase%' THEN 1
            WHEN NextNode.LabelText LIKE '%Purchase%' THEN 1
            ELSE 0 
        END AS HasPurchaseElement
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (70)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (70)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle 
FROM PathTraversal 
WHERE HasPurchaseElement = 1
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (4, 'Purchase', 'Add items to a store', 0)
-- (5, 'Straight', 'Paper work', 0)
-- (6, 'Straight', 'Raise an indent', 0)
-- (7, 'Straight', 'Create a purchase order', 0)
-- (8, 'Straight', 'End', 0)

============================================================

-- Question: What are the steps if the branching path chosen is 'Sales'?
WITH RECURSIVE PathTraversal AS (
    -- Base case: Find all nodes that are immediate targets of an edge with 'Sales' as the ConditionLabel
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere, -- This will be 'Sales' for the initial steps
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (70)'
    WHERE Edges.DiagramID = 'Connect (70)'
      AND Edges.ConditionLabel LIKE '%Sales%'

    UNION ALL

    -- Recursive step: Traverse subsequent nodes from the initial 'Sales' path
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (70)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (70)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Sales', 'Create an item category', 0)
-- (1, 'Straight', 'Add items to a store', 0)
-- (2, 'Straight', 'Bill Check', 0)

============================================================

-- Question: What shape is used for the 'Paper work' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Connect (70)' AND LabelText LIKE '%Paper work%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

