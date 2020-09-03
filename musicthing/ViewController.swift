//
//  ViewController.swift
//  musicthing
//
//  Created by Cody Shaw on 8/30/20.
//  Copyright © 2020 spin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    //Array of Flats
    let notesFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

    //Array of Sharps
    let notesSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "B♯", "B"]
    
    //Control Globals
    var runningRandomNote = false
    var randomNoteTime = 10.0
    var currentNote = 13;
    
    //Empty DispatchWorkItem to turn on and off when button is pressed
    var displayRandomNote = DispatchWorkItem(){}
    
    //****************************************************************OUTLETS
    //Text Field Outlet
    @IBOutlet weak var NoteText: NSTextField!
    //Randomize Note Outlet
    @IBOutlet weak var randomizeNoteButton: NSButton!
    //Random Note Timer Input
    @IBOutlet weak var randomNoteTimeInput: NSTextField!
    
    //****************************************************************VIEW LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Load the workitem
        displayRandomNote = DispatchWorkItem(){
            self.randomizeNote()
        }
        
        //Display a note by default
        DispatchQueue.main.async {
            self.changeNote(note: self.notesFlats[0])
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    //****************************************************************FUNCTIONS
    
    //Randomize the displayed note, to be ran in a thread
    func randomizeNote(){
        //Run until cancelled
        
        while(true){
            //Make Thread to update text field on GUI
            
            //Ensure a new note is chosen
            var newNote = 0
            
            repeat{
               newNote = Int.random(in: 0..<12)
            } while (newNote == currentNote);
            
            currentNote = newNote
            
            //Change note
            DispatchQueue.main.async(){
                self.changeNote(note: self.notesFlats[self.currentNote])
            }
            
            //Delay the timer amount
            sleep(UInt32(randomNoteTime))
            
            //Check if the thread was cancelled
            if(displayRandomNote.isCancelled) { break; }
        }
    }
    
    //Lock in new random note time
    func lockNewTime(){
        var newTime = Double(randomNoteTimeInput.stringValue) ?? 10
        
        //Only time between 1 second and 60 seconds
        if(newTime > 60){
            newTime = 60
        } else if (newTime < 1) {
            newTime = 1
        }
        
        randomNoteTime = newTime
        randomNoteTimeInput.stringValue = String(randomNoteTime)
    }
    
    //Changes the Note in the GUI
    func changeNote(note: String){
        NoteText.stringValue = note
    }
    
    //****************************************************************UI ACTIONS
    
    //Button Click function
    @IBAction func changeNoteClick(_ sender: NSButton) {
        //Flip the current setting
        runningRandomNote = !runningRandomNote
        
        //Remake the thread if it was cancelled
        if(displayRandomNote.isCancelled){
            displayRandomNote = DispatchWorkItem(){
                self.randomizeNote()
            }
        }
        
        //Depending if you want to start or stop the notes
        if(runningRandomNote){
            
            //Change button title, freeze text box
            DispatchQueue.main.async {
                self.randomizeNoteButton.title = "Generating..."
                self.lockNewTime()
                self.randomNoteTimeInput.isEnabled = false
            }
            
            //Start the thread
            DispatchQueue.global().async(execute: displayRandomNote)
            
        } else {
            
            //Change button title, unfreeze text box
            DispatchQueue.main.async {
                self.randomizeNoteButton.title = "Start Notes"
                self.randomNoteTimeInput.isEnabled = true
            }
            
            //Cancel the thread
            DispatchQueue.global().async {
                self.displayRandomNote.cancel()
            }
            
        }

    }
    
    //Random Note Text Input function
    @IBAction func randomNoteTimeInputted(_ sender: Any) {
        
        //If we are already running...
        if(runningRandomNote){
            //Dont allow for the note time to change.
            randomNoteTimeInput.stringValue = String(randomNoteTime)
        } else {
            //Else, change the note (between 1 and 60 seconds)
            lockNewTime()
        }
    }
}




