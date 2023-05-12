import 'package:flutter/material.dart';
import 'package:travel_app/screens/search/widgets/package_widget.dart';
import 'package:travel_app/screens/search/widgets/place_widget.dart';
import 'package:travel_app/screens/search/widgets/user_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  String serachText = "";
  int slide = 0;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, left: 25, right: 25),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 4, right: 2),
              child: Row(
                children: [
                  const Icon(Icons.search, size: 26),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 30,
                    width: 220,
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        setState(() {
                          serachText = value;
                        });
                      },
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          TabBar(
            labelColor: Colors.black,
            controller: _tabController,
            tabs: const [
              Tab(
                text: 'Place',
              ),
              Tab(
                text: 'Package',
              ),
              Tab(
                text: 'User & Agency',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                const AllPlaces(),
                AllPackages(
                  package: serachText,
                ),
                AllUsers(
                  user: serachText,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
