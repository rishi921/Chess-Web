set search_path to chess_sch, public;
show search_path;

--Table 1: Players
--This table stores essential information about each chess player.

CREATE TABLE Players (
    player_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    current_world_ranking INTEGER UNIQUE NOT NULL,
    total_matches_played INTEGER DEFAULT 0 NOT NULL
);

--Table 2: Matches
--This table records the basic details of each match played during the tournament.

CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY ,
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,
    match_date DATE NOT NULL,
    match_level VARCHAR(20) NOT NULL,
    winner_id INT,
    FOREIGN KEY (player1_id) REFERENCES Players(player_id),
    FOREIGN KEY (player2_id) REFERENCES Players(player_id),
    FOREIGN KEY (winner_id) REFERENCES Players(player_id)
);

select * from Matches;


--Table 3: Sponsors
--This table tracks the sponsors supporting the players.

CREATE TABLE Sponsors (
    sponsor_id SERIAL PRIMARY KEY ,
    sponsor_name VARCHAR(100) UNIQUE NOT NULL,
    industry VARCHAR(50) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(20) NOT NULL
);  


--Table 4: Player_Sponsors
--This table connects players with their sponsors.

CREATE TABLE Player_Sponsors (
    player_id INTEGER NOT NULL,
    sponsor_id INTEGER NOT NULL,
    sponsorship_amount NUMERIC(10, 2) NOT NULL,
    contract_start_date DATE NOT NULL,
    contract_end_date DATE NOT NULL,
    PRIMARY KEY (player_id, sponsor_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id),
    FOREIGN KEY (sponsor_id) REFERENCES Sponsors(sponsor_id)
);


-- Insert data into the Players table

INSERT INTO Players (first_name, last_name, country, current_world_ranking, total_matches_played)
VALUES 
('Magnus', 'Carlsen', 'Norway', 1, 100),
('Fabiano', 'Caruana', 'USA', 2, 95),
('Ding', 'Liren', 'China', 3, 90),
('Ian', 'Nepomniachtchi', 'Russia', 4, 85),
('Wesley', 'So', 'USA', 5, 80),
('Anish', 'Giri', 'Netherlands', 6, 78),
('Hikaru', 'Nakamura', 'USA', 7, 75),
('Viswanathan', 'Anand', 'India', 8, 120),
('Teimour', 'Radjabov', 'Azerbaijan', 9, 70),
('Levon', 'Aronian', 'Armenia', 10, 72);


-- Insert data into the Sponsors table

INSERT INTO Sponsors (sponsor_name, industry, contact_email, contact_phone)
VALUES 
('TechChess', 'Technology', 'contact@techchess.com', '123-456-7890'),
('MoveMaster', 'Gaming', 'info@movemaster.com', '234-567-8901'),
('ChessKing', 'Sports', 'support@chessking.com', '345-678-9012'),
('SmartMoves', 'AI', 'hello@smartmoves.ai', '456-789-0123'),
('GrandmasterFinance', 'Finance', 'contact@grandmasterfinance.com', '567-890-1234');


-- Insert data into the Matches table

INSERT INTO Matches (player1_id, player2_id, match_date, match_level, winner_id)
VALUES 
(1, 2, '2024-08-01', 'International', 1),
(3, 4, '2024-08-02', 'International', 3),
(5, 6, '2024-08-03', 'National', 5),
(7, 8, '2024-08-04', 'International', 8),
(9, 10, '2024-08-05', 'National', 10),
(1, 3, '2024-08-06', 'International', 1),
(2, 4, '2024-08-07', 'National', 2),
(5, 7, '2024-08-08', 'International', 7),
(6, 8, '2024-08-09', 'National', 8),
(9, 1, '2024-08-10', 'International', 1);


-- Insert data into the Player_Sponsors table

INSERT INTO Player_Sponsors (player_id, sponsor_id, sponsorship_amount, contract_start_date, contract_end_date)
VALUES 
(1, 1, 500000.00, '2023-01-01', '2025-12-31'),
(2, 2, 300000.00, '2023-06-01', '2024-06-01'),
(3, 3, 400000.00, '2024-01-01', '2025-01-01'),
(4, 4, 350000.00, '2023-03-01', '2024-03-01'),
(5, 5, 450000.00, '2023-05-01', '2024-05-01'),
(6, 1, 250000.00, '2024-02-01', '2025-02-01'),
(7, 2, 200000.00, '2023-08-01', '2024-08-01'),
(8, 3, 600000.00, '2023-07-01', '2025-07-01'),
(9, 4, 150000.00, '2023-09-01', '2024-09-01'),
(10, 5, 300000.00, '2024-04-01', '2025-04-01');


select * from Players; 

select * from Matches; 

select * from Sponsors; 

select * from Player_Sponsors ;


/*
Phase 2: SQL Queries
 
1.  List the match details including the player names (both player1 and player2), match date, and match level for all International matches. */

