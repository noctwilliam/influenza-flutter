import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:influenza/services/auth/auth_service.dart';
import 'package:influenza/services/cloud/firebase_cloud_storage.dart';

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
  final severityProvider = StateProvider<String>((ref) => '');

  Map<String, bool> symptoms = {
    "high_fever_(>_38_celcius)": false,
    "shortness_of_breath": false,
    "difficulty_breathing": false,
    "comorbidity": false,
    "loss_of_smell": false,
    "loss_of_taste": false,
    "muscle_aches": false,
    "cough": false,
    "coughing_with_blood": false,
    "dizziness_when_standing": false,
    "chest_pains": false,
    "diarrhea": false,
    "vomiting": false,
    "runny_nose": false,
    "sneezing": false
  };

  Future<String> makeRequest() async {
    String result = '', firebaseSeverity = '';
    var url = 'https://hrthimrn-influenza-severity.hf.space/predict';
    Map<String, int> symptomsForApi =
        symptoms.map((key, value) => MapEntry(key, value ? 1 : 0));
    Map<String, int> originalSymptoms =
        symptoms.map((key, value) => MapEntry(key, value ? 1 : 0));
    // remove symptoms that are not needed for the API request
    symptomsForApi.remove('high_fever_(>_38_celcius)');
    symptomsForApi.remove('comorbidity');
    symptomsForApi.remove('coughing_with_blood');
    symptomsForApi.remove('chest_pains');
    var body = jsonEncode(symptomsForApi);
    var response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    // error-handling
    if (response.statusCode == 200) {
      debugPrint('Success!');
      debugPrint(result);
      var apiResponse = jsonDecode(response.body);
      int severity = apiResponse['severity'];
      debugPrint(originalSymptoms.toString());
      if (severity == 0) {
        if (originalSymptoms['high_fever_(>_38_celcius)'] == 1 ||
            originalSymptoms['comorbidity'] == 1 ||
            originalSymptoms['coughing_with_blood'] == 1 ||
            originalSymptoms['chest_pains'] == 1) {
          result =
              'You have severe influenza symptoms, it is advisable to seek professional health immediately';
          firebaseSeverity = 'Severe';
        } else {
          result =
              'You have mild influenza symptoms, do recuperate well at home';
          firebaseSeverity = 'Not Severe';
        }
      } else {
        result =
            'You have severe influenza symptoms, it is advisable to seek professional health immediately';
        firebaseSeverity = 'Severe';
      }
    } else {
      result = 'A problem occur';
      debugPrint('Failed to make request.');
    }
    ref.read(textProvider.notifier).state = result;
    ref.read(severityProvider.notifier).state = firebaseSeverity;
    storeResultToFirebase();
    return firebaseSeverity;
  }

  void storeResultToFirebase() {
    final currentUser = AuthService.firebase().currentUser!;
    final firebaseCloudStorage = FirebaseCloudStorage();
    final severity = ref.read(severityProvider);
    firebaseCloudStorage.createNewHistory(
      ownerUserId: currentUser.id,
      severity: severity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = ref.watch(textProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Predict Severity'),
      ),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: makeRequest,
                  child: const Text('Predict'),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    if (text != 'Select your symptoms/condition') {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
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
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
