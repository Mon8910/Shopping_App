import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NewItemsState();
  }
}

class _NewItemsState extends State<NewItem> {
  var currentname = '';
  var currentnumber = 1;
  var currentcategory = categories[Categories.vegetables];
  var issending=false;
  final _formkey = GlobalKey<FormState>();
  void _saveditem() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        issending=true;
      });
      _formkey.currentState!.save();
      final url = Uri.https('flutter-prep-7ce11-default-rtdb.firebaseio.com',
          'shopping-list.json');
      final response = await http.post(url,
          headers: {'content-type': 'application/json'},
          body: json.encode({
            'name': currentname,
            'quantity': currentnumber,
            'category': currentcategory!.id
          }));
      final resData = json.decode(response.body);

      //print(response.statusCode); // de btl3 number
      // print(response.body); // de btl3 zy map feha name w string
      if (!context.mounted) {
        return;
      }
      // 3mlt de hna 3shan mstnash request 3la fade tlama ana gwoa .
      Navigator.of(context).pop(GroceryItems(
          id: resData['name'],
          name: currentname,
          quantity: currentnumber,
          category: currentcategory!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add a new items'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(label: Text('name')),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (value) {
                  currentname = value!;
                }, // 3shan at2k mn al 7aga w lw msln feh error yrg3 el error
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                      child: TextFormField(
                    decoration: const InputDecoration(label: Text('quantity')),
                    initialValue: currentnumber.toString(),
                    //maxLength: 20,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return 'enter valied number ';
                      }
                    },
                    onSaved: (value) {
                      currentnumber = int.parse(value!);
                    },
                  )),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: DropdownButtonFormField(
                          value: currentcategory,
                          items: [
                            for (final cate in categories
                                .entries) // entries hna bt7wl el map to list
                              DropdownMenuItem(
                                  value: cate.value,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 16,
                                        height: 16,
                                        color: cate.value.color,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(cate.value.id)
                                    ],
                                  ))
                          ],
                          onChanged: (value) {
                            setState(() {
                              currentcategory = value!;
                            });
                          }))
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: issending? null:
                      () {
                        _formkey.currentState!.reset();
                      },
                      child: const Text('Reset')),
                  ElevatedButton(
                      onPressed: issending ?null:
                      _saveditem, child:issending?const SizedBox(width: 16,height: 16,child: CircularProgressIndicator(),): const Text('add item'))
                ],
              )
            ],
          ),
        ),
      ), //
      //bsht8l bde lma ykon 3nde kza textfield f 3shan keda bnsht8l b de
    );
  }
}
