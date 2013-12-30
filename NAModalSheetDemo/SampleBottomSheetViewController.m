//
//  SampleBottomSheetViewController.m
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import "SampleBottomSheetViewController.h"

@interface SampleBottomSheetViewController () <NAModalSheetDelegate>
{
  __weak IBOutlet UISwitch* dismissOptionSwitch;
  __weak NAModalSheet* modalSheet;
}

@end

@implementation SampleBottomSheetViewController

+ (void)presentWithStyle:(NAModalSheetPresentationStyle)style slideInset:(CGFloat)slideInset
{
  SampleBottomSheetViewController *svc = [[SampleBottomSheetViewController alloc] init];
  NAModalSheet *sheet = [[NAModalSheet alloc] initWithViewController:svc presentationStyle:style];
  svc->modalSheet = sheet;
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

- (IBAction)sizeSwitchChanged:(id)sender
{
  UISwitch *sizeSwitch = (UISwitch*)sender;
  if ([sizeSwitch isKindOfClass:[UISwitch class]])
  {
    CGSize s = self.view.bounds.size;
    if (sizeSwitch.on)
    {
      s.height += 40;
      s.width -= 40;
    }
    else
    {
      s.height -= 40;
      s.width += 40;
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
