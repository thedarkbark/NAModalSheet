//
//  ViewController.m
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import "ViewController.h"
#import "SampleSheetViewController.h"
#import "SampleBottomSheetViewController.h"

@interface ViewController ()
{
  __weak IBOutlet UINavigationBar* myNavBar;
}
@end

@implementation ViewController

- (IBAction)presentFromTop:(id)sender
{
  [SampleSheetViewController presentWithStyle:NAModalSheetPresentationStyleSlideInFromTop slideInset:0.0];
}

- (IBAction)presentFromTopExcludingNavBar:(id)sender
{
  [SampleSheetViewController presentWithStyle:NAModalSheetPresentationStyleSlideInFromTop slideInset:[[UIApplication sharedApplication] statusBarFrame].size.height + myNavBar.frame.size.height];
}

- (IBAction)presentFromBottom:(id)sender
{
  [SampleBottomSheetViewController presentWithStyle:NAModalSheetPresentationStyleSlideInFromBottom slideInset:0.0];
}

- (IBAction)presentCentered:(id)sender
{
  [SampleSheetViewController presentWithStyle:NAModalSheetPresentationStyleFadeInCentered slideInset:0.0];
}

@end
