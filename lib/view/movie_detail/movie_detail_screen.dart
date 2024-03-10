import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubit_movie_app/utils/common_strings.dart';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/common_widgets.dart';
import 'package:cubit_movie_app/view/movie_detail/movie_detail_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../main.dart';

class MovieDetailScreen extends StatelessWidget {
  const MovieDetailScreen({super.key, required this.movieId});
  final int movieId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocProvider(
        create: (context) => MovieDetailCubit()
          ..fetchMovieDetailApi(movieId)
          ..fetchMovieTrailerApi(movieId)
          ..fetchMovieCreditsApi(movieId),
        child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
          builder: (context, state) {
            var cubitData = context.read<MovieDetailCubit>();

            return state.showMovieDetailLoader! || state.showCreditsLoader!
                ?

                /// Main Circular Progress Indicator of details screen
                commonLoader()
                :

                /// Sliver App Bar
                CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        expandedHeight: size.height * numD3,
                        // pinned: true,
                        leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Container(
                            decoration: BoxDecoration(
                              color: CommonColors.appThemeColor,
                              borderRadius:
                                  BorderRadius.circular(size.width * numD5),
                            ),
                            child: Center(
                              child: Image.asset(
                                "${CommonPath.iconPath}/ic_back.png",
                                height: size.width * numD055,
                                color: CommonColors.whiteColor,
                              ),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: ClipRRect(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(size.width * numD06),
                              bottomRight: Radius.circular(size.width * numD06),
                            ),
                            child: CachedNetworkImage(
                              height: size.height * numD90,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${CommonPath.itemImagePath}${state.movieDetail!.backdropPath}",
                              placeholder: (context, url) => Padding(
                                  padding: EdgeInsets.all(size.width * numD035),
                                  child: commonLoader()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),

                      /// Data After Sliver App Bar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * numD03,
                          ).copyWith(
                            bottom: size.height * numD02,
                          ),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: size.height * numD008),

                                /// Title
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: CommonText(
                                        title: state.movieDetail!.title!
                                            .toUpperCase(),
                                        fontSize: size.width * numD065,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * numD01,
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          splashColor:
                                              CommonColors.transparentColor,
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return showTrailerDialog(
                                                  size,
                                                  state.trailerKey!,
                                                  context,
                                                );
                                              },
                                            );
                                          },
                                          child: Image.asset(
                                            "${CommonPath.iconPath}/ic_youtube.png",
                                            height: size.width * numD065,
                                          ),
                                        ),
                                        SizedBox(width: size.width * numD02),
                                        InkWell(
                                          onTap: () {
                                            moreOptionsBottomSheet(
                                                size, context, cubitData);
                                          },
                                          splashColor:
                                              CommonColors.transparentColor,
                                          child: const Icon(
                                            Icons.more_vert,
                                            color: CommonColors.whiteColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                CommonText(
                                  title: "${DateFormat('yyyy').format(
                                    DateTime.parse(
                                        state.movieDetail!.releaseDate!),
                                  )} : ${formatDuration(state.movieDetail!.runtime!)}",
                                  fontSize: size.width * numD03,
                                ),
                                SizedBox(height: size.height * numD002),
                                commonDivider(),

                                /// Movie Poster, Movie Genere, Movie Overview
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration:
                                          commonBoxDecoration(size: size),

