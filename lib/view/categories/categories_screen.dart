import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cubit_movie_app/utils/common_strings.dart';
import 'package:cubit_movie_app/utils/common_utils.dart';
import 'package:cubit_movie_app/utils/common_widgets.dart';
import 'package:cubit_movie_app/view/categories/categories_cubit.dart';
import 'package:cubit_movie_app/view/category_movies/category_movies_screen.dart';
import 'package:cubit_movie_app/view/movie_detail/movie_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocProvider(
        create: (context) => CategoriesCubit(),
        child: BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
          var cubitData = context.read<CategoriesCubit>();

          return state.showLoader!
              ? commonLoader()
              : SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * numD05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * numD055,
                        ),
                        CommonText(
                          title: whichCategoryToWatchText,
                          fontSize: size.width * numD055,
                          fontWeight: FontWeight.w500,
                        ),
                        // Use ListView.builder for the outer list
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.genreList!.length,
                          itemBuilder: (context, index) {
                            var genreItem = state.genreList![index];

                            return Padding(
                              padding:
                                  EdgeInsets.only(bottom: size.height * numD02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CommonText(
                                        title: genreItem.genreName!,
                                        fontSize: size.width * numD047,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(
                                        height: size.height * numD03,
                                        child: commonTextButton(
                                          onTap: () {
                                            Routes.instance.push(
                                                widget: CategoryMoviesScreen(
                                                  genreId: genreItem.genreId!,
                                                  categoryName:
                                                      genreItem.genreName!,
                                                ),
                                                context: context);
                                          },
                                          size: size,
                                          buttonText: "more...",
                                        ),
                                      ),
                                    ],
                                  ),
                                  // Use ListView.builder for the inner list
                                  SizedBox(
                                    height: size.height * numD23,
                                    child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemCount: min(
                                          5, genreItem.genreMoviesList!.length),
                                      itemBuilder: (context, index) {
                                        var genreMovieItem =
                                            genreItem.genreMoviesList![index];

                                        return InkWell(
                                          onTap: () {
                                            Routes.instance.push(
                                                widget: MovieDetailScreen(
                                                    movieId: genreMovieItem
                                                        .movieId!),
                                                context: context);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                    vertical:
                                                        size.height * numD003)
                                                .copyWith(
                                                    right: index != 4
                                                        ? size.width * numD02
                                                        : 0),
                                            decoration:
                                                commonBoxDecoration(size: size),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  "${CommonPath.itemImagePath}${genreMovieItem.moviePoster}",
                                              placeholder: (context, url) =>
                                                  SizedBox(
                                                width: size.width * numD31,
                                                child: commonShimmerEffect(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
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
                      ],
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
