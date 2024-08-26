import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Navbar from './components/Navbar';
import Home from './components/Home';
import ViewItem from './components/ViewItem';
import './App.css';
import AddMatchForm from './components/AddItem';
import WinPercentage from './components/WinPercentage';
import AverageWins from './components/AverageOfWins';

const App = () => {
    return (
        <div style={{ backgroundColor: 'black', color: 'white', height: '100vh' }}>
        <Router>
            <div className="App">
                <Navbar />
                <main>
                    <Routes>
                        <Route path="/" element={<Home />} />
                        <Route path="/about" element={<AddMatchForm />} />
                        <Route path="/services" element={<ViewItem />} />
                        <Route path='/WinPercentage' element={<WinPercentage />} />
                        <Route path='/AverageWins' element={<AverageWins />} />
                    </Routes>
                </main>
            </div>
        </Router>
        </div>
    );
};

export default App;
