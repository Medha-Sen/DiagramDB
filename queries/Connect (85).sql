-- Auto-generated SQL and Answers for Diagram: Connect (85)

-- Question: What node immediately follows the 'Start' node?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Connect (85)' AND T2.DiagramID = 'Connect (85)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Connect (85)' AND LabelText LIKE '%Start%'
  );;

-- Verifiable Database Answer:
-- ('My Operation',)

============================================================

-- Question: If the 'Yes or No?' decision evaluates to 'yes', what happens next?
WITH RECURSIVE PathTraversal AS (
    -- Base Case: Identify the node that is reached when the 'Yes or No?' decision evaluates to 'yes'.
    SELECT 
        NextNode.NodeID AS CurrentNode, 
        NextNode.LabelText AS StepDescription, 
        EdgesFromDecision.ConditionLabel AS ConditionToGetHere, -- This will be 'yes' for the initial step after the decision
        0 AS HopCount, 
        ',' || NextNode.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS DecisionNode
    JOIN Edges AS EdgesFromDecision 
        ON DecisionNode.NodeID = EdgesFromDecision.SourceNodeID 
        AND DecisionNode.DiagramID = EdgesFromDecision.DiagramID
    JOIN Nodes AS NextNode 
        ON EdgesFromDecision.TargetNodeID = NextNode.NodeID 
        AND EdgesFromDecision.DiagramID = NextNode.DiagramID
    WHERE 
        DecisionNode.DiagramID = 'Connect (85)' 
        AND DecisionNode.LabelText LIKE '%Yes or No?%'
        AND EdgesFromDecision.ConditionLabel LIKE '%yes%' -- Filter for the 'yes' branch
    
    UNION ALL
    
    -- Recursive Step: Traverse from the current node to subsequent nodes
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), -- Condition label for subsequent edges
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges 
        ON Edges.SourceNodeID = PathTraversal.CurrentNode 
        AND Edges.DiagramID = 'Connect (85)'
    JOIN Nodes AS NextNode 
        ON NextNode.NodeID = Edges.TargetNodeID 
        AND NextNode.DiagramID = 'Connect (85)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'yes', 'caten something', 0)
-- (1, 'Straight', 'End', 0)

============================================================

-- Question: Trace the loop sequence if the decision evaluates to 'no'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        TargetNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS DecisionNode
    JOIN Edges ON Edges.SourceNodeID = DecisionNode.NodeID AND Edges.DiagramID = 'Connect (85)'
    JOIN Nodes AS TargetNode ON TargetNode.NodeID = Edges.TargetNodeID AND TargetNode.DiagramID = 'Connect (85)'
    WHERE
        DecisionNode.DiagramID = 'Connect (85)'
        AND DecisionNode.LabelText LIKE '%Yes or No?%'
        AND Edges.ConditionLabel LIKE '%no%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (85)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (85)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'no', 'Therapy', 0)
-- (1, 'Straight', 'My Operation', 0)
-- (2, 'Straight', 'Yes or No?', 0)
-- (3, 'yes', 'caten something', 0)
-- (3, 'no', 'Therapy', 1)
-- (4, 'Straight', 'End', 0)

============================================================

-- Question: After the 'Therapy' step, which node does the process return to?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (85)' AND LabelText LIKE '%Therapy%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (85)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (85)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT StepDescription
FROM PathTraversal
WHERE IsCycle = 1
ORDER BY HopCount
LIMIT 1;;

-- Verifiable Database Answer:
-- ('Therapy',)

============================================================