SELECT 
    concat(p1.first_name,' ',p1.last_name) AS Player_1,
    concat(p2.first_name,' ',p2.last_name) AS Player_2,
    m.match_date,
    m.match_level
FROM Matches m
JOIN Players p1 ON m.player1_id = p1.player_id
JOIN Players p2 ON m.player2_id = p2.player_id
WHERE m.match_level = 'International'; 

-- 2. Extend the contract end date of all sponsors associated with players from the USA by one year.

UPDATE Player_Sponsors ps
SET contract_end_date = contract_end_date + INTERVAL '1 year'
WHERE ps.player_id IN (
    SELECT player_id
    FROM Players
    WHERE country = 'USA'
);


-- 3. List all matches played in August 2024, sorted by the match date in ascending order.

SELECT 
    concat(p1.first_name,' ',p1.last_name) AS player1,
    concat(p2.first_name,' ',p2.last_name) AS player2,
    m.match_date,
    m.match_level
FROM Matches m
JOIN Players p1 ON m.player1_id = p1.player_id
JOIN Players p2 ON m.player2_id = p2.player_id
WHERE m.match_date BETWEEN '2024-08-01' AND '2024-08-31'
ORDER BY m.match_date;

-- 4. Calculate the average sponsorship amount provided by sponsors and display it along with the total number of sponsors. Dispaly with the title Average_Sponsorship  and Total_Sponsors.

SELECT 
    AVG(ps.sponsorship_amount) AS Average_Sponsorship,
    COUNT(DISTINCT ps.sponsor_id) AS Total_Sponsors
FROM Player_Sponsors ps;


-- 5. Show the sponsor names and the total sponsorship amounts they have provided across all players. Sort the result by the total amount in descending order.

SELECT 
	s.sponsor_name,
    SUM(ps.sponsorship_amount) AS Total_Sponsorship
FROM Sponsors s
JOIN Player_Sponsors ps ON s.sponsor_id = ps.sponsor_id
GROUP BY s.sponsor_name
ORDER BY Total_Sponsorship DESC;





/*
Phase 4 : Creating Views
1.  Create a view named PlayerRankings that lists all players with their full name (first name and last name combined), country, and current world ranking, sorted by their world ranking in ascending order. */

CREATE VIEW PlayerRankings AS
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    country,
    current_world_ranking
FROM Players
ORDER BY current_world_ranking;

select * from PlayerRankings

-- 2. Create a view named MatchResults that shows the details of each match, including the match date, the names of the players (both player1 and player2), and the name of the winner. If the match is yet to be completed, the winner should be displayed as 'TBD'.

CREATE VIEW MatchResults AS
SELECT 
    m.match_date,
    CONCAT(p1.first_name, ' ', p1.last_name) AS player1_name,
    CONCAT(p2.first_name, ' ', p2.last_name) AS player2_name,
    CASE
        WHEN m.winner_id IS NULL THEN 'TBD'
        ELSE CONCAT(pw.first_name, ' ', pw.last_name)
    END AS winner_name
FROM Matches m
JOIN Players p1 ON m.player1_id = p1.player_id
JOIN Players p2 ON m.player2_id = p2.player_id
LEFT JOIN Players pw ON m.winner_id = pw.player_id;

select * from MatchResults


-- 3. Create a view named SponsorSummary that shows each sponsor's name, the total number of players they sponsor, and the total amount of sponsorship provided by them.

CREATE VIEW SponsorSummary AS
SELECT 
    s.sponsor_name,
    COUNT(sp.player_id) AS total_players_sponsored,
    SUM(sp.sponsorship_amount) AS total_sponsorship_amount
FROM Sponsors s
JOIN Player_Sponsors sp ON s.sponsor_id = sp.sponsor_id
GROUP BY s.sponsor_name;

select * from SponsorSummary

-- 4. Create a view named ActiveSponsorships that lists the active sponsorships (where the contract end date is in the future). The view should include the player’s full name, sponsor name, and sponsorship amount. Ensure the view allows updates to the sponsorship amount.

CREATE OR REPLACE VIEW ActiveSponsorships AS
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    s.sponsor_name,
    sp.sponsorship_amount
FROM Player_Sponsors sp
JOIN Players p ON sp.player_id = p.player_id
JOIN Sponsors s ON sp.sponsor_id = s.sponsor_id
WHERE sp.contract_end_date > CURRENT_DATE;

select * from ActiveSponsorships;


/* 5. Create a view named PlayerPerformanceSummary that provides a detailed summary of each player's performance in the chess tournament. The view should include the following columns:

Player Name: Full name of the player (concatenation of first_name and last_name).
Total Matches Played: The total number of matches the player has participated in.
Total Wins: The total number of matches the player has won.
Win Percentage: The percentage of matches won by the player.
Best Match Level: The highest level (either "International" or "National") where the player has won the most matches. If the player has an equal number of wins at both levels, the view should return "Balanced".
Ensure that the view accounts for players who have not won any matches by returning NULL for the Total Wins and Win Percentage columns, and appropriately handles the Best Match Level logic.

*/

