//
//  Constant.swift
//  frameproject
//
//  Created by Quang Trinh on 21/10/2022.
//

import Foundation

class Constant {
    
    static var bundleIdentifier: String {
        if let key = bundleMainInfo?[kCFBundleIdentifierKey as String] as? String {
            return key
        }
        return ""
    }
    
    static var bundleMainInfo: [String: Any]? {
        return Bundle.main.infoDictionary
    }
    
    // MARK: - Status local key
    static let kLanguage: String = "language"
    static let kCurrentShippingAddressId: String = "currentShippingAddressId"
    static let kCurrentDurationPlayed: String = "currentDurationPlayed"
    // MARK: - Logger environment
    static let enableLogger: Bool = true
    static let enableLoggerMemory: Bool = false
    static let enableLoggerDatabase: Bool = false
    static let enableLoggerURLSource: Bool = false
    static let enableLoggerPathSource: Bool = false
    
    // MARK: - Header key
    static let kHeaderAccessToken = "X-Access-Token"
    static let kContentType = "Content-Type"
    static let kAcceptLanguage = "Accept-Language"
    static let kXLoziClientToken = "X-Lozi-Client-Token"
    static let kXLoziClient = "X-Lozi-Client"
    static let kXAppBuild = "X-App-Build"
    static let kXAPIVersion = "X-API-Version"
    static let kXLanguage = "X-Language"
    static let kXLoziAppClient = "X-Lozi-App-Client"
    // MARK: - Header Value
    static let clientId = "30"
    static let appClientId = "31"
    static let appBuild = 631
    static let apiVersion: String = "v2"
    // MARK: - Constant for key
    static let kData: String = "data"
    static let kAccessToken: String = "accessToken"
    static let kTmpAccessToken: String = "tmpAccessToken"
    static let kId = "id"
    
    static let kCurrentUserId = "currentUserId"
    
    // MARK: - Constant for pagination
    static let kTotal = "total"
    static let kPage = "page"
    static let kNextUrl = "nextUrl"
    static let kPagination = "pagination"
    
    static let kStoredUUID = "storedUUID"
    static let kAPNDeviceToken = "apnDeviceToken"
    
    static let kCityInfo = "cityInfo"
    static let kDefaultAddressInfo = "defaultAddressInfo"
    static let cityList = [["cityId": 1 as AnyObject, "googleCityName": ["Thành phố Hà Nội", "Hà Nội", "Ha Noi City"], "cityName": "Hà Nội" as AnyObject, "viewCityName": "Hà Nội" as AnyObject],
                           ["cityId": 50 as AnyObject, "googleCityName": ["Thành phố Hồ Chí Minh", "Hồ Chí Minh", "Ho Chi Minh City"], "cityName": "Hồ Chí Minh" as AnyObject, "viewCityName": "Hồ Chí Minh" as AnyObject],
                           ["cityId": 32 as AnyObject, "googleCityName": ["Thành phố Đà Nẵng", "Đà Nẵng", "Da Nang City"], "cityName": "Đà Nẵng" as AnyObject, "viewCityName": "Đà Nẵng" as AnyObject],
                           ["cityId": 59 as AnyObject, "googleCityName": ["Thành phố Cần Thơ", "Cần Thơ", "Can Tho City"], "cityName": "Cần Thơ" as AnyObject, "viewCityName": "Cần Thơ" as AnyObject],
                           ["cityId": 48 as AnyObject, "googleCityName": ["Tỉnh Đồng Nai", "Đồng Nai", "Dong Nai Province"], "cityName": "Đồng Nai" as AnyObject, "viewCityName": "Biên Hòa" as AnyObject]]
    static let defaultGroupCategoryList: [[String:Any]] = [["type": "eatery-food",
                                                            "name": "category.food".localized],
                                                           ["type": "eatery-cuisine",
                                                            "name": "category.cuisine".localized],
                                                           ["type": "eatery-theme",
                                                            "name": "category.theme".localized]]
     
    
    static let kDistrictListInfo = "districyListInfo"
    static let kCurrentFilledUserInfo = "currentFilledUserInfo"
    static let facebookPermissions = ["email"]
    static let flurryKey = "43BT8CWHKCT9KDWB4VKB"
    /// this is a key in user defaults, save it to compare when done order and create new shipping address
    static let kCurrentBaseShippingAddressForRequestOrder = "currentBaseShippingAddressForRequestOrder"
    static let kCurrentUsedShippingAddressForRequestOrder = "currentUsedShippingAddressForRequestOrder"
    static let kDidAnnounceLopoint = "didAnnounceLopoint"
    static let kDidShowLopointIntroduction = "didShowLopointIntroduction"
    static let kMaximumShippingAddress: Int = 5
    
