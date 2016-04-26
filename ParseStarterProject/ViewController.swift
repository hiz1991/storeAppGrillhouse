/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import Foundation

class ViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,SideBarDelegate {
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var server: UILabel!
    @IBOutlet weak var signature: UITextField!
    @IBOutlet weak var textField: UITextView!
    @IBAction func sendRequest(sender: AnyObject) {
        if(textField.text.characters.count==0){
            self.server.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1);
            self.server.text = "Empty message"
            return
        }
        activityInd.startAnimating()
        self.server.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0);
        server.text=""
                PFCloud.callFunctionInBackground("sendSMS", withParameters: ["message":textField.text!,"signature":signature.text!, "key":"azmomkVkrozLlu7dxiwYDxcqD"], block: {
                    (result: AnyObject?, error: NSError?) -> Void in
                    self.activityInd.stopAnimating()
                    if ( error === nil) {
                        self.server.textColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1);
                        self.server.text="Success"
                        NSLog("Rates: \(result) ")
                    }
                    else if (error != nil) {
                        NSLog("error")
                        self.server.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1);
                   self.server.text="Failed to connect"
                    }
                });
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self;
        signature.delegate = self;
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view, typically from a nib.
//        var frameRect:CGRect  = textField.frame;
//                frameRect.size.height = 53;
//                textField.frame = frameRect;
        
        textField.layer.cornerRadius = 8;
        textField.layer.masksToBounds = true;
        textField.layer.borderColor = UIColor(red: 0/255, green: 119/255, blue: 204/255, alpha: 1).CGColor
        textField.layer.borderWidth = 1;
        
        PFCloud.callFunctionInBackground("getJSON", withParameters: ["d":"d"], block: {
            (result: AnyObject?, error: NSError?) -> Void in
            self.activityInd.stopAnimating()
            if ( error === nil) {
                self.server.textColor = UIColor(red: 0/255, green: 255/255, blue: 0/255, alpha: 1);
                self.server.text="Success"
//                NSLog("Rates: \(result) ")
                let obj = result!
                var menuArray:[String]=[]
                var offers:NSArray  = obj.valueForKey("Offers") as! NSArray
                for i in offers {
//                    print(i.valueForKey("category"))
                    menuArray.append(i.valueForKey("category") as! String)
                    
                }
                let unique = self.uniq(menuArray)
                print(unique)
                
                var sideBar:SideBar = SideBar()
                
                sideBar = SideBar(sourceView: self.view, menuItems:unique) //["first item", "second item", "funny item", "another item", "second item", "funny item", "another item"])
                sideBar.delegate = self
                
                
               
                
            }
            else if (error != nil) {
                NSLog("error")
                self.server.textColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1);
                self.server.text="Failed to connect"
            }
        });
        
        
        
    }
    func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
    var buffer = [T]()
    var added = Set<T>()
    for elem in source {
        if !added.contains(elem) {
            buffer.append(elem)
            added.insert(elem)
        }
    }
    return buffer
    }

    func sideBarDidSelectButtonAtIndex(index: Int) {
        print("pressed")
        print(index)
//        if index == 0{
//            imageView.backgroundColor = UIColor.redColor()
//            imageView.image = nil
//        } else if index == 1{
//            imageView.backgroundColor = UIColor.clearColor()
//            imageView.image = UIImage(named: "image2")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
//    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
//    func hexStringToUIColor (hex:String) -> UIColor {
//        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
//        
//        if (cString.hasPrefix("#")) {
//            cString = cString.substringFromIndex(advancedBy(1));
//        }
//        
//        if ((cString.characters.count) != 6) {
//            return UIColor.grayColor()
//        }
//        
//        var rgbValue:UInt32 = 0
//        NSScanner(string: cString).scanHexInt(&rgbValue)
//        
//        return UIColor(
//            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
//            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
//            alpha: CGFloat(1.0)
//        )
//    }
}
