namespace ChessWebAPI.Models
{
    public class PlayerWinPercentage
    {
        public string ? FullName { get; set; }
        public int TotalMatchesWon { get; set; }
        public decimal WinPercentage { get; set; }
    }
}
