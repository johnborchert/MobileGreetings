MOBILE GREETINGS APP STARTER KIT
--------------------------------


These Changes Are Required For Your Customized Application
----------------------------------------------------------

ArtCards/src/WebViewController.m
- adjust the 3 url links to your web site, twitter, and/or Facebook page


ArtCards/src/WebViewController.xib
- to adjust instructions for your custom app, in interface builder, click on WebViewController.xib … View … Text View … 4 icons from left .. Text .. then update text


ArtCards/src/BioViewController.xib
- to adjust text for your bio, in BioViewController.xib, click on View … Text View .. 4 icons from left .. Text .. adjust text


ArtCards/Helper Classes/Appirater.h
- You MUST CHANGE the attribute values in ArtCards/Helper Classes/Appirater.h. Appirater prompts your customers to rate your app.
- the minimum changes are:
  APPIRATOR_APP_NAME:  the "App Id" of your custom application
  APPIRATER_APP_NAME:  the "name" of your custom application that will be shown in the rate it popup


ArtCards/Helper Classes/FBRequestWrapper.h
- you MUST CHANGE the 3 Facebook attribute values in ArtCards/Helper Classes/FBRequestWrapper.h for your custom application that corresponds to the Facebook App properties that you can copy from your Facebook settings of your Facebook app


ArtCards/Supporting Files/ArtCards.plist
- Each row in the plist corresponds to each card in your custom application


ArtCards/Supporting Files/ArtCards-Info.plist
- Project settings. Be sure to update "Bundle Identifier" for your custom application


ArtCards/ArtCards/ directory
- include your card image files here. The sample cards provided are in low res, 320x480. You should include both low res, 320x480 cards, and their high res equivalents, 640x960. ie. SampleCardBlack@2x.png


ArtCards/Supporting Files/Default.png
- the splash screen image


ArtCards/Supporting Files/Icon.png
ArtCards/Supporting Files/Icon@2x.png
- the icons for your custom applications


ArtCards/Graphics/Other/ directory
- place other graphics used by your custom application here


ArtCards/Graphics/Buttons/ directory
- you may wish to change some of the button graphics in this directory for your custom application


That's it. Good Luck. I'm sure you will make a beautiful app!
The VectorBloom team


Notes on Main Classes in the ArtCards/src/ Directory
-------------------------------------------------------------------------------------


AppManager.h
AppManager.m

- no code changes necessary for your custom application

This "Singleton" class is imported by all classes in your project since it is listed in the following file, along with the 2 standard import files:

ArtCards/Supporting Files/ArtCards-Prefix.pch

import "AppManager.h"  is listed along with the 2 standard imports

This class, AppManager.m, is a good place for methods that you want accessible from any class in your application and is a better location for these 'global' methods than placing them in the application's delegate ie. ArtCardsAppDelegate.m.

ArtCardsAppDelegate.h
ArtCardsAppDelegate.m

- no code changes are necessary for your custom application unless you rename your initially loading view controller. Currently it is named MainArtViewController.h.

This is the application delegate that is standard in all iOS applications. This file is intentionally left with minimal code changes. Global methods / properties are placed in AppManager.m, instead of ArtCardsAppDelegate.m.

Other than importing the first view controller (MainArtViewController.h), the only other change is 1 line in the 1st method called "application: didFinishLaunchingWithOptions:"

where the app rater code is run with the line:
  [Appirater appLaunched:YES];

and 1 line in the method "applicationWillEnterForeground"
  [Appirater appEnteredForeground:YES];

If you do not want to use Appirater, for auto prompting of 'rate it' to your customers, then you can comment out the above 2 lines (along with commenting out #import "Appirater.h")


MainArtViewController.h
MainArtViewController.m

 - no code changes needed for your custom application

This is the 1st view controller that appears in the app.

You can adjust the image size in method "carousel: viewForItemAtIndex:" if necessary. It is currently set as 221 x 331 (for portrait) for images of 320 x 480 or 640 x 960). If your application runs in landscape, this needs to be adjusted.

MainArtViewController.xib

You need to change the header button and footer button.


FBFriendsViewController.h
FBFriendsViewController.m

- no code changes are necessary for your customer application

This class shows your Facebook friends in a table view.

It is called by the class CustomizeArtCardView.m method:
  finishedRequestingGet: withResult:

The Facebook images are cached using the excellent SDWebImage classes. This collection of classes are in ArtCards/External Frameworks/SDWebImage/.

