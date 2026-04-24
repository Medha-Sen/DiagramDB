-- Auto-generated SQL and Answers for Chart: 00339007006077

-- Question: Percentage in Haiti
SELECT NumericValue 
FROM ChartData 
WHERE ChartID = '00339007006077' AND CategoryLabel = 'Haiti';;

-- Verifiable Database Answer:
-- (6.12)

============================================================

-- Question: Country with lowest share
SELECT CategoryLabel, NumericValue 
FROM ChartData 
WHERE ChartID = '00339007006077' 
ORDER BY NumericValue ASC LIMIT 1;;

-- Verifiable Database Answer:
-- ('Colombia', 1.45)

============================================================

-- Question: Difference between Libya and Lebanon
SELECT 
    (SELECT NumericValue FROM ChartData WHERE ChartID = '00339007006077' AND CategoryLabel = 'Libya') -
    (SELECT NumericValue FROM ChartData WHERE ChartID = '00339007006077' AND CategoryLabel = 'Lebanon') AS Difference;;

-- Verifiable Database Answer:
-- (0.82)

============================================================