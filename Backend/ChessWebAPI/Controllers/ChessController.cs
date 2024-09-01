﻿using ChessWebAPI.DAO;
using ChessWebAPI.Models;
using Microsoft.AspNetCore.Mvc;

namespace ChessWebAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ChessController : ControllerBase
    {
        private readonly IChessDAO _chessDAO;

        public ChessController(IChessDAO chessDAO)
        {
            _chessDAO = chessDAO;
        }


        [HttpGet("GetPlayerByCountry", Name = "GetPlayerByCountry")]
        public async Task<ActionResult<List<Player>>> GetPlayerByCountry(string country, string column)
        {
            var players = await _chessDAO.GetPlayerByCountry(country, column);
            if (players == null)
            {
                return NotFound();
            }

            return Ok(players);
        }

        [HttpGet("GetPlayerWinPercentageByAverageOfWins", Name = "GetPlayerWinPercentageByAverageOfWins")]
        public async Task<ActionResult<List<PlayerWinPercentage>>> GetPlayerWinPercentageByAverageOfWins()
        {
            var players = await _chessDAO.GetPlayerWinPercentageByAverageOfWins();
            if (players == null)
            {
                return NotFound();
            }

            return Ok(players);
        }

        [HttpGet("GetPlayerWinPercentage", Name = "GetPlayerWinPercentage")]
        public async Task<ActionResult<List<PlayerWinPercentage>>> GetPlayerWinPercentage()
        {
            var players = await _chessDAO.GetPlayerWinPercentage();
            if (players == null)
            {
                return NotFound();
            }

            return Ok(players);
        }


        [HttpPost("AddMatch", Name = "AddMatch")]
        public async Task<ActionResult<Match>> AddMatch(Match product)
        {
            if (product == null)
            {
                return BadRequest("Product Not Found");
            }
            else
            {
                int value = await _chessDAO.AddMatch(product);

                return Ok(value);
            }

        }

    }
}