-- Auto-generated SQL and Answers for Diagram: image_09aa01

-- Question: Image to 3D Cost volume Path
WITH RECURSIVE PathTraversal AS (
    SELECT NodeID AS CurrentNode, LabelText AS StepDescription, 0 AS HopCount, ',' || NodeID || ',' AS VisitedNodes
    FROM Nodes WHERE DiagramID = 'image_09aa01' AND LabelText = 'Image'

    UNION ALL

    SELECT Edges.TargetNodeID, NextNode.LabelText, PathTraversal.HopCount + 1, PathTraversal.VisitedNodes || Edges.TargetNodeID || ','
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'image_09aa01'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'image_09aa01'
    WHERE PathTraversal.VisitedNodes NOT LIKE '%,' || Edges.TargetNodeID || ',%'
)
SELECT HopCount, StepDescription FROM PathTraversal 
WHERE HopCount <= (SELECT MAX(HopCount) FROM PathTraversal WHERE StepDescription = '3D Cost volume')
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Image')
-- (1, 'Offline\\LiDAR map')
-- (1, 'Image Encoder')
-- (2, 'Projected depth')
-- (2, 'Correlation')
-- (3, 'LiDAR Encoder')
-- (3, '3D Cost volume')
-- (4, 'Correlation')
-- (4, '+')
-- (5, '3D Cost volume')
-- (5, 'POET')

============================================================

-- Question: Convergence before Correlation
SELECT SourceNode.LabelText
FROM Edges
JOIN Nodes AS TargetNode ON Edges.TargetNodeID = TargetNode.NodeID AND Edges.DiagramID = TargetNode.DiagramID
JOIN Nodes AS SourceNode ON Edges.SourceNodeID = SourceNode.NodeID AND Edges.DiagramID = SourceNode.DiagramID
WHERE TargetNode.DiagramID = 'image_09aa01' AND TargetNode.LabelText = 'Correlation';;

-- Verifiable Database Answer:
-- ('Image Encoder',)
-- ('LiDAR Encoder',)

============================================================

-- Question: Downstream of '+' & Loops
WITH RECURSIVE PathTraversal AS (
    SELECT NodeID AS CurrentNode, LabelText AS StepDescription, 0 AS HopCount, ',' || NodeID || ',' AS VisitedNodes, 0 AS IsCycle
    FROM Nodes WHERE DiagramID = 'image_09aa01' AND LabelText = '+'

    UNION ALL

    SELECT Edges.TargetNodeID, NextNode.LabelText, PathTraversal.HopCount + 1, PathTraversal.VisitedNodes || Edges.TargetNodeID || ',',
    CASE WHEN PathTraversal.VisitedNodes LIKE '%,' || Edges.TargetNodeID || ',%' THEN 1 ELSE 0 END AS IsCycle
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'image_09aa01'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'image_09aa01'
    WHERE PathTraversal.IsCycle = 0
)
SELECT HopCount, StepDescription, IsCycle FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, '+', 0)
-- (1, 'POET', 0)
-- (2, 'POET', 1)
-- (2, 'Relative pose', 0)
-- (3, 'x', 0)
-- (4, 'Optimized\\vehicle pose', 0)

============================================================