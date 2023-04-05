import 'package:flutter/material.dart';
import 'package:state_management/business/my_bloc/state.dart';

import '../../business/my_bloc/bloc.dart';
import '../../business/my_bloc/events.dart';
import '../components/item_card.dart';

class MyBlocApp extends StatelessWidget {
  const MyBlocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple State Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final ItemBloc bloc;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    bloc = ItemBloc();
    bloc.action.add(LoadAllItems());
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Simple State App'),
        actions: [
          IconButton(
              onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              icon: const Icon(Icons.shopping_cart))
        ],
      ),
      endDrawer: Drawer(
        child: StreamBuilder<ItemState>(
            stream: bloc.state,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasData) {
                var data = snapshot.data;
                return ListView(
                  children: data!.cartItems
                      .map(
                        (item) => Card(
                          child: ListTile(
                            leading: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 80),
                              child: Image.asset(item.image),
                            ),
                            title: Text(item.title),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  bloc.action.add(RemoveItemFromCart(item)),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              } else {
                return Container();
              }
            }),
      ),
      body: Center(
        child: StreamBuilder<ItemState>(
          stream: bloc.state,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return ListView(
                children: data!.items
                    .map(
                      (item) => ListTile(
                        title: ItemCard(
                          id: item.id,
                          title: item.title,
                          description: item.description,
                          image: item.image,
                          onTap: () => bloc.action.add(AddItemToCart(item)),
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
