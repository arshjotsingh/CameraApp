//
//  ViewController.swift
//  CameraApp
//
//  Created by Student on 2016-01-20.
//
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate ,UITextFieldDelegate{
    
    
    //Properties
    var imagePicker: UIImagePickerController!
    var lastPoint = CGPoint()
    var path = UIBezierPath()
    var isAddText: Bool = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        addTextField.delegate =  self
        self.navigationItem.title = "Photos App"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func takePhoto(sender: UIButton) {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
        
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        isAddText = true
        addTextField.resignFirstResponder()
        return true
    }
    
    
    
    
  
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
       
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let grayScaleImage = convertToGrayScale(selectedImage!)
        
        let rotatedPhoto = grayScaleImage.imageRotatedByDegrees(90, flip: false)
        
        // set image grayscale
        imageView.image = rotatedPhoto
        
        
        
        
    }
    
   
   
    
    func convertToGrayScale(image: UIImage) -> UIImage {
       
        let imageRect:CGRect = CGRectMake(0, 0, image.size.width, image.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let width = image.size.width
        let height = image.size.height
        
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        let context = CGBitmapContextCreate(nil, Int(width), Int(height), 8, 0, colorSpace, bitmapInfo.rawValue)
       
        
        CGContextDrawImage(context, imageRect, image.CGImage)
        
        let imageRef = CGBitmapContextCreateImage(context)
        
        let newImage = UIImage(CGImage: imageRef!)
        
        return newImage
    }
    
    
    // Touch Event Handling
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        lastPoint = (touches.first?.locationInView(imageView))!
        
        
        
        if isAddText && imageView.pointInside(lastPoint, withEvent: event){
            drawTextToCanvas()
        }
        else
        {
            // start point
            path.moveToPoint(lastPoint)
            
        }
        
        
        
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let currentPoint = touches.first?.locationInView(imageView)
        
        // to start image with context
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 2.0)
        imageView.image!.drawInRect(imageView.bounds)
        UIColor.orangeColor().setStroke()
        path.lineWidth = 4
        path.stroke()
        path.addLineToPoint(currentPoint!)
        self.imageView.setNeedsDisplay()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        lastPoint = currentPoint!
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let endPoint = touches.first?.locationInView(imageView)
        path.addLineToPoint(endPoint!)
        path.removeAllPoints()
    }
    
    func drawTextToCanvas () {
    
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 2.0)
        imageView.image!.drawInRect(imageView.bounds)
        
        let attributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        let textToDraw = NSAttributedString(string: addTextField.text!,attributes: attributes)
        
        UIColor.greenColor()
        textToDraw.drawAtPoint(lastPoint)
        

        isAddText = false
        addTextField.text = nil
        self.imageView.setNeedsDisplay()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //
    }
    
    
    @IBAction func savePhotoToAlbum(sender: UIBarButtonItem) {
        
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
        
        let alert = UIAlertController(title: "Photo Saved", message: "The photo is successfully saved in Albums", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)    }
    
    
    
   
    
    
    
    
}

