import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widget/new_item.dart';

class GroceryItem extends StatefulWidget {
  const GroceryItem({super.key});

  @override
  State<GroceryItem> createState() => _GroceryItemState();
}

class _GroceryItemState extends State<GroceryItem> {
  final List<GroceryItems> _groceryitem=[];
  void _addpage()async {
  final saveddata=await  Navigator.of(context)
        .push<GroceryItems>(MaterialPageRoute(builder: (ctx) => const NewItem()));
        if(saveddata==null){
          return ;
        }
        setState(() {
          _groceryitem.add(saveddata);
        });
  }
  void _removeddata(GroceryItems item){
    _groceryitem.remove(item);
  }
  

  @override
  Widget build(BuildContext context) {
    Widget content =const Center(child: Text('no data find'),);
    if(_groceryitem.isNotEmpty){
      content=ListView.builder(
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
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _addpage, icon:const  Icon(Icons.add))],
        title: const Text('Your Groceries'),
      ),
      body: content
    );
  }
}
