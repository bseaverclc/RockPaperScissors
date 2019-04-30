//
//  ViewController.swift
//  RockPaperScissors
//
//  Created by Robert Todd Lincoln on 5/31/18.
//  Copyright © 2018 Mobile Makers Edu. All rights reserved.
//

// Add SafariServices for the first stretch
// This is how we get access to the SafariViewController
// Added for Stretch #1
import SafariServices

// Take note to the delegates we will add along the way.
// UIImagePickerControllerDelegate is for taking photos
// and picking pictures from our devices photo library.

// UINavigationController is what allows segues to function and move
// between ViewController's
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var computerPlayerImage: UIImageView!
    @IBOutlet var userPlayerImage: UIImageView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var singleTap: UITapGestureRecognizer!

    @IBOutlet var imageViews: [UIImageView]!
    
    var images: [UIImage] = []
    var userChoice = -1
    
    //Added for Stretch #2
    @IBOutlet var countdownLabel: UILabel!
    @IBOutlet var startPlaying: UIButton!
    
    var countForTimer = 3

    //Added for Stretch #3
    var currentImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load up all the image into an array so that we can choose a
        // random one from this array
        images = [#imageLiteral(resourceName: "Rock"),#imageLiteral(resourceName: "Paper"),#imageLiteral(resourceName: "Scissors")]
        
        //Don't let the user tap until the start button is pressed
        //Added for Stretch #2
        singleTap.isEnabled = false
        
        //Picker needs to talk to us
        //Added for Stretch #3
        imagePicker.delegate  = self
        imagePicker.allowsEditing = false
    }
    
    // When the user single taps on an image, play the move.
    @IBAction func singleTappedOnImageView(_ sender: UITapGestureRecognizer){
        let selectedPoint = sender.location(in: stackView)
        for imageView in imageViews {
            if imageView.frame.contains(selectedPoint) {
                userChoice = imageView.tag
                userPlayerImage.image = images[userChoice]
            }
        }
    }
    
    func decideWinner(computerChoice: Int){
        if userChoice == computerChoice{
            displayEndGameAlert(message: "Draw! Play again.")
        }
        else if userChoice == 0 && computerChoice == 1{
            // User = Rock | computer = Paper
            self.displayEndGameAlert(message: "You lose! Play again.")
        }
        else if userChoice == 0 && computerChoice == 2{
            // User = Rock | computer = Scissors
            self.displayEndGameAlert(message: "You Win!! Play again.")
        }
        else if userChoice == 1 && computerChoice == 0{
            // User = Paper | computer = Rock
            self.displayEndGameAlert(message: "You Win!! Play again.")
        }
        else if userChoice == 1 && computerChoice == 2{
            // User = Paper | computer = Scissors
            self.displayEndGameAlert(message: "You lose! Play again.")
        }
        else if userChoice == 2 && computerChoice == 0{
            // User = Scissors | computer = Rock
            self.displayEndGameAlert(message: "You lose! Play again.")
        }
        else if userChoice == 2 && computerChoice == 1{
            // User = Scissors | computer = Paper
            self.displayEndGameAlert(message: "You Win!! Play again.")
        }
        else
        {
            self.displayEndGameAlert(message: "You lose! Play again.")
        }
    }
    
    // We show the result of the game in this alert. Then in the "Ok" alertAction, we will reset the game so it can be played again.
    func displayEndGameAlert(message: String){
        let alertController = UIAlertController.init(title: "Good Game!", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            self.userPlayerImage.image = UIImage()
            self.computerPlayerImage.image = UIImage()
            self.countdownLabel.text = "3"
        }
        
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // The following two functions are for the first stretch, bringing up the wikipedia page
    // for the instructions on how to play rock paper scissors.
    // Added for Stretch #1
    @IBAction func showRockPaperScissorsRules(_ sender: Any) {
        if let url = URL(string: "https://en.wikipedia.org/wiki/Rock-paper-scissors") {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    // Here's where the game begins by counting down and allowing players to make a move. When the counter ends, an win/lose/draw will be found, and an alert will present the result. Then the game will be reset and the user may play again.
    // Added for Stretch #2
    @IBAction func startPlaying(_ sender: Any) {
        
        startPlaying.isEnabled = false
        countdownLabel.text = "\(self.countForTimer)"
        singleTap.isEnabled = true
        
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.countForTimer -= 1
            
            if self.countForTimer > 0 {
                self.countdownLabel.text = "\(self.countForTimer)"
            }
            else{
                
                // Re-enable the start button
                self.startPlaying.isEnabled = true
                self.singleTap.isEnabled = false
                // Reset the count so that when we press the start button again, it will pop to 3 in the label.
                self.countForTimer = 3
                
                // Shut down the timer
                timer.invalidate()
                
                // get a random number from 0-2 and use that number to get an image from the array of images.
                // Moved Here for Stretch #2
                let randomNumber = Int(arc4random_uniform(3))
                self.computerPlayerImage.image = self.images[randomNumber]
                self.decideWinner(computerChoice: randomNumber)
            }
        }
    }
    
    
    
    // This will be hooked up in the Storyboard ot the Sent Action property on the
    // Gesture recognizer.  When double tapped, open up the photo library on the phone
    // and allow the user to choose an image.  Keep track of the image that was chosen
    // for image assignment when the delegate is called upon choosing in image.
    // Added for Stretch #3
    @IBAction func doubleTappedOnImageView(_ sender: UITapGestureRecognizer) {
        
        let selectedPoint = sender.location(in: stackView)
        for imageView in imageViews {
            if imageView.frame.contains(selectedPoint) {
                currentImageView = imageView
            }
        }
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    // This function will be called by the UIImagePickerController through delegation.
    // When this fuction is called, we will be assigning the image that was picked
    // to the imageView that was doubleTapped on in our doubleTappedOnImageView function
    // Added for Stretch #3
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        currentImageView.contentMode = .scaleAspectFit
        currentImageView.image = image
        images[currentImageView.tag] = image
        currentImageView.backgroundColor = UIColor.clear
        
        dismiss(animated:true, completion: nil)
    }
    
    // This function will be called if you hold a long-press on 1 of the imageViews. Note that the simulator doesn't have access to a camera so doing this on a simulator will break the app. But this will work on a iPhone/iPad
    // Added for Stretch #4
    @IBAction func longPressOnImageView(_ sender: UILongPressGestureRecognizer) {
        let selectedPoint = sender.location(in: stackView)
        for imageView in imageViews {
            if imageView.frame.contains(selectedPoint) {
                currentImageView = imageView
            }
        }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = .camera
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
        present(picker, animated: true, completion: nil)
    }
}


