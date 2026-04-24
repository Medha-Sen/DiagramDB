-- Auto-generated SQL and Answers for Diagram: Break (25)

-- Question: What is the shape of the 'Accept Submission?' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (25)' AND LabelText LIKE 'Accept%Submission%';;

-- Verifiable Database Answer:
-- ('diamond',)

============================================================

-- Question: What happens if 'Form Complete?' is 'Yes'?
WITH RECURSIVE PathTraversal AS (
    -- Base Case: Find the starting node 'Form Complete?'
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS N
    WHERE N.DiagramID = 'Break (25)' AND N.LabelText LIKE '%Form%Complete?%'

    UNION ALL

    -- Recursive Step: Traverse edges
    SELECT
        E.TargetNodeID,
        NextNode.LabelText,
        IFNULL(E.ConditionLabel, 'Straight'),
        PT.HopCount + 1,
        PT.VisitedNodes || E.TargetNodeID || ',',
        CASE WHEN PT.VisitedNodes LIKE '%,' || E.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal AS PT
    JOIN Edges AS E ON E.SourceNodeID = PT.CurrentNode AND E.DiagramID = 'Break (25)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = E.TargetNodeID AND NextNode.DiagramID = 'Break (25)'
    WHERE PT.IsCycle = 0
      AND PT.HopCount < 15
      -- Apply the 'Yes' condition only for the first hop (when HopCount from PathTraversal is 0)
      AND (PT.HopCount > 0 OR E.ConditionLabel = 'Yes')
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Form\\Complete?', 0)
-- (1, 'Yes', 'Verify\\details', 0)
-- (2, 'Straight', 'Accept\\Submission?', 0)
-- (3, 'No', 'Return\\Document', 0)
-- (3, 'Yes', 'Write\\Acceptance\\Letter', 0)
-- (4, 'Straight', 'End', 0)
-- (4, 'Straight', 'Confirmation', 0)
-- (5, 'Straight', 'End', 0)

============================================================

-- Question: Trace the process if 'Accept Submission?' is 'Yes'.
WITH RECURSIVE PathTraversal AS (
    -- Base case: Find the node that is the target of the 'Yes' condition from 'Accept Submission?'
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Yes (from Accept Submission?)' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS N
    JOIN Edges AS E ON N.NodeID = E.TargetNodeID AND N.DiagramID = E.DiagramID
    WHERE N.DiagramID = 'Break (25)'
      AND E.SourceNodeID = (
          SELECT NodeID
          FROM Nodes
          WHERE DiagramID = 'Break (25)' AND LabelText LIKE '%Accept%Submission%?%'
      )
      AND E.ConditionLabel = 'Yes'

    UNION ALL

    -- Recursive step: Find subsequent nodes from the current path
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (25)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (25)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Yes (from Accept Submission?)', 'Write\\Acceptance\\Letter', 0)
-- (1, 'Straight', 'Confirmation', 0)
-- (2, 'Straight', 'End', 0)

============================================================

-- Question: What sequence of events occurs if the form is not complete?
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Find the node that is the target of the 'No' branch from 'Form\Complete?'
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS ConditionToGetHere, -- This will be 'No'
        0 AS HopCount,
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Edges
    JOIN Nodes AS SourceNode ON SourceNode.NodeID = Edges.SourceNodeID AND SourceNode.DiagramID = 'Break (25)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (25)'
    WHERE
        Edges.DiagramID = 'Break (25)'
        AND SourceNode.LabelText LIKE '%Form%Complete?%'
        AND Edges.ConditionLabel LIKE '%No%' -- Assuming 'No' or similar condition for "not complete"

    UNION ALL

    -- Recursive member: Traverse subsequent nodes
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (25)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (25)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'No', 'Submit the\\registration\\form', 0)
-- (1, 'Straight', 'Form\\Complete?', 0)
-- (2, 'Yes', 'Verify\\details', 0)
-- (2, 'No', 'Submit the\\registration\\form', 1)
-- (3, 'Straight', 'Accept\\Submission?', 0)
-- (4, 'No', 'Return\\Document', 0)
-- (4, 'Yes', 'Write\\Acceptance\\Letter', 0)
-- (5, 'Straight', 'End', 0)
-- (5, 'Straight', 'Confirmation', 0)
-- (6, 'Straight', 'End', 0)

============================================================

