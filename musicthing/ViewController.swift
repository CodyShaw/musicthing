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
    var randomNoteTime = 0.0
    
    //Text Field Outlet
    @IBOutlet weak var NoteText: NSTextField!
    //Randomize Note Outlet
    @IBOutlet weak var randomizeNoteButton: NSButton!
    
    //Randomize the displayed note, to be ran in a thread
    func randomizeNote(){
        //Run until cancelled
        while(true){
            //Make Thread to update text field on GUI
            DispatchQueue.main.asyncAfter(deadline: .now() + randomNoteTime){
                self.changeNote(note: self.notesFlats[Int.random(in: 0..<12)])
            }
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
        
        if(runningRandomNote){
            
            DispatchQueue.main.async {
                self.randomizeNoteButton.stringValue = "Generating..."
            }
            
            DispatchQueue.global().async(execute: displayRandomNote)
            
        } else {
            
            DispatchQueue.main.async {
                self.randomizeNoteButton.stringValue = "Start Notes"
            }
            
            DispatchQueue.main.async {
                self.displayRandomNote.cancel()
            }
            
        }

    }

}




