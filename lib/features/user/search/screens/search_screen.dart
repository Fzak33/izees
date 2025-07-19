import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/product_model.dart';
import '../../../../resources/strings_res.dart';
import '../../izees/screens/product_detailed_screen.dart';
import '../../izees/services/recommended/recommended_cubit.dart';
import '../services/search_services_cubit/search_cubit.dart';

class ProductSearchPage extends StatefulWidget {
  const ProductSearchPage({Key? key}) : super(key: key);

  @override
  _ProductSearchPageState createState() => _ProductSearchPageState();
}

class _ProductSearchPageState extends State<ProductSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // For pagination, if implemented

  @override
  void initState() {
    super.initState();
    // Listen to changes in the text field and send them to the Cubit
    _searchController.addListener(() {
      final query = _searchController.text.trim();
      context.read<SearchCubit>().onSearchChanged(query);
    });

    // If implementing infinite scroll, add listener to scroll controller
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >=
    //           _scrollController.position.maxScrollExtent - 200 &&
    //       !_scrollController.position.outOfRange) {
    //     context.read<ProductSearchCubit>().loadMore();
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title:  Text(localization.productSearch),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            // Search Input Field with Clear Button
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: localization.searchProducts,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<SearchCubit>().onSearchChanged('');
                  },
                )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            // Search Results
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return  Center(
                      child: Text(localization.searchName),
                    );
                  } else if (state is SearchLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is SearchSuccess) {
                    if (state.products.isEmpty) {
                      return  Center(
                        child: Text(localization.noProductsFound),
                      );
                    }
                    return ListView.builder(
                      controller: _scrollController, // If using pagination
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return _buildProductItem(product , context);
                      },
                    );
                  } else if (state is SearchFailure) {
                    return Center(
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(Product product, BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        onTap: (){
          Navigator.pushNamed(context, ProductDetailedScreen.routeName, arguments: product);
          context.read<RecommendedCubit>().recommended(category: product.category);
        },
        title: Text(product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${product.price.toStringAsFixed(2)} ${localization.jod} \n${product.description}',
       maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: true,
        trailing:Container(
          height: 100,
          width:  75,
          decoration:    BoxDecoration(
            shape: BoxShape.rectangle,
            image:  DecorationImage(image: NetworkImage("${StringsRes.uri}/${product.images[0]}") ,)  ,
          ),
        )
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose(); // If using pagination
    super.dispose();
  }
}