CREATE VIEW PlayerPerformanceSummary AS
WITH Player_Performance AS (
    SELECT 
        p.player_id,
        CONCAT(p.first_name, ' ', p.last_name) AS player_name,
        COUNT(m.match_id) AS total_matches_played,
        SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS total_wins,
        ROUND((SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) * 100.0 / COUNT(m.match_id)), 2) AS win_percentage
    FROM Players p
    LEFT JOIN Matches m ON p.player_id = m.player1_id OR p.player_id = m.player2_id
    GROUP BY p.player_id, p.first_name, p.last_name
),
Best_Match_Level AS (
    SELECT 
        p.player_id,
        CASE
            WHEN COALESCE(SUM(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) > 
                 COALESCE(SUM(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) THEN 'International'
            WHEN COALESCE(SUM(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) < 
                 COALESCE(SUM(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) THEN 'National'
            WHEN COALESCE(SUM(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) = 
                 COALESCE(SUM(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) THEN 'Balanced'
            ELSE NULL
        END AS best_match_level
    FROM Players p
    LEFT JOIN Matches m ON p.player_id = m.winner_id
    GROUP BY p.player_id
)
SELECT 
    pp.player_name,
    pp.total_matches_played,
    pp.total_wins,
    pp.win_percentage,
    bml.best_match_level
FROM Player_Performance pp
LEFT JOIN Best_Match_Level bml ON pp.player_id = bml.player_id;

select * from PlayerPerformanceSummary


/*
Advanced Queries

1.      Retrieve the names of players along with their total number of matches won, calculated as a percentage of their total matches played.Display the full_name along with  Win_Percentage rounded to 4 decimals */

SELECT
    CONCAT(p.first_name,' ',p.last_name) AS full_name,
    ROUND((SUM
	(CASE 
		WHEN m.winner_id = p.player_id 
			THEN 1 ELSE 0 END) / COUNT(m.player1_id)) * 100, 4) AS Win_Percentage
FROM
    Players p
    JOIN Matches m ON p.player_id = m.player1_id OR p.player_id = m.player2_id
GROUP BY
    p.player_id,p.first_name,p.last_name;

-- 2. Retrieve the match details for matches where the winner's current world ranking is among the top 5 players. Display the match date, winner's name, and the match level.

SELECT 
    m.match_date, 
    CONCAT(p.first_name, ' ', p.last_name) AS winner_name, 
    m.match_level
FROM Matches m
JOIN Players p ON m.winner_id = p.player_id
WHERE p.current_world_ranking <= 5;


-- 3. Find the sponsors who are sponsoring the top 3 players based on their current world ranking. Display the sponsor name and the player's full name an their world ranking .

SELECT 
    s.sponsor_name, 
    CONCAT(p.first_name, ' ', p.last_name) AS player_full_name, 
    p.current_world_ranking
FROM Sponsors s
JOIN Player_Sponsors ps ON s.sponsor_id = ps.sponsor_id
JOIN Players p ON ps.player_id = p.player_id
WHERE p.current_world_ranking <= 3
ORDER BY p.current_world_ranking;

/* 
4. Create a query that retrieves the full names of all players along with a label indicating their performance in the tournament based on their match win percentage. The label should be:

"Excellent" if the player has won more than 75% of their matches.
"Good" if the player has won between 50% and 75% of their matches.
"Average" if the player has won between 25% and 50% of their matches.
"Needs Improvement" if the player has won less than 25% of their matches.
The query should also include the player's total number of matches played and total number of matches won. The calculation for the win percentage should be done using a subquery. */

WITH Player_Performance AS (
    SELECT 
        p.player_id,
        p.first_name,
	    p.last_name,
        COUNT(m.match_id) AS total_matches_played,
        SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS total_matches_won,
        (SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) * 100.0 / COUNT(m.match_id)) AS win_percentage
    FROM Players p
    JOIN Matches m ON p.player_id = m.match_id
    GROUP BY p.player_id, p.first_name, p.last_name
)
SELECT 
    CONCAT(pp.first_name, ' ', pp.last_name),
    pp.total_matches_played,
    pp.total_matches_won,
    pp.win_percentage,
    CASE
        WHEN pp.win_percentage > 75 THEN 'Excellent'
        WHEN pp.win_percentage BETWEEN 50 AND 75 THEN 'Good'
        WHEN pp.win_percentage BETWEEN 25 AND 50 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance_label
FROM Player_Performance pp;


-- 5. Retrieve the names of players who have never won a match (i.e., they have participated in matches but are not listed as a winner in any match). Display their full name and current world ranking.

SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS full_name, 
    p.current_world_ranking
FROM Players p
WHERE p.player_id IN (
        SELECT DISTINCT player1_id FROM Matches
        UNION
        SELECT DISTINCT player2_id FROM Matches
    )
    AND p.player_id NOT IN (
        SELECT DISTINCT winner_id FROM Matches
    );