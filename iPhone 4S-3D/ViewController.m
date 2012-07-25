//
//  ViewController.m
//  iPhone4S-3D
//
//  Created by Ahmed Eid on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "IphoneView.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize iPhoneView = _iPhoneView;
@synthesize explodeButton = _explodeButton;

- (void)viewDidLoad
{
    [super viewDidLoad];  
    self.iPhoneView = [[IphoneView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    self.iPhoneView.delegate = self;
    [self.view addSubview:self.iPhoneView];
}

- (void)viewDidUnload
{
    [self setExplodeButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)fade:(id)sender {
    if (self.iPhoneView.layer.opacity ==1)
    {
        [self fadeView:self.iPhoneView fromOpacity:1 toOpacity:0 withDuration:3];
    } else
    {
        [self fadeView:self.iPhoneView fromOpacity:0 toOpacity:1 withDuration:3];
    }
}

- (IBAction)bounce:(id)sender {
    
    CAKeyframeAnimation *bounce = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    CATransform3D forward = CATransform3DMakeScale(1.3, 1.3, 1);
    CATransform3D back = CATransform3DMakeScale(0.7, 0.7, 1);
    CATransform3D forward2 = CATransform3DMakeScale(1.0, 1.0, 1);
    CATransform3D back2 = CATransform3DMakeScale(0.9, 0.9, 1);
    
    NSArray *bouncesArray = [NSArray arrayWithObjects:
                             [NSValue valueWithCATransform3D:CATransform3DIdentity],
                             [NSValue valueWithCATransform3D:forward], 
                             [NSValue valueWithCATransform3D:back], 
                             [NSValue valueWithCATransform3D:forward2], 
                              [NSValue valueWithCATransform3D:back2],
                              [NSValue valueWithCATransform3D:CATransform3DIdentity],
                              nil];
    [bounce setValues:bouncesArray];
    [bounce setDuration:1.0];
    
    [self.iPhoneView.layer addAnimation:bounce forKey:@"bounce"];
}

- (IBAction)explode:(id)sender {
    if (!self.iPhoneView.exploded) {
        self.explodeButton.title = @"Unexplode";
        [self.iPhoneView explodeIphone];
    } else if (self.iPhoneView.exploded) {
        self.explodeButton.title = @"Explode";
        [self.iPhoneView unExplodeIphone];
    }
}

/*
- (IBAction)scale:(id)sender {
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D currentTransform = self.logoView.layer.sublayerTransform;
    CATransform3D scaleTransform = CATransform3DScale(currentTransform, 0.5, 0.5, 0.5);
    self.logoView.layer.sublayerTransform = scaleTransform;    

    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:currentTransform];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:scaleTransform];
    scaleAnimation.duration = 3;
    
    [self.logoView.layer addAnimation:scaleAnimation forKey:@"ScaleAnimation"];
}
*/

#pragma mark - CoreAnimationHelperMethods 

-(void)fadeView:(UIView *)view fromOpacity:(int)fromOpacity toOpacity:(int)toOpacity withDuration:(int)duration
{
    //Setup an explicit animation
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = [NSNumber numberWithInt:fromOpacity];
    fade.toValue = [NSNumber numberWithInt:toOpacity];
    fade.duration = duration;
    [view.layer addAnimation:fade forKey:nil];
    
    //Change the model layer 
    if (toOpacity ==0) {
        view.layer.opacity = 0;
    } else if (toOpacity ==1)
    {
        view.layer.opacity = 1;
    }
}

#pragma mark - iPhoneTapsDelegateMethods 

-(void)iPhoneFrontTapped
{
    NSLog(@"Front of iPhone was tapped");
    [self showAlertViewWithTitle:@"Front of iPhone was tapped" andMessage:nil];
}

-(void)iPhoneRearTapped
{
    NSLog(@"Rear of iPhone was tapped");
    [self showAlertViewWithTitle:@"Rear of iPhone was tapped" andMessage:nil];

}

-(void)iPhoneBatteryTapped
{
    NSLog(@"Battery of iPhone was tapped");
    [self showAlertViewWithTitle:@"Battery of iPhone was tapped" andMessage:nil];
}

#pragma mark - Helper Methods 

-(void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Alright" otherButtonTitles:nil, nil];
    [alert show];
}

@end