FBFriendsViewController.xib

- no adjustments need in this xib for your customer application


CustomizeArtCardView.h
CustomizeArtCardView.m

- no code changes needed for your custom application

This is the main class and holds the most code in this starter kit.
It displays the card that was selected and allows you custom its appearance, change the font, and then send it out or save it.

The 2 finger rotation of text code has been commented out in the viewDidLoad method.

All the imported classes in CustomizeArtCardView.h & .m will be described in their sections.

CustomizeArtCard.xib

You may wish to adjust the appearance of the toolbar buttons in this xib


MainWindow.xib

- no changes needed

MainWindow.xib is generated automatically by Xcode. The main window interacts with your application delegate to handle events that your application receives through the views.


WebViewController.h
WebViewController.m

- you will want to adjust the url links in the WebViewController.m so it links to your web site, twitter, and Facebook page

- you may wish to add or remove one or more of the buttons in WebViewController.xib and its associated methods in WebViewController.h/.m

This is the web view that displays if the footer image is pressed on the 1st carousel view.

WebViewController.xib

To adjust instructions for your custom app in interface builder, click on WebViewController.xib … View … Text View … 4 icons from left .. Text


BioViewController.h
BioViewController.m

- no code changes needed for your custom application

This view is shown when pressing the initial views button at the top of the view.

BioViewController.xib

- to adjust text for your bio, in BioViewController.xib, click on View … Text View .. 4 icons from left .. Text .. adjust text


ActionContentViewController.h
ActionContentViewController.m

- no code changes needed for your custom application

This is the popover view called from the action button on the CustomArtCardView.

ActionContentViewController.xib

- no changes needed for your custom application.

- see method "actionButtonPressed:" in CustomizeArtCardView.m for positioning information of the actions popover.


FontContentTableViewController.h
FontContentTableViewController.m

- no code changes needed for your custom application

This class reads the fonts list in Fonts.plist and presents the table rows in a popover view. It is call in CustomizeArtCardView.m.

FontContentTableViewController.xib

- no changes needed for your custom application.

- Any changes to the width and height of the Table View in FontContentTableViewController.xib is automatically used in the fonts popover.

- see the method "fontButtonPressed:" in CustomizeArtCardView.m for positioning information of the fonts popover.


Notes on the Helper Classes in the ArtCards/Helper Classes
----------------------------------------------------------

Appirater.h
Appirater.m

- changes ARE required in Appirater.h for your custom application.

This optional helper class prompts your users to rate your app.

To disable this feature, comment out the 3 lines referring to Appirater the application delegate, ArtCardsAppDelegate.

You must adjust the property values in Appirater.h to use this helper class.
The minimum changes are:
  APPIRATOR_APP_NAME:  the "App Id" of your custom application
  APPIRATER_APP_NAME:  the name of your custom application that will be shown in the rate it popup

Appirater was created by Arash Payan.
https://github.com/arashpayan/appirater/


FBFeedGet.h         by VectorBloom, modified from FBFeedPost.h
FBFeedGet.m         by VectorBloom, modified from FBFeedPost.m
FBFeedPost.h        by Andy Yanok
FBFeedPost.m        by Andy Yanok
FBRequestWrapper.h  by Andy Yanok
FBRequestWrapper.m  by Andy Yanok

- you MUST CHANGE the 3 Facebook attribute values in ArtCards/Helper Classes/FBRequestWrapper.h for your custom application that corresponds to the Facebook App properties that you can copy from your Facebook settings of your Facebook app

This group of classes are used for getting and posting to Facebook and communicates to Facebook's iOS SDK included in the "ArtCards/External Frameworks/" directory

This code was originally created by Andy Yanok and is well described here:
http://www.icodeblog.com/2011/03/28/facebook-sdk-posting-to-user-news-feed/

Look for updates here:
https://github.com/ayanok/Andy-Yanok---Public-Sample-Code


iCarousel.h
iCarousel.m

- no code changes are necessary for your custom application

This class provides the Carousel effect on the MainArtViewController.m view.
As you interact with the Carousel, delegate methods are fired in MainArtViewController.m, such as "buttonTapped". As the iPhone is tilted, the accelerometer code in MainArtViewController.m calls the carousel code with the direction and amount to scroll the carousel.

Created by Nick Lockwood

Look for updates here:
https://github.com/nicklockwood/icarousel


IFNNotificationDisplay.h
IFNNotificationDisplay.m

