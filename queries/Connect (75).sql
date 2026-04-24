-- Auto-generated SQL and Answers for Diagram: Connect (75)

-- Question: What shape represents the 'Input Total Score' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Connect (75)' AND LabelText LIKE '%Input Total%Score%';;

-- Verifiable Database Answer:
-- ('trapezium',)

============================================================

-- Question: If 'If total score > 800' evaluates to 'Yes', what is the next step?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes 
    WHERE DiagramID = 'Connect (75)' AND LabelText LIKE '%If total score%800%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (75)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (75)'
    WHERE PathTraversal.IsCycle = 0 
      AND PathTraversal.HopCount < 15
      AND (
          (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'Yes') -- Apply 'Yes' condition for the first hop
          OR PathTraversal.HopCount > 0 -- No specific condition for subsequent hops, if any
      )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle 
FROM PathTraversal 
WHERE HopCount = 1 -- Only interested in the immediate next step
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'Yes', 'Good Work', 0)

============================================================

-- Question: Trace the sequence of events if the score is not greater than 800.
WITH RECURSIVE PathTraversal AS (
    -- Initial step: Find the target node that is reached when the condition 'score is not greater than 800' is met.
    -- This means finding the 'If total score > 800' node and then following its 'No' branch.
    SELECT 
        Edges.TargetNodeID AS CurrentNode, 
        NextNode.LabelText AS StepDescription, 
        Edges.ConditionLabel AS ConditionToGetHere, -- This will capture the 'No' or similar label
        1 AS HopCount, -- This is the first step *after* the decision point
        ',' || Edges.TargetNodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS DecisionNode
    JOIN Edges ON DecisionNode.NodeID = Edges.SourceNodeID AND Edges.DiagramID = 'Connect (75)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (75)'
    WHERE 
        DecisionNode.DiagramID = 'Connect (75)' 
        AND DecisionNode.LabelText LIKE 'If total score%>%\ 800%' -- Matches 'If total score $>$\\ 800'
        AND Edges.ConditionLabel LIKE '%No%' -- Assumes 'No' or similar implies 'not greater than 800'
    
    UNION ALL
    
    -- Recursive step: continue traversal from the current node to subsequent nodes
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (75)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (75)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'No', 'Bad Work', 0)
-- (2, 'Straight', 'End', 0)

============================================================

-- Question: What is the final step for both the 'Bad Work' and 'Good Work' branches?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        CASE
            WHEN Nodes.LabelText LIKE '%End%' THEN 1
            WHEN NOT EXISTS (SELECT 1 FROM Edges WHERE Edges.SourceNodeID = Nodes.NodeID AND Edges.DiagramID = Nodes.DiagramID) THEN 1
            ELSE 0
        END AS IsFinalStep
    FROM Nodes
    WHERE DiagramID = 'Connect (75)' AND (LabelText LIKE '%Bad Work%' OR LabelText LIKE '%Good Work%')

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        CASE
            WHEN NextNode.LabelText LIKE '%End%' THEN 1
            WHEN NOT EXISTS (SELECT 1 FROM Edges WHERE Edges.SourceNodeID = NextNode.NodeID AND Edges.DiagramID = NextNode.DiagramID) THEN 1
            ELSE 0
        END AS IsFinalStep
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Connect (75)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Connect (75)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT DISTINCT StepDescription FROM PathTraversal WHERE IsFinalStep = 1;;

-- Verifiable Database Answer:
-- ('End',)

============================================================

