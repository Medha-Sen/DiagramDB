-- Auto-generated SQL and Answers for Diagram: Normal (3)

-- Question: What is the central node that connects to all other entities?
WITH DiagramNodes AS (
    SELECT NodeID, LabelText FROM Nodes WHERE DiagramID = 'Normal (3)'
),
TotalNodeCount AS (
    SELECT COUNT(NodeID) AS Count FROM DiagramNodes
),
AllNodePairs AS (
    -- Get all direct connections where the node is the source
    SELECT SourceNodeID AS NodeA, TargetNodeID AS NodeB FROM Edges WHERE DiagramID = 'Normal (3)'
    UNION
    -- Get all direct connections where the node is the target (reverse direction)
    SELECT TargetNodeID AS NodeA, SourceNodeID AS NodeB FROM Edges WHERE DiagramID = 'Normal (3)'
),
UniqueNeighborsPerNode AS (
    SELECT
        ap.NodeA,
        COUNT(DISTINCT ap.NodeB) AS ConnectedToCount
    FROM AllNodePairs ap
    JOIN DiagramNodes dn2 ON ap.NodeB = dn2.NodeID -- Ensure NodeB is a valid node in the diagram
    WHERE ap.NodeA != ap.NodeB -- Exclude self-connections when counting connections to 'other entities'
    GROUP BY ap.NodeA
)
SELECT
    DN.LabelText
FROM DiagramNodes DN
JOIN UniqueNeighborsPerNode UNPN ON DN.NodeID = UNPN.NodeA
JOIN TotalNodeCount TNC ON UNPN.ConnectedToCount = (TNC.Count - 1);;

-- Verifiable Database Answer:
-- ('Albert Einstein',)

============================================================

-- Question: Trace the relationship from 'Mileva Maric' to 'Albert Einstein'.
WITH RECURSIVE PathTraversal AS (
    SELECT
        NodeID AS CurrentNode,
        LabelText AS StepDescription,
        'Start' AS ConditionToGetHere,
        0 AS HopCount,
        ',' || NodeID || ',' AS VisitedNodes,
        0 AS IsCycle,
        CAST(NodeID AS TEXT) AS FullPathID -- Stores the sequence of NodeIDs to reconstruct the full path for filtering
    FROM Nodes WHERE DiagramID = 'Normal (3)' AND LabelText LIKE 'Mileva Maric'
    
    UNION ALL
    
    SELECT
        Edges.TargetNodeID,
        NextNode.LabelText,
        IFNULL(Edges.ConditionLabel, 'Straight'),
        PathTraversal.HopCount + 1,
        PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
        CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle,
        PathTraversal.FullPathID || ',' || Edges.TargetNodeID
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'Normal (3)'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'Normal (3)'
    WHERE PathTraversal.IsCycle = 0 AND PathTraversal.HopCount < 15
),
PathsThatReachTarget AS (
    -- Identify all unique FullPathIDs that end with 'Albert Einstein'
    SELECT DISTINCT FullPathID
    FROM PathTraversal
    WHERE StepDescription LIKE 'Albert Einstein'
)
-- Select all steps (rows) from PathTraversal that belong to a FullPathID identified in PathsThatReachTarget.
-- This is achieved by checking if the current step's FullPathID is a prefix of one of the target paths.
SELECT
    PT.HopCount,
    PT.ConditionToGetHere,
    PT.StepDescription,
    PT.IsCycle
FROM PathTraversal AS PT
JOIN PathsThatReachTarget AS PTRT
ON PTRT.FullPathID LIKE PT.FullPathID || '%'
ORDER BY PT.FullPathID, PT.HopCount;;

-- Verifiable Database Answer:
-- (0, 'Start', 'Mileva Maric', 0)
-- (1, 'wife of', 'Albert Einstein', 0)

============================================================

-- Question: If you traverse the 'Son of' edge from 'Harris Albert Einstein', which node do you reach?
SELECT
  T2.LabelText
FROM Edges AS T1
INNER JOIN Nodes AS T2
  ON T1.TargetNodeID = T2.NodeID
WHERE
  T1.DiagramID = 'Normal (3)' AND T2.DiagramID = 'Normal (3)' AND T1.SourceNodeID = (
    SELECT
      NodeID
    FROM Nodes
    WHERE
      DiagramID = 'Normal (3)' AND LabelText LIKE '%Harris Albert Einstein%'
  ) AND T1.ConditionLabel LIKE '%Son of%';

-- Verifiable Database Answer:
-- ('Albert Einstein',)

============================================================

-- Question: What relationship edge connects 'Albert Einstein' to the 'German Empire'?
SELECT Edges.ConditionLabel
FROM Edges
JOIN Nodes AS SourceNode ON Edges.SourceNodeID = SourceNode.NodeID AND Edges.DiagramID = SourceNode.DiagramID
JOIN Nodes AS TargetNode ON Edges.TargetNodeID = TargetNode.NodeID AND Edges.DiagramID = TargetNode.DiagramID
WHERE Edges.DiagramID = 'Normal (3)'
  AND (
        (SourceNode.LabelText LIKE '%Albert Einstein%' AND TargetNode.LabelText LIKE '%German Empire%')
        OR
        (SourceNode.LabelText LIKE '%German Empire%' AND TargetNode.LabelText LIKE '%Albert Einstein%')
      );;

-- Verifiable Database Answer:
-- ('born in',)

============================================================

