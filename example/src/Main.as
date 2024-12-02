package
{
    import com.applovin.air.AppLovinMAX;
    import com.applovin.air.AppLovinMAXEvents;
    import com.applovin.air.AppLovinMAXParameters;
    import com.applovin.air.data.AdInfo;
    import com.applovin.air.data.ErrorInfo;
    import com.applovin.air.data.Reward;
    import com.applovin.air.data.SdkConfiguration;
    import com.applovin.air.enums.AdViewPosition;

    import flash.display.SimpleButton;

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField
    import flash.text.TextFieldAutoSize;

    public class Main extends Sprite
    {
        private static const TAG:String = "AppLovinMAX-AdobeAIR-Example";

        private static const SDK_KEY:String = "YOUR_SDK_KEY";
        private static const BANNER_AD_UNIT_ID:String = "BANNER_AD_UNIT_ID";
        private static const MREC_AD_UNIT_ID:String = "MREC_AD_UNIT_ID";
        private static const INTERSTITIAL_AD_UNIT_ID:String = "INTER_AD_UNIT_ID";
        private static const REWARDED_AD_UNIT_ID:String = "REWARDED_AD_UNIT_ID";

        private static var showingBanner:Boolean;
        private static var showingMRec:Boolean;

        private static var bannerPosition:AdViewPosition = AdViewPosition.TOP_CENTER;
        private static var mrecPosition:AdViewPosition = AdViewPosition.BOTTOM_CENTER;

        private var statusTextField:TextField;

        public function Main()
        {
            statusTextField = buildButton(-5, "", null, true);
            buildButton(-4, "Toggle Banner Show", toggleBannerShow);
            buildButton(-3, "Next Banner Position", showBannerAtNextPosition);
            buildButton(-2, "Toggle MRec Show", toggleMRecShow);
            buildButton(-1, "Next MRec Position", showMRecAtNextPosition);
            buildButton(1, "Load Interstitial Ad", loadInterstitialAd);
            buildButton(2, "Show Interstitial Ad", showInterstitialAd);
            buildButton(3, "Load Rewarded Video Ad", loadRewardedAd);
            buildButton(4, "Show Rewarded Video Ad", showRewardedAd);
            buildButton(5, "Track Event", trackEvent);
            buildButton(6, "Show Mediation Debugger", showMediationDebugger);

            AppLovinMAX.setTestDeviceAdvertisingIds(["YOUR_IDFA_HERE", "YOUR_GAID_HERE"])

            AppLovinMAXEvents.setSdkInitializedEvent(function (configuration:SdkConfiguration):void
            {
                setStatus("SDK Initialized");

                AppLovinMAX.createBanner(BANNER_AD_UNIT_ID, bannerPosition);
                AppLovinMAX.setBannerBackgroundColor(BANNER_AD_UNIT_ID, 0x5ABFDC);
                AppLovinMAX.setBannerPlacement(BANNER_AD_UNIT_ID, "main");

                AppLovinMAX.createMRec(MREC_AD_UNIT_ID, mrecPosition);

                AppLovinMAX.loadInterstitial(INTERSTITIAL_AD_UNIT_ID);
                AppLovinMAX.loadRewardedAd(REWARDED_AD_UNIT_ID);
            });
            AppLovinMAX.initialize(SDK_KEY);

            AppLovinMAXEvents.setBannerAdLoadedEvent(onBannerAdLoaded);
            AppLovinMAXEvents.setBannerAdLoadedEvent(onBannerAdLoaded);
            AppLovinMAXEvents.setBannerAdLoadFailedEvent(onBannerAdLoadFailed);
            AppLovinMAXEvents.setBannerAdClickedEvent(onBannerAdClicked);
            AppLovinMAXEvents.setBannerAdExpandedEvent(onBannerAdExpanded);
            AppLovinMAXEvents.setBannerAdCollapsedEvent(onBannerAdCollapsed);

            AppLovinMAXEvents.setMRecAdLoadedEvent(onMRecAdLoaded);
            AppLovinMAXEvents.setMRecAdLoadFailedEvent(onMRecAdLoadFailed);
            AppLovinMAXEvents.setMRecAdClickedEvent(onMRecAdClicked);
            AppLovinMAXEvents.setMRecAdExpandedEvent(onMRecAdExpanded);
            AppLovinMAXEvents.setMRecAdCollapsedEvent(onMRecAdCollapsed);

            AppLovinMAXEvents.setInterstitialLoadedEvent(onInterstitialLoaded);
            AppLovinMAXEvents.setInterstitialLoadFailedEvent(onInterstitialLoadFailed);
            AppLovinMAXEvents.setInterstitialDisplayedEvent(onInterstitialDisplayed);
            AppLovinMAXEvents.setInterstitialDisplayFailedEvent(onInterstitialDisplayFailed);
            AppLovinMAXEvents.setInterstitialClickedEvent(onInterstitialClicked);
            AppLovinMAXEvents.setInterstitialHiddenEvent(onInterstitialHidden);

            AppLovinMAXEvents.setRewardedAdLoadedEvent(onRewardedAdLoaded);
            AppLovinMAXEvents.setRewardedAdLoadFailedEvent(onRewardedAdLoadFailed);
            AppLovinMAXEvents.setRewardedAdDisplayedEvent(onRewardedAdDisplayed);
            AppLovinMAXEvents.setRewardedAdDisplayFailedEvent(onRewardedAdDisplayFailed);
            AppLovinMAXEvents.setRewardedAdClickedEvent(onRewardedAdClicked);
            AppLovinMAXEvents.setRewardedAdReceivedRewardEvent(onRewardedAdReceivedReward);
            AppLovinMAXEvents.setRewardedAdHiddenEvent(onRewardedAdHidden);
        }

        /**
         * TODO: Find a more readable way to show a list of buttons.
         */
        private function buildButton(number:int, text:String, clickFunction:Function, isStatusTextField:Boolean = false):TextField
        {
            var buttonHeight:int = 40;
            var yPosition:int = 100 + stage.stageHeight * 0.25 +
                    (number < 0 ? number * buttonHeight : (number - 1) * buttonHeight) + ((number != 1 && number != -1) ?
                            (number > 0 ? 20 * Math.abs(number) : -20 * Math.abs(number)) : number * 10);

            var textField:TextField = new TextField();
            textField.text = text;
            textField.autoSize = TextFieldAutoSize.CENTER;
            textField.mouseEnabled = false;
            textField.x = (stage.stageWidth - textField.width) * 0.5;
            textField.y = yPosition + 10;

            var buttonSprite:Sprite = new Sprite();
            var x:int = isStatusTextField ? 0 : (stage.stageWidth - 250) * 0.5;
            var width:int = isStatusTextField ? stage.stageWidth : 250;
            buttonSprite.graphics.beginFill(0x5ABFDC);
            buttonSprite.graphics.drawRect(x, yPosition, width, buttonHeight);
            buttonSprite.graphics.endFill();
            buttonSprite.addChild(textField);

            var simpleButton:SimpleButton = new SimpleButton();
            simpleButton.downState = buttonSprite;
            simpleButton.upState = buttonSprite;
            simpleButton.overState = buttonSprite;
            simpleButton.hitTestState = buttonSprite;
            if (clickFunction != null) simpleButton.addEventListener(MouseEvent.CLICK, clickFunction);

            addChild(simpleButton);

            return textField;
        }

        private static function toggleBannerShow(event:MouseEvent):void
        {
            if (showingBanner)
            {
                traceTestAppEvent("Hiding banner ad")

                AppLovinMAX.hideBanner(BANNER_AD_UNIT_ID);
            }
            else
            {
                traceTestAppEvent("Showing banner ad")

                AppLovinMAX.showBanner(BANNER_AD_UNIT_ID);
            }
            showingBanner = !showingBanner;
        }

        private static function showBannerAtNextPosition(event:MouseEvent):void
        {
            bannerPosition = getNextAdViewPosition(bannerPosition)

            AppLovinMAX.updateBannerPosition(BANNER_AD_UNIT_ID, bannerPosition);
        }

        private static function toggleMRecShow(event:MouseEvent):void
        {
            if (showingMRec)
            {
                traceTestAppEvent("Hiding MRec ad")

                AppLovinMAX.hideMRec(MREC_AD_UNIT_ID);
            }
            else
            {
                traceTestAppEvent("Showing MRec ad")

                AppLovinMAX.showMRec(MREC_AD_UNIT_ID);
            }
            showingMRec = !showingMRec;
        }

        private static function showMRecAtNextPosition(event:MouseEvent):void
        {
            mrecPosition = getNextAdViewPosition(mrecPosition);

            AppLovinMAX.updateMRecPosition(MREC_AD_UNIT_ID, mrecPosition);
        }

        private static function getNextAdViewPosition(currentPosition:AdViewPosition):AdViewPosition
        {
            var nextPosition:AdViewPosition;

            if (currentPosition == AdViewPosition.TOP_LEFT)
            {
                nextPosition = AdViewPosition.TOP_CENTER;
            }
            else if (currentPosition == AdViewPosition.TOP_CENTER)
            {
                nextPosition = AdViewPosition.TOP_RIGHT;
            }
            else if (currentPosition == AdViewPosition.TOP_RIGHT)
            {
                nextPosition = AdViewPosition.CENTER_LEFT;
            }
            else if (currentPosition == AdViewPosition.CENTER_LEFT)
            {
                nextPosition = AdViewPosition.CENTERED;
            }
            else if (currentPosition == AdViewPosition.CENTERED)
            {
                nextPosition = AdViewPosition.CENTER_RIGHT;
            }
            else if (currentPosition == AdViewPosition.CENTER_RIGHT)
            {
                nextPosition = AdViewPosition.BOTTOM_LEFT;
            }
            else if (currentPosition == AdViewPosition.BOTTOM_LEFT)
            {
                nextPosition = AdViewPosition.BOTTOM_CENTER;
            }
            else if (currentPosition == AdViewPosition.BOTTOM_CENTER)
            {
                nextPosition = AdViewPosition.BOTTOM_RIGHT;
            }
            else if (currentPosition == AdViewPosition.BOTTOM_RIGHT)
            {
                nextPosition = AdViewPosition.TOP_LEFT;
            }

            return nextPosition;
        }

        private function loadInterstitialAd(Event:MouseEvent):void
        {
            traceTestAppEvent("Load interstitial ad button clicked!");

            if (AppLovinMAX.isInterstitialReady(INTERSTITIAL_AD_UNIT_ID))
            {
                traceTestAppEvent("Interstitial ad already loaded, click Show Interstitial to show the ad.")
                return;
            }

            AppLovinMAX.loadInterstitial(INTERSTITIAL_AD_UNIT_ID);
        }

        private static function showInterstitialAd(event:MouseEvent):void
        {
            traceTestAppEvent("Show interstitial ad button clicked!");

            if (AppLovinMAX.isInterstitialReady(INTERSTITIAL_AD_UNIT_ID))
            {
                AppLovinMAX.showInterstitial(INTERSTITIAL_AD_UNIT_ID);
            }
            else
            {
                traceTestAppEvent("Interstitial ad is not ready. Load an ad before showing");
            }
        }

        private static function loadRewardedAd(event:MouseEvent):void
        {
            traceTestAppEvent("Load rewarded ad button clicked!");

            if (AppLovinMAX.isRewardedAdReady(REWARDED_AD_UNIT_ID))
            {
                traceTestAppEvent("Rewarded ad already loaded, click Show Interstitial to show the ad.")
                return;
            }

            AppLovinMAX.loadRewardedAd(REWARDED_AD_UNIT_ID);
        }

        private static function showRewardedAd(event:MouseEvent):void
        {
            traceTestAppEvent("Show rewarded ad button clicked!");

            if (AppLovinMAX.isRewardedAdReady(REWARDED_AD_UNIT_ID))
            {
                AppLovinMAX.showRewardedAd(REWARDED_AD_UNIT_ID);
            }
            else
            {
                traceTestAppEvent("Rewarded ad is not ready. Load an ad before showing");
            }
        }

        private static function trackEvent(event:MouseEvent):void
        {
            traceTestAppEvent("Tracking generic event")

            var parameters:AppLovinMAXParameters = new AppLovinMAXParameters();
            parameters.add("key", "value");
            parameters.add("dummy", "param");
            AppLovinMAX.trackEvent("sample_event", parameters)
        }

        private static function showMediationDebugger(event:MouseEvent):void
        {
            traceTestAppEvent("Show mediation debugger clicked");

            AppLovinMAX.showMediationDebugger();
        }

        private function onBannerAdLoaded(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onBannerAdLoaded called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)

            setStatus("Banner ad loaded")
        }

        private function onBannerAdLoadFailed(adUnitId:String, errorInfo:ErrorInfo):void
        {
            traceTestAppEvent("onBannerAdLoadFailed called for ad unit ID: " + adUnitId + " and error code: " + errorInfo.code)
            setStatus("Banner ad failed to load with error: " + errorInfo)
        }

        private function onBannerAdClicked(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onBannerAdClicked called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onBannerAdExpanded(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onBannerAdExpanded called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onBannerAdCollapsed(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onBannerAdCollapsed called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onMRecAdLoaded(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onMRecAdLoaded called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)

            setStatus("MREC ad loaded")
        }

        private function onMRecAdLoadFailed(adUnitId:String, errorInfo:ErrorInfo):void
        {
            traceTestAppEvent("onMRecAdLoadFailed called for ad unit ID: " + adUnitId + " and error code: " + errorInfo.code)
            setStatus("MREC ad failed to load with error: " + errorInfo)
        }

        private function onMRecAdClicked(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onMRecAdClicked called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onMRecAdExpanded(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onMRecAdExpanded called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onMRecAdCollapsed(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onMRecAdCollapsed called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onInterstitialLoaded(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onInterstitialLoaded called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onInterstitialLoadFailed(adUnitId:String, errorInfo:ErrorInfo):void
        {
            traceTestAppEvent("onInterstitialLoadFailed called for ad unit ID: " + adUnitId + " and error code: " + errorInfo.code)
            setStatus("Interstitial ad failed to load with error: " + errorInfo)
        }

        private function onInterstitialDisplayed(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onInterstitialDisplayed called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onInterstitialDisplayFailed(adUnitId:String, errorInfo:ErrorInfo, adInfo:AdInfo):void
        {
            traceTestAppEvent("onInterstitialDisplayFailed called for ad unit ID: " + adUnitId + " and error code: " + errorInfo.code)
            traceTestAppEvent("Ad Info: " + adInfo)
            traceTestAppEvent("Error Info: " + errorInfo)
        }

        private function onInterstitialClicked(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onInterstitialClicked called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onInterstitialHidden(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onInterstitialHidden called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onRewardedAdLoaded(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onRewardedAdLoaded called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onRewardedAdLoadFailed(adUnitId:String, errorInfo:ErrorInfo):void
        {
            traceTestAppEvent("onRewardedAdLoadFailed called for ad unit ID: " + adUnitId + " and error code: " + errorInfo.code)
            setStatus("Interstitial ad failed to load with error: " + errorInfo)
        }

        private function onRewardedAdDisplayed(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onRewardedAdDisplayed called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onRewardedAdDisplayFailed(adUnitId:String, errorInfo:ErrorInfo, adInfo:AdInfo):void
        {
            traceTestAppEvent("onRewardedAdFailedToDisplay called for ad unit ID: " + adUnitId + " and error code: " + errorInfo.code)
            traceTestAppEvent("Ad Info: " + adInfo)
            traceTestAppEvent("Error Info: " + errorInfo)
        }

        private function onRewardedAdClicked(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onRewardedAdClicked called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onRewardedAdReceivedReward(adUnitId: String, adInfo:AdInfo, reward:Reward):void
        {
            traceTestAppEvent("onRewardedAdReceivedReward called for ad unit ID: " + adUnitId)
            setStatus("Rewarded ad rewarded with " + reward.toString())
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private function onRewardedAdHidden(adUnitId:String, adInfo:AdInfo):void
        {
            traceTestAppEvent("onRewardedAdHidden called for ad unit ID: " + adUnitId)
            traceTestAppEvent("Ad Info: " + adInfo)
        }

        private static function traceTestAppEvent(message:String):void
        {
            trace("[" + TAG + "] " + message);
        }

        private function setStatus(status:String):void
        {
            statusTextField.text = status;
            statusTextField.x = (stage.width - statusTextField.width) * 0.5
        }
    }
}
