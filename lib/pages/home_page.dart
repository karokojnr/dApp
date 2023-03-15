import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/feed_service.dart';
import '../widgets/add_message_sheet.dart';
import '../widgets/glass_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var feedService = Provider.of<FeedService>(context, listen: true);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("dApp Feed"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () => showAddMessageSheet(context),
        child: const Icon(Icons.add),
      ),
      body: feedService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                const SizedBox(height: 15),
                Expanded(
                  child: ListView.builder(
                    itemCount: feedService.messages.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GlassListTile(
                        title: Text(feedService.messages[index].message),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