    static let JWTSecretKey: String = "@q%pliCiVNTpql^11fJqGT1pfXi%2zqV"
    
    static let ZaloPayAppId: Int = 110
    static let allowedCouponType = [CouponType.loshipPromotion.rawValue, CouponType.merchantPromotion.rawValue]
//    static let paymentMethodList: [[String:Any]] = [["id": 0,
//                                                     "isOnlinePayment": false,
//                                                     "fee": 0.0],
//                                                    ["id": 2, // Visa
//                                                     "isOnlinePayment": true,
//                                                     "fee": 10000.0],
//                                                    ["id": 3, // ATM
//                                                     "isOnlinePayment": true,
//                                                     "fee": 10000.0],
//                                                    ["id": 1, // Zalo Pay
//                                                     "isOnlinePayment": true,
//                                                     "fee": 10000.0],
//                                                    ["id": 4, // Momo
//                                                     "isOnlinePayment": true,
//                                                     "fee": 10000.0]]
    static let kCurrentPaymentMethod: String = "currentPaymentMethod"
    static let kCurrentPaymentCard: String = "currentPaymentCard"
    static let kCurrentPaymentRemberingOption: String = "currentPaymentRememberingOption"
    static let kCurrentPaymentBankId: String = "currentPaymentBankAlias"
    static let kCurrentLosendSourceInfo: String = "currentLosendSourceInfo"
    static let phoneNumberFormatRegex = "^0?\\d{4,16}$"
    static let appStoreUrl = "https://apps.apple.com/vn/app/loship-ship-%C4%91%E1%BB%93-%C4%83n-r%E1%BA%A5t-nhanh/id1348206645"
    static let merchantAppStoreUrl = "itms-apps://itunes.apple.com/app/id1377478517"
    
    static let kCurrentIgnoreOrderCode = "currentIgnoreOrderCode"
    static let kIsAbandonRating = "isAbandonRating"
    static let kIsFinishedRatingOrderCode = "isFinishedRatingOrderCode"
    static let kLatestVersionRating = "latestVersionRating"
    static let JWTTrackingDataSecretKey = "Ta4dz9CJ&q8R@z&4TGi1S4^S%VlVaSNf"
    static let JWTDeviceInfoSecretKey = "n9DTl4Tbg7xHqIhSK6hs3h5iwlJSdpdknZSxBPRq"
    static let localLoziCategoryList: [LoshipLoziCategory] = [LoshipLoziCategory.init(id: 4, name: "Góc con gái", slug: "goc-con-gai", image: "https://tea-4.lozi.vn/v1/images/resized/goc-con-gai-1500526800", order: 0),
                                                              LoshipLoziCategory.init(id: 5, name: "Đồ con trai", slug: "do-con-trai", image: "https://tea-2.lozi.vn/v1/images/resized/do-con-trai-1500526800", order: 0),
                                                              LoshipLoziCategory.init(id: 13, name: "Đồ ăn ship", slug: "do-an-ship", image: "https://tea-2.lozi.vn/v1/images/resized/do-an-ship-1500526800", order: 0),
                                                              LoshipLoziCategory.init(id: 8, name: "Mỹ phẩm", slug: "my-pham", image: "https://tea-4.lozi.vn/v1/images/resized/my-pham-1500526800", order: 0),
                                                              LoshipLoziCategory.init(id: 28, name: "Mẹ & Bé", slug: "me-va-be", image: "https://tea-4.lozi.vn/v1/images/resized/me-va-be-1500526800", order: 0),
                                                              LoshipLoziCategory.init(id: 6, name: "Phụ kiện thời trang", slug: "phu-kien-thoi-trang", image:
                                                                "https://tea-3.lozi.vn/v1/images/resized/phu-kien-thoi-trang-1500526800", order: 0),
                                                              LoshipLoziCategory.init(id: 19, name: "Sách & truyện", slug: "sach-va-truyen", image: "https://tea-3.lozi.vn/v1/images/resized/sach-va-truyen-1500526800", order: 0),
                                                              LoshipLoziCategory.init(id: 20, name: "Đồ chơi & Sở thích", slug: "do-choi-va-so-thich", image: "https://tea-1.lozi.vn/v1/images/resized/do-choi-va-so-thich-1500526800", order: 0)]
    
