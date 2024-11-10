import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<Map<String, dynamic>> _items = [];
  final _shopBox = Hive.box('show_box');
  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() {
    final data = _shopBox.keys.map((key) {
      final item = _shopBox.get(key);
      if (item is Map) {
        return {
          "key": key,
          "name": item["name"] ?? "Unnamed",
          "quantity": item["quantity"] ?? 0
        };
      }
      return {"key": key, "name": "Unnamed", "quantity": 0};
    }).toList();

    setState(() {
      _items = data.reversed.toList();
    });
  }

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _shopBox.add(newItem);
    _refreshItems();
  }
  Future<void> _updateItem(int itemKey, Map<String, dynamic> item) async {
    await _shopBox.put(itemKey, item);
    _refreshItems();
  }
  Future<void> _deleteItem(int itemKey) async {
    await _shopBox.delete(itemKey);
    _refreshItems();
  }

  void _showDeleteDialog(BuildContext context, int itemKey) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteItem(itemKey);
                Navigator.of(context).pop();
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }


  void _showForm(BuildContext ctx, int? itemKey) async {

    if(itemKey != null){
      final existingItem = 
          _items.firstWhere((element) => element['key'] == itemKey);
      _nameController.text = existingItem['name'];
      _quantityController.text = existingItem['quantity'];
    }
    showModalBottomSheet(
        context: ctx,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 15,
            left: 15,
            right: 15
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Name'
                ),
              ),
              const SizedBox(height: 10,),
              TextField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'quantity'
                ),
              ),
              const SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: () async {
            if(itemKey == null) {
            _createItem({
            'name': _nameController.text,
            'quantity': _quantityController.text
            });
            }
                    if(itemKey != null) {
                      _updateItem(itemKey, {
                        'name': _nameController.text.trim(),
                        'quantity': _quantityController.text.trim()
                      });
                    }
                    _nameController.text = '';
                    _quantityController.text = '';

                Navigator.of(context).pop();
              },
                  child: Text(itemKey == null ? 'Create New' : 'Update'),
              ),
              const SizedBox(height: 15,),
            ],
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Database'),
      ),
      body: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (_, index) {
              final currentItem = _items[index];
              return Card(
                color: Colors.orange,
                margin: EdgeInsets.all(10),
                elevation: 3,
                child: ListTile(
                  title: Text(currentItem['name']),
                  subtitle: Text(currentItem['quantity'].toString()),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                          onPressed: () =>
                        _showForm(context, currentItem['key']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _showDeleteDialog(context, currentItem['key']),
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context, null),
        child: Icon(Icons.add),
      ),
    );
  }
}
