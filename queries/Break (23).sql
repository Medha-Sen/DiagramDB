-- Auto-generated SQL and Answers for Diagram: Break (23)

-- Question: What shape represents the 'Start' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (23)' AND LabelText LIKE '%Start%';;

-- Verifiable Database Answer:
-- ('ellipse',)

============================================================

-- Question: If 'Approval Needed?' is 'Yes', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (23)' AND LabelText LIKE '%Approval%Needed%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (23)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (23)'
    WHERE
        PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'Yes') OR
            (PathTraversal.HopCount > 0)
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Approval\\Needed?', 0)
-- (1, 'Yes', 'Go to\\manager', 0)

============================================================

-- Question: What is the final step if 'Approval Needed?' is 'No'?
WITH RECURSIVE PathTraversal AS (
    -- Anchor Member: Start at the 'Approval Needed?' node.
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        N.NodeID AS InitialConditionalNodeID -- Store the NodeID of 'Approval Needed?' to apply the 'No' condition
    FROM Nodes AS N
    WHERE N.DiagramID = 'Break (23)' AND N.LabelText LIKE '%Approval%Needed?%'

    UNION ALL

    -- Recursive Member: Traverse edges to find subsequent steps.
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        PathTraversal.InitialConditionalNodeID
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (23)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (23)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15 -- Limit to prevent excessively long paths
      -- Apply the condition: If the current node is 'Approval Needed?', the edge label must be 'No'.
      -- Otherwise (for any other node), any edge label is allowed for traversal.
      AND (
          (PathTraversal.CurrentNode = PathTraversal.InitialConditionalNodeID AND Edges.ConditionLabel = 'No')
          OR
          (PathTraversal.CurrentNode != PathTraversal.InitialConditionalNodeID)
      )
)
-- Select the StepDescription of the final step, which is 'Finished' in this context.
SELECT StepDescription
FROM PathTraversal
WHERE StepDescription LIKE '%Finished%';;

-- Verifiable Database Answer:
-- ('Finished',)

============================================================

-- Question: Trace the entire process from 'Start'.
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (23)' AND LabelText LIKE '%Start%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (23)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (23)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Start', 0)
-- (1, 'Straight', 'Approval\\Needed?', 0)
-- (2, 'No', 'Finished', 0)
-- (2, 'Yes', 'Go to\\manager', 0)

============================================================

