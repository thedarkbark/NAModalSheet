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

@interface ViewController () <NAModalSheetDelegate>
{
  __weak IBOutlet UINavigationBar* myNavBar;
  __weak IBOutlet UISwitch* landscapeSwitch;
  __weak IBOutlet UILabel* landscapeSwitchLabel;
  __weak IBOutlet UISwitch* dismissOnOutsideTouchSwitch;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
  landscapeSwitch.on = YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
  landscapeSwitch.hidden = (UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
  landscapeSwitchLabel.hidden = landscapeSwitch.hidden;
}

- (IBAction)presentFromTop:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromTop];
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentFromTopExcludingNavBar:(id)sender
{
  CGSize sbSize = [[UIApplication sharedApplication] statusBarFrame].size;
  CGFloat statusBarHeight = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? sbSize.width : sbSize.height;
  CGSize nbSize = myNavBar.frame.size;
  
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromTop];
  sheet.slideInset = statusBarHeight + nbSize.height;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentFromBottom:(id)sender
{
  SampleBottomSheetViewController *svc = [[SampleBottomSheetViewController alloc] init];
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleSlideInFromBottom];
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (IBAction)presentCentered:(id)sender
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:NAModalSheetPresentationStyleFadeInCentered];
  sheet.cornerRadiusWhenCentered = 24.0;
  sheet.delegate = self;
  svc.modalSheet = sheet;
  [sheet presentWithCompletion:^{
    
  }];
}

- (BOOL)shouldAutorotate
{
  return landscapeSwitch.on;
}

- (NSUInteger)supportedInterfaceOrientations
{
  return (landscapeSwitch.on ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait);
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
