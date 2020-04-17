//
//  WebViewController.swift
//  AdForest
//
//  Created by Glixen on 15/04/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController,UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!{
        didSet {

            webView.delegate =  self
            webView.isOpaque = false
            webView.backgroundColor = UIColor.clear
        }
    }
    //ummed
//    https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=86fohl6w88kexu&redirect_uri=https://adforest-testapp.scriptsbundle.com&scope=r_liteprofile%2Cr_emailaddress&state=nhAC-nR-CgEwO3XS2ezANhuPBMz-IUmLPJYgGHlZvZ8B1pCfsGBU0PR0dZ5XxE4zbyeI0RLcKByqPLKkgQdqMm4s6DjFYqMCEehYA2iWT9MfioEHjPXGCt2USxUTF0wKBpflCUjG5URVlJa3qI7U3ydFOErZ4Hhnr9SVmKdf1bithYfbOqBx345o8LQLexbddQ687vP6y0szrIyCM6FHip1tCpOY3Hgg5FJQEFH1mCJ_yLunD5vDUN4VVfkQbcjk
    //
//https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=86fohl6w88kexu&redirect_uri=https://adforest-testapp.scriptsbundle.com%2Fauth%2Flinkedin%2Fcallback&state=fooobar&scope=r_liteprofile%20r_emailaddress
//    https://www.linkedin.com/uas/login?session_redirect=%2Foauth%2Fv2%2Flogin-success%3Fapp_id%3D65976026%26auth_type%3DAC%26flow%3D%257B%2522redirectUri%2522%253A%2522https%253A%252F%252Fadforest-testapp.scriptsbundle.com%252F%2522%252C%2522codeChallenge%2522%253Anull%252C%2522codeChallengeMethod%2522%253Anull%252C%2522externalBindingKey%2522%253Anull%252C%2522currentStage%2522%253A%2522LOGIN_SUCCESS%2522%252C%2522currentSubStage%2522%253A0%252C%2522flowHint%2522%253Anull%252C%2522authFlowName%2522%253A%2522generic-permission-list%2522%252C%2522appId%2522%253A65976026%252C%2522loginHint%2522%253Anull%252C%2522creationTime%2522%253A1586942653258%252C%2522state%2522%253A%2522nhAC-nR-CgEwO3XS2ezANhuPBMz-IUmLPJYgGHlZvZ8B1pCfsGBU0PR0dZ5XxE4zbyeI0RLcKByqPLKkgQdqMm4s6DjFYqMCEehYA2iWT9MfioEHjPXGCt2USxUTF0wKBpflCUjG5URVlJa3qI7U3ydFOErZ4Hhnr9SVmKdf1bithYfbOqBx345o8LQLexbddQ687vP6y0szrIyCM6FHip1tCpOY3Hgg5FJQEFH1mCJ_yLunD5vDUN4VVfkQbcjk%2522%252C%2522scope%2522%253A%2522r_liteprofile%2Br_emailaddress%2522%252C%2522authorizationType%2522%253A%2522OAUTH2_AUTHORIZATION_CODE%2522%257D&fromSignIn=1&trk=oauth&cancel_redirect=%2Foauth%2Fv2%2Flogin-cancel%3Fapp_id%3D65976026%26auth_type%3DAC%26flow%3D%257B%2522redirectUri%2522%253A%2522https%253A%252F%252Fadforest-testapp.scriptsbundle.com%252F%2522%252C%2522codeChallenge%2522%253Anull%252C%2522codeChallengeMethod%2522%253Anull%252C%2522externalBindingKey%2522%253Anull%252C%2522currentStage%2522%253A%2522LOGIN_SUCCESS%2522%252C%2522currentSubStage%2522%253A0%252C%2522flowHint%2522%253Anull%252C%2522authFlowName%2522%253A%2522generic-permission-list%2522%252C%2522appId%2522%253A65976026%252C%2522loginHint%2522%253Anull%252C%2522creationTime%2522%253A1586942653258%252C%2522state%2522%253A%2522nhAC-nR-CgEwO3XS2ezANhuPBMz-IUmLPJYgGHlZvZ8B1pCfsGBU0PR0dZ5XxE4zbyeI0RLcKByqPLKkgQdqMm4s6DjFYqMCEehYA2iWT9MfioEHjPXGCt2USxUTF0wKBpflCUjG5URVlJa3qI7U3ydFOErZ4Hhnr9SVmKdf1bithYfbOqBx345o8LQLexbddQ687vP6y0szrIyCM6FHip1tCpOY3Hgg5FJQEFH1mCJ_yLunD5vDUN4VVfkQbcjk%2522%252C%2522scope%2522%253A%2522r_liteprofile%2Br_emailaddress%2522%252C%2522authorizationType%2522%253A%2522OAUTH2_AUTHORIZATION_CODE%2522%257D
    
    let linkedInKey = "86fohl6w88kexu"
    let linkedInSecret = "YAOoXObs6wU3aUg9"
    let authorizationEndPoint = "https://www.linkedin.com/oauth2/v2/authorization"
    let accessTokenEndPoint = "https://www.linkedin.com/oauth2/v2/accessToken"
    let urlChaa = "https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=86fohl6w88kexu&redirect_uri=https://adforest-testapp.scriptsbundle.com&scope=r_liteprofile%2Cr_emailaddress&state=nhAC-nR-CgEwO3XS2ezANhuPBMz-IUmLPJYgGHlZvZ8B1pCfsGBU0PR0dZ5XxE4zbyeI0RLcKByqPLKkgQdqMm4s6DjFYqMCEehYA2iWT9MfioEHjPXGCt2USxUTF0wKBpflCUjG5URVlJa3qI7U3ydFOErZ4Hhnr9SVmKdf1bithYfbOqBx345o8LQLexbddQ687vP6y0szrIyCM6FHip1tCpOY3Hgg5FJQEFH1mCJ_yLunD5vDUN4VVfkQbcjk"
    


    var accessToken : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startAuthorization()
