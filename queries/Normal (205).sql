-- Auto-generated SQL and Answers for Diagram: Normal (205)

-- Question: What step comes immediately after 'Modulation'?
SELECT T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (205)' AND T2.DiagramID = 'Normal (205)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Normal (205)' AND LabelText LIKE '%Modulation%'
  );;

-- Verifiable Database Answer:
-- ('Channel\\Decoder',)

============================================================

-- Question: Trace the sequence of events from 'Amplifier' down to 'Decoder'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNodeID,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        NodeID AS PathEndNodeID,
        LabelText AS PathEndLabelText
    FROM Nodes
    WHERE DiagramID = 'Normal (205)' AND LabelText LIKE '%Amplifier%'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        Edges.TargetNodeID AS PathEndNodeID,
        NextNode.LabelText AS PathEndLabelText
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNodeID AND Edges.DiagramID = 'Normal (205)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (205)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
)
SELECT T1.HopCount, T1.ConditionToGetHere, T1.StepDescription, T1.IsCycle
FROM PathTraversal AS T1
JOIN (
    SELECT VisitedNodes AS FullPathVisitedNodes FROM PathTraversal
    WHERE PathEndLabelText LIKE '%Decoder%' AND IsCycle = 0
) AS ValidEndingPaths ON ValidEndingPaths.FullPathVisitedNodes LIKE T1.VisitedNodes || '%'
ORDER BY ValidEndingPaths.FullPathVisitedNodes, T1.HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Amplifier', 0)
-- (1, 'Straight', 'Demodulation', 0)
-- (2, 'Straight', 'Channel\\Decoder', 0)
-- (0, 'Start', 'Amplifier', 0)
-- (1, 'Straight', 'Demodulation', 0)
-- (2, 'Straight', 'Channel\\Decoder', 0)
-- (3, 'Straight', 'Decoder', 0)

============================================================

-- Question: What shape is used for the 'Demodulation' node?
SELECT ShapeType FROM Nodes WHERE DiagramID = 'Normal (205)' AND LabelText LIKE '%Demodulation%';;

-- Verifiable Database Answer:
-- ('rectangle',)

============================================================

-- Question: Is there any decision-based branching in this sequence?
SELECT EXISTS (
    SELECT 1
    FROM Nodes AS N
    JOIN Edges AS E ON N.DiagramID = E.DiagramID AND N.NodeID = E.SourceNodeID
    WHERE N.DiagramID = 'Normal (205)'
    GROUP BY N.DiagramID, N.NodeID
    HAVING COUNT(DISTINCT E.ConditionLabel) > 1 AND COUNT(E.EdgeID) > 1
);;

-- Verifiable Database Answer:
-- (0,)

============================================================