- no code changes are necessary for your custom application

This helper class displays a HUD indicator to show the user that the app is processing something, getting or posting to Facebook, etc.

This code was originally created by Andy Yanok and is part of the code used by FBFeedGet.m and FBFeedPost.m also created by Andy Yanok.

Look for updates here:
https://github.com/ayanok/Andy-Yanok---Public-Sample-Code

Note that around 6 lines have been adjusted in IFNNotificationDisplay.m to adjust the location, color, and size of the HUD display indicator. All original 6 lines are indicated by "// original code".


Supporting Files
----------------

ArtCards.plist
- Each row in the plist corresponds to each card in your custom application

ArtCards-Info.plist
- Project settings, including your bundle identifier and list of non-standard fonts available

ArtCards/Supporting Files/Fonts.plist
- list of fonts for the Fonts popover

ArtCards/Supporting Files/Fonts/ directory
- Non-standard fonts files. These need to be listed in ArtCards-Info.plist and are also list in the Fonts.plist for use in the Fonts popover.

ArtCards/Graphics/Cards/ directory
- include your card images here. The sample cards provided are in low res, 320x480. You should include both low res, 320x480 cards, and their high res equivalents, 640x960. ie. SampleCardBlack@2x.png

ArtCards/Supporting Files/Default.png
- the splash screen image

ArtCards/Supporting Files/Icon.png
ArtCards/Supporting Files/Icon@2x.png
- the icons for your custom applications

ArtCards/Graphics/Other directory
- other graphics used by your custom application

ArtCards/Graphics/Other/FBFriendsPlaceholder.gif
- the graphic used for the Facebook friends table, for friends with no images, or rows that have not yet populated yet from Facebook while scrolling.

ArtCards/Graphics/Buttons/ directory
- all the graphic buttons used by application

ArtCards/Supporting Files/en.lproj/InfoPlist.strings
- localized file is not currently used

ArtCards/Supporting Files/ArtCards-Prefix.pch
- this file lists the imports and constants that are used by ALL classes automatically, such as importing the single class "AppManager.h" and defining the allTrim command

ArtCards/Supporting Files/main.m
- standard iOS script for starting the application


Tests
-----

ArtCards/ArtCardsTests directory
- not currently used



External Frameworks
-------------------

ArtCards/External Frameworks/WEPopover/

- Generic popover implementation for iOS with same API as the UIPopoverController for the iPad

Created by Werner Altewischer
https://github.com/werner77/WEPopover



ArtCards/External Frameworks/SDWebImage/

- Asynchronous image downloader with cache support. This app uses it for the Facebook friends table view to cache images from Facebook. Images are cached locally as you scroll.

Created by Olivier Poitrey
https://github.com/rs/SDWebImage



ArtCards/External Frameworks/Facebook SDK/

- Created by Facebook and modified by Andy Yanok for ArtCards/Helper Classes/FBRequestWrapper.h/.m

Andy Yanok's slightly modified version of the Facebook iOS SDK can be found with his Facebook Demo code here:
https://github.com/ayanok/Andy-Yanok---Public-Sample-Code

Facebook's original version, and regularly updated is here:
https://github.com/facebook/facebook-ios-sdk



ArtCards/External Frameworks/JSON/

- This is the JSON Framework used by the Facebook iOS SDK

Created by Stig Brautaset.

This included non-modified version is from Andy Yanok's Facebook Demo code here:
https://github.com/ayanok/Andy-Yanok---Public-Sample-Code

The original JSON Framework code that is updated regularly by Stig Brautaset is here:
https://github.com/stig/json-framework



Frameworks
----------

These are standard Apple Frameworks. They are adjusted by first clicking of the Project TARGETS, Summary tab, Linked Frameworks and Libraries. They then can be dragged to the /ArtCards/Frameworks/ directory.

Currently these are the included Apple frameworks used by this application:

ArtCards/Frameworks/MessageUI.framework
ArtCards/Frameworks/Twitter.framework
ArtCards/Frameworks/OpenGLES.framework
ArtCards/Frameworks/SystemConfiguration.framework
ArtCards/Frameworks/CFNetwork.framework
ArtCards/Frameworks/QuartzCore.framework
ArtCards/Frameworks/UIKit.framework
ArtCards/Frameworks/Foundation.framework
ArtCards/Frameworks/CoreGraphics.framework

ArtCards/Products/ directory
- used internally by iOS