//        self.requestForAccessToken(authorizationCode: "200")
//        self.profiledata()
        // Create a URL request and load it in the web view.
        
        // Do any additional setup after loading the view.
    }
    
    func startAuthorization(){
        // Specify the response type which should always be "code".
        let responseType = "?code=AQSmFQJ8T6Mm1vR38FmZFDoKbZyxg7Es1u4_OhSv9jjSTSfuwxgErascAKEIUXfzrzfaNe_G--m1x6cKXBAU65LEYxzz69a8h_ETgRT4gvouJkNEoZ4w_GnRVEMDmyfwQCDXKHiPs9mE8CbHhOpR7WBdRwlIrnI0gE9tc4DJ9L6x84xdvg_66tCzC9wpKQ&state=popup"

        // Set the redirect URL which you have specify at time of creating application in LinkedIn Developer’s website. Adding the percent escape characthers is necessary.
        
        let redirectURL = "https://adforest-testapp.scriptsbundle.com/"

        // Create a random string based on the time interval (it will be in the form linkedin12345679).
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"

        // Set preferred scope.
//        r_liteprofile, r_emailaddress
        let scope = " r_basicprofile, r_emailaddress"

//        Next step is to compose the authorization URL. For that use URL assigned to authorizationEndPoint, and append all parameters.


        // Create the authorization URL string.
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInKey)&"
        authorizationURL += "redirect_uri=\(redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        print(authorizationURL)
//        let url22 = URL (string:"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=86fohl6w88kexu&redirect_uri=https://adforest-testapp.scriptsbundle.com&scope=r_liteprofile%2Cr_emailaddress&state=nhAC-nR-CgEwO3XS2ezANhuPBMz-IUmLPJYgGHlZvZ8B1pCfsGBU0PR0dZ5XxE4zbyeI0RLcKByqPLKkgQdqMm4s6DjFYqMCEehYA2iWT9MfioEHjPXGCt2USxUTF0wKBpflCUjG5URVlJa3qI7U3ydFOErZ4Hhnr9SVmKdf1bithYfbOqBx345o8LQLexbddQ687vP6y0szrIyCM6FHip1tCpOY3Hgg5FJQEFH1mCJ_yLunD5vDUN4VVfkQbcjk")
    
        
        //https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=86fohl6w88kexu&redirect_uri=https://adforest-testapp.scriptsbundle.com&state=popup&scope=r_liteprofile r_emailaddress"
