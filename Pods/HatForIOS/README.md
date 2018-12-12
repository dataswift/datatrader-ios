# HAT for iOS

## Overview
This libary contains all the API calls needed to communicate with the HAT

- Handle user Login
- Request tokens for the user or services like Facebook, Twitter, Fitbit etc
- Read and write data to endpoints
- Upload files
- Check HAT status

#### Requirements
Xcode build 9.0+. Requires iOS SDK 9.0+ and Swift 4.0+

### Installing and Running HatForIOS
#### Install
Clone (using SSH) the repository to install the demo app (including any cocoapods) to your local machine

1. Create a new folder
2. Clone the app to the folder. While in the new folder, open a cmd terminal and run the following:
```sh
git clone git@github.com:Hub-of-all-Things/HatForIOS.git
```

Once complete, the structure will be as follows:

```
[your project folder]
│
└───Notables
│   README.md
│
├───HAT
│   │   ...
│
├───HATTests
│   │   ...
│
├───HATUITests
│   │   ...
│
└───Pods
│   │   ...
│
└───HAT.xcworkspace

```

#### Run
1. Navigate to the hat-mobile-ios.xcworkspace file (see project tree above). This is a workspace file
2. Double click to open in Xcode
3. Click Run (⌘R)


#### Notes
1. If you need to create SSH keys, https://help.github.com/articles/generating-an-ssh-key/
2. The app does not require cocoapods to be installed

#### Troubleshooting
If there are Xcode errors. Try the following:

1. Make sure you 'clean' the project (Xcode -> Product -> Clean) or (⇧⌘K)
2. Delete the Derived Data folder for the project. While in Xcode, go to 'Window -> Projects'. hat-mobile-ios will be highlighted. Go ahead and click 'Delete...'. Confirm deletion.
3. Run pod install in order to install cocoapods
