-- Auto-generated SQL and Answers for Diagram: Normal (140)

-- Question: What shape represents the 'Read Temperature' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (140)' AND LabelText LIKE '%Read Temperature%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

-- Question: If 'Check Temperature' evaluates to 'YES', what is the next action?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (140)' AND T2.DiagramID = 'Normal (140)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Normal (140)' AND LabelText LIKE '%Check%Temperature%'
  ) AND T1.ConditionLabel = 'YES';;

-- Verifiable Database Answer:
-- ("Print\\``Below Freezing''",)

============================================================

-- Question: Trace the sequence of events if the temperature check evaluates to 'NO'.
WITH RECURSIVE PathTraversal AS (
    -- Initial step: Start at the 'Check Temperature' node itself, as this is where the condition is evaluated.
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Check Temperature Node' AS ConditionToGetHere, -- Label indicating this is the decision point
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Normal (140)' AND LabelText LIKE '%Check%Temperature%'
    
    UNION ALL
    
    -- Recursive step: Traverse subsequent nodes based on conditions
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (140)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (140)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
    -- CRITICAL FILTER: For the first hop (from the initial 'Check Temperature' node, HopCount = 0),
    -- only follow the edge where ConditionLabel is 'NO'. For subsequent hops (HopCount > 0),
    -- follow all outgoing edges.
    AND (
        (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'NO')
        OR
        (PathTraversal.HopCount > 0)
    )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Check Temperature Node', 'Check\\Temperature', 0)
-- (1, 'NO', "Print\\``Above Freezing''", 0)
-- (2, 'Straight', 'End', 0)

============================================================

-- Question: What is the final step for both the 'YES' and 'NO' branches?
WITH RECURSIVE PathTraversal AS (
    -- Anchor Member: Start from the 'Check Temperature' node, as it's the likely branching point for 'YES'/'NO'
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        NULL AS ConditionToGetHere, -- The starting node itself doesn't have a preceding condition
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        NULL AS InitialBranchCondition -- This will store 'YES' or 'NO' for the first hop after the check
    FROM Nodes WHERE DiagramID = 'Normal (140)' AND LabelText LIKE 'Check%Temperature%'

    UNION ALL

    -- Recursive Member: Traverse edges to find subsequent steps
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        -- Capture the 'YES' or 'NO' condition if this is the first hop from the 'Check Temperature' node
        -- Otherwise, propagate the previously captured InitialBranchCondition
        CASE
            WHEN PathTraversal.HopCount = 0 AND Edges.ConditionLabel IN ('YES', 'NO') THEN Edges.ConditionLabel
            ELSE PathTraversal.InitialBranchCondition
        END AS InitialBranchCondition
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (140)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (140)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
-- Select the final steps for both 'YES' and 'NO' branches
-- A final step is a node that has no outgoing edges (i.e., not a SourceNodeID in any edge).
SELECT DISTINCT
    PathTraversal.InitialBranchCondition,
    PathTraversal.StepDescription
FROM PathTraversal
WHERE
    PathTraversal.InitialBranchCondition IS NOT NULL -- Ensure we only consider paths originating from a 'YES' or 'NO' branch
    AND PathTraversal.CurrentNode NOT IN (SELECT SourceNodeID FROM Edges WHERE DiagramID = 'Normal (140)'); -- Filter for terminal nodes (nodes with no outgoing edges);

-- Verifiable Database Answer:
-- ('YES', 'End')
-- ('NO', 'End')

============================================================