                                      /// Cached Network Image
                                      child: CachedNetworkImage(
                                        height: size.height * numD3,
                                        width: size.width * numD4,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${CommonPath.itemImagePath}${state.movieDetail!.posterPath}",
                                        placeholder: (context, url) => SizedBox(
                                          width: size.width * numD31,
                                          height: size.height * numD205,
                                          child: commonShimmerEffect(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                    SizedBox(width: size.width * numD02),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          /// Horizontal Scrollable List
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Row(
                                              children: List.generate(
                                                state.movieDetail!.genres!
                                                    .length,
                                                (index) => Container(
                                                  padding: EdgeInsets.all(
                                                      size.width * numD015),
                                                  margin: EdgeInsets.symmetric(
                                                          horizontal:
                                                              size.width *
                                                                  numD01)
                                                      .copyWith(
                                                          bottom: size.width *
                                                              numD01),
                                                  decoration:
                                                      commonBoxDecoration(
                                                          size: size,
                                                          borderRadius: numD01,
                                                          boxShadowOpacity: 0.4,
                                                          blurRadius: 0),
                                                  child: CommonText(
                                                    title: state.movieDetail!
                                                        .genres![index].name
                                                        .toString(),
                                                    fontSize:
                                                        size.width * numD035,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: size.width * numD01),

                                          /// Movie Detail
                                          CommonText(
                                              title:
                                                  state.movieDetail!.overview!,
                                              fontSize: size.width * numD035,
                                              maxLine: 5),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                commonDivider(),
                                ratingRevenueStatusWidget(size),
                                commonDivider(),

                                /// Movie Casts
                                SizedBox(height: size.height * numD02),
                                CommonText(
                                  title: popularCastsText,
                                  fontSize: size.width * numD04,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: size.height * numD01),

                                ///
                                popularCastWidget(
                                    size,
                                    state.movieCredits!.cast!.length,
                                    cubitData),
                                SizedBox(height: size.height * numD03),

                                ///
                                CommonText(
                                  title: popularCrewsText,
                                  fontSize: size.width * numD04,
                                  fontWeight: FontWeight.w500,
                                ),
                                SizedBox(height: size.height * numD01),
                                popularCrewWidget(
                                    size,
                                    state.movieCredits!.crew!.length,
                                    cubitData),

                                ///
                                ///
                              ]),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  /// SHOW TRAILER WIDGET
  Widget showTrailerDialog(Size size, String movieId, BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: size.width * numD03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: <Widget>[
              // Stroked text as border.
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * numD03),
                    child: Text(
                      'TRAILER',
                      style: TextStyle(
                        fontFamily: CommonTextStyle.fontFamily,
                        fontSize: size.width * numD08,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 4
                          ..color = CommonColors.whiteColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.cancel_rounded,
                      color: CommonColors.whiteColor,
                      size: size.width * numD08,
                    ),
                  ),
                ],
              ),
              // Solid text as fill.
              Padding(
                padding: EdgeInsets.only(left: size.width * numD03),
                child: CommonText(
                  title: "TRAILER",
                  fontSize: size.width * numD08,
                  color: CommonColors.appThemeColor,
                ),
              ),
            ],
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: size.width * numD02).copyWith(
              bottom: size.width * numD02,
            ),
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: movieId,
                flags: const YoutubePlayerFlags(
                  autoPlay: true,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
              progressIndicatorColor: CommonColors.whiteColor,
              progressColors: const ProgressBarColors(
                playedColor: CommonColors.whiteColor,
                handleColor: CommonColors.whiteColor,
              ),
              bottomActions: [
                CurrentPosition(),
                ProgressBar(
                  isExpanded: true,
                  colors: const ProgressBarColors(
                    playedColor: CommonColors.whiteColor,
                    handleColor: CommonColors.redColor,
                  ),
                ),
                RemainingDuration(),
                const PlaybackSpeedButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Format Minutes To Hours Function
  String formatDuration(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}h ${remainingMinutes.toString().padLeft(2, '0')}m';
  }

  /// Format Money Function
  String formatMoney(double value) {
    if (value >= 1000000000) {
      double billionValue = value / 1000000000;
      return '\$${billionValue.toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      double millionValue = value / 1000000;
      return '\$${millionValue.toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      double thousandValue = value / 1000;
      return '\$${thousandValue.toStringAsFixed(2)}T';
    } else {
      return '\$${value.toStringAsFixed(2)}';
    }
  }

  /// Rating & Revenue & Status Widget
  Widget ratingRevenueStatusWidget(Size size) {
    return BlocBuilder<MovieDetailCubit, MovieDetailState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// Rating
            Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * numD01),
              child: Column(
                children: [
                  Image.asset(
                    "${CommonPath.iconPath}/ic_star.png",
                    height: size.width * numD06,
                  ),
                  SizedBox(height: size.width * numD01),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: state.movieDetail!.voteAverage
                              .toString()
                              .substring(0, 3),
                          style: TextStyle(
                            fontSize: size.width * numD035,
                            fontWeight: FontWeight.w600,
                            color: CommonColors.whiteColor,
                          ),
                        ),
                        TextSpan(
                          text: "/10",
                          style: TextStyle(
                            fontSize: size.width * numD03,
                            color: CommonColors.whiteColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CommonText(
                    title: ratingText,
                    fontSize: size.width * numD03,
                  ),
                ],
              ),
            ),

            /// Revenue
            Column(
              children: [
                Image.asset(
                  "${CommonPath.iconPath}/ic_dollar.png",
                  height: size.width * numD06,
                ),
                SizedBox(height: size.width * numD01),
                CommonText(
                  title: formatMoney(state.movieDetail!.revenue!.toDouble()),
                  fontSize: size.width * numD035,
                  fontWeight: FontWeight.w600,
                ),
                CommonText(
                  title: revenueText,
                  fontSize: size.width * numD03,
                ),
              ],
            ),

            /// Released
            Column(
              children: [
                Image.asset(
                  "${CommonPath.iconPath}/ic_released.png",
                  height: size.width * numD06,
                ),
                SizedBox(height: size.width * numD01),
                CommonText(
                  title: state.movieDetail!.status!,
                  fontSize: size.width * numD035,
                  fontWeight: FontWeight.w600,
                ),
                CommonText(
                  title: statusText,
                  fontSize: size.width * numD03,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Popular Cast Widget
  Widget popularCastWidget(Size size, int length, MovieDetailCubit cubitData) {
    // to minimise the no of cast & crew =
    if (length > 5) length = 5;
    return BlocBuilder<MovieDetailCubit, MovieDetailState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * numD01),
                decoration:
                    commonBoxDecoration(size: size, borderRadius: numD015),
                child: InkWell(
                  onTap: () {
                    cubitData.fetchPersonDetailApi(
                        state.movieCredits!.cast![index].id!);
                    popularCastCrewDetailsBottomSheet(size, context, cubitData);
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(size.width * numD013),
                          topRight: Radius.circular(size.width * numD013),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              "${CommonPath.itemImagePath}${state.movieCredits!.cast![index].profilePath}",
                          fit: BoxFit.cover,
                          height: size.height * numD2,
                          width: size.width * numD35,
                          placeholder: (context, url) => SizedBox(
                            width: size.width * numD31,
                            height: size.height * numD205,
                            child: commonShimmerEffect(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(size.width * numD01),
                        child: CommonText(
                          title: state.movieCredits!.cast![index].name!,
                          fontSize: size.width * numD035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Popular Crew Widget
  Widget popularCrewWidget(Size size, int length, MovieDetailCubit cubitData) {
    // to minimise the no of cast & crew =
    if (length > 5) length = 5;
    return BlocBuilder<MovieDetailCubit, MovieDetailState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(
              length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * numD01),
                decoration:
                    commonBoxDecoration(size: size, borderRadius: numD015),
                child: InkWell(
                  onTap: () {
                    cubitData.fetchPersonDetailApi(
                        state.movieCredits!.crew![index].id!);
                    popularCastCrewDetailsBottomSheet(size, context, cubitData);
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(size.width * numD013),
                          topRight: Radius.circular(size.width * numD013),
                        ),
                        child: CachedNetworkImage(
                          imageUrl:
                              "${CommonPath.itemImagePath}${state.movieCredits!.crew![index].profilePath}",
                          fit: BoxFit.cover,
                          height: size.height * numD2,
                          width: size.width * numD35,
                          placeholder: (context, url) => SizedBox(
                            width: size.width * numD31,
                            height: size.height * numD205,
                            child: commonShimmerEffect(),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(size.width * numD01),
                        child: CommonText(
                          title: state.movieCredits!.crew![index].name!,
                          fontSize: size.width * numD035,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Popular Cast Details Bottom Sheet
  popularCastCrewDetailsBottomSheet(
      Size size, BuildContext context, MovieDetailCubit cubitData) {
    showModalBottomSheet(
        context: navigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: cubitData,
            child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
              builder: (context, state) {
                return Container(
                  width: size.width,
                  height: size.height * numD6,
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * numD015,
                    horizontal: size.width * numD045,
                  ),
                  decoration: BoxDecoration(
                    color: CommonColors.appThemeColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * numD095),
                      topRight: Radius.circular(size.width * numD095),
                    ),
                  ),
                  child: state.showCastDetailsLoader!
                      ? commonLoader()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: bottomSheetLine(size),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width * numD01),
                                    decoration: commonBoxDecoration(
                                        size: size, borderRadius: numD015),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        size.width * numD013,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${CommonPath.itemImagePath}${state.personDetail!.profilePath}",
                                        fit: BoxFit.cover,
                                        height: size.height * numD2,
                                        width: size.width * numD35,
                                        placeholder: (context, url) =>
                                            commonLoader(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * numD01),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Dob: ",
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * numD033,
                                                    color:
                                                        CommonColors.whiteColor,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: state.personDetail!
                                                          .birthday!.isEmpty
                                                      ? ""
                                                      : DateFormat.yMMMMd()
                                                          .format(DateTime
                                                              .parse(state
                                                                  .personDetail!
                                                                  .birthday!)),
                                                  style: TextStyle(
                                                    color:
                                                        CommonColors.whiteColor,
                                                    fontSize:
                                                        size.width * numD04,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Name: ",
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * numD033,
                                                    color:
                                                        CommonColors.whiteColor,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      state.personDetail!.name!,
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * numD04,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        CommonColors.whiteColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Profession: ",
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * numD033,
                                                    color:
                                                        CommonColors.whiteColor,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: state.personDetail!
                                                      .knownForDepartment!,
                                                  style: TextStyle(
                                                    fontSize:
                                                        size.width * numD04,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        CommonColors.whiteColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              commonDivider(),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    state.personDetail!.biography!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: CommonTextStyle.fontFamily,
                                      fontSize: size.width * numD033,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                );
              },
            ),
          );
        });
  }

  /// Three dots Click Options
  moreOptionsBottomSheet(
      Size size, BuildContext context, MovieDetailCubit cubitData) {
    showModalBottomSheet(
        context: navigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: cubitData,
            child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
              builder: (context, state) {
                return Container(
                  width: size.width,
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * numD015,
                    horizontal: size.width * numD045,
                  ),
                  decoration: BoxDecoration(
                    color: CommonColors.appThemeColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * numD095),
                      topRight: Radius.circular(size.width * numD095),
                    ),
                  ),
                  child: state.showCastDetailsLoader!
                      ? commonLoader()
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: bottomSheetLine(size),
                              ),
                              SizedBox(height: size.height * numD02),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  websiteReviewsCollection(
                                      "ic_website.png",
                                      visitWebsiteText,
                                      size,
                                      cubitData, () async {
                                    if (!await launchUrl(Uri.parse(
                                        state.movieDetail!.homepage!))) {
                                      throw "Url not found";
                                    }
                                    Navigator.pop(navigatorKey.currentContext!);
                                  }),
                                  websiteReviewsCollection(
                                    "ic_reviews.png",
                                    reviewsText,
                                    size,
                                    cubitData,
                                    () {
                                      cubitData.fetchMovieReviewsApi(movieId);
                                      Navigator.pop(context);
                                      reviewsBottomSheet(
                                          size, context, cubitData);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: size.height * numD02),
                            ],
                          ),
                        ),
                );
              },
            ),
          );
        });
  }

  /// Website Reviews Collection
  Widget websiteReviewsCollection(String icon, String title, Size size,
      MovieDetailCubit cubitData, VoidCallback onTap) {
    return BlocBuilder<MovieDetailCubit, MovieDetailState>(
      builder: (context, state) {
        return Flexible(
          fit: FlexFit.loose,
          child: Column(
            children: [
              InkWell(
                onTap: onTap,
                child: Image.asset(
                  "${CommonPath.iconPath}/$icon",
                  color: title == visitWebsiteText
                      ? null
                      : CommonColors.whiteColor,
                  height: size.width * numD1,
                ),
              ),
              SizedBox(height: size.height * numD01),
              SizedBox(
                width: size.width * numD3,
                child: CommonText(
                  title: title,
                  fontSize: size.width * numD03,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Reviews Bottom Sheet
  reviewsBottomSheet(
      Size size, BuildContext context, MovieDetailCubit cubitData) {
    showModalBottomSheet(
      context: navigatorKey.currentContext!,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: cubitData,
          child: BlocBuilder<MovieDetailCubit, MovieDetailState>(
            builder: (context, state) {
              return Container(
                width: size.width,
                height: size.height * numD6,
                padding: EdgeInsets.symmetric(
                  vertical: size.height * numD015,
                  horizontal: size.width * numD045,
                ),
                decoration: BoxDecoration(
                  color: CommonColors.appThemeColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * numD095),
                    topRight: Radius.circular(size.width * numD095),
                  ),
                ),
                child: state.showMovieReviewsLoader!
                    ? commonLoader()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: bottomSheetLine(size),
                          ),
                          state.movieReviewsList!.isEmpty
                              ? Center(
                                  child: CommonText(
                                      title: noReviewsText,
                                      fontSize: size.width * numD05),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.movieReviewsList!.length,
                                    itemBuilder: (context, index) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "${CommonPath.iconPath}/ic_person.png"),
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  bottom: size.height * numD015,
                                                  left: size.width * numD02),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      size.width * numD03),
                                              decoration: BoxDecoration(
                                                color: CommonColors.greyColor
                                                    .withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.width * numD03),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        size.width * numD01,
                                                    vertical:
                                                        size.height * numD005),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      title: state
                                                          .movieReviewsList![
                                                              index]
                                                          .author!,
                                                      fontSize:
                                                          size.width * numD04,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    SizedBox(
                                                        height: size.height *
                                                            numD003),
                                                    ReadMoreText(
                                                      state
                                                          .movieReviewsList![
                                                              index]
                                                          .content!,
                                                      trimLines: 5,
                                                      colorClickableText:
                                                          CommonColors
                                                              .whiteColor,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText:
                                                          'Show more',
                                                      trimExpandedText:
                                                          'Show less',
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.width * numD03,
                                                        color: CommonColors
                                                            .whiteColor,
                                                      ),
                                                      moreStyle: TextStyle(
                                                        fontSize:
                                                            size.width * numD03,
                                                        color: CommonColors
                                                            .orangeColor
                                                            .withOpacity(0.8),
                                                      ),
                                                      lessStyle: TextStyle(
                                                        fontSize:
                                                            size.width * numD03,
                                                        color: CommonColors
                                                            .orangeColor
                                                            .withOpacity(0.8),
                                                      ),
                                                    ),
                                                    /*  CommonText(
                                                      title: state
                                                          .movieReviewsList![
                                                              index]
                                                          .content!,
                                                      fontSize:
                                                          size.width * numD03,
                                                      color: Colors.white,
                                                      maxLine: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ), */
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                        ],
                      ),
              );
            },
          ),
        );
      },
    );
  }
}
