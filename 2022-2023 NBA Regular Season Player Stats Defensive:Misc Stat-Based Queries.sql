---- 2022-2023 NBA Regular Season Player Stats---
---- Defensive/Misc Stat-Based Queries----

--- Initial Query---
SELECT *
FROM player_stats_2022_2023
LIMIT 10;

--- Player(s) Who Played All 82 Games This Season---
SELECT player, COUNT(game_date) games
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) = 82
ORDER BY 2 DESC;


--- Top 50 Rebounders In The NBA For The 2022-2023 NBA Season---
SELECT player, team, AVG(reb) avg_reb
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Top 50 Offensive Rebounders in the NBA For The 2022-2023 NBA Season---
SELECT player, team, AVG(oreb) avg_oreb
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

---- Player With The Highest Offensive Rebound Percentage---
SELECT player, SUM(oreb)*100/SUM(oreb) oreb_pct
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- Running Average Of The Offensive Rebounds That Each Player Picked Up---
SELECT player, game_date,oreb, AVG(oreb) OVER (PARTITION BY player ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM player_stats_2022_2023


--- Top 50 Defensive Rebounders In The NBA For The 2022-2023 NBA Season---
SELECT player, team, AVG(dreb) avg_dreb
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

---- Players With The Highest Defensive Rebound Percentage---
SELECT player, SUM(dreb)*100/SUM(reb) dreb_pct
FROM player_stats_2022_2023
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- Top 25 Players With The Most Steals For The 2022-2023 NBA Season---
SELECT player, team, AVG(stl) avg_stl
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 25;

--- Top 25 Players With The Most Blocks for the 2022-2023 NBA Season---
SELECT player, team, AVG(blk) avg_blk
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 25;

--- Top 25 Players With The Most Turnovers For The 2022-2023 NBA Season---
SELECT player, team, AVG(tov) avg_tov
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 25;

--- Running Average Of The Turnovers That Each Player Picked Up---
SELECT player, game_date, tov, AVG(tov) OVER (PARTITION BY team ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM player_stats_2022_2023;

--- Top 25 Players With The Highest Turnvoer Ratio for the 2022-2023 NBA Season---
SELECT player, (SUM(tov)*100/(.96*((SUM(fga) + SUM(tov) + (.44*(SUM(fta)))) - SUM(oreb)))) tot_possessions
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- Top 25 Players With The Most Fouls For The 2022-2023 NBA Season---
SELECT player, team, AVG(pf) avg_pf
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 25;

--- Running Average Of The Fouls For Each Player ---
SELECT player, game_date, pf, AVG(pf) OVER(PARTITION BY team ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM player_stats_2022_2023;

--- Personal Foul Efficiency: Indicates How Efficiently A Player Forces Turnovers, Removing The Bias Of Jump-Happy Or Slaptastic Players Who Accumulate Deceptive Block Or Steal Totals---
SELECT player, team, (SUM(stl) + SUM(blk))/SUM(pf) personal_foul_efficiency
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 25;

--- Top 25 Players With The Best +/- for the 2022-2023 NBA Season---
SELECT player, team, AVG(plus_minus) avg_plus_minus
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 25;

--- Running Total Of The Plus/Minus For Each Team ---
SELECT player, game_date, plus_minus, SUM(plus_minus) OVER(PARTITION BY player ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM player_stats_2022_2023;

--- Top 25 Players With The Best Ast/Tov Ratio For The 2022-2023 NBA Season---
SELECT player, team, SUM(ast)/SUM(tov) avg_ast_tov_ratio
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 25;

--- Possessions In Total/Per Game: Estimates Number Of Possessions A Player Has---
--- 0.96*[(FGA)+(TOV)+0.44*(FTA)-(OReb)]---
SELECT player, (.96*((SUM(fga) + SUM(tov) + (.44*(SUM(fta)))) - SUM(oreb))) tot_possessions
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- Non-Scoring Possessions In Total/Per Game: Player’s Missed Field Goals, Plus Free Throws That Weren’t Rebounded By His Team, Plus His Turnovers---
--- (Player’s Field Goal Attempts)-Player’s Field Goal Made)+0.4*(Free Throw Attempts)+(Player’s Turnovers)---
SELECT player, ((SUM(fga) - SUM(fgm) + (.44*(SUM(fta)))) + SUM(tov)) non_scoring_player_possessions
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- Players With The Most Games Where They Had More Turnovers Than Assists---
SELECT player, COUNT(game_date) game_count
FROM player_stats_2022_2023
WHERE tov > ast
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- NBA Efficiency: First Ever Player Evaluation Metric Which Indicates Player’s Linear Efficiency---
SELECT player, (SUM(pts) + SUM(reb) + SUM(stl) + SUM(ast) + SUM() - SUM(blk) - SUM(tov) - (SUM(fga) - SUM(fgm))) nba_eff
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

---Individual Floor Percentage: Is A Metric That Indicates The Ratio Of A Player’s Scoring Possessions By His Total Possessions---
WITH t1 AS (
SELECT player, (.96*((SUM(fga) + SUM(tov) + (.44*(SUM(fta)))) - SUM(oreb))) tot_possessions
FROM player_stats_2022_2023
GROUP BY 1
ORDER BY 2 DESC;
) ,

t2 AS (
SELECT player, ((SUM(fga) - SUM(fgm) + (.44*(SUM(fta)))) + SUM(tov)) non_scoring_player_possessions
FROM player_stats_2022_2023
GROUP BY 1
ORDER BY 2 DESC;
)

SELECT t1.player, ((t1.tot_possessions - t2.non_scoring_player_possessions) / t1.tot_possessions)
FROM t1
JOIN t2
ON t1.player = t2.player;

--- Player Impact Estimate: Metric To Gauge A Player’s All-Around Contribution To The Game---
--- (PTS + FGM + FTM – FGA – FTA + Deff.REB + Off.REB/2 + AST + STL + BLK/2 – PF – TO) / (Game.PTS + Game.FGM + Game.FTM – Game.FGA – Game.FTA + Game.Deff.REB + Game.Off.REB/2 + Game.AST + Game.STL + Game.BLK/2 – Game.PF – Game.TO)---
WITH t1 AS ( 
SELECT player, team, (SUM(pts) + SUM(fgm)+ SUM(ftm)-SUM(fga)-SUM(fta)+SUM(dreb)+(SUM(oreb)/2)+ SUM(ast) + SUM(stl) + (SUM(blk)/2) - SUM(pf) - SUM(tov)) pie_player
FROM player_stats_2022_2023
GROUP BY 1,2	
) ,

t2 AS (
SELECT teams_post_23, (points_post_23 + fgm_post_23+ ftm_post_23 - fga_post_23- fta_post_23 + dreb_post_23 + (oreb_post_23/2) + ast_post_23 + stl_post_23 + (blk_post_23/2) - pf_post_23 - tov_post_23) pie_team
FROM nba_2022_2023_szns
)

SELECT t3.player, AVG(t3.pie) avg_pie
FROM (
SELECT t1.player, (t1.pie_player::numeric/t2.pie_team) pie
FROM t1
JOIN t2
ON t1.team = t2.teams_post_23
WHERE (t1.pie_player::numeric/t2.pie_team) IS NOT NULL
ORDER BY pie DESC) t3
GROUP BY 1