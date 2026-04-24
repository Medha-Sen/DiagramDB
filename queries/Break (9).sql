-- Auto-generated SQL and Answers for Diagram: Break (9)

-- Question: What shape represents 'Purchase Requisition'?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (9)' AND LabelText LIKE '%Purchase Requisition%';;

-- Verifiable Database Answer:
-- ('tape',)

============================================================

-- Question: If 'Approved' is 'NO', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        TargetNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        1 AS HopCount,
        ',' || Edges.SourceNodeID || ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes AS SourceNode ON SourceNode.NodeID = Edges.SourceNodeID AND SourceNode.DiagramID = 'Break (9)'
    JOIN Nodes AS TargetNode ON TargetNode.NodeID = Edges.TargetNodeID AND TargetNode.DiagramID = 'Break (9)'
    WHERE Edges.DiagramID = 'Break (9)'
      AND SourceNode.LabelText LIKE '%Approved%'
      AND Edges.ConditionLabel LIKE '%NO%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (9)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (9)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'NO', 'Purchase Requisition', 0)

============================================================

-- Question: Trace the entire process if the payment method is 'Credit Card'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes 
    WHERE DiagramID = 'Break (9)' AND LabelText LIKE '%Credit Card%or%Cash%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (9)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (9)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        AND (
            (PathTraversal.HopCount = 0 AND PathTraversal.StepDescription LIKE '%Credit Card%or%Cash%' AND Edges.ConditionLabel LIKE '%Credit Card%')
            OR
            (PathTraversal.HopCount > 0)
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Credit Card\\or\\Cash?', 0)
-- (1, 'Credit Card', 'Enter card number', 0)
-- (2, 'Straight', 'Invoice CCPR', 0)
-- (3, 'Straight', 'Documents to\\Controller for Approval', 0)

============================================================

-- Question: What sequence of events occurs if it is not an Independent Contractor?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (9)' AND LabelText LIKE '%Is it an%Independent%Contractor%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (9)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (9)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        AND (
            PathTraversal.HopCount > 0 OR -- For subsequent hops, no specific condition on Edges.ConditionLabel
            Edges.ConditionLabel LIKE '%No%' -- For the first hop (when PathTraversal.HopCount = 0), only follow 'No' path
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Is it an\\Independent\\Contractor?', 0)
-- (1, 'NO', 'Obtain P.O from\\Controller', 0)
-- (2, 'Straight', 'Invoice', 0)
-- (3, 'To Controller', 'Documents to\\Controller for Approval', 0)

============================================================

