# Music Player-iOS

## Music player for iOS that downloads music from youtube. 
 - The app also downloads the thumbnail of the Youtube and places it as a cover art
 - This app is nothing without the accompaning project *TODO out Youtube-DL github link*
 
 ## Dependency's
 - [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
 - [Youtube-DL](https://...)
 
 ## Running
 - Install the Pods from Podfile
 ```
 $ pod install
 ```
 - Change the URL of the Youtube-DL server <br>
    In file: FirstViewController.swift
    ```swift
    14      let SERVER_URL = "http://YOUR_YOUTUBE_DL_SERVER_URL/"
    ```
    
 -  Build and run :)
