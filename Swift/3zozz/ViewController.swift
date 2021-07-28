//
//  github,com/azozzalfiras/AZInstaller
//  AZInstaller
//
//  Created by Ahmed Salah on 28/07/2021.
//  Developer by Azozz ALFiras
//

import UIKit

class ViewController: UIViewController {

@IBOutlet weak var textFild: UITextField!
override func viewDidLoad() {
super.viewDidLoad()

}

@IBAction func button(_ sender: Any)
{



let urlString = textFild.text!;

// change yourserver to your link with https:// but doesn't delete ?url=
    // for the server know link and for get
let urlRequest = "yourserver?url="

let url_3zozz = urlRequest + urlString


// url for request
let url = NSURL(string:url_3zozz);

guard let requestUrl = url else { fatalError() }

// Create URL Request
var request = URLRequest(url: requestUrl as URL)

// Specify HTTP Method to use "GET"
request.httpMethod = "GET"

// header
request.setValue("application/json", forHTTPHeaderField: "Accept")
request.setValue("Azozz ALFiras", forHTTPHeaderField:"Developer")


// Send HTTP Request
let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

// Check if Error took place
if let error = error {
print("Error took place \(error)")
return
}

// Read HTTP Response Status code
if let response = response as? HTTPURLResponse {
print("Response HTTP Status code: \(response.statusCode)")
}

// Convert HTTP Response Data to a simple String
if let data = data, let dataString = String(data: data, encoding: .utf8) {
print("Response data string:\n \(dataString)")
}

do {
if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {

// Print out entire dictionary
print(convertedJsonIntoDict)

// Get value by key
let azf_url = convertedJsonIntoDict["azf_url"]
let Status = convertedJsonIntoDict["Status"]
let Version = convertedJsonIntoDict["Version"]

if ((Status as! String == "Yes")  && (Version as! String == "1.0") ){

// for open url on app
if let url = URL(string:azf_url as! String) {
UIApplication.shared.open(url)
}
} else {
    
let alright = UIAlertController(title: "AZINstaller", message:"The Request Server have problem plz try again", preferredStyle: .alert)
alright.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//present(alright, animated: true)
}
}
} catch let error as NSError {
print(error.localizedDescription)
}


}
task.resume()

}

}

