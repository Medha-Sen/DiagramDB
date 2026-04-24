-- Auto-generated SQL and Answers for Diagram: Connect (69)

-- Question: What shape is used for the 'Deal?' decision?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Connect (69)' AND LabelText LIKE '%Deal?%';;

-- Verifiable Database Answer:
-- ('diamond',)

============================================================

-- Question: What sequence of events happens after 'Customer Consulting and Quotation'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (69)' AND LabelText LIKE '%Customer Consulting and Quotation%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (69)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (69)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Customer Consulting and Quotation', 0)
-- (1, 'Straight', 'Deal?', 0)
-- (2, 'No', 'Go home', 0)
-- (2, 'Yes', 'Invoice', 0)
-- (3, 'Straight', 'Shipping', 0)
-- (4, 'Straight', 'Custom Clearance', 0)
-- (5, 'Straight', 'Payment mode', 0)
-- (6, 'Straight', 'Delivery', 0)
-- (7, 'Straight', 'Service Payment', 0)
-- (8, 'Straight', 'Pay Foreign Exchange?', 0)
-- (9, 'Yes', 'Payment', 0)
-- (9, 'No', 'Stop', 0)
-- (10, 'Straight', 'Stop', 0)

============================================================

-- Question: If the 'Deal?' condition is 'No', what is the exact next action?
SELECT
  T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Connect (69)' AND T2.DiagramID = 'Connect (69)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Connect (69)' AND LabelText LIKE '%Deal?%'
  ) AND T1.ConditionLabel = 'No';;

-- Verifiable Database Answer:
-- ('Go home',)

============================================================

-- Question: What steps occur if 'Pay Foreign Exchange?' evaluates to 'Yes'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Connect (69)' AND LabelText LIKE '%Pay Foreign Exchange?%'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (69)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (69)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15
      AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'Yes') -- Filter for 'Yes' only on the first hop from the starting node
            OR
            (PathTraversal.HopCount > 0) -- For subsequent hops, no specific condition filter needed
          )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Pay Foreign Exchange?', 0)
-- (1, 'Yes', 'Payment', 0)
-- (2, 'Straight', 'Stop', 0)

============================================================

