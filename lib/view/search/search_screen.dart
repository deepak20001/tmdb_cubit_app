import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubit_movie_app/main.dart';
import 'package:cubit_movie_app/view/movie_detail/movie_detail_screen.dart';
import 'package:cubit_movie_app/view/search/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../utils/common_strings.dart';
import '../../utils/common_utils.dart';
import '../../utils/common_widgets.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slideAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(controller);
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocProvider(
        create: (context) => SearchCubit(),
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            var cubitData = context.read<SearchCubit>();

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * numD05)
                  .copyWith(
                top: size.height * numD065,
              ),
              child: Column(
                children: [
                  SlideTransition(
                    position: slideAnimation,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: CommonTextFormField(
                            size: size,
                            hintText: searchText,
                            autofocus: true,
                            textCapitalization: TextCapitalization.sentences,
                            suffixIcon: IconButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel_rounded,
                                color: CommonColors.greyColor,
                                size: size.width * numD08,
                              ),
                            ),
                            onChange: (val) {
                              cubitData.updateSearchMovieName(val);
                            },
                            controller: cubitData.searchController,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: size.width * numD01),
                            child: GestureDetector(
                              onTap: () {
                                filterBottomSheet(size, context, cubitData);
                              },
                              child: Image.asset(
                                "${CommonPath.iconPath}/ic_filter.png",
                                color: CommonColors.whiteColor,
                                height: size.height * numD04,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  cubitData.searchController.text.isEmpty
                      ? Column(
                          children: [
                            SizedBox(height: size.height * numD01),
                            CommonText(
                              title: whatToWatchText,
                              fontSize: size.width * numD055,
                              fontWeight: FontWeight.w500,
                            ),
                            Lottie.asset(
                                "${CommonPath.animationPath}/search.json",
                                height: size.height * numD3),
                          ],
                        )
                      : state.isSearchLoading!
                          ? Padding(
                              padding:
                                  EdgeInsets.only(top: size.height * numD04),
                              child: Lottie.asset(
                                  "${CommonPath.animationPath}/search.json",
                                  height: size.height * numD3),
                            )
                          : state.searchMoviesList!.isEmpty
                              ? Lottie.asset(
                                  "${CommonPath.animationPath}/no_results_found.json",
                                  height: size.height * numD3,
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: state.searchMoviesList!.length,
                                    itemBuilder: (context, index) {
                                      var item = state.searchMoviesList![index];

                                      return InkWell(
                                        onTap: () {
                                          Routes.instance.push(
                                              widget: MovieDetailScreen(
                                                  movieId: item.movieId!),
                                              context: context);
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: size.height * numD01),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                decoration: commonBoxDecoration(
                                                    size: size),

                                                /// Cached Network Image
                                                child: CachedNetworkImage(
                                                  height: size.height * numD15,
                                                  width: size.width * numD22,
                                                  fit: BoxFit.cover,
                                                  imageUrl:
                                                      "${CommonPath.itemImagePath}/${item.posterPath}",
                                                  placeholder: (context, url) =>
                                                      SizedBox(
                                                    width: size.width * numD31,
                                                    height:
                                                        size.height * numD205,
                                                    child:
                                                        commonShimmerEffect(),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: size.width * numD05),
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    CommonText(
                                                      title: item.movieTitle!,
                                                      fontSize:
                                                          size.width * numD04,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    CommonText(
                                                      title: item.releaseDate!
                                                              .isNotEmpty
                                                          ? DateFormat('yyyy')
                                                              .format(
                                                              DateTime.parse(item
                                                                  .releaseDate!),
                                                            )
                                                          : "",
                                                      fontSize:
                                                          size.width * numD035,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          "${CommonPath.iconPath}/ic_star.png",
                                                          height: size.width *
                                                              numD04,
                                                        ),
                                                        SizedBox(
                                                            width: size.width *
                                                                numD01),
                                                        Text.rich(
                                                          TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: item
                                                                    .voteCount
                                                                    .toString()
                                                                    .substring(
                                                                        0, 3),
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .width *
                                                                      numD035,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: CommonColors
                                                                      .whiteColor,
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: "/10",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: size
                                                                          .width *
                                                                      numD03,
                                                                  color: CommonColors
                                                                      .whiteColor,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// FILTER BOTTOM SHEET
  filterBottomSheet(Size size, BuildContext context, SearchCubit cubitData) {
    showModalBottomSheet(
        context: navigatorKey.currentContext!,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        useRootNavigator: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: cubitData,
            child: BlocBuilder<SearchCubit, SearchState>(
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
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * numD01)
                            .copyWith(bottom: size.height * numD005),
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
                          children: [
                            SizedBox(
                              width: size.width * numD3,
                              child: CommonText(
                                title: "Sort by: ",
                                fontSize: size.width * numD04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: CommonDropdown<String>(
                                size: size,
                                items: const ['Popularity', 'Rating'],
                                value: state.sortBySelectedValue,
                                onChanged: (value) {
                                  cubitData.selectedValueFromDropdown(
                                      0, value!);
                                },
                                hintText: 'Select an option',
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * numD01,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * numD3,
                              child: CommonText(
                                title: "Genres: ",
                                fontSize: size.width * numD04,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: CommonDropdown<String>(
                                size: size,
                                items: const [
                                  'All',
                                  'Action',
                                  'Adventure',
                                  'Animation',
                                  'Comedy',
                                  'Horror',
                                  'Romance',
                                  'Science Fiction',
                                  'Thriller',
                                  'War',
                                ],
                                value: state.genreSelectedValue,
                                onChanged: (value) {
                                  cubitData.selectedValueFromDropdown(
                                      1, value!);
                                },
                                hintText: 'Select an option',
                              ),
                            ),
                          ],
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
}
