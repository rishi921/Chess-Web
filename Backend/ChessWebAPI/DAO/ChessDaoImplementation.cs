using ChessWebAPI.Models;
using Npgsql;
using NpgsqlTypes;
using System.Data;

namespace ChessWebAPI.DAO
{
    public class ChessDaoImplementation : IChessDAO
    {
        private readonly NpgsqlConnection _connection;

        public ChessDaoImplementation(NpgsqlConnection connection)
        {
            _connection = connection;
        }

        public async Task<List<Player>> GetPlayerByCountry(string country, string column)
        {
            string query = $"SELECT * FROM Players WHERE country = @country ORDER BY {column}";
            List<Player> playerList = new List<Player>();

            try
            {
                using (_connection)
                {
                    await _connection.OpenAsync();

                    using var command = new NpgsqlCommand(query, _connection)
                    {
                        CommandType = CommandType.Text
                    };
                    command.Parameters.AddWithValue("@country", country);

                    using var reader = await command.ExecuteReaderAsync();
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            var player = new Player
                            {
                                PlayerID = reader.GetInt32(0),
                                FirstName = reader.GetString(1),
                                LastName = reader.GetString(2),
                                Country = reader.GetString(3),
                                CurrentWorldRanking = reader.GetInt32(4),
                                TotalMatchesPlayed = reader.GetInt32(5)
                            };
                            playerList.Add(player);
                        }
                    }
                }
            }
            catch (NpgsqlException e)
            {
                Console.WriteLine(e.Message);
            }

            return playerList;
        }

        public async Task<List<PlayerWinPercentage>> GetPlayerWinPercentageByAverageOfWins()
        {
            string query = @"
                WITH PlayerWins AS (
                    SELECT winner_id AS player_id, COUNT(*) AS wins 
                    FROM Matches 
                    WHERE winner_id IS NOT NULL 
                    GROUP BY winner_id
                ),
                AverageWins AS (
                    SELECT AVG(wins) AS avg_wins 
                    FROM PlayerWins
                ),
                PlayerStats AS (
                    SELECT p.player_id, p.first_name || ' ' || p.last_name AS full_name, 
                           COALESCE(pw.wins, 0) AS wins,
                           (COALESCE(pw.wins, 0) * 100.0 / p.total_matches_played) AS win_percentage 
                    FROM Players p 
                    LEFT JOIN PlayerWins pw ON p.player_id = pw.player_id
                )
                SELECT ps.full_name, ps.wins, ps.win_percentage 
                FROM PlayerStats ps, AverageWins aw 
                WHERE ps.wins > aw.avg_wins;
            ";

            List<PlayerWinPercentage> playerList = new List<PlayerWinPercentage>();

            try
            {
                using (_connection)
                {
                    await _connection.OpenAsync();

                    using var command = new NpgsqlCommand(query, _connection)
                    {
                        CommandType = CommandType.Text
                    };

                    using var reader = await command.ExecuteReaderAsync();
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            var playerWinPercentage = new PlayerWinPercentage
                            {
                                FullName = reader.GetString(0),
                                TotalMatchesWon = reader.GetInt32(1),
                                WinPercentage = reader.GetDecimal(2)
                            };
                            playerList.Add(playerWinPercentage);
                        }
                    }
                }
            }
            catch (NpgsqlException e)
            {
                Console.WriteLine(e.Message);
            }

            return playerList;
        }

        public async Task<List<PlayerWinPercentage>> GetPlayerWinPercentage()
        {
            string query = @"
                SELECT 
                    p.first_name || ' ' || p.last_name AS full_name,
                    p.total_matches_played AS total_matches_won,
                    ROUND((COUNT(m.winner_id) * 100.0) / NULLIF(p.total_matches_played, 0), 4) AS win_percentage 
                FROM 
                    Players p 
                LEFT JOIN 
                    Matches m ON p.player_id = m.winner_id 
                GROUP BY 
                    p.first_name, p.last_name, p.total_matches_played;
            ";

            List<PlayerWinPercentage> playerList = new List<PlayerWinPercentage>();

            try
            {
                using (_connection)
                {
                    await _connection.OpenAsync();

                    using var command = new NpgsqlCommand(query, _connection)
                    {
                        CommandType = CommandType.Text
                    };

                    using var reader = await command.ExecuteReaderAsync();
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            var playerWinPercentage = new PlayerWinPercentage
                            {
                                FullName = reader.GetString(0),
                                TotalMatchesWon = reader.GetInt32(1),
                                WinPercentage = reader.GetDecimal(2)
                            };
                            playerList.Add(playerWinPercentage);
                        }
                    }
                }
            }
            catch (NpgsqlException e)
            {
                Console.WriteLine(e.Message);
            }

            return playerList;
        }


        public async Task<int> AddMatch(Match m)
        {
            string insertQuery = @$"
                INSERT INTO Matches (player1_id, player2_id, match_date, match_level, winner_id) 
                VALUES ('{m.Player1Id}', '{m.Player2Id}', '{m.MatchDate}', '{m.MatchLevel}', '{m.WinnerId}');
            ";

            int rowsInserted = 0;

            try
            {
                using (_connection)
                {
                    await _connection.OpenAsync();

                    using var insertCommand = new NpgsqlCommand(insertQuery, _connection)
                    {
                        CommandType = CommandType.Text
                    };

                    rowsInserted = await insertCommand.ExecuteNonQueryAsync();
                }
            }
            catch (NpgsqlException e)
            {
                Console.WriteLine($"------Exception-----: {e.Message}");
            }

            return rowsInserted;
        }
    }
}
