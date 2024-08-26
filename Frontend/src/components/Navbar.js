import React from 'react';
import { Link } from 'react-router-dom';
import '../styling/Navbar.css';

const Navbar = () => {
    return (
        <nav className="navbar">
            <div className="navbar-brand">
                <img
                    src="https://as2.ftcdn.net/v2/jpg/03/44/08/87/1000_F_344088782_rRID0MOTm4gfcHrLh2I3VRiXAWYXLH92.jpg"
                    alt="Chess Logo"
                    className="navbar-logo-image"
                />
                <Link to="/" className="navbar-logo">ChessMaster</Link>
            </div>
            <ul className="navbar-menu">
                <li><Link to="/" className="navbar-item button-link">Home</Link></li>
                <li><Link to="/about" className="navbar-item button-link" >Add Player </Link></li>
                <li><Link to="/services" className="navbar-item button-link" >View Player</Link></li>
                <li><Link to="/WinPercentage" className="navbar-item button-link" >Win Percentage</Link></li>
                <li><Link to="/AverageWins" className="navbar-item button-link" >Average Wins</Link></li>
            </ul>
        </nav>
    );
};

export default Navbar;
