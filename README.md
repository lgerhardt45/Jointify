# Jointify - Remote Range-of-Motion joint measurement: an iOS application
Digitalizing the Range-of-Motion (ROM) analysis for the MRI hospital, Munich, as part of the Tech Challenge at the Technical University Munich in the summer semester 2020.

## Things
### Software
Swift: https://developer.apple.com/swift/
* SwiftUI: https://developer.apple.com/documentation/swiftui
* CoreML: https://developer.apple.com/documentation/coreml

PoseNet: https://developer.apple.com/machine-learning/models/
* [Sample code](https://developer.apple.com/documentation/coreml/detecting_human_body_poses_in_an_image)

XCode IDE: https://developer.apple.com/xcode/

### Hardware
iPhone or iPad running at least iOS 13. Alternatively, you can use the simulator provided by XCode.


## Story
Jointify was developed during the TechChallenge of the Technical University Munich in the summer semester 2020. This guide features how to reproduce the prototype with which we won the challenge proposed by the Technical Univerity's hospital [MRI](https://www.mri.tum.de/)

### What is Jointify
Jointify is an iOS app that allows patients to take range of motion (ROM) measurements right at home, rather than having to visit a doctor. This is made feasible by a machine learning model that analyzes a patient’s video in which she performs the flexing and bending of the joint. The final prototype has the measurement for the knee implemented. 

### How Jointify works
![How Jointify Works](/readme_images/how_jointify_works.png)

## Re-creating Jointify
### Create new Xcode project
Open Xcode and click _File_ -> _New…_ -> _Project…_

A Single View App suffices. Add the name and your Developer Team, choose a location on your disk and click _Create_. We always recommend to use a linter that pushes you to keep your code organized. For Swift, this is `SwiftLint`, which you can get here: https://github.com/realm/SwiftLint. It’s highly configurable and can be included in the build progress directly to ensure your code stays clean.

### Build the user interfaces
As always with a new prototype you need to consider what it will look like. We first created wireframes on [Figma](https://www.figma.com/) to guide us how to build the user interfaces. Here you can see all interfaces (i.e. full screens the user is shown) for your reference:
![Jointify UI](/readme_images/user_interfaces.png)

This also represents the expected user walk through, i.e. how she uses the app. In this order, we go into more detail about what the `View` holds and what needs to be considered when implementing them.

1. **`WelcomeView`**: The `WelcomeView` holds a button that starts the user flow through the app. To realise the navigation through the app, `NavigationLinks` are used. Further, previous records are shown in a `List`. See [Final remarks](#final-remarks) for information on how the user data (i.e. past measurements) that is shown in the `List` is stored on the device.

2. **`InstructionsView`**: This screen holds instructions on how to use the app. A combination of horizontal and vertical `ScrollView`s is used to have all necessary information in one place.

3. **`ChooseInputView`**: Choosing the body side to be analysed happens through a `SegmentedControllPicker`. The choice is passed through to the `ProcessingView`. The two buttons below offer the choice to use an existing recording or record a video right in the app. With a click on _Record_ or _Gallery_, the `MediaPicker` is opened with the `UIImagePickerController.SourceType` `.camera` or `.gallery`, respectively.

4. **`MediaPicker`**: The `MediaPicker` encapsulates the system way to choose media from the gallery or camera. The `mediaType` has to be set to `[kUTTypeMovie as String]` in order to only show videos in the gallery or have the video mode set in the camera. For a video, the `imagePicker` returns a `NSURL`, i.e. the internal file location where the chosen video is stored.

5. **`ProcessingView`**: Here, the magic happens. The video is split up into frames (we chose three frames per second), passed through the PoseNet analysis (see [Load PoseNet model](#load-posenet-model)) and returns the frames with the minimum and maximum range of motion values (those are calculated from the vectors between the joints, compare [Calculate angles](#calculate-angles)). To give the user something to do while he waits for the analysis to finish we added an info box. A `ProgressBar` is added to give feedback on the progress. If the analysis fails, the user is shown an `Alert` that prompts him to try again.

6. **`VideoResultView`**: After a successful analysis, the frames on which the highest and lowest angle of your joint bending/ flexing is shown with their respective values.

7. **`ResultView`**: The values only are shown on the last screen. Previous values, if they exist, are displayed below. From here, the user can go back to the WelcomeView (button Done) or choose to create a PDF which translates the angles into standardized medical values along the “Neutral-Null-Methode” (compare [PDFWriter](#pdfwriter)).

9. **`MailView`**: The result PDF from the PDFWriter is attached to an email draft. We utilize the system mail programm by wrapping a `MFMailComposeViewController`. Hitting send dismisses the view and brings you back to the `ResultView`.


### Load PoseNet model
We used the PoseNet model provided by Apple in their `.mlmodel` format. We chose the _PoseNetMobileNet075S8FP16_ version because it is said to be the most accurate and light-weight enough to also run on low-end devices (compare the description of the official [PoseNet TensorFlow model on GitHub](https://github.com/tensorflow/tfjs-models/tree/master/posenet)). While still taking the longest to process, we decided to suit Jointify as medical application to go for the highest accuracy possible. The model is available to download from [developer.apple.com/machine-learning/models](https://developer.apple.com/machine-learning/models) -> _PoseNet_ or directly [here](https://ml-assets.apple.com/coreml/models/Image/PoseEstimation/PoseNet/PoseNetMobileNet075S8FP16.mlmodel). 
To get the model into the app and up and running on passed into images, we mostly followed [this tutorial](https://developer.apple.com/documentation/coreml/detecting_human_body_poses_in_an_image) provided by Apple.
The following diagram from the tutorial shows which body features the model recognizes and how those can be connected by vectors. The coordinates of the body features and the vectors are used to get the angles of a joint.
![PoseNet body recognition](/readme_images/posenet_joint_recognition.png)

### Use video frame by frame
As the PoseNet model runs on single images, you first have to cut the video returned by the `MediaPicker` into separate frames. We found that 3 frames per second make a good balance between enough frames to have retrieved the required values and not letting the user wait too long for the results on the `ProcessingView`. Getting the frames from the `NSURL`  (i.e. the storage location of the selected video) was rather straightforward: 
![transformVideoToImageArry gist](/readme_images/transitionVideoToImageArray_gist.png)

### Implement quality criteria
After getting the model running on a video, we realised the impediments of using a pre-trained model and computer vision in general. Through a lot of testing and and checking we came to the conclusion, that the model sometimes illogical poses. We found the following to be the most frequently observed erroneous analysis results. To tackle this problem, we created several quality criteria to reject the wrong pose analyses.
**Erroneous output examples:**
Example 1 | Example 2 | Example 3
--------- | --------- | ---------
![Example 1](/readme_images/erroneous_output_example_1.png) | ![Example 2](/readme_images/erroneous_output_example_2.png) | ![Example 3](/readme_images/erroneous_output_example_3.png)

#### Basic assumptions: 
* User always faces the camera straight and is standing
* Pose can be represented on a 2D coordinate system: user needs to be standing
* All extremities have to be visible at all times, e.g. the user does not hide the hip behind her arm

#### How to tackle the erroneous output examples
1. The lowest confidence value that PoseNet assigns to the recognized coordinates of all relevant joints must be over `0.3`
2. All X coordinates must be rational (_Example 1_)
  1. Left joints: X Coordinate of each joint must be larger than or equal to the X Coordinate of respective right joint
  2. Right joints: X Coordinate of each joint must be lower than or equal to the X Coordinate of respective left joint
3. X and Y Coordinates of knee must be rational (_Example 2_). **Problem**: hip and ankle are analysed correctly, but knee is not. **Solutions**:
  1. Left knee: The X Coordinate must be larger than the X Coordinate of left ankle OR the Y Coordinate must be lower than the Y Coordinate of the left ankle
  2. Right knee: X coordinate must be lower than X Coordinate of right ankle OR Y coordinate must be lower than Y Coordinate of right ankle
4. Knee and ankle coordinates must be rational (_Example 3_). **Problem**: only hip is analysed correctly, but knee and ankles are not. **Solutions**:
  1. Left hip: X Coordinate must be lower than X Coordinate of left ankle OR X Coordinate must be higher than X coordinate of left knee
  2. Right hip: X Coordinate must be lower than X Coordinate of right ankle OR X Coordinate must be higher than X coordinate of right knee
5. **Final check: At least 55% of all extracted frames must conform to all of the previous checks.**

### Calculate angles
Once we obtain the joints’ coordinates from the model, we use these to create two vectors between the hip joint and the knee joint (_v1_) and twohe ankle joint and the knee joint (_v2_). Then, we use the following formula to calculate the cutting angle of both vectors: ![calc angles formular](calculate_angles_formular.png)

### PDFWriter
The results of the measurement can be sent via mail in a standardized form that is used by doctors to log your range of motions. The form for the upper and lower extremities are, among others, provided by the Deutsche Gesetzliche Unfallsversicherung (DGUV) here: [upper extremities](https://www.dguv.de/medien/formtexte/aerzte/f_4222/f4222.pdf), [lower extremities](https://www.dguv.de/medien/formtexte/aerzte/f_4224/f4224.pdf). For writing the extracted values into the PDF form, we created a dedicated class `MeasurementSheetPDFWriter` which offers one public method `createPDF()` that takes the measurement values, writes them into the PDF and returns it. The following steps are well documented in the method: 
![createPDF gist](/readme_images/createPDF_gist.png)
  
To get the right pixel coordinates, we had to manually check the position of the values on the templates. Those are stored in the `PDFWriterConstants`.
When clicking the _Report_ button on the `VideoResultView`, the `createPDF()` method is triggered and the PDF (in the form of `Data`) is attached to the mail draft in the `MailView`.

### Final remarks
For a medical application, data privacy has to be taken very seriously. To avoid having to encrypt all data, including the video, all results are stored on device. The class `DataHandler` offers methods to store data in JSON format right on the device’s document directory. For this, make sure that all attributes of stored instances (for example, the `Measurements`) conform to the `Codable` protocol of Swift. 

We hope this description can give you a better understanding for Jointify and helps you to recreate the necessary steps. The whole project is publically available on GitHub (see below).

## Credits
TechChallenge SS20 team Jointify: 
* Annalena Feix: annalena.feix@tum.de 
* Lennart Jayasuriya: l.jayasuriya@tum.de 
* Niklas Bergmüller: niklas.bergmueller@tum.de 
* Lukas Gerhardt: lukas.gerhardt@tum.de
Feel free to reach out if you have any further questions about the project, the code or our implementation of PoseNet.

# Version
## Build
[![Build Status](https://travis-ci.com/lgerhardt45/Jointify.svg?branch=master)](https://travis-ci.com/lgerhardt45/Jointify)

## Current Version
**`v1.2.1-beta`: This is a beta release is the MVP version presented at the TechChallenge demo day!**

## Release Notes
`v.1.2`  
- more quality checks on the PoseNet model in order to make sure that the analysis runs properly

`v.1.2.1`: Getting ready for presenting the MVP
- the video passed into the analysis does not need to be cropped to a square anymore
- revamp the `VideoResultView` to a horizontal scroll view
- disable the Record button to record a video right from the app


