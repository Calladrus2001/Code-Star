
# Code:Star (App)

Dyslexia is a major barrier in the learning process of students as it affects various cognitive functions. It's not just about being unable to decipher text: Its more than that.

This App enables Dyslexic Students to keep up with their peers in the short-term as well as learn to subside this adverse condition by training themselves in the long-term.

Students can generate **Audiobooks** for their notes by uploading the respective images. They can also train by attempting the **Transcription test** and the **Hearing Test**.
## Tech Stack

**Client:** Flutter

**Client Plugins:** Google MLKit Text Recognition, Firebase Storage, Text-to-Speech, AudioPlayer

**APIs:** Dialogflow, Places API

**Server:** [GitHub Repo link](https://github.com/Calladrus2001/CodeStar-Backend)


## Installation

Clone this Repository and run `flutter pub get` in the project root directory to install all the dependencies. Follow the installation guide for the **Backend** as well because both function concurrently.

You will also need a **Firebase** account and would need to initialise a project here. Go to [Firebase's official site](https://firebase.google.com).

Since this year's Google I/O, the process of initialising Firebase in your project as been made much simpler. Just install the **FlutterFire CLI** by running:

`dart pub global activate flutterfire_cli`

Following which, run `flutterfire configure` to select a project and it's target platforms. Now go back to [Firebase console](https://console.firebase.google.com/u/0/) and enable **Firebase Storage**.
## Demo

[Presentation Video](https://youtu.be/DeV6T9TCAzg) [Demo Video](https://youtu.be/AxHoiOyVks4)


## Diagrams
Technical Architecture Diagram:
[Technical Architecture Diagram](https://drive.google.com/file/d/1TWXRNlNP5wu570d1JdN8t6lYBUZYDzcp/view?usp=share_link)


## Code:Star (Backend)

The App is just one part of the project, it also has a Node.js based backend. [GitHub Repo link](https://github.com/Calladrus2001/CodeStar-Backend)


## Acknowledgements
This project couldn't have been made if not for the resources below.

Youtube Videos:
- [Text Extraction from Image](https://www.youtube.com/watch?v=jZqTjFOxiC4&t=286s)
- [Audioplayer in Flutter](https://www.youtube.com/watch?v=MB3YGQ-O1lk)

Pub.dev Documentation:
- [Text-to-Speech](https://pub.dev/packages/text_to_speech)


