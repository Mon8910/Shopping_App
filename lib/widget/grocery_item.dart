import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widget/new_item.dart';

class GroceryItem extends StatefulWidget {
  const GroceryItem({super.key});

  @override
  State<GroceryItem> createState() => _GroceryItemState();
}

class _GroceryItemState extends State<GroceryItem> {
  var isloading=true;
  String? error ;
  @override
  void initState() {
    super.initState();
    _loaddata();
  }

   List<GroceryItems> _groceryitem =[];
  // hna hshyl de 3shan dynamics
  // to send request create new method
  void _loaddata() async {
    final List<GroceryItems> loadlist = [];
    final url = Uri.https(
        'flutter-prep-7ce11-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(url);
    if(response.statusCode >=400){
      setState(() {
              error='please try again ';

      });
    

    }
    if(response.body=='null'){
        setState(() {
          isloading=false;
        });
        return;
      }
    final Map<String, dynamic> listdata =
        json.decode(response.body);
    for (final item in listdata.entries) {
      final category=categories.entries.firstWhere((catevlaue) =>catevlaue.value.id==item.value['category']).value;

      loadlist.add(
        GroceryItems(
            id: item.key
            ,
             name: item.value['name'], 
             quantity: item.value['quantity'], 
             category: category
             ),
      );
      
    }
    setState(() {
      _groceryitem=loadlist;
      isloading=false;
    });
    
  }

  void _addpage() async {
   final newitem= await Navigator.of(context).push<GroceryItems>(
        MaterialPageRoute(builder: (ctx) => const NewItem()));

        // hna h3ml condition hna 2no at2k mn el 7aga 2le hna bdl ma ady3 mkan 
       if(newitem==null){
        return ;
       }
       setState(() {
        _groceryitem.add(newitem);
         
       });
  }

  void _removeddata(GroceryItems item) async{
    setState(() {
      _groceryitem.remove(item);
    });

    final url=Uri.https('flutter-prep-7ce11-default-rtdb.firebaseio.com', 'shopping-list/${item.id}.json');
  
      http.delete(url);
    
    
   
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('no data find'),
    );
    if(isloading){
      content=const Center(child: CircularProgressIndicator(),);
    }
    if (_groceryitem.isNotEmpty) {
      content = ListView.builder(
        itemCount: _groceryitem.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) {
            _removeddata(_groceryitem[index]);
          },
          key: ValueKey(_groceryitem[index].id),
          child: ListTile(
            title: Text(_groceryitem[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: _groceryitem[index].category.color,
            )
            // 3shan 2dr atl3 el rakm hna w al container hna 3shan 2dr asht8l 3la color w a7dd leha mkan
            ,
            trailing: Text(
              _groceryitem[index].quantity.toString(),
            ), // 3shan 2dr atl3 el rakm hna
          ),
        ),

        // bt3mle el shkl 3la row bs zy fe morb3 tlama 3ozhm gnb b3d
      );
    }
    if(error!=null){
      content=Center(child: Text(error!),);
    }
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: _addpage, icon: const Icon(Icons.add))
          ],
          title: const Text('Your Groceries'),
        ),
        body: content);
  }
}
