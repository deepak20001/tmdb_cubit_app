const baseURL = "https://api.themoviedb.org/3/";

const mostPopularApiUrl = "movie/popular";
const mostPopularApiReq = 1;

const topRatedApiUrl = "movie/top_rated";
const topRatedApiReq = 2;

const upcomingApiUrl = "movie/upcoming";
const upcomingApiReq = 3;

const trendingApiUrl = "trending/movie/day";
const trendingApiReq = 4;

String movieDetailApiUrl(int movieId) => "movie/$movieId";
const movieDetailApiReq = 5;

String movieTrailerApiUrl(int movieId) => "movie/$movieId/videos";
const movieTrailerApiReq = 6;

String movieCreditsApiUrl(int movieId) => "movie/$movieId/credits";
const movieCreditsApiReq = 7;

String personDetailApiUrl(int personId) => "/person/$personId";
const personDetailApiReq = 8;

String movieReviewApiUrl(int movieId) => "movie/$movieId/reviews";
const movieReviewApiReq = 9;

String searchApiUrl = "/search/movie";
const searchApiReq = 10;

String genreApiUrl = "/genre/movie/list";
const genreApiReq = 11;

String movieFromGenreApiUrl = "discover/movie";
const movieFromGenreApiReq = 12;
