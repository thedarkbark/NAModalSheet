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
#import "NAModalSheet.h"
#import "UIImage+BoxBlur.h"

@interface ViewController () <NAModalSheetDelegate>
{
  __weak IBOutlet UINavigationBar* myNavBar;
  __weak IBOutlet UISwitch* landscapeSwitch;
  __weak IBOutlet UISwitch* dismissOnOutsideTouchSwitch;
  __weak IBOutlet UILabel* dismissOutsideLabel;
  __weak IBOutlet UISwitch* disableBlurSwitch;
  __weak IBOutlet UILabel* disableBlurLabel;
}
@end

@implementation ViewController

- (void)viewDidLayoutSubviews
{
  CGRect f = dismissOutsideLabel.frame;
  f.origin.x = CGRectGetMaxX(dismissOnOutsideTouchSwitch.frame) + 8.0;
  dismissOutsideLabel.frame = f;
  
  f = disableBlurLabel.frame;
  f.origin.x = CGRectGetMaxX(disableBlurSwitch.frame) + 8.0;
  disableBlurLabel.frame = f;
}

- (IBAction)presentFromTop:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromTop];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentFromTopExcludingNavBar:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromUnderNavBar];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentFromBottom:(id)sender
{
  SampleBottomSheetViewController *svc = [[SampleBottomSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromBottom];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentCentered:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleFadeInCentered];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.cornerRadiusWhenCentered = 24.0;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentCustomFromTop:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  svc.opaque = disableBlurSwitch.on;
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromTop];
  sheet.disableBlurredBackground = disableBlurSwitch.on;
  sheet.delegate = self;
  sheet.backgroundProcessingBlock = ^(UIImage *image) {
    NSData *imageData = UIImageJPEGRepresentation(image, 0.01);
    return [[UIImage imageWithData:imageData] blurredImage:0.1];
  };
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
      
  }];
}

#pragma mark NAModalSheetDelegate

- (void)modalSheetTouchedOutsideContent:(NAModalSheet *)sheet
{
  if (dismissOnOutsideTouchSwitch.on)
  {
    [sheet dismissWithCompletion:^{
      
    }];
  }
}

- (BOOL)modalSheetShouldAutorotate:(NAModalSheet *)sheet
{
  return [self shouldAutorotate];
}

- (NSUInteger)modalSheetSupportedInterfaceOrientations:(NAModalSheet *)sheet
{
  return [self supportedInterfaceOrientations];
}

@end
