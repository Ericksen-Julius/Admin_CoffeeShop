// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:io';

class AddMenuPage extends StatefulWidget {
  @override
  State<AddMenuPage> createState() => _AddMenuPageState();

  final String token;

  const AddMenuPage({super.key, required this.token});
}

class _AddMenuPageState extends State<AddMenuPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  int? _selectedCategoryId;
  File? _selectedImage;
  final picker = ImagePicker();

  // Placeholder for categories, replace with your actual categories data
  final List<Map<String, dynamic>> _categories = [
    {'id': 1, 'name': 'Food'},
    {'id': 2, 'name': 'Americano'},
    {'id': 3, 'name': 'Latte'},
    {'id': 4, 'name': 'Non Coffee'}
  ];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        debugPrint("huy ${_selectedImage!.path}");
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Validasi form dan kirim data
      try {
        final uri = Uri.parse('http://10.0.2.2:8000/api/menu');
        final request = http.MultipartRequest('POST', uri)
          ..fields['category_id'] = _selectedCategoryId.toString()
          ..fields['name'] = _nameController.text
          ..fields['description'] = _descController.text
          ..fields['price'] = _priceController.text
          ..headers.addAll({
            'Content-Type': 'multipart/form-data',
            'Authorization': 'Bearer ${widget.token}',
          });

        if (_selectedImage != null) {
          final mimeTypeData = lookupMimeType(_selectedImage!.path)?.split('/');
          if (mimeTypeData != null && mimeTypeData.length == 2) {
            request.files.add(await http.MultipartFile.fromPath(
              'image',
              _selectedImage!.path,
              contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
            ));
          }
        }

        final response = await request.send();

        if (response.statusCode == 201) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      "Success",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                  content: Text("Menu has been added successfully."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).pop(true);
                      },
                      child: Text("OK"),
                    )
                  ],
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    "Failed",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text("Sorry There's some trouble."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("OK"),
                    )
                  ],
                );
              });
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Failed",
                  style: TextStyle(color: Colors.red),
                ),
                content: Text(e.toString()),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("OK"),
                  )
                ],
              );
            });
      }
    }

    // void _submitForm() {
    //     // Handle form submission
    //     print('Name: ${_nameController.text}');
    //     print('Category ID: $_selectedCategoryId');
    //     print('Description: ${_descController.text}');
    //     print('Price: ${_priceController.text}');
    //     print('Image: $_selectedImage');
    //     // Add your API call or further processing here
    //   }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add New Menu Item',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      DropdownButtonFormField<int?>(
                        decoration: InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        value: _selectedCategoryId,
                        items: [
                          ..._categories.map((category) {
                            return DropdownMenuItem<int?>(
                              value: category['id'],
                              child: Text(category['name']),
                            );
                          }).toList()
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        minLines: 3,
                        maxLines: 6,
                        controller: _descController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                        controller: _priceController,
                        decoration: InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _selectedImage == null
                              ? Text('No image selected.')
                              : Image.file(
                                  _selectedImage!,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                          SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: _pickImage,
                            child: Text('Pick Image'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Add Menu'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 24.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
