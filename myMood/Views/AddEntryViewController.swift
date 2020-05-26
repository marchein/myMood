//
//  AddEntryViewController.swift
//  myMood
//
//  Created by Marc Hein on 25.05.20.
//  Copyright © 2020 Marc Hein. All rights reserved.
//

import UIKit
import CoreData

class AddEntryViewController: UIViewController, UITextViewDelegate {
    
    var selectedEmoji: String?
    @IBOutlet weak var emojiStackView: UIStackView!
    @IBOutlet weak var descriptionTextView: UITextView!
    private let descPlaceholderText = "Wie ging es dir seit deinem letzten Eintrag?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionTextView.delegate = self
        self.descriptionTextView.text = self.descPlaceholderText
        self.descriptionTextView.textColor = UIColor.lightGray
        self.loadEmojis()
        self.highlightEmoji(emoji: self.selectedEmoji)
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            if #available(iOS 13, *) {
                textView.textColor = UIColor.label
            } else {
                textView.textColor = UIColor.black
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.descPlaceholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func loadEmojis() {
        for subview in self.emojiStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        for emoji in Model.Moods {
            let button = UIButton()
            button.setTitle(emoji, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32)
            button.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
            
            self.emojiStackView.addArrangedSubview(button)
        }
    }
    
    func getIndexOf(emoji: String?) -> Int {
        for i in 0..<Model.Moods.count {
            if emoji != nil && emoji == Model.Moods[i] {
                return i
            }
        }
        return -1
    }
    
    func highlightEmoji(emoji: String?) {
        guard let emoji = emoji else {
            return
        }
        let index = getIndexOf(emoji: emoji)
        for button in self.emojiStackView.arrangedSubviews {
            guard let button = button as? UIButton else {
                return
            }
            button.titleLabel?.removeDropShadow()
        }
        if let button = self.emojiStackView.arrangedSubviews[index] as? UIButton {
            button.titleLabel?.addDropShadow()
            self.selectedEmoji = button.titleLabel?.text
        }
    }
    
    @IBAction func emojiTapped(_ sender: UIButton) {
        self.highlightEmoji(emoji: sender.titleLabel?.text)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func saveAction(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let newMood = Mood(context: context)
        
        newMood.date = Date()
        newMood.mood = self.selectedEmoji
        newMood.desc = self.descriptionTextView.text.contains(self.descPlaceholderText) ? nil : self.descriptionTextView.text
        
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
