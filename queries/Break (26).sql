-- Auto-generated SQL and Answers for Diagram: Break (26)

-- Question: What step immediately follows 'START'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Break (26)' AND T2.DiagramID = 'Break (26)' AND T1.SourceNodeID IN (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Break (26)' AND LabelText LIKE '%START%'
  );;

-- Verifiable Database Answer:
-- ('Greet',)

============================================================

-- Question: What happens if the scans do not match?
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (26)' AND LabelText LIKE '%1ST%AND%2ND%SCAN%MATCH%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (26)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (26)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15
      AND Edges.ConditionLabel LIKE '%No%' -- Assuming 'No' or similar indicates scans do not match
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', '1ST AND 2ND SCAN MATCH?', 0)
-- (1, 'NO', 'Enter ID', 0)

============================================================

-- Question: What is the result if 'Greet' leads to 'FAILURE'?
WITH RECURSIVE PathTraversal AS (
    SELECT 
        NodeID AS CurrentNode, 
        LabelText AS StepDescription, 
        'Start' AS ConditionToGetHere, 
        0 AS HopCount, 
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'Break (26)' AND LabelText LIKE '%Greet%'
    
    UNION ALL
    
    SELECT 
        Edges.TargetNodeID, 
        NextNode.LabelText, 
        IFNULL(Edges.ConditionLabel, 'Straight'), 
        PathTraversal.HopCount + 1, 
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (26)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (26)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
      AND (
          (PathTraversal.HopCount = 0 AND Edges.ConditionLabel LIKE '%FAILURE%') OR
          (PathTraversal.HopCount > 0)
      )
)
SELECT HopCount, ConditionToGetHere, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Greet', 0)
-- (1, 'FAILURE', 'ACCEPT NO COMMANDS', 0)

============================================================

-- Question: Trace the successful login path from 'Enter ID' to 'STOP'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS CurrentLabel,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        LabelText AS FullPathDescription,
        0 AS IsCycle
    FROM Nodes
    WHERE DiagramID = 'Break (26)' AND LabelText LIKE '%Enter ID%'

    UNION ALL

    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        PathTraversal.FullPathDescription || ' -> ' ||
        CASE WHEN Edges.ConditionLabel IS NOT NULL THEN '(' || Edges.ConditionLabel || ') -> ' ELSE '' END ||
        NextNode.LabelText,
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Break (26)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Break (26)'
    WHERE PathTraversal.IsCycle = 0
      AND PathTraversal.HopCount < 15
      -- Stop extending paths once 'STOP' is reached
      AND PathTraversal.CurrentLabel NOT LIKE '%STOP%'
      -- Filter for 'successful login path' by avoiding known failure nodes
      AND NextNode.LabelText NOT LIKE '%SCAN FINGER AGAIN%'
      AND NextNode.LabelText NOT LIKE '%ACCEPT NO COMMANDS%'
)
SELECT
    FullPathDescription
FROM PathTraversal
WHERE CurrentLabel LIKE '%STOP%' AND IsCycle = 0
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (No matching results found in the diagram topology)

============================================================

