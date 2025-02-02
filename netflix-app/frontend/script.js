// Config object to store API configuration
const config = {
    apiKey: '${TMDB_API_KEY}', // This will be replaced by the build process
    baseUrl: 'https://api.themoviedb.org/3',
    imageBaseUrl: 'https://image.tmdb.org/t/p/w500'
};

async function fetchTrendingMovies() {
    try {
        const response = await fetch(`${config.baseUrl}/trending/movie/week?api_key=${config.apiKey}`);
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
    image.src = `${config.imageBaseUrl}${movie.poster_path}`;
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