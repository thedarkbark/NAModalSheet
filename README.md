##NAModalSheet

NAModalSheet presents your view controller with a blurred image of the background behind it - tested on iOS 6 and 7, but should be deployable on iOS 5.

[![Cocoapods](https://cocoapod-badges.herokuapp.com/v/NAModalSheet/badge.png)](http://beta.cocoapods.org/?q=name%3Anamodalsheet%2A)
[![Cocoapods](https://cocoapod-badges.herokuapp.com/p/NAModalSheet/badge.png)](http://beta.cocoapods.org/?q=name%3Anamodalsheet%2A)

## Install with CocoaPods

Use [CocoaPods](http://cocoapods.org) and add NAModalSheet to your project.

* Add a pod entry for NAModalSheet to your Podfile:

```
pod 'NAModalSheet', '~> 0.0.1'
```	

* Install the pod(s) by running:

```
pod install
```

###Usage

* __You should link with the Accelerate.framework when using NAModalSheet__

Initialize an NAModalSheet with your view controller and the presentation style: sheets can slide on from the top or bottom, or fade in centered.

	//Create a view controller to display as a sheet  
	SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];


	//Initialize an NAModalSheet view controller with it
	NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromTop];
	  
	[sheet presentWithCompletion:^{
		// block called when your view is fully presented
	}];

Specify an inset value before presenting if using a sliding presentation style. This causes the view to slide in at the given distance from the edge of the screen. You could use this to make it appear as if the view is sliding out from under the navigation bar.

	sheet.slideInset = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;

The view you present should be translucent to allow the blurred background image to show through. White at 50% opacity works well.

###Credits

The box blur code was presented publicly in a blog post on IndieAmbitions.com:

><http://indieambitions.com/idevblogaday/perform-blur-vimage-accelerate-framework-tutorial>

