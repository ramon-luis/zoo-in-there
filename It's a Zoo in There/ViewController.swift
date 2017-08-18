//
//  ViewController.swift
//  It's a Zoo in There
//
//  Created by Ramon RODRIGUEZ on 1/27/17.
//  Copyright © 2017 Ramon Rodriguez. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var fadeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var scrollViewWidth = 375
    var scrollViewHeight = 500
    
    var avPlayer: AVPlayer!
    var animals: Array<Animal> = []
    
    var lastX: CGFloat = 0.0
    var lastPage = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set animals
        animals = getAnimals()
        animals.shuffle()
        let firstAnimal = animals[0]
        
        // set labels
        updateLabel(label: label, animal: firstAnimal)
        hideFadeLabel()
    
        // set scrollview
        scrollView.contentSize = CGSize(width: (scrollViewWidth * animals.count), height: scrollViewHeight)
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        
        // add buttons & images for each animal
        for i in 0...animals.count - 1 {
            let animal = animals[i]
            addButton(i: i, animal: animal)
            addImage(i: i, animal: animal)
        }
    }
    
    // get the array of animals
    func getAnimals() -> Array<Animal> {
        // create individual animal objects
        let cat = Animal(name: "Colby", species: "cat", origin: "Paris", designer: "Christian Dior", image: #imageLiteral(resourceName: "cat"), soundPath: "cat")
        let goat = Animal(name: "Gabriel", species: "goat", origin: "Sao Paolo", designer: "Ralph Lauren", image: #imageLiteral(resourceName: "goat"), soundPath: "goat")
        let hippo = Animal(name: "Huey", species: "hippo", origin: "Los Angeles", designer: "Sean Jean", image: #imageLiteral(resourceName: "hippo"), soundPath: "ohyeah")
        let racoon = Animal(name: "Rufus", species: "racoon", origin: "Chicago", designer: "Georgio Armani", image: #imageLiteral(resourceName: "racoon"), soundPath: "racoon")
        let warthog = Animal(name: "Wallace", species: "warthog", origin: "Charleston", designer: "Tom Ford", image: #imageLiteral(resourceName: "warthog"), soundPath: "warthog")
        let wolf = Animal(name: "Wesley", species: "wolf", origin: "Vancouver", designer: "Pierre Cardin", image: #imageLiteral(resourceName: "wolf"), soundPath: "wolf")
        
        return [cat, goat, hippo, racoon, warthog, wolf]
    }
    
    // action when scrollview is done decelerating: update label
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // determine page
        let x = self.scrollView.contentOffset.x
        let w = self.scrollView.bounds.size.width
        let currentPage = Int(x/w)
        
        // get animal matching current page and update label
        let currentAnimal = animals[currentPage]
        updateLabel(label: label, animal: currentAnimal)
        hideFadeLabel()
        
        // update last x and page: used to track scroll direction & fade
        lastX = x
        lastPage = currentPage
    }
    
    // action when scrollview is being scrolled: fade label
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // determinate params to measure how much fade to apply
        let x = self.scrollView.contentOffset.x
        let w = self.scrollView.bounds.size.width
        var fade = 1.0
        
        // check direction of movement
        let bIsMovingRight = x > lastX
        
        // set var to hold next page & animal
        var nextPage = -1
        var nextAnimal = animals[lastPage];
        
        // set next page & fade
        if (bIsMovingRight) {
            nextPage = (lastPage < animals.count - 1) ? lastPage + 1 : lastPage
            fade = Double((CGFloat(nextPage) * w - CGFloat(x)) / w) * 0.75  // multiply by 0.75 to make it more obvious
        } else {
            nextPage = (lastPage > 0) ? lastPage - 1 : lastPage
            fade = Double((w - (CGFloat(lastPage) * w - CGFloat(x))) / w) * 0.75  // multiply by 0.75 to make it more obvious
        }
        
        // apply fade to current label
        label.alpha = CGFloat(fade)
        
        // update fade label & make more visible
        nextAnimal = animals[nextPage]
        updateLabel(label: fadeLabel, animal: nextAnimal)
        fadeLabel.alpha = 1.0 - CGFloat(fade)
    }
    
    // make sure main label is visible and fade label is hidden
    func hideFadeLabel() {
        label.alpha = 1.0
        fadeLabel.alpha = 0.0
    }
    
    // update label text
    func updateLabel(label: UILabel, animal: Animal) {
        label.text = "Meet \(animal.name), a \(animal.species) from \(animal.origin)."
    }
    
    // add a button to the scrollView
    func addButton(i: Int, animal: Animal) {
        let button = UIButton(frame: CGRect(x: i * 375 + 62, y: 400, width: 250, height: 50))
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Learn more about \(animal.name)", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.tag = i
        self.scrollView.addSubview(button)
    }
    
    // add an image to the scrollView
    func addImage(i: Int, animal: Animal) {
        let image = animal.image
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: i * 375, y: 0, width: 375, height: 400)
        imageView.contentMode = .scaleAspectFit
        self.scrollView.addSubview(imageView)
    }

    // button click action: animal sound and info
    func buttonAction(sender: UIButton!) {
        // get the animal
        let animalIndex: Int = sender.tag
        let animal = animals[animalIndex]
        
        // print animal info to console
        animal.dumpAnimalObject()
        
        // play animal sound
        playAnimalSound(animal: animal)
        
        // create & show animal info (alert)
        let name = "\(animal.name)"
        let msg = "\(name) is a \(animal.species).\nHe is wearing \(animal.designer)."
        let alert = UIAlertController(title: name, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // play an animal sound
    func playAnimalSound(animal: Animal) {
        // get the path & set the url
        let path = Bundle.main.path(forResource: animal.soundPath, ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        // set url & play the sound
        avPlayer = AVPlayer(url: url)
        avPlayer.play()
    }
    
}


// shuffle function for array
// - Attributions: http://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
extension Array {
    mutating func shuffle() {
        if count < 2 { return }
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            if (i != j) {
                swap(&self[i], &self[j])
            }
        }
    }
}

