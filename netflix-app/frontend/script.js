const API_KEY = '36ea7942e80240d2463ca4826e1a8527';
const BASE_URL = 'https://api.themoviedb.org/3';
const IMAGE_BASE_URL = 'https://image.tmdb.org/t/p/w500';

async function fetchTrendingMovies() {
    try {
        const response = await fetch(`${BASE_URL}/trending/movie/week?api_key=${API_KEY}`);
        const data = await response.json();
        return data.results;
    } catch (error) {
        console.error('Error fetching movies:', error);
        return [];
    }
}

function createMovieCard(movie) {
    const movieCard = document.createElement('div');
    movieCard.className = 'movie-card';
    
    const image = document.createElement('img');
    image.src = `${IMAGE_BASE_URL}${movie.poster_path}`;
    image.alt = movie.title;
    
    const title = document.createElement('div');
    title.className = 'title';
    title.textContent = movie.title;
    
    movieCard.appendChild(image);
    movieCard.appendChild(title);
    
    return movieCard;
}

async function displayMovies() {
    const movies = await fetchTrendingMovies();
    const movieGrid = document.getElementById('trending-movies');
    
    movies.forEach(movie => {
        const card = createMovieCard(movie);
        movieGrid.appendChild(card);
    });
}

// Load movies when the page loads
document.addEventListener('DOMContentLoaded', displayMovies); 