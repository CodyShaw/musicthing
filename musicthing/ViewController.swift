//
//  ViewController.swift
//  musicthing
//
//  Created by Cody Shaw on 8/30/20.
//  Copyright © 2020 spin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let notesFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]

    let notesSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "B♯", "B"]
    
    var note = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBOutlet weak var NoteText: NSTextField!
    
    @IBAction func changeNoteClick(_ sender: NSButton) {
        
        note += 1
        
        if(note >= 12){
            note = 0;
        }
        
        NoteText.stringValue = notesFlats[note]
        
        
        
        let queue = DispatchQueue(label: "testQueue")

        queue.async {
            
            var i = 0;
            
            while(true){
                sleep(10)
                
                self.changeNote(note: self.notesFlats[i])
                
                i = i + 1
                
                if(i >= 12){
                    i = 0
                }
            }
        }
        
    }
    
    func changeNote(note: String){
        
        NoteText.stringValue = note
        
    }
    
    
}


