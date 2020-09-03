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
    var randomNoteTime = 1.0
    var currentNote = 13;
    
    //Text Field Outlet
    @IBOutlet weak var NoteText: NSTextField!
    //Randomize Note Outlet
    @IBOutlet weak var randomizeNoteButton: NSButton!
    
    //Randomize the displayed note, to be ran in a thread
    func randomizeNote(){
        //Run until cancelled
        
        while(true){
            //Make Thread to update text field on GUI
            var newNote = 0
            
            repeat{
               newNote = Int.random(in: 0..<12)
            } while (newNote == currentNote);
            
            currentNote = newNote
            
            DispatchQueue.main.async(){
                self.changeNote(note: self.notesFlats[self.currentNote])
            }
            sleep(UInt32(randomNoteTime))
            if(displayRandomNote.isCancelled) { break; }
        }
    }
    
    //Changes the Note in the GUI
    func changeNote(note: String){
        NoteText.stringValue = note
    }
    
    //Empty DispatchWorkItem to turn on and off when button is pressed
    var displayRandomNote = DispatchWorkItem(){}
    
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
    
    
    //Button Click function
    @IBAction func changeNoteClick(_ sender: NSButton) {
        //Flip the current setting
        runningRandomNote = !runningRandomNote
        
        if(displayRandomNote.isCancelled){
            displayRandomNote = DispatchWorkItem(){
                self.randomizeNote()
            }
        }
        
        if(runningRandomNote){
            
            DispatchQueue.main.async {
                self.randomizeNoteButton.title = "Generating..."
            }
            
            DispatchQueue.global().async(execute: displayRandomNote)
            
        } else {
            
            DispatchQueue.main.async {
                self.randomizeNoteButton.title = "Start Notes"
            }
            
            DispatchQueue.global().async {
                self.displayRandomNote.cancel()
            }
            
        }

    }

}




