//
//  AdMobDelegate.swift
//  AdForest
//
//  Created by Furqan Nadeem on 08/04/2019.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

import GoogleMobileAds

class AdMobDelegate: NSObject, GADInterstitialDelegate {
    
    var interstitialView: GADInterstitial!
    
    //GADInterstitial!
    //ca-app-pub-3521346996890484/7679081330"
    func createAd() -> GADInterstitial {
        //"ca-app-pub-3940256099942544/4411468910"
        interstitialView = GADInterstitial(adUnitID: Constants.AdMob.intersetialId!)
        interstitialView.delegate = self
        let request = GADRequest()
//            GADRequest()
        interstitialView.load(request)
        return interstitialView
    }
    
    func showAd() {
        if interstitialView != nil {
            if (interstitialView.isReady == true){
                interstitialView.present(fromRootViewController:currentVc)
            } else {
                print("ad wasn't ready")
                interstitialView = createAd()
            }
        } else {
            print("ad wasn't ready")
            interstitialView = createAd()
        }
    }
    
    private func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Ad Received")
        if ad.isReady {
            interstitialView.present(fromRootViewController: currentVc)
        }
    }
    
    private func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("Did Dismiss Screen")
    }
    
    private func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("Will Dismiss Screen")
    }
    
    private func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("Will present screen")
    }
    
    private func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("Will leave application")
    }
    
    private func interstitialDidFail(toPresentScreen ad: GADInterstitial) {
        print("Failed to present screen")
    }
    
    private func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError!) {
        print("\(ad) did fail to receive ad with error \(String(describing: error))")
    }
}
