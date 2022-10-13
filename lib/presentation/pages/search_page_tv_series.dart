import 'package:ditonton/presentation/bloc_movies/search_bloc/search_bloc.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/custom_information.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPageTvSeries extends StatelessWidget {
  static const ROUTE_NAME = '/searchTv';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onChanged: (query) {
                context.read<SearchBloc>().add(OnQueryChangedTv(query));
              },
              decoration: InputDecoration(
                hintText: 'Search Title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            SizedBox(height: 16),
            Text(
              'Search Result',
              style: kHeading6,
            ),
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SearchTvHasData) {
                  final result = state.resultTv;
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, index) {
                        final tv = result[index];
                        return TvCard(tv);
                      },
                      itemCount: result.length,
                    ),
                  );
                } else if (state is SearchError) {
                  return Expanded(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                } else {
                  return Expanded(
                    child: CustomInformation(
                      asset: 'assets/search.svg',
                      title: 'Pencarian tidak ditemukan',
                      subtitle: 'Coba cari lagi',
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
