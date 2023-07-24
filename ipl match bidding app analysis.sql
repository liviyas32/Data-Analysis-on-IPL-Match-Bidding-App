use ipl;

###### Data Cleaning ######

-- IPL_Bidder_Details

 # remarks was an unnecessary column filled with only null values, thus using 'alter' and 'drop' commands we removed the column from the table
alter table ipl_bidder_details drop remarks;

select * from ipl_bidder_details;

-- IPL_Bidder_Points

# using 'alter' and 'change', we changed the column name from tournmt_id to tournament_id
alter table ipl_bidder_points change Tournmt_id TOURNAMENT_ID int; 

select * from ipl_bidder_points;

-- IPL_BIDDING_DETAILS

## ipl_bidding_details does not need cleaning

select * from ipl_bidding_details;

-- IPL_MATCH

create table new_ipl_match as
select MATCH_ID, TEAM_ID1, TEAM_ID2, TOSS_WINNER, MATCH_WINNER, 
substring_index(substring_index(win_details, ' ',2), ' ',-1) as WINNING_TEAM, 
substring_index(win_details, ' ',-2) as WON_BY
from ipl_match;

# in ipl_match table win_details had data that can be better understood or worked with if it's seperated into 2 different columns,
# thus we created a new table with a different name using subquery by selecting all the other columns and seperated win_details column into two new columns using
# substring_index (winning_team and won_by) from ipl_match table

drop table ipl_match; # dropped the old table

rename table new_ipl_match to ipl_match; # renamed the new table using the old table name

select * from ipl_match;

-- IPL_MATCH_SCHEDULE

set sql_safe_updates = 0;

update ipl_match_schedule 
set Start_time = start_time * 100; 

alter table ipl_match_schedule modify START_TIME time; 

# in this table start_time wasn't in the 'time' datatype; using 'alter' and 'modify', we changed the datatype to time.
# start time had only 4 digit values, where '1600' actually meant '16:00:00', but if we try to change '1600' to time datatype we will get 00:16:00 which will be wrong info, 
# thus we first changed the values to 6 digits by multiplying by 100 and then changed it time datatype

alter table ipl_match_schedule change tournmt_id TOURNAMENT_ID int;
 
# using 'alter' and 'change', we changed the column name from tournmt_id to tournament_id

select * from ipl_match_schedule;

-- IPL_Player

create table new_ipl_player as 
(select Player_Id, Player_Name, 
substr(substring_index(PERFORMANCE_DTLS, ' ', 1),5) as Points,
substring_index(substring_index(PERFORMANCE_DTLS, ' ', 2), '-', -1) as Matches,
substring_index(substring_index(PERFORMANCE_DTLS, ' ', 3), '-', -1)as Wickets,
substring_index(substring_index(PERFORMANCE_DTLS, ' ', 4), '-', -1) as Dots,
substring_index(substring_index(PERFORMANCE_DTLS, ' ', 5), '-', -1)  as `4s`,
substring_index(substring_index(PERFORMANCE_DTLS, ' ', 6), '-', -1) as `6s`,
substring_index(substring_index(PERFORMANCE_DTLS, ' ', 7), '-', -1) as Catches,
substring_index(substring_index(PERFORMANCE_DTLS, ' ', 8), '-', -1) as Stumpings,
Remarks
from ipl_player);

# in this table there was one column which had data that could be seperated into 8 different columns ('Pts-3.5 Mat-1 Wkt-0 Dot-0 4s-0 6s-1 Cat-0 Stmp-0'),
# it could have been easily done using for loop, but as the syntax looked a little complex to understand we chose to go with the long way;
# where we created a new table using 'subquery' in which we used the inbuilt function 'substring_index' within a  'substring_index, to fetch the required variable 
# for a new column.

drop table ipl_player; # dropped the old table

rename table new_ipl_player to ipl_player; # renamed the new table using the old table name

