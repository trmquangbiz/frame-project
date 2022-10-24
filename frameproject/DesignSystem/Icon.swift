//
//  Icon.swift
//  frameproject
//
//  Created by Quang Trinh on 30/07/2022.
//

import Foundation
import UIKit
extension DesignSystem {
    enum Icon: String {
        var image: UIImage? {
            guard let image = UIImage.init(named: "icon_system_\(rawValue)") else {
                Debugger.debug("Cannot init icon image \(rawValue). Please check your asset")
                return nil
            }
            return image
        }
        
        case add_friend = "add_friend"
        case add_image = "add_image"
        case back_arrow = "back_arrow"
        case bag = "bag"
        case box = "box"
        case calendar = "calendar"
        case call = "call"
        case camera = "camera"
        case caution = "caution"
        case chat = "chat"
        case checked = "checked"
        case checked2 = "checked2"
        case clock = "clock"
        case copy = "copy"
        case coupon = "coupon"
        case cross = "cross"
        case discount = "discount"
        case edit = "edit"
        case filter = "filter"
        case gift = "gift"
        case go_arrow = "go_arrow"
        case gps = "gps"
        case hamberger_menu = "hamberger_menu"
        case highlight = "highlight"
        case home = "home"
        case image = "image"
        case info = "info"
        case leader = "leader"
        case list = "list"
        case location = "location"
        case lock = "lock"
        case medicine = "medicine"
        case member = "member"
        case merchant = "merchant"
        case minus = "minus"
        case more_option = "more_option"
        case noti = "noti"
        case notification = "notification"
        case order_list = "order_list"
        case payment = "payment"
        case plus = "plus"
        case profile = "profile"
        case profile_new = "profile_new"
        case question = "question"
        case question2 = "question2"
        case remove_friend = "remove_friend"
        case remove = "remove"
        case save = "save"
        case saved = "saved"
        case search = "search"
        case setting = "setting"
        case share = "share"
        case wallet = "wallet"
        case work = "work"
        case map = "map"
        case contact = "contact"
        case exchange = "exchange"
        case line_dash = "line_dash"
        case reload = "reload"
        case mail = "mail"
        case detailDown = "detail_down"
        case seen = "seen"
        case unseen = "unseen"
        case arrow = "arrow"
        case arrow_up = "arrow_up"
        case arrow_down = "arrow_down"
        case linked = "linked"
        case social = "social"
        case addNote = "add_note"
        case groupPromo = "group_promo"
        case cart = "cart"
        case infoCircle = "icon_info_circle"
        case notlike = "not_like"
        case liked = "liked"
        case love = "love"
        case seemore = "seemore"
        case showless = "showless"
        case community = "community"
        case updateVersion = "update_version"
        case updateIconProfile = "update_profile"
        case arrow_filled = "arrow_filled"
        case radio_play = "radio_play"
        case radio_pause = "radio_pause"
        case search_white = "search_white"
    }
}
