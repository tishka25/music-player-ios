//
//  SecondViewController.swift
//  Music Player-iOS
//
//  Created by Teodor Stanishev on 23.07.19.
//  Copyright © 2019 Teodor Stanishev. All rights reserved.
//

import UIKit
import AVKit




class SecondViewController: UITableViewController {

    @IBOutlet weak var savedMusicList: UITableView!
    var didLoad = false
    override func viewDidLoad() {
        super.viewDidLoad()
        getSongs()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if(didLoad){
            getSongs()
//            savedMusicList.reloadData()
//        }
    }
    
    
    private func getSongs(){
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("songs")
        songs.removeAll()
        do {
            let files = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            files.forEach{file in
                let songURL = file.appendingPathComponent(file.lastPathComponent + ".m4a")
                let coverArtURL = file.appendingPathComponent(file.lastPathComponent + ".jpeg")
                let songName = file.lastPathComponent
                var duration:TimeInterval!
                do {
                    duration = try AVAudioPlayer(contentsOf: songURL).duration
                }catch{
                    onError(message: "Error retrieving duration of song")
                    duration = 0.00
                }
                songs.append(Music(name: songName, songURL: songURL, coverArtURL: coverArtURL, duration: duration))
            }
            savedMusicList.reloadData()
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    private func deleteSong(index: Int){
        let fileManager = FileManager.default
        do {
            //Delete the directory containing the song and cover art
            try fileManager.removeItem(at: songs[index].songURL.deletingLastPathComponent())
            print("Deleting song: " + songs[index].songURL.deletingLastPathComponent().absoluteString)
            getSongs()
        }catch{
            onError(message: "Error removing " + songs[index].songURL.deletingLastPathComponent().lastPathComponent)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == indexPath.last){
            didLoad = true
        }
    }
    
    //Get current size of items
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (songs.count)
    }
    
    //Delete cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteSong(index: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
            //TODO Go to first view controller for downloading a new song
        }
    }
    //Show Context menu
    override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    //Show items
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCell", for: indexPath) as! MusicCell
        cell.songName.text = songs[indexPath.row].name
        cell.songDurationLabel.text = PlayerViewController.secondsToHoursMinutesSeconds(seconds: Int(songs[indexPath.row].duration))
        cell.setPostedImage(image: UIImage(contentsOfFile: songs[indexPath.row].coverArtURL.path)!)
        cell.layoutIfNeeded()
        return(cell)
    }
    
    //Selected current item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        PlayerViewController.playSong(song: songs[indexPath.row])
        currentSongIndex = indexPath.row
        
    }
    
    
    private func onError(message: String){
        showMessage(title: "ERROR", message: message)
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
                
            default: print("default")
            }}))
        self.present(alert, animated: true, completion: nil)
    }


}

