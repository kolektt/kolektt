import 'package:flutter/cupertino.dart';

import 'genre_button.dart';

class GenreScrollView extends StatelessWidget {
  final List<String> genres;
  final ValueNotifier<String> selectedGenre;

  const GenreScrollView(
      {Key? key, required this.genres, required this.selectedGenre})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ValueListenableBuilder<String>(
        valueListenable: selectedGenre,
        builder: (context, genre, _) => ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: genres.length,
          separatorBuilder: (_, __) => SizedBox(width: 10),
          itemBuilder: (context, index) {
            final title = genres[index];
            return GenreButton(
              title: title,
              isSelected: genre == title,
              onPressed: () {
                selectedGenre.value = title;
              },
            );
          },
        ),
      ),
    );
  }
}
