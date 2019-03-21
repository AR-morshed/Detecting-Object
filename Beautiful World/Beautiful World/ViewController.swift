//
//  ViewController.swift
//  Beautiful World
//
//  Created by Arman morshed on 28/2/19.
//  Copyright © 2019 Arman morshed. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        //imagePicker.sourceType = .photoLibrary
        imagePicker.sourceType = .camera
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[.originalImage] as?  UIImage{
                imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert into Ci Image")
            }
            detect(image: ciimage)
        }
        
        
        imagePicker.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    func detect (image : CIImage){
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            fatalError("Loding CoreMl Model failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Model failed to process image")
            }
            
            if let result = results.first {
                self.navigationItem.title = result.identifier
                 
            }
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
        try handler.perform([request])
        }catch{
           print(error)
        }
    }
    

    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
}

