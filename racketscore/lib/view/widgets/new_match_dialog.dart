import 'package:flutter/material.dart';


class CreateMatchDialog extends StatefulWidget {
  Function(String, String, String, int) onMatchCreated;

  CreateMatchDialog({super.key, required this.onMatchCreated});

  @override
  State<CreateMatchDialog> createState() => _CreateMatchDialogState();
}

class _CreateMatchDialogState extends State<CreateMatchDialog> {
  TextEditingController _textMatchNameController = TextEditingController();
  TextEditingController _textTeamAController = TextEditingController();
  TextEditingController _textTeamBController = TextEditingController();
  int _selectedNumber = 2;

  @override
  void dispose() {
    _textMatchNameController.dispose();
    _textTeamAController.dispose();
    _textTeamBController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Match'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textMatchNameController,
            decoration: InputDecoration(labelText: 'Match Name'),
          ),
          TextField(
            controller: _textTeamAController,
            decoration: InputDecoration(labelText: 'Team A'),
          ),
          TextField(
            controller: _textTeamBController,
            decoration: InputDecoration(labelText: 'Team B'),
          ),
          ListTile(
            title: Text('Sets to win'),
            trailing: DropdownButton<int>(
              value: _selectedNumber,
              onChanged: (int? newValue) {
                setState(() {
                  _selectedNumber = newValue ?? 2;
                });
              },
              items: <int>[2, 3].map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
        ),
        ElevatedButton(
          child: Text('Create'),
          onPressed: () {
            String matchName = _textMatchNameController.text;
            String teamA = _textTeamAController.text;
            String teamB = _textTeamBController.text;
            int setsToWin = _selectedNumber;
            Navigator.pop(context);
            widget.onMatchCreated(matchName, teamA, teamB, setsToWin);
          },
        ),
      ],
    );
  }
}