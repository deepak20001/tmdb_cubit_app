import 'dart:convert';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/network__class/api_url_constants.dart';
import '../../utils/network__class/dio_network_class.dart';
import '../../utils/network__class/network_response.dart';

class CategoryMoviesCubit extends Cubit<CategoryMoviesState>
    implements NetworkResponse {
  int genreId;
  int pageNumber = 1;
  final ScrollController scrollController;
  CategoryMoviesCubit({required this.genreId, required this.scrollController})
      : super(
          CategoryMoviesState(
            showLoader: true,
            specificGenreMoviesList: [],
          ),
        ) {
    fetchMovieFromGenre(genreId, pageNumber);
    scrollController.addListener(() {
      debugPrint("Hoo");
      loadMoreData(pageNumber);
    });
  }

  void loadMoreData(int pageNumber) {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (pageNumber < 5) {
        fetchMovieFromGenre(genreId, pageNumber);
      }
    }
  }

  /// FETCH MOVIE FROM GENRE
  Future<void> fetchMovieFromGenre(int genreId, int pageNumber) async {
    emit(state.copyWith(showLoader: true));
    Map<String, dynamic> map = {
      "with_genres": genreId,
      "api_key": tmdbSecretKey,
      'page': pageNumber,
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
      case movieFromGenreApiReq:
        successLog("movieFromGenreApiReq success:::::$response");
        var data = jsonDecode(response);
        var cList = (data["results"] as List)
            .map((e) => GenreMovieModel.fromJson(e))
            .toList();
        while (cList.length % 3 != 0) {
          cList.removeAt(cList.length - 1);
        }
        emit(state.copyWith(specificGenreMoviesList: [
          ...state.specificGenreMoviesList!,
          ...cList
        ]));
        pageNumber++;
        break;
    }
  }

  @override
  Future<void> close() {
    scrollController.dispose(); // Dispose of the scroll controller
    return super.close();
  }
}

/// Categories State
class CategoryMoviesState {
  bool? showLoader;
  List<GenreMovieModel>? specificGenreMoviesList;

  CategoryMoviesState({
    this.showLoader,
    this.specificGenreMoviesList,
  });

  CategoryMoviesState copyWith({
    bool? showLoader,
    List<GenreMovieModel>? specificGenreMoviesList,
  }) {
    return CategoryMoviesState(
      showLoader: showLoader ?? this.showLoader,
      specificGenreMoviesList:
          specificGenreMoviesList ?? this.specificGenreMoviesList,
    );
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
