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
  }

  final textProvider =
      StateProvider<String>((ref) => 'Select your symptoms/condition');

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
    var url = 'https://hrthimrn-influenza-severity.hf.space/predict';
    Map<String, int> symptomsForApi =
        symptoms.map((key, value) => MapEntry(key, value ? 1 : 0));
    Map<String, int> originalSymptoms =
        symptoms.map((key, value) => MapEntry(key, value ? 1 : 0));
    // remove symptoms that are not needed for the API request
    symptomsForApi.remove('fever_above_38_celcius');
    symptomsForApi.remove('comorbidity');
    var body = jsonEncode(symptomsForApi);
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    debugPrint(body);
    // error-handling
    if (response.statusCode == 200) {
      debugPrint('Success!');
      debugPrint(result);
      var apiResponse = jsonDecode(response.body);
      int severity = apiResponse['severity'];
      debugPrint(originalSymptoms.toString());
      if (severity == 0) {
        if (originalSymptoms['fever_above_38_celcius'] == 1 ||
            originalSymptoms['comorbidity'] == 1) {
          result =
              'You have severe influenza symptoms, it is advisable to seek professional health immediately';
        } else {
          result =
              'You have mild influenza symptoms, do recuperate well at home';
        }
      } else {
        result =
            'You have severe influenza symptoms, it is advisable to seek professional health immediately';
      }
    } else {
      result = 'A problem occur';
      debugPrint('Failed to make request.');
    }
    ref.read(textProvider.notifier).state = result;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final text = ref.watch(textProvider);
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                    setState(
                      () {
                        symptoms[symptomKey] = value!;
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: makeRequest,
                  child: const Text('Predict'),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    if (text != 'Select your symptoms/condition') {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            symptoms.forEach((key, value) {
                              symptoms[key] = false;
                            });
                          });
                          ref.read(textProvider.notifier).state =
                              'Select your symptoms/condition';
                        },
                        child: const Text('Reset'),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              ],
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