alter table ipl_player 
modify column Points int,
modify column Matches int,
modify column Wickets int,
modify column Dots int,
modify column `4s` int,
modify column `6s` int,
modify column Catches int,
modify column Stumpings int; #changed the datatypes of all newly made columns to int datatypes

select * from ipl_player;

-- IPL_STADIUM

## ipl_stadium does not need cleaning

select * from ipl_stadium;

-- IPL_TEAM

create table new_ipl_team as 
(select TEAM_ID, TEAM_NAME, 
substring(Team_city, 1, instr(team_city, ',')-1) as TEAM_CITY, 
substring(Team_city, instr(team_city, ',')+1) as TEAM_STATE,
REMARKS from ipl_team); 

# in ipl_team table team_city had data which included both the city and the state, thus it can be better understood or worked with if it's seperated into 2
# different columns, thus we created a new table with a different name using subquery by selecting all the other columns and seperated team_city column into two new columns 
# (team_city and team_state) from ipl_team table

drop table ipl_team; # dropped the old table

rename table new_ipl_team to ipl_team;  # renamed the new table using the old table name

alter table ipl_team change remarks TEAM_NAME_SHORT varchar(200); # in this table remarks was an irrelavent column name, thus using 'alter' and 'change', 
# we changed it to team_name_short (short form of the actual team names)

select * from ipl_team;

-- IPL_TEAM_PLAYERS

alter table ipl_team_players change remarks PLAYED_FOR varchar(200); # in this table remarks was an irrelavent column name, thus using 'alter' and 'change', 
# we changed it to played_for

update ipl_team_players
set PLAYED_FOR =  substr(PLAYED_FOR, instr(PLAYED_FOR, '-') +1); # for the same column, just short form of the team name is enough, 
# thus using 'update' we just kept the name of the team

select * from ipl_team_players;

-- IPL_TEAM_STANDINGS

alter table ipl_team_standings change tournmt_id TOURNAMENT_ID int; # using 'alter' and 'change', we changed the column name from tournmt_id to tournament_id

select * from ipl_team_standings;

-- IPL_TOURNAMENT

alter table ipl_tournament change remarks CHAMPIONS varchar(200); # in this table remarks was an irrelavent column name, thus using 'alter' and 'change', 
# we changed it to champions

update ipl_tournament
set CHAMPIONS =  substr(CHAMPIONS, instr(CHAMPIONS, '-') +1); # for the same column, just short form of the team name is enough, 
# thus using 'update' we just kept the name of the team

alter table ipl_tournament change Tournmt_id TOURNAMENT_ID int; # using 'alter' and 'change', we changed the column name from tournmt_id to tournament_id

alter table ipl_tournament change Tournmt_name TOURNAMENT_NAME varchar(100); # using 'alter' and 'change', we changed the column name from tournmt_name to tournament_name

select * from ipl_tournament;

-- IPL_USER

alter table ipl_user drop remarks; # remarks had one remark for user_type as admin, which wasn't necessary and the rest rows were all null, 
# thus using 'alter' and 'drop' commands we removed the column from the table

select * from ipl_user;

#########################################################################################################
## DATA ANALYSIS###

-- Q1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage

create view bid_win_details as 
(select bidder_id, count(bid_status) as win_count from ipl_bidding_details where
bid_status = 'Won'
group by bidder_id);

select bd.bidder_id, no_of_bids, win_count, round((win_count/no_of_bids)*100,2) as perc_win 
from ipl_bidder_points bd 
inner join bid_win_details bp
on bd.bidder_id = bp.bidder_id
order by perc_win desc;

# created temporary table that contains bidder_id, win bis_status count.
# displayed bidder_id, total_bid by each bidder, no_of_bids_won, win percentage.
# ordered them using precentage win in descending order.
-- bidder_id -103 has the highest win percentage of 100% whereas bidder id -119 has the lowest win percentage of 10%.


