import 'package:flutter/material.dart';

class FaqView extends StatelessWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FAQ Page'),
        ),
        body: ListView(
          children: const [
            ListTile(
              title: Text('What is Influenza?', style: TextStyle(fontSize: 30)),
              subtitle: Text(
                'Influenza, commonly known as the flu, is a contagious respiratory illness caused by influenza viruses. It can cause mild to severe illness and can sometimes lead to complications, especially among vulnerable populations like seniors.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text('What are the symptoms of Influenza?',
                  style: TextStyle(fontSize: 30)),
              subtitle: Text(
                'The symptoms of influenza are similar to those of the common cold, but tend to be more severe. Symptoms include: fever, chills, cough, sore throat, runny or stuffy nose, muscle or body aches, headaches, fatigue, vomiting, and diarrhea.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text('How does Influenza spread?',
                  style: TextStyle(fontSize: 30)),
              subtitle: Text(
                'Influenza is spread through the air by coughing, sneezing, or talking. It can also be spread by touching a surface or object that has the virus on it and then touching your mouth, nose, or eyes.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text('How can I prevent Influenza?',
                  style: TextStyle(fontSize: 30)),
              subtitle: Text(
                "The best way to prevent influenza is to get vaccinated every year. The vaccine is available at your doctor's office, local pharmacy, or public health clinic. You can also prevent influenza by washing your hands often with soap and water, avoiding touching your eyes, nose, or mouth, and staying home when you are sick.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text(
                  'How does this app help in monitoring influenza symptoms??',
                  style: TextStyle(fontSize: 30)),
              subtitle: Text(
                'This app allows you to track and monitor your influenza symptoms over time. You can log your symptoms daily, record their severity, and track any changes in your condition with history viewing. This information can assist in self-assessment and provide valuable data for better understanding your health.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text('Can this app diagnose influenza??',
                  style: TextStyle(fontSize: 30)),
              subtitle: Text(
                "No, this app does not diagnose influenza. It helps in symptom screening and severity assessment.",
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text('How often should I log my symptoms?',
                  style: TextStyle(fontSize: 30)),
              subtitle: Text(
                'You can log your symptoms as frequently as you like, especially when you experience changes in how you feel. Daily tracking can provide a clearer picture of symptom progression.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text('Where can I get more information about influenza?',
                  style: TextStyle(fontSize: 30)),
              subtitle: Text(
                'For more detailed information about influenza, its prevention, and treatment, consult reputable healthcare sources or visit official health organization websites.',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ListTile(
              title: Text('Note', style: TextStyle(fontSize: 20)),
              subtitle: Text(
                'This app is not intended to be a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of your physician or other qualified health provider with any questions you may have regarding a medical condition.',
                style: TextStyle(fontSize: 18),
              ),
            )
          ],
        ));
  }
}
