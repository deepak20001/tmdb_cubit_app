import 'dart:convert';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/network__class/api_url_constants.dart';
import '../../utils/network__class/dio_network_class.dart';
import '../../utils/network__class/network_response.dart';

class SearchCubit extends Cubit<SearchState> implements NetworkResponse {
  SearchCubit()
      : super(
          SearchState(
            searchMoviesList: [],
            isSearchLoading: false,
            sortBySelectedValue: 'Popularity',
            selectedGenreValue: null,
            genreSelectedValue: 'All',
            searchedMovieName: '',
          ),
        );

  ///
  /*  Map<String, String> sortByMap = {
    'Popularity': 'popularity.desc',
    'Revenue': 'revenue.desc',
    'Rating': 'vote_average.desc',
  };
  Map<String, int> genresMap = {
    'Action': 28,
    'Adventure': 12,
    'Animation': 16,
    'Comedy': 35,
    'Horror': 27,
    'Romance': 10749,
    'Science Fiction': 878,
    'Thriller': 53,
    'War': 10752,
  }; */

  ///
  TextEditingController searchController = TextEditingController();

  void selectedValueFromDropdown(int index, String value) {
    switch (index) {
      case 0:
        emit(state.copyWith(sortBySelectedValue: value));
      case 1:
        emit(state.copyWith(genreSelectedValue: value));
    }
    fetchSearchMovieApi(state.searchedMovieName!);
  }

  //
  void updateSearchMovieName(String val) {
    emit(state.copyWith(isSearchLoading: true));
    emit(state.copyWith(searchedMovieName: val));
    fetchSearchMovieApi(val);
  }

  /// FETCH MOVIE DETAIL API
  Future<void> fetchSearchMovieApi(String movieName) async {
    Map<String, dynamic> map = {
      "query": movieName,
      "api_key": tmdbSecretKey,
    };

    debugPrint("searchMap:::::::::::::::::::$map");
    DioNetworkClass.fromNetworkClass(
            endUrl: searchApiUrl,
            networkResponse: this,
            requestCode: searchApiReq,
            jsonBody: map)
        .callRequestService(false, "get");
  }

  /// Error
  @override
  void onApiError({required int requestCode, required String response}) {
    switch (requestCode) {
      case searchApiReq:
        errorLog("searchApiReq error:::::$response");
        emit(state.copyWith(isSearchLoading: false));
        break;
    }
  }

  /// Success
  @override
  void onResponse({required int requestCode, required String response}) {
    switch (requestCode) {
      case searchApiReq:
        successLog("searchApiReq success:::::$response");
        var data = jsonDecode(response);

        state.searchMoviesList = (data["results"] as List<dynamic>)
            .map((e) => SearchModel.fromJson(e))
            .toList();

        /// FIltered the data
        if (state.sortBySelectedValue! == 'Popularity') {
          state.searchMoviesList!.sort(
              (a, b) => (b.popularity ?? 0.0).compareTo(a.popularity ?? 0.0));
        } else if (state.sortBySelectedValue! == 'Rating') {
          state.searchMoviesList!.sort(
              (a, b) => (b.voteCount ?? 0.0).compareTo(a.voteCount ?? 0.0));
        }

        if (state.genreSelectedValue != 'All') {
          if (state.genreSelectedValue == 'Action') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(28));
          } else if (state.genreSelectedValue == 'Adventure') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(12));
          } else if (state.genreSelectedValue == 'Animation') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(16));
          } else if (state.genreSelectedValue == 'Comedy') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(35));
          } else if (state.genreSelectedValue == 'Horror') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(27));
          } else if (state.genreSelectedValue == 'Romance') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(10749));
          } else if (state.genreSelectedValue == 'Science Fiction') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(878));
          } else if (state.genreSelectedValue == 'Thriller') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(53));
          } else if (state.genreSelectedValue == 'War') {
            state.searchMoviesList!
                .removeWhere((element) => !element.genres!.contains(10752));
          }
        }

        emit(state.copyWith(
            searchMoviesList: state.searchMoviesList, isSearchLoading: false));
        break;
    }
  }
}

/// Search State
class SearchState {
  List<SearchModel>? searchMoviesList;
  bool? isSearchLoading;
  String? sortBySelectedValue;
  GenreModel? selectedGenreValue;
  String? genreSelectedValue;
  String? searchedMovieName;

  SearchState({
    this.searchMoviesList,
    this.isSearchLoading,
    this.sortBySelectedValue,
    this.selectedGenreValue,
    this.genreSelectedValue,
    this.searchedMovieName,
  });

  SearchState copyWith({
    List<SearchModel>? searchMoviesList,
    bool? isSearchLoading,
    String? sortBySelectedValue,
    GenreModel? selectedGenreValue,
    String? genreSelectedValue,
    String? searchedMovieName,
  }) {
    return SearchState(
      searchMoviesList: searchMoviesList ?? this.searchMoviesList,
      isSearchLoading: isSearchLoading ?? this.isSearchLoading,
      sortBySelectedValue: sortBySelectedValue ?? this.sortBySelectedValue,
      selectedGenreValue: selectedGenreValue ?? this.selectedGenreValue,
      genreSelectedValue: genreSelectedValue ?? this.genreSelectedValue,
      searchedMovieName: searchedMovieName ?? this.searchedMovieName,
    );
  }
}

/// Search Model
class SearchModel {
  String? posterPath;
  String? movieTitle;
  String? releaseDate;
  double? voteCount;
  int? movieId;
  double? popularity;
  List<dynamic>? genres;

  SearchModel({
    this.posterPath,
    this.movieTitle,
    this.releaseDate,
    this.voteCount,
    this.movieId,
    this.popularity,
    this.genres,
  });

  SearchModel.fromJson(Map<String, dynamic> json) {
    posterPath = json["poster_path"] ?? "";
    movieTitle = json["title"] ?? "";
    releaseDate = json["release_date"] ?? "";
    voteCount = json["vote_average"] != null
        ? double.parse(json["vote_average"].toString())
        : null;
    movieId = json["id"];
    popularity = json["popularity"];
    genres = json["genre_ids"] ?? [];
  }
}

/// Genre Model
class GenreModel {
  int? genreId;
  String? genreName;

  GenreModel({
    required this.genreId,
    required this.genreName,
  });

  GenreModel.fromJson(Map<String, dynamic> json) {
    genreId = json["id"];
    genreName = json["name"] ?? "";
  }
}
