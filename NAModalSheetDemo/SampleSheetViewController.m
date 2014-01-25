//
//  SampleSheetViewController.m
//  NAModalSheet
//
//  Created by Ken Worley on 11/22/13.
//  Copyright (c) 2013 Ken Worley. All rights reserved.
//

#import "SampleSheetViewController.h"
#import "NAModalSheet.h"

@implementation SampleSheetViewController

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
  [self.modalSheet dismissWithCompletion:^{
    
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
    [self.modalSheet adjustContentSize:s animated:YES];
  }
}

@end
