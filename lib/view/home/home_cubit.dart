import 'dart:convert';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/common_models.dart';
import '../../utils/network__class/api_url_constants.dart';
import '../../utils/network__class/dio_network_class.dart';
import '../../utils/network__class/network_response.dart';

class HomeCubit extends Cubit<HomeState> implements NetworkResponse {
  HomeCubit()
      : super(
          HomeState(
            selectedTab: 0,
            showPopularLoader: true,
            requestTabList: [
              MovieTabModel(
                  title: 'Top Rated', value: 'toprated', isSelected: true),
              MovieTabModel(
                  title: 'Upcoming', value: 'upcoming', isSelected: false),
              MovieTabModel(
                  title: 'Trending', value: 'trending', isSelected: false),
            ],
            popularMovieList: [],
            topRatedMovieList: [],
            upcomingMovieList: [],
          ),
        );

  /// CHANGE TAB INDEX
  void onSelectTab(int index) {
    var pos = state.requestTabList!.indexWhere((element) => element.isSelected);
    if (pos >= 0) {
      state.requestTabList![pos].isSelected = false;
    }
    state.requestTabList![index].isSelected = true;

    emit(state.copyWith(
        selectedTab: index, requestTabList: state.requestTabList));
  }

  /// FETCH POPULAR MOVIES API
  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(showPopularLoader: true));

    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: mostPopularApiUrl,
            networkResponse: this,
            requestCode: mostPopularApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// FETCH TOP RATED MOVIES API
  Future<void> fetchTopRatedMovies() async {
    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: topRatedApiUrl,
            networkResponse: this,
            requestCode: topRatedApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// FETCH UPCOMING MOVIES API
  Future<void> fetchUpcomingMovies() async {
    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: upcomingApiUrl,
            networkResponse: this,
            requestCode: upcomingApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// FETCH TRENDING MOVIES API
  Future<void> fetchTrendingMovies() async {
    Map<String, dynamic> map = {
      "api_key": tmdbSecretKey,
    };

    DioNetworkClass.fromNetworkClass(
            endUrl: trendingApiUrl,
            networkResponse: this,
            requestCode: trendingApiReq,
            jsonBody: map)
        .callRequestService(true, "get");
  }

  /// Error
  @override
  void onApiError({required int requestCode, required String response}) {
    switch (requestCode) {
      case mostPopularApiReq:
        errorLog("mostPopularApiReq error:::::$response");
        emit(state.copyWith(showPopularLoader: false));
        break;
      case topRatedApiReq:
        errorLog("topRatedApiReq error:::::$response");
        break;
      case upcomingApiReq:
        errorLog("upcomingApiReq error:::::$response");
        break;
      case trendingApiReq:
        errorLog("trendingApiReq error:::::$response");
        break;
    }
  }

  /// Success
  @override
  void onResponse({required int requestCode, required String response}) {
    switch (requestCode) {
      case mostPopularApiReq:
        successLog("mostPopularApiReq success:::::$response");
        var data = jsonDecode(response);
        emit(state.copyWith(
            popularMovieList: data['results']
                .map<MovieModel>((json) => MovieModel.fromJson(json))
                .toList()));
        emit(state.copyWith(showPopularLoader: false));
        break;
      case topRatedApiReq:
        successLog("topRatedApiReq success:::::$response");
        var data = jsonDecode(response);
        emit(state.copyWith(
            topRatedMovieList: data['results']
                .map<MovieModel>((json) => MovieModel.fromJson(json))
                .toList()));
        break;
      case upcomingApiReq:
        successLog("upcomingApiReq success:::::$response");
        var data = jsonDecode(response);
        emit(state.copyWith(
            upcomingMovieList: data['results']
                .map<MovieModel>((json) => MovieModel.fromJson(json))
                .toList()));
        break;
      case trendingApiReq:
        successLog("trendingApiReq success:::::$response");
        var data = jsonDecode(response);
        emit(state.copyWith(
            trendingMovieList: data['results']
                .map<MovieModel>((json) => MovieModel.fromJson(json))
                .toList()));
        break;
    }
  }
}

/// Home State
class HomeState {
  int? selectedTab;
  List<MovieTabModel>? requestTabList;
  List<MovieModel>? popularMovieList;
  List<MovieModel>? topRatedMovieList;
  List<MovieModel>? upcomingMovieList;
  List<MovieModel>? trendingMovieList;
  bool? showPopularLoader;

  HomeState({
    this.selectedTab,
    this.requestTabList,
    this.popularMovieList,
    this.topRatedMovieList,
    this.upcomingMovieList,
    this.trendingMovieList,
    this.showPopularLoader,
  });

  HomeState copyWith({
    int? selectedTab,
    List<MovieTabModel>? requestTabList,
    List<MovieModel>? popularMovieList,
    List<MovieModel>? topRatedMovieList,
    List<MovieModel>? upcomingMovieList,
    List<MovieModel>? trendingMovieList,
    bool? showPopularLoader,
  }) {
    return HomeState(
      selectedTab: selectedTab ?? this.selectedTab,
      requestTabList: requestTabList ?? this.requestTabList,
      popularMovieList: popularMovieList ?? this.popularMovieList,
      topRatedMovieList: topRatedMovieList ?? this.topRatedMovieList,
      upcomingMovieList: upcomingMovieList ?? this.upcomingMovieList,
      trendingMovieList: trendingMovieList ?? this.trendingMovieList,
      showPopularLoader: showPopularLoader ?? this.showPopularLoader,
    );
  }
}

/// MovieModel
class MovieTabModel {
  String title = "";
  String value = "";
  bool isSelected = false;

  MovieTabModel({
    required this.title,
    required this.value,
    required this.isSelected,
  });
}
