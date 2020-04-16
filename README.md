# One on one chat app with Stream
A chat app that enables a logged-in user to chat with other users. You can follow the tutorial to build it here.

## Prerequisites

You need a [Stream app](https://getstream.io/) to successfully run this. You can create one when you signup. In addition to that, you need the following installed on your machine:

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [Android Studio](https://developer.android.com/studio/index) or [Visual Studio](https://code.visualstudio.com/download)
* [Node](http://nodejs.org)

## Getting Started

Clone the repository. The repository contains a `nodejs-backend` folder for the server and an `app` folder for the Flutter app. 

To get your server running, you need to do the following:
* Replace the key holders in the `index.js` file with the keys from your Stream app.

* Open the backend folder on your terminal and install the following dependencies:

```
npm install stream-chat express body-parser
```

* Run this command to get your server up: 

```
node index.js
```

To get your mobile app running, you need to do the following:
* Open the `app` directory in any IDE of your choice.
* Replace the `STREAM_API_KEY` in the `login_page.dart` with the API key from your Stream app.
* Replace the `url` variable on line 79 with the address of your server.
* Run your app.

## Built With

* [Flutter](https://flutter.dev/) - Used to build the cross-platform client
* [Stream](https://getstream.io/) - To power the chat functionalities. 
* [Node](http://nodejs.org) - Used to build the server.


## Acknowledgments
- Idorenyin Obong
