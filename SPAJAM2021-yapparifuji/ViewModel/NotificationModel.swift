//
//  NotificationModel.swift
//  SPAJAM2021-yapparifuji
//
//  Created by 吉川莉央 on 2021/10/10.
//

import SwiftUI
import UserNotifications

class NotificationModel {
    
    var notificationDelegate = ForegroundNotificationDelegate()
    
    init() {
        UNUserNotificationCenter.current().delegate = self.notificationDelegate
//        setNotification(genre: "チャック", item: "空いてますよ")
    }

    func setNotification(genre:String ,item:String){

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]){
            (granted, _) in
            if granted {
                //許可
                self.makeNotification(genre:genre ,item:item)
            }else{
                //非許可
            }
        }

    }

    func makeNotification(genre:String ,item:String){

        //日時
        let notificationDate = Date().addingTimeInterval(3)//10秒後
        let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: notificationDate)

        //日時でトリガー指定
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)

        //通知内容
        let content = UNMutableNotificationContent()
        content.title = "注意！"
        content.body = "\(genre)\(item)"
        content.sound = UNNotificationSound.default

        //リクエスト作成
        let identifier = "Genre=\(genre)&Item=\(item)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        //通知をセット
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}


class ForegroundNotificationDelegate:NSObject, UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
//        completionHandler([.alert, .list, .badge, .sound]) //~iOS13
        completionHandler([.banner, .list, .badge, .sound]) //iOS14~
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let queryString = response.notification.request.identifier
        let url = URL(string:"deeplinktest://deeplink?\(queryString)")
        if let openUrl = url {
            UIApplication.shared.open(openUrl)
        }
        
        completionHandler()
    }
}
