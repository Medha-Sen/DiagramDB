-- Auto-generated SQL and Answers for Diagram: image_09bd47

-- Question: INTERNET ARCHIVE to Visualization
WITH RECURSIVE PathTraversal AS (
    SELECT NodeID AS CurrentNode, LabelText AS StepDescription, 0 AS HopCount, ',' || NodeID || ',' AS VisitedNodes
    FROM Nodes WHERE DiagramID = 'image_09bd47' AND LabelText = 'INTERNET ARCHIVE'

    UNION ALL

    SELECT Edges.TargetNodeID, NextNode.LabelText, PathTraversal.HopCount + 1, PathTraversal.VisitedNodes || Edges.TargetNodeID || ','
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'image_09bd47'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'image_09bd47'
    WHERE PathTraversal.VisitedNodes NOT LIKE '%,' || Edges.TargetNodeID || ',%'
)
SELECT HopCount, StepDescription FROM PathTraversal ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'INTERNET ARCHIVE')
-- (1, 'Web Content')
-- (2, 'Face Detection')
-- (3, 'Feature\\Extraction')
-- (4, 'Face\\Verification')
-- (5, 'Visualization')

============================================================

-- Question: Data to Filtering Prerequisites
WITH RECURSIVE PathTraversal AS (
    SELECT NodeID AS CurrentNode, LabelText AS StepDescription, 0 AS HopCount, ',' || NodeID || ',' AS VisitedNodes
    FROM Nodes WHERE DiagramID = 'image_09bd47' AND LabelText = 'Data'

    UNION ALL

    SELECT Edges.TargetNodeID, NextNode.LabelText, PathTraversal.HopCount + 1, PathTraversal.VisitedNodes || Edges.TargetNodeID || ','
    FROM PathTraversal
    JOIN Edges ON Edges.SourceNodeID = PathTraversal.CurrentNode AND Edges.DiagramID = 'image_09bd47'
    JOIN Nodes AS NextNode ON NextNode.NodeID = Edges.TargetNodeID AND NextNode.DiagramID = 'image_09bd47'
    WHERE PathTraversal.VisitedNodes NOT LIKE '%,' || Edges.TargetNodeID || ',%'
)
SELECT HopCount, StepDescription FROM PathTraversal 
WHERE HopCount <= (SELECT MAX(HopCount) FROM PathTraversal WHERE StepDescription = 'Filtering')
ORDER BY HopCount;;

-- Verifiable Database Answer:
-- (0, 'Data')
-- (1, 'CNN Training')
-- (2, 'Feature extraction')
-- (2, 'Feature\\Extraction')
-- (3, 'Filtering')
-- (3, 'Face\\Verification')


============================================================

-- Question: Diverging paths from CNN Training
SELECT TargetNode.LabelText
FROM Edges
JOIN Nodes AS TargetNode ON Edges.TargetNodeID = TargetNode.NodeID AND Edges.DiagramID = TargetNode.DiagramID
JOIN Nodes AS SourceNode ON Edges.SourceNodeID = SourceNode.NodeID AND Edges.DiagramID = SourceNode.DiagramID
WHERE SourceNode.DiagramID = 'image_09bd47' AND SourceNode.LabelText = 'CNN Training';;

-- Verifiable Database Answer:
-- ('Feature extraction',)
-- ('Feature\\Extraction',)

============================================================