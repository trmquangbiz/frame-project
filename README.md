# frame-project
## 1. Introduction
This is my frame project that can make a head start for anyone want to start a project from the scratch. It contains some libraries and I have made it convenient to use. Please check folder Screen/Sample and Screen/SampleList for examples

## 2. Technical structure
Here is the libraries I included inside this frame-project:

- Networking:
    - Alamofire
    - CocoaMQTT
 
- Serialize:
    - ObjectMapper

- Data Storage:
    - Realm

- Image Caching:
    - Kingfisher

- Crashlytic:
    - Firebase Crashlytics

- Continuous Delivery:
    - fastlane
    - Firebase
    - TestFlight
 
- Programming Paradigm:
    - Reactive programming

- Architecture:
    - MVP (Model - View - Presenter)
 
- App Security:
    - Pinning Certificate
  
## 3. Programming Paradigm, Data Storage and Architecture
The project is built in reactive programming, but not on RxSwift framework. I have used my experience to **make logic flow between data flow become more simple**. Please take a look at SamplePresenter.swift and SampleListPresenter.swift. 

There are thoughts that I think I would try to integrate Realm with my framework. I have also included expired mechanism for realm to make sure the local memory is not taken by realm so much (90 days). You can check Service/MigrationService.swift for more info. Still RxSwift provide some benefits that I will try to integrate later.

## 4. Networking, serialization and subscribe mechanism
This project doesn't put all API in the handler. Instead, it fixed the API logic and serialize logic in the Entity layer, which means 1 API will go with 1 serialize logic through out the development time. It helps me developer faster by avoiding repeat the api call and serialization process.

Also, the serialization process will be integrated with saving data to storage mechanism. With this, the developer will not need to worry about the underlying data layer. All they need to do is calling static func that can be initialize easily with all 4 features: fetching local, reload remote, load more data, and subscribe data change.

Please take a look at Standardize/SmartLocalObservable.swift, Standardize/SmartLocalObservableList.swift and Model/SampleObject.swift for more information.

```swift
    var sampleObservableList: SmartLocalObservableList<Results<SampleObject>>!
    
    weak var view: SampleListViewProtocol?
    
    var wireFrame: SampleListWireFrameProtocol!
    
    var sampleObjectList: [SampleNameCellModel] = [] {
        didSet {
            if let view = view {
                view.updateView()
            }
        }
    }
    func viewDidLoad() {
        sampleObservableList = SampleObject.makeSampleListObservableList()
            .subscribe({[weak self] changes in
                if let weakSelf = self {
                    weakSelf.sampleObjectList = weakSelf.makeMapList()
                }
            })
        sampleObservableList.fetchLocal()
        if let view = view {
            view.beginRefreshing()
        }
    }
    
    func reloadData() {
        sampleObservableList.fetchRemote(queryParams: ["sort": "nearest"],
                                         onSuccess: {[weak self] in
            if let weakSelf = self, let view = weakSelf.view {
                view.endRefreshing()
            }
        }, onFail: {[weak self] errorCode, errorMsg in
            if let weakSelf = self, let view = weakSelf.view {
                view.endRefreshing()
            }
            // show error message if you want
            
        }, onEmpty: {[weak self] in
            if let weakSelf = self, let view = weakSelf.view {
                view.endRefreshing()
            }
            // show empty result
        })

    }

```

## 5. Safe KVO
There is a class that this project allowed user to make a safe KVO. For the long time that KVO have made a good uses until RxSwift was bornt. However, the complex setup of KVO mechanism (addObserver, override observeValue, removeObserver in deinitialization process) has made KVO outdate and unsafe for a team project. So I create StandardNSObject and ViewController.swift that help this process safer, faster and more . To use this, please check SampleViewController.swift, the API addSafeObserver

```swift
addSafeObserver(sampleObservingObj, forKeyPath: #keyPath(SampleNSObjectClass.subscribedSampleKeyPath), selector: #selector(receiveChange))
```

## 6. Observable Primitive Array with multi handling action
There are times that we need to do a global service which serve the lifetime logic of app. These "singleton" services can contain data pool which is built from normal Array. Usually, to track changes of any Array, developers will use didSet, however the weak point of didSet is its "single action", which means only one action is performed in that didSet block. So developers will work around by adding another keypath in the service, the didSet block will change the value of keyPath, and other class/screen will subscribe to that keypath

Good point, but if we have 10 data pools in that service?

So i create the ObservableArray, this array is integrated with safe KVO and no need to do any setup, developer just need to subscribe, it will serve every observer when the array has some changes

Also, this Observable conform ExpressibleByArrayLiteral, so you can init it like normal array

