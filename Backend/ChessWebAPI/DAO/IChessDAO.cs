using ChessWebAPI.Models;

namespace ChessWebAPI.DAO
{
    public interface IChessDAO
    {
        Task <List<Player>> GetPlayerByCountry(string country, string column);
        Task<List<PlayerWinPercentage>> GetPlayerWinPercentage();
        Task<List<PlayerWinPercentage>> GetPlayerWinPercentageByAverageOfWins();
        Task<int> AddMatch(Match m);
    }
}
