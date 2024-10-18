import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';import 'package:shop/services/category_service.dart';

import 'package:shop/models/category.dart';

import '../../../../constants.dart';

class Categories extends StatefulWidget {
  const Categories({
    super.key,
  });

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  late Future<List<Category>> futureCategories;
  final CategoryService categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    futureCategories = categoryService.fetchCategories(page: 1, limit: 50);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Category>>(
      future: futureCategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No categories found'));
        } else {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: defaultPadding, right: defaultPadding / 2),
                  child: CategoryBtn(
                    category: "All Categories",
                    svgSrc: null, // Update this if you have svgSrc for "All Categories"
                    isActive: true, // Set this to true if you want "All Categories" to be active by default
                    press: () {
                      // Handle navigation or other actions here
                    },
                  ),
                ),
                ...List.generate(
                  snapshot.data!.length,
                  (index) => Padding(
                    padding: EdgeInsets.only(
                        left: defaultPadding / 2,
                        right: index == snapshot.data!.length - 1
                            ? defaultPadding
                            : 0),
                    child: CategoryBtn(
                      category: snapshot.data![index].categoryName,
                      svgSrc: null, // Update this if you have svgSrc in your API response
                      isActive: false,
                      press: () {
                        // Handle navigation or other actions here
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}

class CategoryBtn extends StatelessWidget {
  const CategoryBtn({
    super.key,
    required this.category,
    this.svgSrc,
    required this.isActive,
    required this.press,
  });

  final String category;
  final String? svgSrc;
  final bool isActive;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        decoration: BoxDecoration(
          color: isActive ? primaryColor : Colors.transparent,
          border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : Theme.of(context).dividerColor),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            if (svgSrc != null)
              SvgPicture.asset(
                svgSrc!,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : Theme.of(context).iconTheme.color!,
                  BlendMode.srcIn,
                ),
              ),
            if (svgSrc != null) const SizedBox(width: defaultPadding / 2),
            Text(
              category,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? Colors.white
                    : Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}