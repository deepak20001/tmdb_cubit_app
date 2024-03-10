import 'package:carousel_slider/carousel_slider.dart';
import 'package:cubit_movie_app/main.dart';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/common_widgets.dart';
import 'package:cubit_movie_app/view/home/home_cubit.dart';
import 'package:cubit_movie_app/view/movie_detail/movie_detail_screen.dart';
import 'package:cubit_movie_app/view/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/common_strings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabViewController;

  @override
  void initState() {
    super.initState();
    tabViewController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    /// SCAFFOLD
    return Scaffold(
      /// BODY
      body: BlocProvider(
        create: (context) => HomeCubit()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies()
          ..fetchUpcomingMovies()
          ..fetchTrendingMovies(),
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            var cubitData = context.read<HomeCubit>();

            return state.showPopularLoader!
                ? commonLoader()
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: size.height * numD055,
                              ),
                              CommonText(
                                title: whatToWatchText,
                                fontSize: size.width * numD055,
                                fontWeight: FontWeight.w500,
                              ),
                              SizedBox(height: size.height * numD03),
                              CommonTextFormField(
                                size: size,
                                hintText: searchText,
                                autofocus: false,
                                suffixIcon: IconButton(
                                  onPressed: () {},
                                  icon: SvgPicture.asset(
                                      "${CommonPath.iconPath}/ic_search.svg"),
                                ),
                                maxLines: 1,
                                onTap: () {
                                  Routes.instance.push(
                                      widget: const SearchScreen(),
                                      context: context);
                                },
                              ),
                              SizedBox(height: size.height * numD03),
                              CommonText(
                                title: popularText,
                                fontSize: size.width * numD045,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: size.height * numD02),

                        ///CarauselSlider
                        CarouselSlider.builder(
                          itemCount: state.popularMovieList!.length,
                          itemBuilder: (BuildContext context, int index,
                              int pageViewIndex) {
                            var item = state.popularMovieList![index];
                            printDataLog("ITEM :: $item");

                            return Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: CommonColors.greyColor),
                                      boxShadow: [
                                        BoxShadow(
                                          color: CommonColors.greyColor
                                              .withOpacity(0.5),
                                          blurRadius: 25.0,
                                        )
                                      ],
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Routes.instance.push(
                                            widget: MovieDetailScreen(
                                              movieId: item.id!,
                                            ),
                                            context: context);
                                      },
                                      child: CachedNetworkImage(
                                        height: size.height * numD90,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${CommonPath.itemImagePath}${item.backdropPath}",
                                        placeholder: (context, url) =>
                                            commonShimmerEffect(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * numD01),
                                CommonText(
                                  title: item.title!.toUpperCase(),
                                  fontSize: size.width * numD045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            );
                          },
                          options: CarouselOptions(
                            autoPlay: true,
                            height: size.height * numD3,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                          ),
                        ),

                        SizedBox(height: size.height * numD01),

                        /// TABBAR
                        TabBar(
                          controller: TabController(
                              initialIndex: state.selectedTab!,
                              length: state.requestTabList!.length,
                              vsync: this),
                          onTap: (value) {
                            cubitData.onSelectTab(value);
                          },
                          isScrollable: true,
                          indicatorColor: CommonColors.appThemeColor,
                          tabAlignment: TabAlignment.start,
                          padding: EdgeInsets.only(left: size.width * numD04),
                          indicatorPadding: EdgeInsets.zero,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: size.width * numD01),
                          dividerColor: Colors.transparent,
                          tabs: List.generate(
                            state.requestTabList!.length,
                            (index) => InkWell(
                              onTap: () {
                                cubitData.onSelectTab(index);
                                debugPrint(
                                    cubitData.state.selectedTab.toString());
                              },
                              child: Container(
                                padding: EdgeInsets.all(size.width * numD023),
                                child: CommonText(
                                  title: state.requestTabList![index].title,
                                  fontSize: size.width * numD035,
                                  color: CommonColors.whiteColor,
                                  fontWeight:
                                      state.requestTabList![index].isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ),

                        ///
                        movieCategoryWidget(size, cubitData),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  /// Movie Category
  Widget movieCategoryWidget(var size, HomeCubit cubitData) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding:
                EdgeInsets.symmetric(horizontal: size.width * numD015).copyWith(
              top: size.width * numD02,
            ),
            shrinkWrap: true,
            itemCount: state.selectedTab == 0
                ? state.topRatedMovieList!.length
                : state.selectedTab == 1
                    ? state.upcomingMovieList!.length
                    : state.trendingMovieList!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              // crossAxisSpacing: size.width * numD001,
              crossAxisCount: 3,
              childAspectRatio: 0.5,
              // mainAxisSpacing: size.width * numD1,
            ),
            itemBuilder: (context, index) {
              var item = state.selectedTab == 0
                  ? state.topRatedMovieList![index]
                  : state.selectedTab == 1
                      ? state.upcomingMovieList![index]
                      : state.trendingMovieList![index];

              printDataLog(item);

              return Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * numD01,
                      vertical: size.height * numD006),
                  padding: EdgeInsets.all(size.width * numD006),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(size.width * numD01),
                    boxShadow: [
                      BoxShadow(
                        color: CommonColors.appThemeColor.withOpacity(1),
                        offset: const Offset(0, 6),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: state.selectedTab == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Routes.instance.push(
                                    widget:
                                        MovieDetailScreen(movieId: item.id!),
                                    context: context);
                              },
                              child: Container(
                                decoration: commonBoxDecoration(size: size),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/original${item.posterPath}",
                                  placeholder: (context, url) => SizedBox(
                                    width: size.width * numD31,
                                    height: size.height * numD205,
                                    child: commonShimmerEffect(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * numD01),
                            CommonText(
                              title: item.title!,
                              fontSize: size.width * numD033,
                              maxLine: null,
                            ),
                            Expanded(
                              child: RatingBar.builder(
                                initialRating: item.voteAverage! / 2.0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                unratedColor: CommonColors.whiteColor,
                                itemCount: 5,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 0.0)
                                        .copyWith(
                                  top: size.height * numD015,
                                ),
                                itemSize: size.width * numD04,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: size.width * numD001,
                                ),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                            ),
                          ],
                        )
                      : state.selectedTab == 1
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Routes.instance.push(
                                        widget: MovieDetailScreen(
                                            movieId: item.id!),
                                        context: context);
                                  },
                                  child: Container(
                                    decoration: commonBoxDecoration(size: size),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://image.tmdb.org/t/p/original${item.posterPath}",
                                      placeholder: (context, url) => SizedBox(
                                        width: size.width * numD31,
                                        height: size.height * numD205,
                                        child: commonShimmerEffect(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * numD01),
                                CommonText(
                                  title: item.title!,
                                  fontSize: size.width * numD033,
                                  maxLine: null,
                                ),
                                Expanded(
                                  child: RatingBar.builder(
                                    initialRating: item.voteAverage! / 2.0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    unratedColor: CommonColors.whiteColor,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 0.0)
                                        .copyWith(
                                      top: size.height * numD015,
                                    ),
                                    itemSize: size.width * numD04,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: size.width * numD001,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Routes.instance.push(
                                        widget: MovieDetailScreen(
                                            movieId: item.id!),
                                        context: context);
                                  },
                                  child: Container(
                                    decoration: commonBoxDecoration(size: size),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "https://image.tmdb.org/t/p/original${item.posterPath}",
                                      placeholder: (context, url) => SizedBox(
                                        width: size.width * numD31,
                                        height: size.height * numD205,
                                        child: commonShimmerEffect(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                SizedBox(height: size.height * numD01),
                                CommonText(
                                  title: item.title!,
                                  fontSize: size.width * numD033,
                                  maxLine: null,
                                ),
                                Expanded(
                                  child: RatingBar.builder(
                                    initialRating: item.voteAverage! / 2.0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    unratedColor: CommonColors.whiteColor,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 0.0)
                                        .copyWith(
                                      top: size.height * numD015,
                                    ),
                                    itemSize: size.width * numD04,
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: size.width * numD001,
                                    ),
                                    onRatingUpdate: (rating) {
                                      // print(rating);
                                    },
                                  ),
                                ),
                              ],
                            ));
            });
      },
    );
  }

  ///
}
