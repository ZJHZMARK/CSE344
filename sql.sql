-- PART C:

# 1) 
SELECT f1.origin_city, f1.dest_city, f1.actual_time
FROM flights f1,
     (SELECT origin_city, MAX(actual_time) as max_time 
      FROM flights
      GROUP BY origin_city) f2
WHERE f1.origin_city = f2.origin_city
AND   f1.actual_time = f2.max_time
GROUP BY f1.origin_city, f1.dest_city, f1.actual_time
ORDER BY f1.origin_city, f1.dest_city;
-- 333 rows
-- CPU time = 1265 ms,  elapsed time = 1355 ms.

-- Aberdeen SD	Minneapolis MN	106
-- Abilene TX	Dallas/Fort Worth TX	111
-- Adak Island AK	Anchorage AK	165
-- Aguadilla PR	Newark NJ	272
-- Akron OH	Denver CO	224
-- Albany GA	Atlanta GA	111
-- Albany NY	Las Vegas NV	360
-- Albuquerque NM	Baltimore MD	297
-- Alexandria LA	Atlanta GA	179
-- Allentown/Bethlehem/Easton PA	Atlanta GA	199
-- Alpena MI	Detroit MI	80
-- Amarillo TX	Houston TX	176
-- Anchorage AK	Houston TX	448
-- Appleton WI	Atlanta GA	180
-- Arcata/Eureka CA	San Francisco CA	136
-- Asheville NC	Newark NJ	189
-- Ashland WV	Cincinnati OH	84
-- Aspen CO	Chicago IL	183
-- Atlanta GA	Honolulu HI	649
-- Atlantic City NJ	Fort Lauderdale FL	212



# 2)
SELECT f.origin_city
FROM flights f
GROUP BY f.origin_city
HAVING MAX(f.actual_time) < 180
ORDER BY f.origin_city;
-- 147 rows
-- CPU time = 844 ms,  elapsed time = 828 ms.

-- Aberdeen SD
-- Abilene TX
-- Adak Island AK
-- Albany GA
-- Alexandria LA
-- Alpena MI
-- Amarillo TX
-- Arcata/Eureka CA
-- Ashland WV
-- Augusta GA
-- Barrow AK
-- Beaumont/Port Arthur TX
-- Bemidji MN
-- Bethel AK
-- Binghamton NY
-- Bloomington/Normal IL
-- Brainerd MN
-- Bristol/Johnson City/Kingsport TN
-- Brownsville TX
-- Brunswick GA




# 3)
SELECT f1.origin_city, num2, num, 100.0 * num2 / num
FROM 
	(SELECT f.origin_city, count(*) num
	FROM flights f 
	GROUP BY f.origin_city) f1 
LEFT OUTER JOIN 
	(SELECT f2.origin_city, count(*) num2
	FROM flights f2
	WHERE f2.actual_time <= 180 
	AND f2.actual_time >=0
	GROUP BY f2.origin_city) f3
ON f1.origin_city = f3.origin_city
ORDER BY 100.0 * num2 / num;
-- 327 rows
-- CPU time = 1375 ms,  elapsed time = 1372 ms.

-- Guam TT	<null>
-- Pago Pago TT	<null>
-- Aguadilla PR	28.679245283018
-- Anchorage AK	31.812110418521
-- San Juan PR	34.012635011208
-- Charlotte Amalie VI	39.124087591240
-- Ponce PR	41.129032258064
-- Fairbanks AK	49.539170506912
-- Kahului HI	53.311745657933
-- Honolulu HI	54.494890699780
-- San Francisco CA	55.169895448954
-- Los Angeles CA	55.605018211250
-- Seattle WA	57.487988396337
-- New York NY	60.904626518480
-- Long Beach CA	61.929732564237
-- Kona HI	62.952799121844
-- Newark NJ	63.620025673940
-- Plattsburgh NY	64.000000000000
-- Las Vegas NV	64.670835954557
-- Christiansted VI	66.000000000000



