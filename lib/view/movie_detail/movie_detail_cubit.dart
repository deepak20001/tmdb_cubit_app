import 'dart:convert';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/common_models.dart';
import '../../utils/network__class/api_url_constants.dart';
import '../../utils/network__class/dio_network_class.dart';
import '../../utils/network__class/network_response.dart';

class MovieDetailCubit extends Cubit<MovieDetailState>
    implements NetworkResponse {
  MovieDetailCubit()
      : super(
          MovieDetailState(
            showMovieDetailLoader: false,
            showCreditsLoader: false,
            showCastDetailsLoader: false,
            showMovieReviewsLoader: false,
            movieDetail: SearchModel(),
            trailerKey: "",
            movieCredits: MovieCreditsModel(),
            personDetail: PersonDetailModel(),
            movieReviewsList: [],
          ),
        );

  /// FETCH MOVIE DETAIL API
  Future<void> fetchMovieDetailApi(int movieId) async {
    emit(state.copyWith(showMovieDetailLoader: true));

    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: movieDetailApiUrl(movieId),
            networkResponse: this,
            requestCode: movieDetailApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// FETCH MOVIE TRAILER API
  Future<void> fetchMovieTrailerApi(int movieId) async {
    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: movieTrailerApiUrl(movieId),
            networkResponse: this,
            requestCode: movieTrailerApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// FETCH MOVIE CREDITS API
  Future<void> fetchMovieCreditsApi(int movieId) async {
    emit(state.copyWith(showCreditsLoader: true));
    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: movieCreditsApiUrl(movieId),
            networkResponse: this,
            requestCode: movieCreditsApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// FETCH PERSON DETAIL API
  Future<void> fetchPersonDetailApi(int personId) async {
    emit(state.copyWith(showCastDetailsLoader: true));
    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: personDetailApiUrl(personId),
            networkResponse: this,
            requestCode: personDetailApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// FETCH MOVIE REVIEWS API
  Future<void> fetchMovieReviewsApi(int movieId) async {
    emit(state.copyWith(showMovieReviewsLoader: true));
    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: movieReviewApiUrl(movieId),
            networkResponse: this,
            requestCode: movieReviewApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// Error
  @override
  void onApiError({required int requestCode, required String response}) {
    switch (requestCode) {
      case movieDetailApiReq:
        errorLog("movieDetailApiReq error:::::$response");
        emit(state.copyWith(showMovieDetailLoader: false));
        break;
      case movieTrailerApiReq:
        errorLog("movieTrailerApiReq error:::::$response");
        break;
      case movieCreditsApiReq:
        errorLog("movieCreditsApiReq error:::::$response");
        emit(state.copyWith(showCreditsLoader: false));
        break;
      case personDetailApiReq:
        errorLog("personDetailApiReq error:::::$response");
        emit(state.copyWith(showCastDetailsLoader: false));
        break;
      case movieReviewApiReq:
        errorLog("movieReviewApiReq error:::::$response");
        emit(state.copyWith(showMovieReviewsLoader: false));
        break;
    }
  }

  /// Success
  @override
  void onResponse({required int requestCode, required String response}) {
    switch (requestCode) {
      case movieDetailApiReq:
        successLog("movieDetailApiReq success:::::$response");
        var data = jsonDecode(response);
        emit(state.copyWith(movieDetail: SearchModel.fromJson(data)));
        emit(state.copyWith(showMovieDetailLoader: false));
        break;
      case movieTrailerApiReq:
        successLog("movieTrailerApiReq success:::::$response");
        var data = jsonDecode(response);

        if (data["results"] != null) {
          List<dynamic> results = data["results"];

          for (var result in results) {
            if (result["type"] == "Trailer") {
              emit(state.copyWith(trailerKey: result["key"]));
              break;
            }
          }
        }
        break;
      case movieCreditsApiReq:
        successLog("movieCreditsApiReq success:::::$response");
        var data = jsonDecode(response);

        emit(state.copyWith(movieCredits: MovieCreditsModel.fromJson(data)));
        emit(state.copyWith(showCreditsLoader: false));
        break;
      case personDetailApiReq:
        successLog("personDetailApiReq success:::::$response");
        var data = jsonDecode(response);

        emit(state.copyWith(personDetail: PersonDetailModel.fromJson(data)));
        emit(state.copyWith(showCastDetailsLoader: false));
        break;
      case movieReviewApiReq:
        successLog("movieReviewApiReq success:::::$response");
        var data = jsonDecode(response);

        for (var reviewData in data['results']) {
          MovieReviewModel review = MovieReviewModel.fromJson(reviewData);
          state.movieReviewsList!.add(review);
        }

        emit(state.copyWith(movieReviewsList: state.movieReviewsList));
        emit(state.copyWith(showMovieReviewsLoader: false));
        break;
    }
  }
}

class MovieDetailState {
  SearchModel? movieDetail;
  bool? showMovieDetailLoader;
  String? trailerKey;
  MovieCreditsModel? movieCredits;
  PersonDetailModel? personDetail;
  bool? showCreditsLoader;
  bool? showCastDetailsLoader;
  bool? showMovieReviewsLoader;
  List<MovieReviewModel>? movieReviewsList;

  MovieDetailState({
    this.movieDetail,
    this.showMovieDetailLoader,
    this.trailerKey,
    this.movieCredits,
    this.personDetail,
    this.showCreditsLoader,
    this.showCastDetailsLoader,
    this.showMovieReviewsLoader,
    this.movieReviewsList,
  });

  MovieDetailState copyWith({
    SearchModel? movieDetail,
    bool? showMovieDetailLoader,
    String? trailerKey,
    MovieCreditsModel? movieCredits,
    PersonDetailModel? personDetail,
    bool? showCreditsLoader,
    bool? showCastDetailsLoader,
    bool? showMovieReviewsLoader,
    List<MovieReviewModel>? movieReviewsList,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      showMovieDetailLoader:
          showMovieDetailLoader ?? this.showMovieDetailLoader,
      trailerKey: trailerKey ?? this.trailerKey,
      movieCredits: movieCredits ?? this.movieCredits,
      personDetail: personDetail ?? this.personDetail,
      showCreditsLoader: showCreditsLoader ?? this.showCreditsLoader,
      showCastDetailsLoader:
          showCastDetailsLoader ?? this.showCastDetailsLoader,
      showMovieReviewsLoader:
          showMovieReviewsLoader ?? this.showMovieReviewsLoader,
      movieReviewsList: movieReviewsList ?? this.movieReviewsList,
    );
  }
}
