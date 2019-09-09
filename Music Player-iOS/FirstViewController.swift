//
//  FirstViewController.swift
//  Music Player-iOS
//
//  Created by Teodor Stanishev on 23.07.19.
//  Copyright © 2019 Teodor Stanishev. All rights reserved.
//

import UIKit
import Alamofire

class FirstViewController: UIViewController {

    let SERVER_URL = "YOUTUBE-DL-SERVER-URL"
    
    @IBOutlet weak var urlTextField: UITextField!
    @IBAction func downloadButton(_ sender: Any) {
//        download(url:SERVER_URL + "downloadAudio/" + (urlTextField.text?.suffix(11))!)
//        download(url:SERVER_URL + "downloadAlbumCover/" + (urlTextField.text?.suffix(11))!)
        let id = String((urlTextField.text?.suffix(11))!)
        downloadAll(videoID: id , onFinished: {
            print("Download finishedt")
            self.showMessage(title: "Finished", message: "Download finished")
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
//        download(url: "http://5.189.164.245:6969/downloadAudio/zPonioDYnoY");
//        download(url: "http://5.189.164.245:6969/downloadAlbumCover/zPonioDYnoY");
        // Do any additional setup after loading the view.
    }

    
    
    public func downloadAll(videoID: String , onFinished: @escaping ()->Void){
        self.showMessage(title: "Started", message: "Downloading...")
        download(url:SERVER_URL + "downloadAudio/" + (videoID) , onFinished: {
            
            self.download(url:self.SERVER_URL + "downloadAlbumCover/" + (videoID) , onFinished: onFinished)
        })

    }

    
    //Download the mp3 to the document directory
    public  func download(url:String , onFinished: @escaping ()->Void){
        let fileManager = FileManager.default
        createDir(name: "songs")
        let filePath = getDir(name: "songs")!
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
        
        Alamofire.download(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: nil,
            to: destination).downloadProgress(closure: { (progress) in
                print("Download Progress: \(progress.fractionCompleted * 100)")
            }).response(completionHandler: { (DefaultDownloadResponse) in
                let dirName = DefaultDownloadResponse.destinationURL!.deletingPathExtension().lastPathComponent
                let fileName = DefaultDownloadResponse.destinationURL!.lastPathComponent
                self.createDir(name: "songs/" + dirName)
                
                let destinationPath = filePath.appendingPathComponent(dirName + "/" + fileName)
                
                if(fileManager.fileExists(atPath: destinationPath.path)){
                    try! fileManager.removeItem(at: destinationPath)
                }
                    try! fileManager.moveItem(at: DefaultDownloadResponse.destinationURL! , to: destinationPath)
                print("Downloaded at: " + (DefaultDownloadResponse.destinationURL?.absoluteString)!)
                onFinished()
        })
    }
    
    
    
    private func createDir(name:String){
        let fileManager = FileManager.default
        var filePath:URL!
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            filePath =  tDocumentDirectory.appendingPathComponent(name)
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Couldn't create document directory")
                }
            }
            NSLog("Document directory is \(String(describing: filePath))")
        }
    }
    
    private func getDir(name:String) -> URL?{
        let fileManager = FileManager.default
        var filePath:URL!
        let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        filePath =  tDocumentDirectory!.appendingPathComponent(name)
        if fileManager.fileExists(atPath: filePath.path) {
            return filePath
        }
        return nil
    }
    
    
    private func showMessage(title:String , message: String){
        let alert = UIAlertController(title: title , message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
