import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

class PredictView extends ConsumerStatefulWidget {
  const PredictView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PredictViewState();
}

class _PredictViewState extends ConsumerState<PredictView> {
  @override
  void initState() {
    super.initState();
    var severityLevel = makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<String> makeRequest() async {
  var url = 'http://127.0.0.1:8000/40';
  var body = {
    "cough": 1,
    "muscle_aches": 1,
    "tiredness": 1,
    "sore_throat": 0,
    "runny_nose": 1,
    "stuffy_nose": 1,
    "fever": 0,
    "nausea": 0,
    "vomiting": 1,
    "diarrhea": 0,
    "shortness_of_breath": 0,
    "difficulty_breathing": 1,
    "loss_of_taste": 1,
    "loss_of_smell": 0,
    "sneezing": 0
  };

  var response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: json.encode(body),
  );

  if (response.statusCode == 200) {
    debugPrint('Success!');
  } else {
    debugPrint('Failed to make request.');
  }
  return jsonDecode(response.body);
}
