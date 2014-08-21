//
//  SampleTooltipViewController.m
//  NAModalSheetDemo
//
//  Created by Ken Worley on 8/20/14.
//  Copyright (c) 2014 Ken Worley. All rights reserved.
//

#import "SampleTooltipViewController.h"
#import "NAModalSheet.h"

@interface SampleTooltipViewController ()

@end

@implementation SampleTooltipViewController

- (id)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)touched:(id)sender
{
  [self.sheet dismissWithCompletion:^{
    
  }];
}

@end