//        https://www.linkedin.com/uas/login?session_redirect=%2Foauth%2Fv2%2Flogin-success%3Fapp_id%3D12269855%26auth_type%3DAC%26flow%3D%257B%2522currentStage%2522%253A%2522LOGIN_SUCCESS%2522%252C%2522flowHint%2522%253Anull%252C%2522authFlowName%2522%253A%2522generic-permission-list%2522%252C%2522appId%2522%253A12269855%252C%2522scope%2522%253A%2522r_liteprofile%2522%252C%2522creationTime%2522%253A1586946163978%252C%2522state%2522%253A%2522popup%2522%252C%2522authorizationType%2522%253A%2522OAUTH2_AUTHORIZATION_CODE%2522%252C%2522externalBindingKey%2522%253Anull%252C%2522loginHint%2522%253Anull%252C%2522codeChallenge%2522%253Anull%252C%2522codeChallengeMethod%2522%253Anull%252C%2522redirectUri%2522%253A%2522https%253A%252F%252Fadforest-testapp.scriptsbundle.com%252F%2522%252C%2522currentSubStage%2522%253A0%257D&fromSignIn=1&trk=oauth&cancel_redirect=%2Foauth%2Fv2%2Flogin-cancel%3Fapp_id%3D12269855%26auth_type%3DAC%26flow%3D%257B%2522currentStage%2522%253A%2522LOGIN_SUCCESS%2522%252C%2522flowHint%2522%253Anull%252C%2522authFlowName%2522%253A%2522generic-permission-list%2522%252C%2522appId%2522%253A12269855%252C%2522scope%2522%253A%2522r_liteprofile%2522%252C%2522creationTime%2522%253A1586946163978%252C%2522state%2522%253A%2522popup%2522%252C%2522authorizationType%2522%253A%2522OAUTH2_AUTHORIZATION_CODE%2522%252C%2522externalBindingKey%2522%253Anull%252C%2522loginHint%2522%253Anull%252C%2522codeChallenge%2522%253Anull%252C%2522codeChallengeMethod%2522%253Anull%252C%2522redirectUri%2522%253A%2522https%253A%252F%252Fadforest-testapp.scriptsbundle.com%252F%2522%252C%2522currentSubStage%2522%253A0%257D
//
        
        
       let urlAsif = "https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=86fohl6w88kexu&redirect_uri=https://adforest-testapp.scriptsbundle.com&scope=r_liteprofile%2Cr_emailaddress&state=nhAC-nR-CgEwO3XS2ezANhuPBMz-IUmLPJYgGHlZvZ8B1pCfsGBU0PR0dZ5XxE4zbyeI0RLcKByqPLKkgQdqMm4s6DjFYqMCEehYA2iWT9MfioEHjPXGCt2USxUTF0wKBpflCUjG5URVlJa3qI7U3ydFOErZ4Hhnr9SVmKdf1bithYfbOqBx345o8LQLexbddQ687vP6y0szrIyCM6FHip1tCpOY3Hgg5FJQEFH1mCJ_yLunD5vDUN4VVfkQbcjk"
               
              
        
//            var authorizationURL = urlAsif

        let url = URL(string: authorizationURL)

            if url != nil{
            let request = NSURLRequest(url: url!)
            print(request)
            webView.loadRequest(request as URLRequest)
            }
        // Create a URL request and load it in the web view.
