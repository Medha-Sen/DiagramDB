-- Auto-generated SQL and Answers for Diagram: Break (43)

-- Question: What step comes immediately after 'Get n'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (43)' AND LabelText LIKE '%Get n%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (43)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (44)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 1
)
SELECT ConditionToGetHere, StepDescription FROM PathTraversal WHERE HopCount = 1 ORDER BY ConditionToGetHere;;

-- Verifiable Database Answer:
-- (No matching results found in the diagram topology)

============================================================

-- Question: If 'n%2==0' is 'Yes', what is the next step?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (43)' AND LabelText LIKE 'n%2==0'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (43)' AND Edges.ConditionLabel = 'Yes'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (43)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal WHERE HopCount = 1 ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (1, 'Yes', 'Even', 0)

============================================================

-- Question: Trace the process if 'n%2==0' is 'No'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (43)' AND LabelText LIKE '%n%2==0%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (43)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (43)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (
          (PathTraversal.HopCount = 0 AND Edges.ConditionLabel = 'No') -- For the first hop, follow only 'No' branch
          OR
          (PathTraversal.HopCount > 0) -- For subsequent hops, follow all branches
      )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'n%2==0', 0)
-- (1, 'No', 'Odd', 0)
-- (2, 'Straight', 'Stop', 0)

============================================================

-- Question: What is the final step for both the 'Even' and 'Odd' paths?
WITH RECURSIVE EvenPathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (43)' AND LabelText LIKE '%Even%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        EvenPathTraversal.HopCount + 1,
        EvenPathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN EvenPathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM EvenPathTraversal
    JOIN Edges ON Edges.SourceNodeID = EvenPathTraversal.CurrentNode AND Edges.DiagramID = 'Break (43)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (43)'
    WHERE EvenPathTraversal.IsCycle = 0 AND EvenPathTraversal.HopCount < 15
),
OddPathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (43)' AND LabelText LIKE '%Odd%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        OddPathTraversal.HopCount + 1,
        OddPathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN OddPathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM OddPathTraversal
    JOIN Edges ON Edges.SourceNodeID = OddPathTraversal.CurrentNode AND Edges.DiagramID = 'Break (43)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (43)'
    WHERE OddPathTraversal.IsCycle = 0 AND OddPathTraversal.HopCount < 15
)
SELECT DISTINCT T.StepDescription
FROM EvenPathTraversal AS T
JOIN OddPathTraversal AS O ON T.CurrentNode = O.CurrentNode
WHERE T.CurrentNode NOT IN (
    SELECT SourceNodeID FROM Edges WHERE DiagramID = 'Break (43)'
);;

-- Verifiable Database Answer:
-- ('Stop',)

============================================================

