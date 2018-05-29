//
//  XFCV.swift
//  checkupdate
//
//  Created by XingfuQiu on 2018/5/29.
//  Copyright © 2018年 XingfuQiu. All rights reserved.
//

import Foundation
import UIKit
import StoreKit

/// 上次检查的时间
public let LastCheckTime = "LAST_CHECK_UPDATE_TIME"

/// iTunes 地址
public let ItunesAdress = "http://itunes.apple.com/lookup?bundleId="

/// 自定义时返回的状态
///
/// - normal: 正常
/// - dataError: 数据错误
/// - noInItunes: 没有找到APP
public enum AppStatus: Int {
    case normal
    case dataError
    case noInItunes
}

public class CheckVersionMgr : NSObject{
    
    private override init() {}
    public static let shared = CheckVersionMgr()
    
    private var window: UIWindow {
        let appDelegate = UIApplication.shared.delegate
        return (appDelegate?.window!)!
    }
    
    ///
    private var privateInfoModel: Result!
    
    /// 默认从 APP 跳转出去到 AppStore 进行更新， 设置 false 为应用内打开
    open var openTrackUrlInAppStore: Bool = true
    
    /// 检查时间间隔，默认 1 Min
    open var CheckAgainInterval: Int = 1
    
    // MARK: - Method
    
    /// 检测新版本(使用默认提示框)
    public func checkVersionWithSystemAlert() {
        if shouldStartCheck() {
            getVersionInfo(completed: { [weak self] (model) in
                guard let weakSelf = self else { return }
                if model.resultCount == 1 {
                    guard let result = model.results?.first,
                        let storeVersion = result.version,
                        let releaseNotes = result.releaseNotes else { return }
                    
                    weakSelf.privateInfoModel = result
                    
                    let isHaveUpdate = weakSelf.compareVersion(weakSelf.getLocalVersion(), storeVersion)
                    if isHaveUpdate {
                        let alertController = UIAlertController(title: "发现新版本", message: releaseNotes, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "稍后再说", style: .destructive, handler: { (action) in
                            //关闭
                        }))
                        alertController.addAction(UIAlertAction(title: "马上更新", style: .default, handler: { (action) in
                            if weakSelf.openTrackUrlInAppStore {
                                weakSelf.openInAppStore(weakSelf.privateInfoModel)
                            } else {
                                weakSelf.openInApp(weakSelf.privateInfoModel)
                            }
                        }))
                        weakSelf.window.rootViewController?.present(alertController, animated: true, completion: nil)

                    } else {
                        //不需要更新
                    }
                } else {
                    //搜索结果为空，可能App尚未上架
                }
            }, failure: { error in
                debugPrint(error!)
            })
        }
    }
    
    /// 检测新版本(自定义提示框)
    ///
    /// - Parameter getInfoBlock: 检查结果回调
    public func checkVersionWithCustomView( getInfoBlock: @escaping (_ infoModel: Result?, _ status: AppStatus)-> ()) {
        let status = shouldStartCheck()
        if status {
            getVersionInfo(completed: { (model) in
                if model.resultCount != 1 {
                    getInfoBlock(nil, .dataError)
                    return
                }
                getInfoBlock(model.results?.first, .normal)
            }) { (error) in
                getInfoBlock(nil, .dataError)
            }
        }
    }
    
}

// MARK: - 跳转 & SKStoreProductViewControllerDelegate
extension CheckVersionMgr: SKStoreProductViewControllerDelegate {
    /// 更新时跳转到Appstore页面
    ///
    /// - Parameter result: 更新消息 model
    fileprivate func openInAppStore(_ result: Result) {
        guard let urlString = result.trackViewUrl,
            let url = URL(string: urlString) else { return }
        if UIApplication.shared.canOpenURL(url) {
            DispatchQueue.main.async {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    /// 更新时在APP应用内打开更新页面
    ///
    /// - Parameter result: 更新消息 model
    fileprivate func openInApp(_ result: Result) {
        guard let trackId = result.trackId else { return }
        
        let storeVC = SKStoreProductViewController()
        storeVC.delegate = self
        let paramete = [SKStoreProductParameterITunesItemIdentifier: trackId]
        storeVC.loadProduct(withParameters: paramete , completionBlock: { (loadFlag, error) in
            if !loadFlag {
                storeVC.dismiss(animated: true, completion: nil)
            }
        })
        self.window.rootViewController?.present(storeVC, animated: true, completion: nil)
    }
    
    public func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - internal extension
internal extension CheckVersionMgr {
    
    /// 检查策略：与上次检查版本的时间间隔1Hour，减少网络频繁请求
    ///
    /// - Returns: 可以执行更新 -> true
    func shouldStartCheck() -> Bool {
        let userdefault = UserDefaults.standard
        let lastTime = userdefault.object(forKey: LastCheckTime)
        let nowTime = NSDate()
        
        if (lastTime != nil) {
            let timeInterval = nowTime.timeIntervalSince1970 - (lastTime as! NSDate).timeIntervalSince1970
            if Int(timeInterval)/60 >=  CheckAgainInterval {
                userdefault.setValue(nowTime, forKey: LastCheckTime)
                userdefault.synchronize()
                return true
            } else {
                return false
            }
        } else {
            userdefault.setValue(nowTime, forKey: LastCheckTime)
            userdefault.synchronize()
            return true
        }
    }
    
    
    /// 向iTunes获取应用信息
    ///
    /// - Parameters:
    ///   - completed: 成功后回调
    ///   - failure: 失败后回调
    func getVersionInfo(completed:@escaping (_ result: AppInfoModel)-> (), failure: @escaping (_ error: Error?)-> ()) {
        let infoDict = Bundle.main.infoDictionary
        let appbundleId : String? = infoDict!["CFBundleIdentifier"] as? String
        let url = URL(string: ItunesAdress + appbundleId!)
        
        //异步请求解决4G卡顿问题，设置缓存策略,不让加载系统中缓存的数据
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        
        let cache = URLCache.shared
        let response = cache.cachedResponse(for: request)
        if (response != nil) {
            cache.removeAllCachedResponses()
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, err) in
            guard let data = data else { return }
            do {
                let model = try JSONDecoder().decode(AppInfoModel.self, from: data)
                completed(model)
            } catch let err {
                failure(err)
            }
        }.resume()
    }
    
    /// 获取本地版本号
    ///
    /// - Returns: 本地版本号
    func getLocalVersion() -> String {
        let localversion = Bundle.main.infoDictionary?["CFBundleShortVersionString"]
        return localversion as! String
    }
    
    /// 比较版本号
    ///
    /// - Parameters:
    ///   - localVersion: 本地版本号
    ///   - itunesVersion: itunes Store 版本号
    /// - Returns: 有新版本 -> true
    func compareVersion(_ localVersion:String, _ itunesVersion:String) -> Bool {
        return localVersion.compare(itunesVersion) == .orderedAscending
    }
    
}