//        let request = NSURLRequest(url: NSURL(string: urlChaa)! as URL)
//        webView.loadRequest(request as URLRequest)
        self.requestForAccessToken(authorizationCode:"?code=AQSmFQJ8T6Mm1vR38FmZFDoKbZyxg7Es1u4_OhSv9jjSTSfuwxgErascAKEIUXfzrzfaNe_G--m1x6cKXBAU65LEYxzz69a8h_ETgRT4gvouJkNEoZ4w_GnRVEMDmyfwQCDXKHiPs9mE8CbHhOpR7WBdRwlIrnI0gE9tc4DJ9L6x84xdvg_66tCzC9wpKQ&state=popup")
        
        
//        let inValidUrl:String = "Invalid url"
//
//        if #available(iOS 10.0, *) {
//            if verifyUrl(urlString: authorizationURL) == false {
//                Constants.showBasicAlert(message: inValidUrl)
//            }else{
//                UIApplication.shared.open(URL(string: authorizationURL)!, options: [:], completionHandler: nil)
//            }
//
//        } else {
//            if verifyUrl(urlString: authorizationURL) == false {
//                Constants.showBasicAlert(message: inValidUrl)
//            }else{
//                UIApplication.shared.openURL(URL(string: authorizationURL)!)
//            }
        
    
    }
    
    func verifyUrl (urlString: String?) -> Bool {
              //Check for nil
              if let urlString = urlString {
                  // create NSURL instance
                  if let url = NSURL(string: urlString) {
                      // check if your application can open the NSURL instance
                      return UIApplication.shared.canOpenURL(url as URL)
                  }
              }
              return false
          }
    
    func requestForAccessToken(authorizationCode: String) {
        let grantType = "authorization_code"
        
        let redirectURL = "https://adforest-testapp.scriptsbundle.com/"
        
        // Set the POST parameters.
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(redirectURL)&"
        postParams += "client_id=\(linkedInKey)&"
        postParams += "client_secret=\(linkedInSecret)"
        
        // Convert the POST parameters into a NSData object.
        let postData = postParams.data(using: String.Encoding.utf8)
        
        // Initialize a mutable URL request object using the access token endpoint URL string.
        let request = NSMutableURLRequest(url: NSURL(string: accessTokenEndPoint)! as URL)
        
        // Indicate that we're about to make a POST request.
        request.httpMethod = "POST"
        
        // Set the HTTP body using the postData object created above.
        request.httpBody = postData
        
        // Add the required HTTP header field.
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
                    print(dataDictionary)
                    
                    //        if let dataData = dictionary["data"] as? [String:Any]{
                    //            data = LoginData(fromDictionary: dataData)
                    //        }
                            //message = dictionary["message"] as? String
                   // self.accessToken = dataDictionary as! String
//                    ["access_token"] as? String
                    
                    

//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        self.dismissViewControllerAnimated(true, completion: nil)
//                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        
        task.resume()
    }
    
//    func profiledata(){
//        if let accessToken = UserDefaults.standard.object(forKey: "LIAccessToken") {
//        // Specify the URL string that we'll get the profile info from.
//        let targetURLString = "https://api.linkedin.com/v1/people/~:(id,public-profile-url,first-name,last-name,email-address)?format=json"
//
//        // Initialize a mutable URL request object.
//            let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
//
//        // Indicate that this is a GET request.
//            request.httpMethod = "GET"
//
//        // Add the access token as an HTTP header field.
//        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//
//        // Initialize a NSURLSession object.
//            let session = URLSession(configuration: URLSessionConfiguration.default)
//
//        // Make the request.
//            let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
//        // Get the HTTP status code of the request.
//                let statusCode = (response as! HTTPURLResponse).statusCode
//
//        if statusCode == 200 {
//        // Convert the received JSON data into a dictionary.
//        do {
//            let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)
//        print("response dictionary ::: \(dataDictionary)")
//
////        dispatch_async(dispatch_get_main_queue(), { () -> Void in
////
////        })
//        }
//        catch {
//        print("Could not convert JSON data into a dictionary.")
//        }
//        }
//        }
//
//        task.resume()
//        }
//
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
