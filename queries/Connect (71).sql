-- Auto-generated SQL and Answers for Diagram: Connect (71)

-- Question: What sequence of events occurs if 'If registered?' evaluates to 'No'?
WITH RECURSIVE PathTraversal AS (
    -- Base Case: Find the starting node 'If registered?'
    SELECT
        N.NodeID AS CurrentNode,
        N.LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || N.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS N
    WHERE N.DiagramID = 'Connect (71)' AND N.LabelText LIKE '%If registered?%'

    UNION ALL

    -- Recursive Step: Traverse edges
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight') AS ConditionToGetHere, -- The condition that led to NextNode
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (71)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (71)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15
      -- Crucial: Apply the 'No' condition only for the first hop from 'If registered?'
      AND (
          (PathTraversal.HopCount = 0 AND Edges.ConditionLabel LIKE 'No%') -- The specific condition for the first step
          OR (PathTraversal.HopCount > 0) -- For all subsequent steps, follow any available path
      )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'If registered?', 0)
-- (1, 'No', 'Registration', 0)
-- (2, 'Straight', 'Login', 0)
-- (3, 'Straight', 'Is valid?', 0)
-- (4, 'No', 'Login', 1)
-- (4, 'Yes', 'Is Admin?', 0)
-- (5, 'Yes', 'Add\\information', 0)
-- (5, 'No', 'Search\\vehicle', 0)
-- (6, 'Straight', 'Update all\\information', 0)
-- (6, 'Straight', 'Car reserved', 0)
-- (7, 'Straight', 'Traveling\\information\\update', 0)
-- (7, 'Straight', 'Get ID', 0)
-- (8, 'Straight', 'Log out', 0)
-- (8, 'Straight', 'Log out', 0)
-- (9, 'Straight', 'Stop', 0)
-- (9, 'Straight', 'Stop', 0)

============================================================

-- Question: If 'Is valid?' is 'No', does the process loop back to a previous step?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (71)' AND LabelText LIKE '%Is valid?%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (71)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (71)'
    WHERE
        PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        AND (
            -- This condition ensures that for the first hop from 'Is valid?', we only follow the 'No' branch.
            (PathTraversal.HopCount = 0 AND PathTraversal.StepDescription LIKE '%Is valid?%' AND Edges.ConditionLabel = 'No')
            -- For all subsequent hops (HopCount > 0), any outgoing edge is followed to trace the path.
            OR PathTraversal.HopCount > 0
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Is valid?', 0)
-- (1, 'No', 'Login', 0)
-- (2, 'Straight', 'Is valid?', 1)

============================================================

-- Question: Trace the entire sequence of events if 'Is Admin?' evaluates to 'Yes'.
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start at the 'Is Admin?' node (HopCount = 0)
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Connect (71)' AND LabelText LIKE '%Is Admin?%'

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
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (71)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (71)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15
      AND (
            -- For the very first hop (from the initial 'Is Admin?' node where HopCount = 0),
            -- only follow edges where the ConditionLabel is 'Yes'.
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel LIKE '%Yes%')
            -- For all subsequent hops (where HopCount > 0), follow any path regardless of ConditionLabel.
            OR (PathTraversal.HopCount > 0)
          )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Is Admin?', 0)
-- (1, 'Yes', 'Add\\information', 0)
-- (2, 'Straight', 'Update all\\information', 0)
-- (3, 'Straight', 'Traveling\\information\\update', 0)
-- (4, 'Straight', 'Log out', 0)
-- (5, 'Straight', 'Stop', 0)

============================================================

-- Question: What is the final converging step for both the Admin and non-Admin paths before 'Stop'?
WITH RECURSIVE AdminBranches AS (
    SELECT
        TargetNodeID,
        ROW_NUMBER() OVER (ORDER BY TargetNodeID) as rn
    FROM Edges
    WHERE DiagramID = 'Connect (71)'
      AND SourceNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Connect (71)' AND LabelText LIKE '%Is Admin?%')
),
PathFromBranch1 AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes
    FROM Nodes
    WHERE DiagramID = 'Connect (71)' AND NodeID = (SELECT TargetNodeID FROM AdminBranches WHERE rn = 1)
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        PathFromBranch1.HopCount + 1,
        PathFromBranch1.VisitedNodes || Edges.TargetNodeID || ','
    FROM PathFromBranch1
    JOIN Edges ON Edges.SourceNodeID = PathFromBranch1.CurrentNode AND Edges.DiagramID = 'Connect (71)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (71)'
    WHERE PathFromBranch1.VisitedNodes NOT LIKE '%,' || Edges.TargetNodeID || ',%' AND PathFromBranch1.HopCount < 15
),
PathFromBranch2 AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes
    FROM Nodes
    WHERE DiagramID = 'Connect (71)' AND NodeID = (SELECT TargetNodeID FROM AdminBranches WHERE rn = 2)
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        PathFromBranch2.HopCount + 1,
        PathFromBranch2.VisitedNodes || Edges.TargetNodeID || ','
    FROM PathFromBranch2
    JOIN Edges ON Edges.SourceNodeID = PathFromBranch2.CurrentNode AND Edges.DiagramID = 'Connect (71)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (71)'
    WHERE PathFromBranch2.VisitedNodes NOT LIKE '%,' || Edges.TargetNodeID || ',%' AND PathFromBranch2.HopCount < 15
)
SELECT DISTINCT T_Nodes.LabelText
FROM PathFromBranch1 AS P1
JOIN PathFromBranch2 AS P2 ON P1.CurrentNode = P2.CurrentNode
JOIN Edges AS E ON E.SourceNodeID = P1.CurrentNode AND E.DiagramID = 'Connect (71)'
JOIN Nodes AS T_Nodes ON T_Nodes.NodeID = P1.CurrentNode AND T_Nodes.DiagramID = 'Connect (71)'
WHERE E.TargetNodeID = (SELECT NodeID FROM Nodes WHERE DiagramID = 'Connect (71)' AND LabelText LIKE '%Stop%');;

-- Verifiable Database Answer:
-- ('Log out',)

============================================================

