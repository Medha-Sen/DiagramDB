-- Auto-generated SQL and Answers for Chart: chart_2

-- Question: Percentage for Monopoly
SELECT NumericValue 
FROM ChartData 
WHERE ChartID = 'chart_2' AND CategoryLabel = 'Monopoly';;

-- Verifiable Database Answer:
-- (21.0)

============================================================

-- Question: Game with highest participants
SELECT CategoryLabel, NumericValue 
FROM ChartData 
WHERE ChartID = 'chart_2' 
ORDER BY NumericValue DESC LIMIT 1;;

-- Verifiable Database Answer:
-- ('Candyland', 23.0)

============================================================

-- Question: Combined percentage for Chess and Uno
SELECT SUM(NumericValue) AS CombinedPercentage 
FROM ChartData 
WHERE ChartID = 'chart_2' AND CategoryLabel IN ('Chess', 'Uno');;

-- Verifiable Database Answer:
-- (19.0)

============================================================