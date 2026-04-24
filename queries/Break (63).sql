-- Auto-generated SQL and Answers for Diagram: Break (63)

-- Question: What shape represents 'Does the TV turn on?'?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Break (63)' AND LabelText LIKE '%Does the TV turn on?%';;

-- Verifiable Database Answer:
-- (No matching results found in the diagram topology)

============================================================

-- Question: If the TV does not turn on and the power light is on, what is the next step?
WITH RECURSIVE PathTraversal AS (
    -- Base case: Identify the effective starting node for finding "the next step".
    -- This is the node 'Is the TV power light on?',
    -- but only if it's reached by taking the 'No' path from 'Does the TV turn on?'.
    SELECT
        N_POWER_LIGHT_Q.NodeID AS CurrentNode,
        N_POWER_LIGHT_Q.LabelText AS StepDescription,
        NULL AS ConditionToGetHere, -- This is the 'context' node, not the step itself.
        0 AS HopCount,
        ',' || N_POWER_LIGHT_Q.NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes AS N_TV_ON
    JOIN Edges AS E1 ON N_TV_ON.NodeID = E1.SourceNodeID AND E1.DiagramID = 'Break (63)'
    JOIN Nodes AS N_POWER_LIGHT_Q ON E1.TargetNodeID = N_POWER_LIGHT_Q.NodeID AND N_POWER_LIGHT_Q.DiagramID = 'Break (63)'
    WHERE N_TV_ON.DiagramID = 'Break (63)'
      AND N_TV_ON.LabelText LIKE '%Does the%TV turn%on%'
      AND E1.ConditionLabel LIKE '%No%' -- Condition 1: 'TV does not turn on'
      AND N_POWER_LIGHT_Q.LabelText LIKE '%Is the TV%power light on%' -- This node represents the state after Condition 1
    
    UNION ALL
    
    -- Recursive step: Find the immediate next step (HopCount = 1) from the identified CurrentNode,
    -- specifically following the 'Yes' condition for 'Is the TV power light on?'.
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (63)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (63)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 1 -- Limit to only the immediate next hop (from HopCount 0 to HopCount 1)
      AND Edges.ConditionLabel LIKE '%Yes%' -- Condition 2: 'the power light is on'
)
SELECT StepDescription FROM PathTraversal WHERE HopCount = 1;;

-- Verifiable Database Answer:
-- ('Turn the\\TV\\monitor on',)

============================================================

-- Question: Trace the sequence of events if the TV turns on but there are no error messages.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (63)' AND LabelText LIKE 'Start'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (63)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (63)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
        AND (
            -- If the current node is "Does the TV turn on?", the condition to follow must be 'Yes'.
            (PathTraversal.StepDescription LIKE 'Does the%TV turn%on?' AND Edges.ConditionLabel = 'Yes')
            -- If the current node is "Are there any error messages?", the condition to follow must be 'No'.
            OR (PathTraversal.StepDescription LIKE 'Are there any%error messages?' AND Edges.ConditionLabel = 'No')
            -- For any other node, allow any outgoing edge (no specific condition is imposed).
            OR (
                   PathTraversal.StepDescription NOT LIKE 'Does the%TV turn%on?'
                   AND PathTraversal.StepDescription NOT LIKE 'Are there any%error messages?'
               )
        )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Start', 0)
-- (1, 'Straight', 'Does the\\TV turn\\on?', 0)
-- (2, 'Yes', 'Are there any\\error messages?', 0)
-- (3, 'No', 'TV\\is fine', 0)

============================================================

-- Question: What action is taken if the TV turns on and there are error messages?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (63)' AND LabelText LIKE '%Are there any%error messages%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (63)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (63)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15
      AND Edges.ConditionLabel LIKE '%Yes%' -- Assuming 'Yes' or similar indicates the presence of error messages
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle
FROM PathTraversal
WHERE HopCount = 1 -- We are looking for the immediate action taken if error messages are present
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'Yes', 'Perform a\\search for the\\error\\message', 0)

============================================================

