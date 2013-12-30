//
//  SampleSheetViewController.m
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import "SampleSheetViewController.h"

@interface SampleSheetViewController () <NAModalSheetDelegate>
{
  __weak IBOutlet UISwitch* dismissOptionSwitch;
  __weak NAModalSheet* modalSheet;
}

@end

@implementation SampleSheetViewController

+ (void)presentWithStyle:(NAModalSheetPresentationStyle)style slideInset:(CGFloat)slideInset
{
  SampleSheetViewController *svc = [[SampleSheetViewController alloc] init];
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:style];
  svc->modalSheet = sheet;
  sheet.cornerRadiusWhenCentered = 24.0;
  sheet.slideInset = slideInset;
  sheet.delegate = svc;
  
  [sheet presentWithCompletion:^{
    
  }];
}

- (instancetype)init
{
  self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
  if (self)
  {
  }
  return self;
}

- (IBAction)dismissButtonTouched:(id)sender
{
  [modalSheet dismissWithCompletion:^{
    
  }];
}

- (IBAction)largerSizeSwitchChanged:(id)sender
{
  UISwitch *sizeSwitch = (UISwitch*)sender;
  if ([sizeSwitch isKindOfClass:[UISwitch class]])
  {
    CGSize s = self.view.bounds.size;
    if (sizeSwitch.on)
    {
      s.height += 40;
      s.width += 40;
    }
    else
    {
      s.height -= 40;
      s.width -= 40;
    }
    [modalSheet adjustContentSize:s animated:YES];
  }
}

#pragma mark NAModalSheetDelegate

- (void)modalSheetTouchedOutsideContent:(NAModalSheet *)sheet
{
  if (dismissOptionSwitch.on)
  {
    [modalSheet dismissWithCompletion:^{
      
    }];
  }
}

@end
