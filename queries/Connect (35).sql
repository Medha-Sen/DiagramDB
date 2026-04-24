-- Auto-generated SQL and Answers for Diagram: Connect (35)

-- Question: What shape is used for the 'Coffee selected' decision?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Connect (35)' AND LabelText LIKE '%Coffee selected%';;

-- Verifiable Database Answer:
-- ('diamond',)

============================================================

-- Question: If 'Mocha' is selected, what is the exact sequence of events before 'Power pressed'?
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start at 'Coffee selected' (representing 'Mocha selected')
    SELECT
        NodeID AS CurrentNode,
        LabelText AS CurrentNodeLabel,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle, -- IsCycle for this specific node in the path (0 for the starting node)
        -- Store the path as a JSON array of objects, including IsCycle status for each step
        json_array(json_object('HopCount', 0, 'Condition', 'Start', 'Description', LabelText, 'IsCycle', 0)) AS PathHistoryJSON
    FROM Nodes
    WHERE DiagramID = 'Connect (35)' AND LabelText LIKE '%Coffee selected%'
    
    UNION ALL
    
    -- Recursive member: Traverse forward
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        -- Append new step to the JSON array with its details and IsCycle status
        json_insert(PathTraversal.PathHistoryJSON, '$[' || (PathTraversal.HopCount + 1) || ']',
                    json_object('HopCount', PathTraversal.HopCount + 1,
                                'Condition', IFNULL(Edges.ConditionLabel, 'Straight'),
                                'Description', NextNode.LabelText,
                                'IsCycle', CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END)) AS PathHistoryJSON
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (35)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (35)'
    WHERE PathTraversal.IsCycle = 0 -- Stop if this particular path has formed a cycle
      AND PathTraversal.HopCount < 15 -- Limit recursion depth to prevent infinite loops
      -- Stop exploring this specific path *branch* once 'Power pressed' is reached
      AND PathTraversal.CurrentNodeLabel NOT LIKE '%Power pressed%'
)
-- Select and format the sequence of events from the valid paths
SELECT
    json_extract(path_step.value, '$.HopCount') AS HopCount,
    json_extract(path_step.value, '$.Condition') AS ConditionToGetHere,
    json_extract(path_step.value, '$.Description') AS StepDescription,
    json_extract(path_step.value, '$.IsCycle') AS IsCycle
FROM PathTraversal AS T_final_path
CROSS JOIN json_each(T_final_path.PathHistoryJSON) AS path_step
WHERE
    -- Filter for paths that successfully ended at 'Power pressed'
    T_final_path.CurrentNodeLabel LIKE '%Power pressed%'
ORDER BY
    json_extract(path_step.value, '$.HopCount');;

-- Verifiable Database Answer:
-- (0, 'Start', 'Coffee selected', 0)
-- (0, 'Start', 'Coffee selected', 0)
-- (0, 'Start', 'Coffee selected', 0)
-- (1, 'Espresso', 'Add sugar', 0)
-- (1, 'Latte', 'Add frothed milk', 0)
-- (1, 'Mocha', 'Add Chocolate\\powder', 0)
-- (2, 'Straight', 'Power pressed', 0)
-- (2, 'Straight', 'Add sugar', 0)
-- (2, 'Straight', 'Add frothed milk', 0)
-- (3, 'Straight', 'Power pressed', 0)
-- (3, 'Straight', 'Add sugar', 0)
-- (4, 'Straight', 'Power pressed', 0)

============================================================

-- Question: Trace the path and intermediate steps if 'Espresso' is selected.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (35)' AND LabelText LIKE '%Coffee selected%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (35)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (35)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Coffee selected', 0)
-- (1, 'Espresso', 'Add sugar', 0)
-- (1, 'Mocha', 'Add Chocolate\\powder', 0)
-- (1, 'Latte', 'Add frothed milk', 0)
-- (2, 'Straight', 'Power pressed', 0)
-- (2, 'Straight', 'Add frothed milk', 0)
-- (2, 'Straight', 'Add sugar', 0)
-- (3, 'Straight', 'Power off', 0)
-- (3, 'Straight', 'Add sugar', 0)
-- (3, 'Straight', 'Power pressed', 0)
-- (4, 'Straight', 'End', 0)
-- (4, 'Straight', 'Power pressed', 0)
-- (4, 'Straight', 'Power off', 0)
-- (5, 'Straight', 'Power off', 0)
-- (5, 'Straight', 'End', 0)
-- (6, 'Straight', 'End', 0)

============================================================

-- Question: What step immediately follows the 'Power pressed' node?
SELECT
  T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Connect (35)' AND T2.DiagramID = 'Connect (35)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Connect (35)' AND LabelText LIKE 'Power pressed'
  );;

-- Verifiable Database Answer:
-- ('Power off',)

============================================================