-- 2. Display the number of matches conducted at each stadium with the stadium name and city.
with count_stadium_match as 
( select stadium_id, count(match_id) as match_count from ipl_match_schedule 
  group by stadium_id
)
select s.stadium_id,stadium_name,city, match_count from ipl_stadium s inner join count_stadium_match cs
on s.stadium_id = cs.stadium_id;

# Created a view to extract stadium_id, match_count.
# Displayed stadium_id, stadium_name, city and no_of_matches
-- The highest number of matches(18) are conducted at Wankhede Stadium whereas the lowest number of matches(7) are conducted at MCA Stadium.


-- 3. In a given stadium, what is the percentage of wins by a team which has won the toss?

select stadium_id,
count(toss_match_winners) as total_matches,
sum(toss_match_winners) as total_toss_match_win, 
round((sum(toss_match_winners)/count(toss_match_winners)),2) * 100 as perc_match_winnings   from
(select ims.stadium_id,im.match_id,(case when toss_winner = match_winner then 1
			else 0 end) as toss_match_winners
from ipl_match im
inner join ipl_match_schedule ims
on ims.match_id = im.match_id)x
group by stadium_id
;

# Displayed stasium_id, total_match, total_toss_match_wins and percentage match wins.
-- In a given stadium, the percentage of wins varies from 70% for stadium id - 6 to 14% for stadium id - 4.

-- 4. Show the total bids along with the bid team and team name.

select team_id, team_name, count(*) as total_bids from ipl_team t inner join ipl_bidding_details bd on 
t.team_id = bd.bid_team
group by team_id,team_name;

# Displayed team_id, team_name and total bids on each team.
-- Highest number of bids(32) are placed on Sunrisers Hyberabad team and 
-- Lowest number of bids(22) are placed on Chennai Super Kings, Mumbai Indians, Kolkata Knight Riders.

-- 5. Show the team id who won the match as per the win details.

-- data cleaning required in match winner where winning team ids have been directly mentioned instead of refering to the coloumn number of winning team.

select * 
from ipl_match
where toss_winner not in (1,2) or match_winner not in (1,2);

-- Identified the rows that required cleaning by retrieving rows that do not contain 1 and 2 in both toss_winner and match_winner columns.

set sql_safe_updates = 0;

update ipl_match
set match_winner = 2
where match_winner = 6 and winning_team = 'RR';

update ipl_match
set match_winner = 1
where match_winner = 5;

update ipl_match
set match_winner = 2
where match_winner = 3;

update ipl_match
set match_winner = 2
where match_winner = 6 and winning_team = 'KXIP';

select *  from ipl_match;

-- Made changes to four rows and now the data is clean to proceed further.

select match_id, (case when match_winner = 1 then team_id1
				when match_winner = 2 then team_id2 end) as winning_team_id, winning_team
                from ipl_match;
                
# using case statement, displayed the match id, winning_team_id and winning team name.


-- 6. Display total matches played, total matches won and total matches lost by the team along with its team name.

select t.team_id,team_name, tournament_id, matches_played, matches_won, matches_lost 
from ipl_team t inner join ipl_team_standings its
on t.team_id = its.team_id;

# using inner join, displayed team_id, team_name, matches_played, matches_won, matches_lost.
-- Out of 14 matches, Highest number of matches(10) are won by Mumbai Indians team 
-- and Highest number of matches(10) are lost by Royal Challengers Banglore.

-- 7. Display the bowlers for the Mumbai Indians team.
-- team, team_players, player

select Player_name, player_role, team_name from ipl_player p 
inner join ipl_team_players tp on p.player_id = tp.player_id 
inner join ipl_team t on tp.team_id = t.team_id
where team_name = 'Mumbai Indians' and player_role = 'Bowler';

# using inner join, joined 3 tables ipl_player, ipl_team_player, ipl_team using common keys - player_id, team_id.
-- displayed player name, player_role and team name.
-- 9 players were bowlers in Mumbai Indians team.


-- 8. How many all-rounders are there in each team, Display the teams with more than 4 all-rounders in descending order

