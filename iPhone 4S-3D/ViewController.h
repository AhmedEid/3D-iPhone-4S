//
//  ViewController.h
//  iPhone4S-3D
//
//  Created by Ahmed Eid on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IphoneView.h"

@interface ViewController : UIViewController <iPhoneViewTapsDelegate>

@property (nonatomic, strong) IphoneView *iPhoneView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *explodeButton;
- (IBAction)fade:(id)sender;
- (IBAction)bounce:(id)sender;
- (IBAction)explode:(id)sender;

@end
