USE consent;

-- 1 -- Show all events in dialog_show with regulation_id '1'.
SELECT * 
FROM dialog_show
WHERE regulation_id = 1;

-- 2 -- Show all events in dialog_show with regulation_id '1', from March 2020.
SELECT *
FROM dialog_show
WHERE regulation_id = '1' AND Month(daystamp) = 3 AND Year(daystamp) = 2020;

-- 3 -- Count the number of events from March 2020 in dialog_show per regulation.
SELECT regulation_id, COUNT(*)
FROM dialog_show
WHERE Month(daystamp) = 3 AND Year(daystamp) = 2020
GROUP BY regulation_id;

-- 4 -- Show all unique events from dialog_event in March 2020 ordered alphabetically.
SELECT DISTINCT event
FROM dialog_event
WHERE Month(daystamp) = 3 AND Year(daystamp) = 2020
ORDER BY event;

-- 5 -- Show top 10 locales from dialog_close with the most close counts in March 2020.
SELECT locale, sum(count)
FROM dialog_close
WHERE MONTH(daystamp) = 3 AND YEAR(daystamp) = 2020
GROUP BY locale
ORDER BY sum(count) DESC
LIMIT 10;

-- 6 -- Show bottom 10 locales from dialog_close where the summed close counts in March 2020 were at least 100 or more.
SELECT locale, sum(count) AS sum
FROM dialog_close
WHERE MONTH(daystamp) = 3 AND YEAR(daystamp) = 2020 
GROUP BY locale
ORDER BY sum(count) >= 100 DESC
LIMIT 10;

-- 7 -- Show all events from dialog_event, but instead of app_id, regulation_id, origin_id,
-- 		flow_id and run_counter_id show the human readable names found in the corresponding
-- 		tables.

SELECT DISTINCT 
		d.event, 
        d.app_id, 
        n.name,
        d.regulation_id,
        r.name,
        d.origin_id,
        o.name,
        d.flow_id,
        f.name, 
        d.run_counter_id,
        rc.name
FROM (
		SELECT app_id, event, regulation_id, origin_id, flow_id, run_counter_id
		FROM dialog_event
    
)d LEFT JOIN (
			SELECT id, name
			FROM app)n ON d.app_id = n.id
   LEFT JOIN (
			SELECT id, name
            FROM regulation
 )r ON d.regulation_id = r.id
	LEFT JOIN (
			 SELECT id, name
             FROM origin
    )o ON d.origin_id = o.id
       LEFT JOIN (
				SELECT id, name
                FROM flow
       )f ON d.flow_id = f.id
          LEFT JOIN (
					SELECT id, name
                    FROM run_counter
          )rc ON d.run_counter_id = rc.id
	;
 
 -- 8 -- (Bonus) Show the summed counts per run_counter ordered from high to low, for all
 -- 	 run_counters but 'old'. Combine 'firstRun', 'secondRun' and 'thirdRun' under one new
 --      group called 'firstToThirdRunCount'. (Hint: Use case statement)
 
 SELECT * FROM dialog_event;
 SELECT * FROM run_counter;
 

 SELECT  
		d.event, 
        d.run_counter_id,
        rc.name,
        SUM(d.count)
FROM (
		SELECT  event, run_counter_id, count
		FROM dialog_event
        WHERE run_counter_id != 1  
)d LEFT JOIN (
				SELECT id, name
				FROM run_counter
                
          )rc ON d.run_counter_id = rc.id
	GROUP BY d.run_counter_id
    ORDER BY SUM(d.count)DESC
    ;
 
 
 SELECT  
		d.event, 
        d.run_counter_id,
        rc.name,
        SUM(d.count), 
        CASE
			WHEN rc.name = "firstRun" OR rc.name = "secondRun" OR rc.name = "thirdRun" THEN "firstToThirdRunCount"
            ELSE rc.name
		END AS sum_count
FROM (
		SELECT  event, run_counter_id, count
		FROM dialog_event
        WHERE run_counter_id != 1  
)d LEFT JOIN (
				SELECT id, name
				FROM run_counter
                
          )rc ON d.run_counter_id = rc.id
	GROUP BY d.run_counter_id
    ORDER BY SUM(d.count)DESC
    
    ;
 
 
 
 
 
 


