import 'dart:convert';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/network__class/api_url_constants.dart';
import '../../utils/network__class/dio_network_class.dart';
import '../../utils/network__class/network_response.dart';

class CategoriesCubit extends Cubit<CategoriesState>
    implements NetworkResponse {
  CategoriesCubit()
      : super(
          CategoriesState(
            showLoader: true,
            genreList: [],
            specificGenreMoviesList: [],
            genreListIndex: 0,
          ),
        ) {
    fetchMovieGenre();
  }

  /// FETCH MOVIE GENRE API
  Future<void> fetchMovieGenre() async {
    emit(state.copyWith(showLoader: true));
    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: genreApiUrl,
            networkResponse: this,
            requestCode: genreApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// FETCH MOVIE FROM GENRE
  Future<void> fetchMovieFromGenre(int genreId) async {
    emit(state.copyWith(showLoader: true));
    Map<String, dynamic> map = {
      "with_genres": genreId,
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: movieFromGenreApiUrl,
            networkResponse: this,
            requestCode: movieFromGenreApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// Error
  @override
  void onApiError({required int requestCode, required String response}) {
    switch (requestCode) {
      case genreApiReq:
        errorLog("genreApiReq error:::::$response");
        emit(state.copyWith(showLoader: false));
        break;
      case movieFromGenreApiReq:
        errorLog("movieFromGenreApiReq error:::::$response");
        emit(state.copyWith(showLoader: false));
        break;
    }
  }

  /// Success
  @override
  Future<void> onResponse(
      {required int requestCode, required String response}) async {
    switch (requestCode) {
      case genreApiReq:
        successLog("genreApiReq success:::::$response");
        var data = jsonDecode(response);

        state.genreList = (data["genres"] as List)
            .map((e) => GenreModel.fromJson(e))
            .toList();

        emit(state.copyWith(genreList: state.genreList));

        for (int i = 0; i < state.genreList!.length; i++) {
          fetchMovieFromGenre(state.genreList![i].genreId!);
        }
        break;
      case movieFromGenreApiReq:
        successLog("movieFromGenreApiReq success:::::$response");
        var data = jsonDecode(response);
        state.specificGenreMoviesList = (data["results"] as List)
            .map((e) => GenreMovieModel.fromJson(e))
            .toList();

        emit(state.copyWith(
            showLoader: false,
            specificGenreMoviesList: state.specificGenreMoviesList));
        state.genreList![state.genreListIndex!].genreMoviesList =
            List<GenreMovieModel>.from(state.specificGenreMoviesList!);
        emit(state.copyWith(
            genreList: state.genreList,
            genreListIndex: state.genreListIndex! + 1));
        break;
    }
  }
}

/// Categories State
class CategoriesState {
  bool? showLoader;
  List<GenreModel>? genreList;
  List<GenreMovieModel>? specificGenreMoviesList;
  int? genreListIndex;

  CategoriesState({
    this.showLoader,
    this.genreList,
    this.specificGenreMoviesList,
    this.genreListIndex,
  });

  CategoriesState copyWith({
    bool? showLoader,
    List<GenreModel>? genreList,
    List<GenreMovieModel>? specificGenreMoviesList,
    int? genreListIndex,
  }) {
    return CategoriesState(
      showLoader: showLoader ?? this.showLoader,
      genreList: genreList ?? this.genreList,
      specificGenreMoviesList:
          specificGenreMoviesList ?? this.specificGenreMoviesList,
      genreListIndex: genreListIndex ?? this.genreListIndex,
    );
  }
}

/// Genre Model
class GenreModel {
  int? genreId;
  String? genreName;
  List<GenreMovieModel>? genreMoviesList;

  GenreModel({
    required this.genreId,
    required this.genreName,
    required this.genreMoviesList,
  });

  GenreModel.fromJson(Map<String, dynamic> json) {
    genreId = json["id"];
    genreName = json["name"] ?? "";
    genreMoviesList = [];
  }
}

/// Genre Movie Model
class GenreMovieModel {
  int? movieId;
  String? movieTitle;
  String? moviePoster;
  double? movieRating;

  GenreMovieModel({
    required this.movieId,
    required this.movieTitle,
    required this.moviePoster,
    required this.movieRating,
  });

  GenreMovieModel.fromJson(Map<String, dynamic> json) {
    movieId = json["id"];
    movieTitle = json["original_title"];
    moviePoster = json["poster_path"];
    movieRating = json["vote_average"];
  }
}