select t.team_id, t.team_name, player_role, count(*) as all_rounders 
from ipl_team_players itp inner join ipl_team t on t.team_id = itp.team_id
where player_role = 'All-Rounder'
group by t.team_id,t.team_name,player_role
having count(*)> 4
order by all_rounders desc;

# Displayed team_id, team_name, player_role, 
-- total_players whose players role are All-Rounders and having total_players count of above 4
-- and it is ordered by total_players count in descending order.

-- 9. Write a query to get the total bidders points for each bidding status of those bidders who bid on CSK when it won the match in M. Chinnaswamy Stadium bidding year-wise.
-- Note the total bidders’ points in descending order and the year is bidding year.
-- Display columns: bidding status, bid date as year, total bidder’s points


with win as (select im.match_id, ims.schedule_id from ipl_match im inner join ipl_match_schedule ims
on im.match_id = ims.match_id where winning_team='CSK' and stadium_id=7)

select ibd.bidder_id, bid_status, year(bid_date) as bidding_year, total_points from ipl_bidding_details ibd 
inner join win on ibd.schedule_id = win.schedule_id
inner join ipl_bidder_points ibp on ibd.bidder_id = ibp.bidder_id
order by total_points desc;

# Created a view using inner join of ipl_match and ipl_match_schedule where winning team is CSK and Stadium is M. Chinnaswamy.
# Displayed bidder_id, bid_status, bidding_year and total point using inner join of view table, ipl_bidding_details and ipl_bidder_points.
-- In 2017 bid year, only 2 bidders bid on CSK matches when it won on chinnaswamy stadium 
-- and bidder_id-104 won bid and scored 17 points.


-- 10.	Extract the Bowlers and All Rounders those are in the 5 highest number of wickets

with ranking_details as (select player_id,player_name, wickets, rank() over(order by wickets desc) as rankings from ipl_player)

(select (select team_name from ipl_team it where it.team_id = itp.team_id) as team_name,
(select player_name from ipl_player ip where ip.player_id = itp.player_id ) as player_name,
player_role from ipl_team_players itp where player_id in ( 
select player_id from ranking_details where rankings <6) and player_role in ('Bowler','All-Rounder'));

# Created a view ranking using dense rank function and ordered the wicket count in descending order.
# Displayed team_name, player_name and player_role using subqueries in select and where clause.
-- Andrew Tyre, Umesh Yadav are one of the top-5 All-Rounders with highest number of wickets
-- and Hardik Pandya, Rashid Khan, Siddarth Kaul are one of the top-5 Bowlers with highest number of wickets.

-- 11. show the percentage of toss wins of each bidder and display the results in descending order based on the percentage


with toss_winners as (select match_id, case when toss_winner = 1 then team_id1
					   when toss_winner = 2 then team_id2 end as toss_winners
from ipl_match)

select bidder_id, round((sum(bid_toss_winner)/count(bid_toss_winner))*100,2) as bid_toss_percentage from
(select ims.schedule_id, bidder_id, bid_team, tw.match_id, toss_winners,
case when bid_team = toss_winners then 1 else 0 end as bid_toss_winner
from ipl_match_schedule ims 
inner join toss_winners tw on ims.match_id = tw.match_id
inner join ipl_bidding_details ibd on ims.schedule_id = ibd.schedule_id) x
group by bidder_id
order by bid_toss_percentage desc;

# Created a view toss_winning_team with match_id and toss_winning_team_id.
# displayed bidder_id, bid_toss_win_percent using inner joins of ipl_match_schedule with view table and ipl_bidding_details
# ordered by bid_toss_win_percent in descending order.
-- Bidder_id 110 has the highest toss win percentage of 88.89%
-- Bidder_id 128 has the lowest toss win percentage of 0%.

-- 12. find the IPL season which has min duration and max duration.
-- Output columns should be like the below:
-- Tournment_ID, Tourment_name, Duration column, Duration

with x as (select tournament_id, tournament_name, datediff(to_date, from_date) as duration, 
rank() over( order by datediff(to_date, from_date)) as rankings from ipl_tournament)

