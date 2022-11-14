//
//  ProfileViewModel.swift
//  ProfilePageCombine
//
//  Created by Павел Кай on 14.11.2022.
//

import Foundation
import UIKit

enum SettingItems: String {
    case notification = "Уведомления"
    case history = "История заказов"
    case adress = "Адрес доставки"
    case payment = "Метод оплаты"
    case favorite = "Избранное"
    case accountSettings = "Настройки аккаунта"
    case exit = "Выйти из аккаунта"
}


final class ProfileViewModel {
    let settingsIcon: [SettingItems] = [.notification, .history, .adress, .payment, .favorite, .accountSettings, .exit]
    let views = [NotificationViewController(), HistoryViewController(), AdressViewController(),
                 PaymentViewController(), FavoriteViewController(), AccountSettingsViewController()]
    
    func configDataSourse(indexPath: IndexPath) -> String {
        switch settingsIcon[indexPath.row] {
        case .notification:
            return SettingItems.notification.rawValue
        case .history:
            return SettingItems.history.rawValue
        case .adress:
            return SettingItems.adress.rawValue
        case .payment:
            return SettingItems.payment.rawValue
        case .favorite:
            return SettingItems.favorite.rawValue
        case .accountSettings:
            return SettingItems.accountSettings.rawValue
        case .exit:
            return SettingItems.exit.rawValue
        }
    }
    
    func configureDidSelect(indexPath: IndexPath) -> UIViewController? {
        switch settingsIcon[indexPath.row] {
        case .notification:
            return NotificationViewController()
        case .history:
            return HistoryViewController()
        case .adress:
            return AdressViewController()
        case .payment:
            return PaymentViewController()
        case .favorite:
            return FavoriteViewController()
        case .accountSettings:
            return AccountSettingsViewController()
        case .exit:
            exitFromAccount()
            return nil
        }
    }
    
    func exitFromAccount() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("exit")
        }
    }
    
}
