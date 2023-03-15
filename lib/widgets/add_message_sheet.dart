import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/feed_service.dart';

showAddMessageSheet(BuildContext context) {
  TextEditingController titleController = TextEditingController();
  var feedService = Provider.of<FeedService>(context, listen: false);
  return showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.all(10),
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 18),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Enter your Message",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: "Hi, this will be in the blockchain",
                  hintStyle: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
                onPressed: () {
                  feedService.addMessage(titleController.text);
                  Navigator.pop(context);
                },
                child: const SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Send message",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