```swift
    var testObjectList: ObservableArray<TestObject> = [TestObject.init(name: "a"),
                                                       TestObject.init(name: "b"),
                                                       TestObject.init(name: "c"),
                                                       TestObject.init(name: "d")]

    override func addViewObservers() {
        super.addViewObservers()
        //...
        testObjectList.registerChange(object: self, selector: #selector(receiveListChange))
    }
```

## 7. Continuous Delivery
I setup To use this CD, please do the following steps:

- Create 3 private remote repository
  - (1) One for signing development, which contains signing environment certificates and profiles, which is shared between developers
  - (2) One for production development, which contains signing appstore certificates and profiles, which is shared between developers
  - (3) One for App Store Connect API, which contains json file for fastlane , which is shared with jenkin

- Create App Store Connect API Key and follow fastlane doc to create the json key file in repo (3)
- Create Firebase GoogleService-Info.plist if you don't have and you planning to work with Firebase
- Here is list of command lines, prepare a cup of coffee and enjoy it:
    - fastlane signing: Signing for app
    - fastlane testflight_beta: Upload app to testflight, developer needs to enter iCloud id and password to verify they have permission to upload
    - fastlane testflight_beta_jenkin: Upload app to testflight, only for jenkin
    - fastlane distribute_firebase: Upload app to firebase distribution, use folder fastlane/firebase to edit testers and release notes. These 2 files are untracked so developers can change themselves without worry that it can affect other developers

For more detail information, please read fastlane/README.md for more information

## 8. Convenient table view
This table view is setup with some default API to make the logic more clear and newbie-friendly. Please take a look at SampleViewController.swift for more information

```swift
        tableView.setSelfSizingRowHeight(with: NameTableViewCell.getCellEstimatedHeight(viewModel: nil))
        tableView.register(NameTableViewCell.self, forCellReuseIdentifier: NameTableViewCell.cellIdentifier())
        tableView.setNumberOfSection(1)
        tableView.setNumberOfRows {[weak self] section in
            if let weakSelf = self {
                return weakSelf.sampleObjectList.count
            }
            return  0
        }
        tableView.setCellForRows {[weak self] indexPath in
            if let weakSelf = self,
               indexPath.row < weakSelf.sampleObjectList.count {
                let model = weakSelf.sampleObjectList[indexPath.row]
                let cell = weakSelf.tableView.dequeueReusableCell(withIdentifier: NameTableViewCell.cellIdentifier(), for: indexPath) as! NameTableViewCell
                cell.setup(viewModel: model)
                return cell
            }
            return UITableViewCell()
        }
        tableView.setDidSelectRowBlock {[weak self] indexPath in
            if let weakSelf = self,
               indexPath.row < weakSelf.sampleObjectList.count,
               let modelId = weakSelf.sampleObjectList[indexPath.row].id{
                weakSelf.presenter.showDetail(sampleId: modelId)
            }
        }
```

## 9. Design System

Design system is a really important in every big company. It is a really good way to speed up the UI layout process of designer and developer. In a good project structure, developers can feedback to designers that they followed Design System or not. Check SampleViewController.swift:

```swift
    var radioButtonView = DesignSystem.View.radioButtonView
```

## 10. App Security

This app use Pinning Certificate technique to secure the connection. I have integrated it in AlamofireNetworkService and Certifcate model. All you need to do is share the TLS certificates between server and app. You just need to add the certificates into Resources/Certificate directory and config the above mentioned files:

```swift
struct Certificates {
    static let yourCert = Certificates.certificate(filename: "your.cert.file.name")
  
    private static func certificate(filename: String) -> SecCertificate {
        let filePath = Bundle.main.path(forResource: filename, ofType: "cer")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        let certificate = SecCertificateCreateWithData(nil, data as CFData)!
        return certificate
    }
}
```

```swift
class AlamofireNetworkService: NetworkServiceProtocol {
    var config: NetworkServiceConfigProtocol
    ...
    
    enum SessionSelection {
        case afDefault
        case pinnedCerfificate
        var value: Session {
            switch self {
            case .afDefault:
                return AF
            case .pinnedCerfificate:
                let evaluators = [
                    Configuration.shared.baseRequestDomain!:
                    PinnedCertificatesTrustEvaluator(certificates: [
                        Certificates.yourCert
                    ])
                ]
                return Session.init(serverTrustManager: ServerTrustManager(evaluators: evaluators))
            }
        }
    }
    ...
}
```

## 11. Environment config

This app is integrated with environment configuration by using plist file, instead of hard coding. Please check Configuration.swift for further detail

## 12. Give it a try!
More things will be integrated in future. Now, let just having fun!
After cloning, please run:

```
pod install
```

Run frameproject.xcworkspace

Feel free to reach out at trmquang0109@gmail.com for any question. Or you can just open discussion, I am happy for your interest!

