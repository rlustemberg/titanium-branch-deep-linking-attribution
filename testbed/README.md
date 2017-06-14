## Create a personal copy of Branch's Titanium TestBed app for testing!

Branch’s Titanium TestBed app serves as a reference implementation to help you integrate the Branch-Titanium SDK into your app.

## Titanium TestBed Installation Instructions:

To start using the Titanium TestBed app, please ensure that you have installed and configured Titanium CLI
(command line interface) from the following location:

- http://docs.appcelerator.com/platform/latest/#!/guide/Titanium_Command-Line_Interface_Reference-section-35619828_TitaniumCommand-LineInterfaceReference-InstallandConfiguretheCLI

In addition, please ensure that Titanium CLI knows where your Android and iOS SDKs are located.

## Clone or Download the Titanium SDK Repo:

If you have github installed, then from command line:

1. Navigate to the directory that you would like to download the Branch Titanium TestBed app to.
2. Type in `git clone git@github.com:BranchMetrics/titanium-branch-deep-linking.git`

This should create a folder called `titanium-branch-deep-linking`.

Alternatively, you can download/unzip the repository from the location below:

- [https://github.com/BranchMetrics/titanium-branch-deep-linking](https://github.com/BranchMetrics/titanium-branch-deep-linking)

The TestBed app is located in a directory called `testbed`.

## Import the app

To run the testbed app, you need to import the app into your Appcelerator account. Use the
`appc` command from the `appcelerator` NPM module.

### Appcelerator CLI setup

In case you don't have the `appc` command available and configured:

```bash
npm install -g appcelerator
appc setup
```

### Install the 6.1.0.GA Titanium SDK

The testbed app uses the version 6.1.0.GA of the Titanium SDK. You can edit
the `<sdk-version>` element in tiapp.xml to use another version or install 6.1.0.GA:

```bash
appc ti sdk install 6.1.0.GA
```

The testbed app requires version 6.0.0.GA or later.

### Run the import command

```bash
cd titanium-branch-deep-linking/testbed
appc new --import
```

When prompted to add Hyperloop or replace Arrow/ACS keys, answer no to both questions.

## Build and Run the iOS TestBed App:

To build and run the Branch Titanium TestBed App for iOS, please perform the following steps:

1. Open `tiapp.xml` in your favorite text editor and update it with your Branch Key. Also register a URI scheme for it.

 Detailed instructions on how to perform this step can be found at the following location:
   - [https://github.com/BranchMetrics/titanium-branch-deep-linking#ios-register-a-uri-scheme-and-add-your-branch-key](https://github.com/BranchMetrics/titanium-branch-deep-linking#ios-register-a-uri-scheme-and-add-your-branch-key)

2. If you are interested in testing Universal Links, then configure Universal Links for the TestBed app using the instructions below:
   - [https://github.com/BranchMetrics/titanium-branch-deep-linking#ios-enable-universal-links](https://github.com/BranchMetrics/titanium-branch-deep-linking#ios-enable-universal-links)   
3. From command line, navigate to: `titanium-branch-deep-linking/testbed`.
4. Type `appc ti build --platform ios` to build and run the app.

If the command executes correctly, then the TestBed app will load in a iOS simulator.

## Build and Run the Android TestBed App:

To build and run the Branch Titanium TestBed app for Android, please perform the following steps:

1. Open `tiapp.xml` in your favorite text editor and update it with your Branch Key. Also register a URI scheme for it.

   -  Detailed instructions on how to perform this step can be found at the following location:
[https://github.com/BranchMetrics/titanium-branch-deep-linking#android-register-a-uri-scheme-and-add-your-branch-key](https://github.com/BranchMetrics/titanium-branch-deep-linking#android-register-a-uri-scheme-and-add-your-branch-key)
2. From command line, navigate to: `titanium-branch-deep-linking/testbed`.
3. Type `appc ti build --platform android` to build and run the app.

If the command executes correctly, then the TestBed app will load in a Android emulator.
