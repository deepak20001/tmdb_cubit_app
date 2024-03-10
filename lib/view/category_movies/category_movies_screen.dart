import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubit_movie_app/utils/common_strings.dart';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/common_widgets.dart';
import 'package:cubit_movie_app/view/category_movies/category_movies_cubit.dart';
import 'package:cubit_movie_app/view/movie_detail/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CategoryMoviesScreen extends StatelessWidget {
  const CategoryMoviesScreen(
      {super.key, required this.genreId, required this.categoryName});
  final int genreId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    errorLog(genreId);
    final ScrollController scrollController = ScrollController();

    return Scaffold(
      appBar: commonAppBar(
        size: size,
        appBarTitle: categoryName,
        showBackButton: true,
        onTapBack: () {
          Navigator.pop(context);
        },
      ),
      body: BlocProvider(
        create: (context) => CategoryMoviesCubit(
          genreId: genreId,
          scrollController: scrollController,
        ),
        child: BlocBuilder<CategoryMoviesCubit, CategoryMoviesState>(
          builder: (context, state) {
            var cubitData = context.read<CategoryMoviesCubit>();

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Column(
                children: [
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * numD015)
                            .copyWith(
                      top: size.width * numD02,
                    ),
                    shrinkWrap: true,
                    itemCount: state.specificGenreMoviesList!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.5,
                    ),
                    itemBuilder: (context, index) {
                      var item = state.specificGenreMoviesList![index];

                      printDataLog(item);

                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: size.width * numD01,
                            vertical: size.height * numD006),
                        padding: EdgeInsets.all(size.width * numD006),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(size.width * numD01),
                          boxShadow: [
                            BoxShadow(
                              color: CommonColors.appThemeColor.withOpacity(1),
                              offset: const Offset(0, 6),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                Routes.instance.push(
                                    widget: MovieDetailScreen(
                                        movieId: item.movieId!),
                                    context: context);
                              },
                              child: Container(
                                decoration: commonBoxDecoration(size: size),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://image.tmdb.org/t/p/original${item.moviePoster}",
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
                              title: item.movieTitle!,
                              fontSize: size.width * numD033,
                              maxLine: null,
                            ),
                            Expanded(
                              child: RatingBar.builder(
                                initialRating: item.movieRating! / 2.0,
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
                        ),
                      );
                    },
                  ),
                  if (state.showLoader! &&
                      cubitData.pageNumber != 0 &&
                      cubitData.pageNumber != 5)
                    Padding(
                      padding: EdgeInsets.all(size.width * numD01),
                      child: commonLoader(),
                    ),
                ],
              ),
            );
          },
        ),
      ),

      /*  ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: specificGenreMoviesList!.length,
        itemBuilder: (context, index) {
          var genreMovieItem = specificGenreMoviesList![index];

          return InkWell(
            onTap: () {
              Routes.instance.push(
                  widget: MovieDetailScreen(movieId: genreMovieItem.movieId!),
                  context: context);
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: size.height * numD003)
                  .copyWith(right: index != 4 ? size.width * numD02 : 0),
              decoration: commonBoxDecoration(size: size),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl:
                    "${CommonPath.itemImagePath}${genreMovieItem.moviePoster}",
                placeholder: (context, url) => Padding(
                  padding: EdgeInsets.all(size.width * numD035),
                  child: const Center(
                      child: CircularProgressIndicator(
                    color: CommonColors.whiteColor,
                  )),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          );
        },
      ),
     */
    );
  }
}