    static let defaultCornerRadius: CGFloat = 10
    static let kLatestServerTimeDiff: String = "latestServerTimeDiff"
    static let gatewayMethod: [String] =  [OrderPaymentMethod.cc.rawValue, OrderPaymentMethod.fullpayment.rawValue, OrderPaymentMethod.epayCC.rawValue, OrderPaymentMethod.epayfullpayment.rawValue]
    static let fbAppPrefix = "fb600859170003466loshipuser"
    
    static let guestId: String = "CaXl012hWQRRKqrV"
    static let kDidShowReferralRewardOnce = "didShowReferralRewardOnce"
    static let appMetricKey = "37301f6e-d185-422e-9126-231713391071"
    static let kCurrentAdministrationId: String = "currentAdministrationId"
    static let kDidTapOnGroupPromoList: String = "didTapOnGroupPromoList"
    static let kSavedAppleAuthData: String = "savedAppleAuthData"
    
    // MARK: - Constant for promoted keyword
    static let kLimitPromotedKeywordOnSuperCategoryDetail: Int = 21
    static let kMinSecondPromotedKeywordOnSuperCategoryDetail: Int = 24
    
    // MARK: - Constant for navigation
    static let kIsTouchedProfile: String = "isTouchedProfile"
    static let kIsUpdateProfile: String = "kIsUpdateProfile"
    static let kIsCheckCommunity: String = "isCheckCommunity"
    static let kIsTouchedGroupMemberFeature: String = "isTouchedGroupMemberFeature"
    
    // MARK: - Constant for GlobalAddress
    static let kGlobalAddress: String = "kGlobalAddress"
    static let kCurrentGlobalAddressExistedId: String = "kCurrentGlobalAddressExistedId"
    static let kCurrentGlobalAddressCityId: String = "kCurrentGlobalAddressCityId"
    static let kClearCache:String = "kClearCache"
    
    // MARK: - Constant for Order
    static let kIsConfirmed: String = "kIsConfirmed"
    static let ktransactionId: String = "ktransactionId"
    
    // MARK: - Constant for OrderDetailSummary
    static let imageShipperDancingURL: String = "https://tea-1.lozi.vn/animations/dancingboi.gif"
    static let imageShippingURL: String = "https://tea-1.lozi.vn/animations/shippingboi.gif"
    
    // MARK: - Constant for VAT
    static let kIsDefaultVAT: String = "kIsDefaultVAT"
    static let kIgnoredDoneOrderList = "kIgnoredDoneOrderPendingRatingList"
    
    // MARK: - Constant for AppsFlyer
    static let kAppAppleId:String = "1348206645"
    static let kAppsFlyerDevKey:String = "2i6BKcZvYJq5ACy3pfZfZa"
}
