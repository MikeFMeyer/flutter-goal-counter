import 'package:gsheets/gsheets.dart';
import 'package:goalcounter/models/goals.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoalTrackerApi {
  static final _credentials = dotenv.env['CREDENTIALS'];
  static final _spreadsheetId = dotenv.env['SPREADSHEETID'] ?? '';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _goalSheet;

  static Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(_spreadsheetId);
      _goalSheet = await _getWorkSheet(spreadsheet, title: 'Goal_Tracker');

      final firstRow = GoalFields.getFields();
      _goalSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('Init Error: $e');
    }
  }

  static Future<Worksheet> _getWorkSheet(
    Spreadsheet spreadsheet, {
      required String title,
    }) async {
      try {
        return await spreadsheet.addWorksheet(title);
      } catch (e) {
        return spreadsheet.worksheetByTitle(title)!;
      }
    }
  
  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (_goalSheet == null) return;

    _goalSheet!.values.map.appendRows(rowList);
  }

  static Future<List<Goal>> getAll() async {
    if (_goalSheet == null) return <Goal>[];

    final goals = await _goalSheet!.values.map.allRows();

    return goals == null ? <Goal>[] : goals.map(Goal.fromJson).toList();
  }
}