# 4)
SELECT DISTINCT f.dest_city 
FROM flights f, 
				(SELECT DISTINCT dest_city, origin_city 
				FROM flights 
				WHERE origin_city = 'Seattle WA') AS f2
WHERE f.dest_city != 'Seattle WA' 
AND f.dest_city not IN (SELECT DISTINCT f1.dest_city 
						FROM flights f1 
						WHERE f1.origin_city = 'Seattle WA') 
AND f.origin_city = f2.dest_city;
-- 256 rows
-- CPU time = 1703 ms,  elapsed time = 1767 ms.

-- Aberdeen SD
-- Abilene TX
-- Adak Island AK
-- Aguadilla PR
-- Akron OH
-- Albany GA
-- Albany NY
-- Alexandria LA
-- Allentown/Bethlehem/Easton PA
-- Alpena MI
-- Amarillo TX
-- Appleton WI
-- Arcata/Eureka CA
-- Asheville NC
-- Ashland WV
-- Aspen CO
-- Atlantic City NJ
-- Augusta GA
-- Bakersfield CA
-- Bangor ME



# 5)
SELECT DISTINCT f.dest_city
FROM flights f
WHERE f.dest_city not IN 
						(SELECT DISTINCT f1.dest_city 
						FROM flights f1 
						WHERE f1.origin_city = 'Seattle WA') 
AND f.dest_city not IN 
					  (SELECT DISTINCT f.dest_city 
					  FROM flights f, 
					  				 (SELECT DISTINCT dest_city, origin_city 
					  				 FROM flights 
					  				 WHERE origin_city = 'Seattle WA') as f2
					  WHERE f.dest_city != 'Seattle WA' 
					  AND f.dest_city not IN 
											(SELECT DISTINCT f1.dest_city 
											FROM flights f1 
											WHERE f1.origin_city = 'Seattle WA') 
					  AND f.origin_city = f2.dest_city);
-- 4 rows
-- CPU time = 24000 ms,  elapsed time = 24595 ms.

-- Devils Lake ND
-- Hattiesburg/Laurel MS
-- Seattle WA
-- St. Augustine FL





-- PART D
-- 1.a)
CREATE INDEX origin_city
ON flights(origin_city);
-- I picked origin_city to be the index because it is part of the WHERE clause in all three queries and hence indexing on it
-- is likely to speed up all three queries.

-- 1.b)
-- For query i:
-- The index was not used. Because in this case a sequential search costs less than randomly accessing indexes, the server then
-- decides to search without using the index.
-- For query ii:
-- The index was used. Because both CPU cost and I/O cost went down by a lot and there is a step "Index Seek"
-- For query iii:
-- The index was not used.Because in this case a sequential search costs less than randomly accessing indexes, the server then
-- decides to search without using the index.

-- 2)
CREATE INDEX dest_city
ON flights(dest_city);
--  I picked dest_city to be the index because in this query both f1 and f2 use dest_city in the WHERE clause and it is more 
--  likely to speed up the query

-- 3)
-- Azure used the index and as a result, both CPU cost and I/O cost went down by a lot and there are two steps of "Index Seek"

-- 4)
								Query i 							Query ii 						Query iii

without indexes   		CPU= 219 ms, elapsed= 220 ms.   	CPU= 172 ms, elapsed= 213 ms.   CPU= 125 ms,  elapsed= 146 ms.
with indexes 			CPU= 234 ms, elapsed= 218 ms.		CPU= 0 ms, elapsed= 1 ms.   	CPU= 156 ms,  elapsed= 153 ms.


-- PART E)
-- I think it is a great tool, allowing users to remotely store, access and manage their databases and I can see why companies
-- would be willing to pay for such services. However, I think it still has room for some improvements, such as response speed,
-- UI design and ease of use. For one, I think increasing number / power of their data centers and futher divide the areas would
-- improve the experience of using their services, because the server is sometimes unresponsive(e.g. when a new index is added, it
-- takes a little while before queries are actually ran using the index.)




