import 'package:flutter/material.dart';
import 'package:shop/constants.dart';
import 'package:shop/models/category.dart';
import 'package:shop/screens/search/views/components/search_form.dart';
import 'package:shop/services/category_service.dart';
import 'package:shop/route/route_constants.dart'; // Import route constants

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late Future<List<Category>> futureCategories;
  final CategoryService categoryService = CategoryService();
  final Map<int, List<Category>> _subCategories = {};
  final Map<int, bool> _expandedCategories = {};

  @override
  void initState() {
    super.initState();
    futureCategories = categoryService.fetchCategoryParent();
  }

  Future<void> _loadSubCategories(int parentId) async {
    if (!_subCategories.containsKey(parentId)) {
      List<Category> subCategories = await categoryService.fetchCategoriesByParentId(parentId);
      setState(() {
        _subCategories[parentId] = subCategories;
      });
    }
  }

  void _navigateToBookmarkScreen(int categoryId) {
  print('Navigating to BookmarkScreen with categoryId: $categoryId'); 
  Navigator.pushNamed(
    context,
    bookmarkScreenRoute,
    arguments: {'categoryId': categoryId},
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: SearchForm(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding / 2),
              child: Text(
                "Parent Categories",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Category>>(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No categories found'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data![index];
                        final isExpanded = _expandedCategories[category.categoryId] ?? false;
                        return ExpansionTile(
                          title: Text(
                            category.categoryName,
                            style: TextStyle(
                              color: isExpanded ? Colors.blue : Colors.black,
                            ),
                          ),
                          backgroundColor: isExpanded ? Colors.blue.shade50 : Colors.transparent,
                          onExpansionChanged: (expanded) {
                            if (expanded) {
                              _loadSubCategories(category.categoryId);
                            }
                            setState(() {
                              _expandedCategories[category.categoryId] = expanded;
                            });
                          },
                          initiallyExpanded: isExpanded,
                          children: [
                            if (_subCategories.containsKey(category.categoryId))
                              ..._subCategories[category.categoryId]!.map((subCategory) {
                                return ListTile(
                                  title: Text(subCategory.categoryName),
                                  onTap: () => _navigateToBookmarkScreen(subCategory.categoryId),
                                );
                              }).toList()
                            else
                              const Center(child: CircularProgressIndicator()),
                          ],
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}