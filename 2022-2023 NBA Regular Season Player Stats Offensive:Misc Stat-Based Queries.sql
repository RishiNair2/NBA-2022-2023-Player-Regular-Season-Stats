---- 2022-2023 NBA Regular Season Player Stats---
---- Offensive/Misc Stat-Based Queries----

--- Initial Query---
SELECT *
FROM player_stats_2022_2023
LIMIT 10;

--- Top 50 Scorers In The NBA For The 2022-2023 NBA Season---
SELECT player, team, AVG(pts) avg_pts
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Top 50 Players With The Most Made Three Pointers For The 2022-2023 NBA Season---
SELECT player, team, AVG(tpm)
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Top 50 Players With The Highest Percentage of Points Be From 3pt Made Baskets---
SELECT player, ((SUM(tpm)*3)*100/SUM(pts)) thpt_conc_percentage
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC
LIMIT 50;

--- Top 50 Players With The Highest Three Point Percentage For The 2022-2023 NBA Season---
SELECT t1.player, t1.team, AVG(t1.tp_pct) avg_tp_pct
FROM(
SELECT player, team, (tpm::numeric/tpa)*100 tp_pct
FROM player_stats_2022_2023
WHERE player IS NOT NULL) t1
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 50;

--- Running Average Of The 3FG Percentage For Each Player ---
SELECT t1.player, t1.game_date, t1.tp_percent, AVG(tp_percent) OVER (PARTITION BY player ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM(
SELECT player, game_date, (tpm::numeric/tpa)*100 tp_percent
FROM post_all_star_break_2022) t1

--- Top 25 Players With The Most 3pt Attempts for the 2022-2023 NBA Season---
SELECT player, team, AVG(tpa)
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 25;

--- Running Average Of The 3PA For Each Player ---
SELECT player, game_date, tpa, AVG(tpa) OVER (PARTITION BY player ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM player_stats_2022_2023;

--- Top 50 Players With The Highest Field Percentage for the 2022-2023 NBA Season---
SELECT t1.player, t1.team, AVG(t1.fg_pct) avg_fg_pct
FROM(
SELECT player, team, (fgm::numeric/fga)*100 fg_pct
FROM player_stats_2022_2023
WHERE player IS NOT NULL) t1
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 50;

--- Effective Field Goal Percentage: Adjusts A Player's Or Team's FG% For The Fact That A 3 Pointer Is Worth 1.5 Times A Standard FG----
-- (FG + .5 * 3P) / FGA---
SELECT t1.player, AVG(t1.efg) * 100 avg_efg
FROM(
SELECT player, ((fgms + (.5*tpm))/(fga)) efg
FROM player_stats_2022_2023
WHERE player IS NOT NULL) t1
GROUP BY 1
ORDER BY 2 DESC;

--- Top 50 Players With The Highest 2pt Percentage For The 2022-2023 NBA Season---
SELECT t1.player, t1.team, (t1.two_fgm::numeric/t1.two_fga)*100 two_fg_pct
FROM(
SELECT player, team, (SUM(fgm) - SUM(tpm)) two_fgm ,(SUM(fga) - SUM(tpa)) two_fga
FROM player_stats_2022_2023
WHERE player IS NOT NULL	
GROUP BY 1,2) t1
ORDER BY 2 DESC;

--- Player With The Highest Percentage of Points Be From 2pt Made Baskets---
WITH t1 AS (
SELECT player, SUM(fgm) - SUM(tpm) tot_two_pt_makes, SUM(pts) tot_points
FROM player_stats_2022_2023
GROUP BY 1)

SELECT player, ((SUM(tot_two_pt_makes)*2)*100/SUM(tot_points)) twpt_conc_percentage
FROM t1
GROUP BY 1
ORDER BY 2 DESC;

--- Top 50 Players With The Most 2pt Field Goal Attempts For The 2022-2023 NBA Season---
SELECT t1.player, t1.team, AVG(t1.two_fga) avg_two_fga
FROM(
SELECT player, team, (fga - tpa) two_fga
FROM player_stats_2022_2023
WHERE player IS NOT NULL
) t1
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Top 50 Players With The Highest Free Throw Percentage For The 2022-2023 NBA Season---
SELECT t1.player, t1.team, AVG(t1.ft_pct) avg_ft_pct
FROM(
SELECT player, team, (ftm::numeric/fta)*100 ft_pct
FROM player_stats_2022_2023
WHERE player IS NOT NULL) t1
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Running Average Of The Free Throw Percentage For Each Team ---
SELECT t1.player, t1.game_date, t1.ft_pct, AVG(ft_pct) OVER (PARTITION BY player ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM(
SELECT player, game_date, (ftm::numeric/fta)*100 ft_pct
FROM player_stats_2022_2023) t1

--- Top 50 Players With The Most Free Throw Attempts For The 2022-2023 NBA Season---
SELECT player, team, AVG(fta) avg_fta
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Running Average Of The Free Throw Attempts For Each Player ---
SELECT player, game_date, fta, AVG(fta) OVER (PARTITION BY player ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM player_stats_2022_2023

--- Top 50 Players With The Most Assists For The 2022-2023 NBA Season---
SELECT player, team, AVG(ast) avg_ast
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Running Average Of The Assists For Each Team ---
SELECT player, game_date, ast, AVG(ast) OVER (PARTITION BY player ORDER BY game_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
FROM player_stats_2022_2023


--- Top 50 Players With The Highest Assist Ratio For The 2022-2023 NBA Season---
--- Assist Percentage: 100*Assists/(((Minutes Played /(Team Minutes/5)) * Team Field Goals Made) – Field Goals Made)--
SELECT player, team, (SUM(a.ast)/((SUM(a.min)/(SUM(b.min_post_23)/5)) * b.fgm_post_23) - a.fgm) ast_ratio
FROM player_stats_2022_2023 a
JOIN nba_2022_2023_szns b
ON a.game_date = b.game_dates_post_23
WHERE a.player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Offensive Efficiency Rating: Number Of Points A Player Scores Per 100 Possessions.---
--- 100*(Points Scored / Possessions)---
SELECT player, ((100*SUM(pts))/(SUM(fga) + (.44*SUM(fta)) + SUM(tov))) oer
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

---- Points Per Shot Attempt:  Player Efficiency Evaluation---
SELECT player, team, SUM(pts)/SUM(fga) pppa
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;


--- Possessions: Estimates Number Of Possessions A Player Has---
--- 0.96*[(FGA)+(TOV)+0.44*(FTA)-(OReb)]---
SELECT player, (.96*((SUM(fga) + SUM(tov) + (.44*(SUM(fta)))) - SUM(oreb))) possessions
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- Player With The Highest Points Per Possession ---
SELECT player, (SUM(pts)::numeric/(.96*((SUM(fga) + SUM(tov) + (.44*(SUM(fta)))) - SUM(oreb)))) points_per_possessions
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- Game Score: Player Evaluation Metric---
--- (Points)+0.4*(Field Goals Made)+0.7*(Offensive Rebounds)+0.3*(Defensive rebounds)+(Steals)+0.7*(Assists)+0.7*(Blocked Shots)- 0.7*(Field Goal Attempts)-0.4*(Free Throws Missed) – 0.4*(Personal Fouls)-(Turnovers)---
SELECT player, ((pts) + .4*(fgm) + 0.7*(oreb)+0.3*(dreb)+(stl)+0.7*(ast)+0.7*(blk)- 0.7*(fga)-0.4*((fta)-(ftm)) - .4*(pf)-(tov)) game_score
FROM player_stats_2022_2023
WHERE 2 IS NOT NULL
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- Player With The Highest Points Per Minute Rating---
SELECT player, team, (36 * AVG(pts)/(AVG(min))) points_per_minute_rating
FROM player_stats_2022_2023
WHERE player IS NOT NULL
GROUP BY 1,2
HAVING COUNT(game_date) > 41
ORDER BY 3 DESC
LIMIT 50;

--- Effective Field Goal Percentage: Adjusts A Player's Or Team's FG% For The Fact That A 3 Pointer Is Worth 1.5 Times A Standard FG----
-- (FG + .5 * 3P) / FGA---
SELECT t1.player, AVG(t1.efg) * 100 avg_efg
FROM(
SELECT player, ((fgm + (.5*tpm))/(fga)) efg
FROM player_stats_2022_2023) t1
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;

--- True Shooting Percentage: Adjusts Standard FG% To Include Their FT%, Encompasses All Ways To Score---
--- Pts / (2 * (FGA + .475 * FTA)) --- 
SELECT t1.player, AVG(ts_percentage) avg_ts_percentage
FROM(
SELECT player, (pts *100/(2*(fga + .475*fta))) ts_percentage 
FROM player_stats_2022_2023) t1
GROUP BY 1
HAVING COUNT(game_date) > 41
ORDER BY 2 DESC;