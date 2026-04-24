-- Auto-generated SQL and Answers for Diagram: Normal (15)

-- Question: What shape represents the 'Input' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (15)' AND LabelText LIKE '%Input%';;

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: If '(angka % 2 == 1)' evaluates to 'True', what happens next?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Normal (15)' AND LabelText LIKE 'If (angka % 2 == 1)'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (15)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (15)'
    WHERE
        PathTraversal.IsCycle = 0
        AND PathTraversal.HopCount < 15
        AND (
            (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'True')
            OR
            (PathTraversal.HopCount > 0)
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'If (angka % 2 == 1)', 0)
-- (1, 'True', 'Prime Number', 0)
-- (2, 'Straight', 'Finish', 0)

============================================================

-- Question: Trace the sequence of events if the condition evaluates to 'False'.
WITH RECURSIVE PathTraversal AS (
    -- Anchor member: Start from the node that is the target of an edge
    -- originating from the 'If' decision node with ConditionLabel = 'False'.
    SELECT
        T2.TargetNodeID AS CurrentNode,
        T3.LabelText AS StepDescription,
        T2.ConditionLabel AS ConditionToGetHere, -- This will be 'False' for the initial step
        0 AS HopCount,
        ',' || T2.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS T1
    JOIN Edges AS T2 ON T1.NodeID = T2.SourceNodeID AND T1.DiagramID = T2.DiagramID
    JOIN Nodes AS T3 ON T2.TargetNodeID = T3.NodeID AND T2.DiagramID = T3.DiagramID
    WHERE
        T1.DiagramID = 'Normal (15)'
        AND T1.LabelText LIKE 'If (angka % 2 == 1)' -- Identify the decision node
        AND T2.ConditionLabel = 'False' -- Follow the 'False' branch
    
    UNION ALL
    
    -- Recursive member: Traverse subsequent nodes from the current path
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'), -- Use 'Straight' if no explicit condition
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (15)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (15)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15 -- Prevent infinite loops and limit depth
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'False', 'Non prime', 0)
-- (1, 'Straight', 'Finish', 0)

============================================================

-- Question: What is the final step for both branches of the condition?
WITH RECURSIVE PathTraversal AS (
    -- Anchor Member: Start from the immediate successors of the "If" node
    -- The ConditionLabel of the edge from the "If" node defines the "branch"
    SELECT
        Edges.TargetNodeID AS CurrentNode,
        NextNode.LabelText AS StepDescription,
        Edges.ConditionLabel AS BranchIdentifier, -- This distinguishes the branches
        1 AS HopCount,
        ',' || Edges.SourceNodeID || ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS IfNode
    JOIN Edges ON IfNode.NodeID = Edges.SourceNodeID AND IfNode.DiagramID = Edges.DiagramID
    JOIN Nodes AS NextNode ON Edges.TargetNodeID = NextNode.NodeID AND Edges.DiagramID = NextNode.DiagramID
    WHERE
        IfNode.DiagramID = 'Normal (15)'
        AND IfNode.LabelText LIKE 'If (angka % 2 == 1)' -- Using LIKE for the string matching rule, where '%' is treated as a wildcard.

    UNION ALL

    -- Recursive Member: Traverse subsequent nodes
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        PathTraversal.BranchIdentifier, -- Keep the original branch identifier for the branch
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (15)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (15)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15 -- Safeguard against infinite loops
),
FinalStepsCandidates AS (
    -- Identify potential final steps for each branch:
    -- A node is considered a final step if it has no outgoing edges OR its label is 'Finish'.
    -- We use ROW_NUMBER to pick the one with the highest HopCount (i.e., the furthest step) for each branch.
    SELECT
        T1.BranchIdentifier,
        T1.StepDescription,
        T1.HopCount,
        ROW_NUMBER() OVER (PARTITION BY T1.BranchIdentifier ORDER BY T1.HopCount DESC) as rn
    FROM PathTraversal AS T1
    LEFT JOIN Edges AS T2 ON T1.CurrentNode = T2.SourceNodeID AND T2.DiagramID = 'Normal (15)'
    WHERE
        T2.EdgeID IS NULL -- No outgoing edges from this node in the diagram
        OR T1.StepDescription LIKE 'Finish%' -- Or it's explicitly the 'Finish' node
)
-- Select the final step (highest hop count) for each branch
SELECT
    BranchIdentifier,
    StepDescription
FROM FinalStepsCandidates
WHERE rn = 1
ORDER BY BranchIdentifier;;

-- Verifiable Database Answer:
-- ('False', 'Finish')
-- ('True', 'Finish')

============================================================

