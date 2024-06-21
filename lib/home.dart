import 'dart:convert';

import 'package:admin_shop/add_menu.dart';
import 'package:admin_shop/detail_menu.dart';
import 'package:admin_shop/edit_menu.dart';
import 'package:admin_shop/login.dart';
import 'package:admin_shop/main.dart';
import 'package:admin_shop/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:admin_shop/models/menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<Menu> menus = [];
  List<Category> categories = [];
  List<DropdownMenuItem<int?>> dropdownItems = []; // List of categories
  String searchQuery = '';
  int? selectedCategoryId;

  int _currentIndex = 0;
  bool isLoading = true; // Tambahkan variabel isLoading

  List<BottomNavigationBarItem> items = const [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.home_outlined,
        size: 25,
      ),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.logout,
        size: 25,
      ),
      label: "Logout",
    ),
  ];
  late List<Widget> pages;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    List<Menu> filteredMenus = menus
        .where((menu) =>
            (menu.name?.toLowerCase().contains(searchQuery.toLowerCase()) ??
                false) &&
            (selectedCategoryId == null ||
                menu.categoryId == selectedCategoryId))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home'),
        centerTitle: true,
      ),
      body: isLoading // Tampilkan loader jika isLoading true
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Search',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<int?>(
                          decoration: InputDecoration(
                            labelText: 'Select Category', // Label dropdown
                            border: OutlineInputBorder(), // Border
                            hintStyle: TextStyle(color: Colors.grey),
                          ),
                          value: selectedCategoryId,
                          items: dropdownItems,
                          padding: EdgeInsets.only(
                              right: 8.0,
                              top: 12.0, // Padding di sekitar input dropdown
                              bottom:
                                  12.0), // Padding di sekitar input dropdown
                          onChanged: (int? value) {
                            setState(() {
                              selectedCategoryId = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredMenus.length,
                    itemBuilder: (context, index) {
                      final menu = filteredMenus[index];
                      return Card(
                        color: Colors.lightBlueAccent,
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl:
                                'http://10.0.2.2:8000/storage/images/${menu.image}',
                            width: 50.0,
                            height: 50.0,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/default_image.jpg',
                              width: 50.0,
                              height: 50.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                              '${menu.name} - (${menu.category?.name ?? 'No Category'})'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Rp ${NumberFormat.decimalPattern('id').format(menu.price!)}'),
                              Text('Total Sold: ${menu.sold ?? 'N/A'}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.brown),
                                onPressed: () {
                                  _editMenu(menu);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _deleteMenu(menu);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MenuDetailAdminPage(
                                  menu: menu,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Increment',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMenuPage()),
          ).then((result) {
            if (result == true) {
              // Refresh or update your menu list here
              fetchData();
            }
          });
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 1) {
        _logout();
      } else {
        _currentIndex = index;
      }
    });
  }

  void _logout() async {
    const url = "http://10.0.2.2:8000/api/logout";
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${sp.getString('token')}'
      },
    );
    if (response.statusCode == 200) {
      sp.remove('token');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ),
      );
    }
  }

  void _editMenu(Menu menuu) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditMenuPage(
                menu: menuu,
              )),
    ).then((result) {
      if (result == true) {
        // Refresh or update your menu list here
        fetchData();
      }
    });
  }

  Future<void> _deleteMenu(Menu menu) async {
    final url = "http://10.0.2.2:8000/api/menu/${menu.id}";
    final uri = Uri.parse(url);
    try {
      final response = await http.delete(
        uri,
        headers: {
          'Content-type': 'application/json',
          'Authorization': "Bearer ${sp.getString('token')}"
        },
      );

      if (response.statusCode == 200) {
        fetchData();
      } else {
        // Handle other status codes, e.g., show error message
        print('Failed to delete menu: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that might occur during the HTTP request
      print('Exception occurred: $e');
    }
  }

  void fetchData() async {
    setState(() {
      isLoading = true; // Mulai pemuatan
    });

    const url = "http://10.0.2.2:8000/api/menu";
    final uri = Uri.parse(url);
    final response = await http.get(
      uri,
      headers: {
        'Content-type': 'application/json',
        'Authorization': "Bearer ${sp.getString('token')}"
      },
    );
    final body = response.body;
    final json = jsonDecode(body);
    setState(() {
      menus =
          (json['menu'] as List).map((item) => Menu.fromJson(item)).toList();
      categories = (json['category'] as List)
          .map((item) => Category.fromJson(item))
          .toList();
      dropdownItems = [
        DropdownMenuItem(
          value: null,
          child: Text('All Categories'),
        ),
        ...categories.map((Category category) {
          return DropdownMenuItem<int?>(
            value: category.id,
            child: Text(category.name ?? 'Unknown Category'),
          );
        }).toList()
      ];
      isLoading = false; // Selesai pemuatan
    });
  }
}
