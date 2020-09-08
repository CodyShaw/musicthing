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
    var currentScaleDisplay = 0; //0 = Flats, 1 = Sharps
    
    //Empty DispatchWorkItem to turn on and off when button is pressed
    var displayRandomNote = DispatchWorkItem(){}
    
    //****************************************************************OUTLETS
    //Text Field Outlet
    @IBOutlet weak var NoteText: NSTextField!
    //Randomize Note Outlet
    @IBOutlet weak var randomizeNoteButton: NSButton!
    //Random Note Timer Input
    @IBOutlet weak var randomNoteTimeInput: NSTextField!
    //Random Note Timer Display
    @IBOutlet weak var randomNoteTimeDisplay: NSTextField!
    //Scale Change Button
    @IBOutlet weak var scaleChangeButton: NSButton!
    //Scale Display
    @IBOutlet weak var scaleDisplay: NSTextField!
    
    
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
        
        //Flats by default
        DispatchQueue.main.async {
            self.scaleDisplay.stringValue = "♭"
        }
        
        //10 second countdown by default
        DispatchQueue.main.async {
            self.randomNoteTimeDisplay.stringValue = String(10)
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
            
            //Init Countdown Timer
            var countdown = UInt32(randomNoteTime) + 1
            
            repeat{
               newNote = Int.random(in: 0..<12)
            } while (newNote == currentNote);
            
            currentNote = newNote
            
            //Change note
            DispatchQueue.main.async(){
                switch self.currentScaleDisplay {
                case 0:
                    self.changeNote(note: self.notesFlats[self.currentNote])
                case 1:
                    self.changeNote(note: self.notesSharps[self.currentNote])
                default:
                    self.changeNote(note: self.notesFlats[self.currentNote])
                }
            }
            
            //Delay the timer amount
            while(countdown > 0){
                if(countdown <= 10){
                    DispatchQueue.main.async(){
                        self.randomNoteTimeDisplay.stringValue = String(countdown)
                        let color = NSColor.init(red: 1, green: 0, blue: 0, alpha: 1)
                        self.randomNoteTimeDisplay.textColor = color
                    }
                } else {
                    DispatchQueue.main.async(){
                        self.randomNoteTimeDisplay.stringValue = String(countdown)
                        let color = NSColor.init(white: 1, alpha: 1)
                        self.randomNoteTimeDisplay.textColor = color
                    }
                }
                countdown = countdown - 1
                sleep(1)
                if(displayRandomNote.isCancelled) { break; }
            }
            
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
        DispatchQueue.main.async(){
            self.randomNoteTimeInput.stringValue = String(self.randomNoteTime)
        }
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
                self.scaleChangeButton.isEnabled = false
            }
            
            //Start the thread
            DispatchQueue.global().async(execute: displayRandomNote)
            
        } else {
            
            //Change button title, unfreeze text box
            DispatchQueue.main.async {
                self.randomizeNoteButton.title = "Start Notes"
                self.randomNoteTimeInput.isEnabled = true
                self.scaleChangeButton.isEnabled = true
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
    
    //Scale Change Button function
    @IBAction func scaleChangePressed(_ sender: Any) {
        
        currentScaleDisplay = currentScaleDisplay + 1
        if( currentScaleDisplay > 1 ){
            currentScaleDisplay = 0
        }
        
        switch currentScaleDisplay {
        case 0:
            DispatchQueue.main.async {
                self.scaleDisplay.stringValue = "♭"
            }
        case 1:
            DispatchQueue.main.async {
                self.scaleDisplay.stringValue = "♯"
            }
        default:
            DispatchQueue.main.async {
                self.scaleDisplay.stringValue = "♭"
            }
        }
        
        
    }
}
