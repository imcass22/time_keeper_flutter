import 'package:flutter/material.dart';
import '../cloud/cloud_note.dart';

typedef NoteCallback = void Function(CloudNote text);

class UserTextListView extends StatelessWidget {
  final Iterable<CloudNote> text;
  final NoteCallback onDeleteText;

  const UserTextListView({
    super.key,
    required this.text,
    required this.onDeleteText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: text.length,
        itemBuilder: (context, index) {
          final userText = text.elementAt(index);
          return Column(
            children: [
              ListTile(
                title: Text('Regular Hours: ${userText.documentId[index]}'),
              )
            ],
          );
        },
      ),
    );
  }
}
