//
//  AppDelegate.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 12/9/20.
//  Copyright © 2020 The Kitchen DS. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import GoogleSignIn
import GoogleMaps
import Firebase
import UserNotifications
import FirebaseMessaging
import SQLite3
import Foundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate, MessagingDelegate {
    var db: OpaquePointer?
    //let googleApiKey = "AIzaSyBU1Eb7M45tudqGcZ1DT9U41uXKuU_djbk"
    let googleApiKey = "AIzaSyAK2n6OncrB-8xrYX4YBv1lNH3vYAR6TOU"
    var window: UIWindow?
func application( _ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? ) -> Bool { ApplicationDelegate.shared.application( application, didFinishLaunchingWithOptions: launchOptions )
    //com.googleusercontent.apps.194369646113-o828h0tj26546jale816g4akmm68b9q2
    GIDSignIn.sharedInstance().clientID = "194369646113-o828h0tj26546jale816g4akmm68b9q2.apps.googleusercontent.com"
    GIDSignIn.sharedInstance().delegate = self
    
    FirebaseApp.configure()
    
    Messaging.messaging().delegate = self
    Messaging.messaging().token{token,error in
        if let error = error{
            print("Error recuperando el token")
        }else if let token = token {
            print("el token es \(token)")
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
    GMSServices.provideAPIKey(googleApiKey)
    registerForPushNotifications()
    
    
    UINavigationBar.appearance().barTintColor = UIColor(red: 0.0/255.0, green: 57.0/255.0, blue: 117.0/255.0, alpha: 1.0)
    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    
    
    return true
    
    }
    
    
    func guardarNotificacion(id:String,post_title:String,post_image_url:String,date_published:String,content:String){
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("chmd_db1b.sqlite")
        
        if(sqlite3_open(fileUrl.path, &db) != SQLITE_OK){
            print("Error en la base de datos")
        }else{
            /*
             post_id TEXT UNIQUE, post_title TEXT, content TEXT, guid TEXT, date_published TEXT
             */
            var statement:OpaquePointer?
            let query="INSERT INTO tbl_notificaciones(post_id,post_title,content,guid,date_published) VALUES(?,?,?,?,?)"
            if sqlite3_prepare(db,query,-1,&statement,nil) != SQLITE_OK {
                print("Error")
            }
            
            let pid = id as NSString
            if sqlite3_bind_text(statement,1,pid.utf8String, -1, nil) != SQLITE_OK {
                print("Error campo 1")
            }
            
            let pt = post_title as NSString
            if sqlite3_bind_text(statement,2,pt.utf8String, -1, nil) != SQLITE_OK {
                print("Error campo 2")
            }
            
            let ct = content as NSString
            if sqlite3_bind_text(statement,3,ct.utf8String, -1, nil) != SQLITE_OK {
                print("Error campo 3")
            }
            let g = post_image_url as NSString
            if sqlite3_bind_text(statement,4,g.utf8String, -1, nil) != SQLITE_OK {
                print("Error campo 4")
            }
            
            let dp = date_published as NSString
            if sqlite3_bind_text(statement,5,dp.utf8String, -1, nil) != SQLITE_OK {
                print("Error campo 5")
            }
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Notificación almacenada correctamente")
            }else{
                print("Notificación no se pudo guardar")
            }
            
        }
        
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        Messaging.messaging().subscribe(toTopic: "centro_historico")
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("Se dio click a la notificacion")
            let request = response.notification.request
            let userInfo = request.content.userInfo
            //Con esto capturamos los valores enviados en la notificacion
            //let idCircular = userInfo["id"] as! String
        
        let aps = userInfo[AnyHashable("aps")] as? NSDictionary
               let alert = aps?["alert"] as? NSDictionary
               let body = alert![AnyHashable("body")] as? String
               let title = alert!["title"] as? String

        let post_id = aps![AnyHashable("post_id")] as? String
        let post_title = aps![AnyHashable("post_title")] as? String
        let post_image_url = aps![AnyHashable("post_image_url")] as? String
        let date_published = aps![AnyHashable("date_published")] as? String
        let content = aps![AnyHashable("date_published")] as? String
        self.guardarNotificacion(id: post_id!, post_title: post_title!, post_image_url: post_image_url!, date_published: date_published!, content: content!)
            /*
        
         String post_id = remoteMessage.getData().get("post_id");
                 String post_title = remoteMessage.getData().get("post_title");
                 String post_image_url = remoteMessage.getData().get("post_image_url");
                 String date_published = remoteMessage.getData().get("date_published");
                 String content = remoteMessage.getData().get("content");
         */
        
        
              //Mostrar el badge
              
        
            debugPrint("Notificaciones: \(userInfo)")
            UserDefaults.standard.set(1, forKey: "viaNotif")
            UserDefaults.standard.set(0, forKey: "idCircularViaNotif")
            
      
            completionHandler()
    }
    
    
    
    
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }

    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("ERROR \(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
           
            let picURL = user.profile.imageURL(withDimension: 120)
            
            UserDefaults.standard.set(userId,forKey:"userId")
            UserDefaults.standard.set(idToken,forKey:"idToken")
            UserDefaults.standard.set(fullName,forKey:"fullName")
            UserDefaults.standard.set(givenName,forKey:"givenName")
            UserDefaults.standard.set(familyName,forKey:"familyName")
            UserDefaults.standard.set(email,forKey:"email")
            UserDefaults.standard.set(picURL,forKey:"picURL")
            UserDefaults.standard.set(1,forKey:"cuentaValida")
            //Aquí se hará el redirect, trabaja en conjunto a la función
            //viewDidAppear del ViewController.
         
           
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
       UserDefaults.standard.set(0,forKey: "autenticado")
       UserDefaults.standard.set(0,forKey: "cuentaValida")
       UserDefaults.standard.set("", forKey: "nombre")
       UserDefaults.standard.set("", forKey: "email")
    }
    
    
    func registerForPushNotifications() {
      //1
      UNUserNotificationCenter.current()
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permiso concedido: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
          }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Ajustes de notificación: \(settings)")
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
      }
    }
    
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    }
    
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
}
   
