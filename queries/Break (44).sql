-- Auto-generated SQL and Answers for Diagram: Break (44)

-- Question: What shape is used for the 'Initialize' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (44)' AND LabelText LIKE '%Initialize%';;

-- Verifiable Database Answer:
-- ('diamond',)

============================================================

-- Question: If 'Initialize' evaluates to 'True', what happens next?
WITH RECURSIVE PathTraversal AS (
    -- Base Case: Start with the node(s) directly connected from 'Initialize' via a 'True' condition edge.
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere,
        1 AS HopCount, -- This is the first step *after* the 'Initialize' node with the 'True' condition
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS InitialNode
    JOIN Edges ON Edges.SourceNodeID = InitialNode.NodeID AND Edges.DiagramID = 'Break (44)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (44)'
    WHERE InitialNode.DiagramID = 'Break (44)'
      AND InitialNode.LabelText LIKE '%Initialize%'
      AND Edges.ConditionLabel LIKE '%True%'

    UNION ALL

    -- Recursive Step: Traverse subsequent nodes
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (44)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (44)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'True', 'Process', 0)
-- (2, 'Straight', 'Increment or\\Decrement', 0)
-- (3, 'Straight', 'Initialize', 0)
-- (4, 'True', 'Process', 1)
-- (4, 'False', 'End Loop', 0)

============================================================

-- Question: Does the process loop back to a previous step after 'Increment or Decrement'?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (44)' AND LabelText LIKE '%Increment or%Decrement%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (44)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (44)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT MAX(IsCycle) FROM PathTraversal;;

-- Verifiable Database Answer:
-- (1,)

============================================================

-- Question: Trace the path if the 'Initialize' condition evaluates to 'False'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        N.NodeID AS CurrentNode, 
        N.LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        N.NodeID AS InitialQueryNodeID -- Store the NodeID of the starting 'Initialize' node
    FROM Nodes AS N WHERE DiagramID = 'Break (44)' AND N.LabelText LIKE '%Initialize%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        PathTraversal.InitialQueryNodeID
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (44)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (44)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (
            -- If this is the first hop from the initial 'Initialize' node, filter by ConditionLabel = 'False'
            (PathTraversal.CurrentNode = PathTraversal.InitialQueryNodeID AND Edges.ConditionLabel LIKE '%False%')
            OR
            -- For subsequent hops, no specific condition is imposed on the edges
            (PathTraversal.CurrentNode != PathTraversal.InitialQueryNodeID)
          )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Initialize', 0)
-- (1, 'False', 'End Loop', 0)

============================================================

