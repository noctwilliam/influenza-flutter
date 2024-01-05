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
    // var severityLevel = makeRequest();
  }

  Map<String, bool> symptoms = {
    "cough": false,
    "muscle_aches": false,
    "tiredness": false,
    "sore_throat": false,
    "runny_nose": false,
    "stuffy_nose": false,
    "fever": false,
    "fever_above_38_celcius": false,
    "nausea": false,
    "vomiting": false,
    "diarrhea": false,
    "shortness_of_breath": false,
    "difficulty_breathing": false,
    "loss_of_taste": false,
    "loss_of_smell": false,
    "sneezing": false,
    "comorbidity": false,
  };

  Future<String> makeRequest() async {
    String result = '';
    var url = 'http://127.0.0.1:8000/predict';
    Map<String, int> symptomsForApi =
        symptoms.map((key, value) => MapEntry(key, value ? 1 : 0));
    symptomsForApi.remove('fever_above_38_celcius');
    symptomsForApi.remove('comorbidity');
    var body = jsonEncode(symptomsForApi);
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    // error-handling
    if (response.statusCode == 200) {
      debugPrint('Success!');
    } else {
      debugPrint('Failed to make request.');
      // Use `symptomsForApi` as the body of your request
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Select your symptoms/condition',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: symptoms.length,
              // shrinkWrap: true,
              itemBuilder: (context, index) {
                final symptomKey = symptoms.keys.elementAt(index);
                final formattedSymptomKey =
                    symptomKey.replaceAll('_', ' ').capitalize();
                return ListTile(
                  title: Text(formattedSymptomKey),
                  trailing: Checkbox(
                    value: symptoms.values.elementAt(index),
                    onChanged: (value) {
                      setState(() {
                        symptoms[symptomKey] = value!;
                      });
                    },
                  ),
                );
              }),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                // var severityLevel = makeRequest();
                debugPrint(symptoms.toString());
              },
              child: const Text('Predict'),
            ),
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