select tournament_id, tournament_name, duration, 
(case when rankings=1 then 'minimum'
	 when rankings=10 then 'maximum' end) as duration_column
from x
where rankings = (select max(rankings) from x) or rankings = (select min(rankings) from x);

# Created a view that retrieves tournament_id, tournament_name, duration and rank_duration based on the duration column.
# Displayed tournament_id, tournament_name, duration and duration_representation.
-- 2009 ipl season has the lowest duration and 2012,2013 ipl seasons have the highest duration.

-- 13.	Write a query to display to calculate the total points month-wise for the 2017 bid year. sort the results based on total points in descending order and month-wise in ascending order.
-- Note: Display the following columns:
-- 1.	Bidder ID, 2. Bidder Name, 3. bid date as Year, 4. bid date as Month, 5. Total points
-- Only use joins for the above query queries

select distinct ibd.bidder_id, ib.bidder_name, year(bid_date) as bid_year, month(bid_date) as bid_month, ibp.total_points
from ipl_bidding_details ibd inner join ipl_bidder_points ibp on ibd.bidder_id = ibp.bidder_id
inner join ipl_bidder_details ib on ibd.bidder_id = ib.bidder_id
where year(bid_date) = '2017' 
order by ibp.total_points desc, bid_month; 

-- 14. Write a query for the above question using sub queries by having the same constraints as the above question.

select distinct bidder_id, (select bidder_name from ipl_bidder_details ib where ib.bidder_id = ibd.bidder_id) as bidder,
year(bid_date) as bid_year, month(bid_date) as bid_month, 
(select total_points from ipl_bidder_points ibp where ibp.bidder_id = ibd.bidder_id ) as tp
 from ipl_bidding_details ibd
where year(bid_date) = '2017' 
order by tp desc, bid_month;
 
-- 15.	Write a query to get the top 3 and bottom 3 bidders based on the total bidding points for the 2018 bidding year.
-- Output columns should be:
-- like:
-- Bidder Id, Ranks (optional), Total points, Highest_3_Bidders --> columns contains name of bidder, Lowest_3_Bidders  --> columns contains name of bidder;

with higher_bidder_rankings as(
  select ibp.bidder_id, sum(total_points) sum_of_points, ib.bidder_name,
 rank() over(order by sum(total_points) desc) as rankings from ipl_bidder_points ibp
 inner join ipl_bidder_details ib on ibp.bidder_id = ib.bidder_id
 group by bidder_id  order by rankings limit 3),

lower_bidder_rankings as(
select ibp.bidder_id, sum(total_points) sum_of_points, ib.bidder_name,
 rank() over(order by sum(total_points) desc) as rankings from ipl_bidder_points ibp
 inner join ipl_bidder_details ib on ibp.bidder_id = ib.bidder_id
 group by bidder_id  order by rankings desc limit 3
 )
 
 select hbr.bidder_id,hbr.sum_of_points, hbr.bidder_name, x.bidder_id,x.sum_of_points, x.bidder_name
 from higher_bidder_rankings hbr
 left outer join
 (select bidder_id,sum_of_points, bidder_name from lower_bidder_rankings) x 
 on hbr.bidder_id = x.bidder_id
 union
 select hbr.bidder_id,hbr.sum_of_points, hbr.rankings, x.bidder_id,x.sum_of_points, x.bidder_name
 from higher_bidder_rankings hbr
 right outer join
 (select bidder_id,sum_of_points,bidder_name from lower_bidder_rankings) x 
 on hbr.bidder_id = x.bidder_id
 ;
 
 # Created two views - high_bidder_rank and low_bidder_rank
 # Displayed bidder_id, total_points, bidder_name for maximum and minimum bid pointers.
 -- Megaduta Dheer and Chatur Mahalanabis are the highest bid point scorers
 -- Krishnan Valimbe, Gagan Panda, Ronald D'Souza are the lowest bid point scorers.
 


