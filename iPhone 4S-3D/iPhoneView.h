//
//  LogoView.h
//  iPhone4S-3D
//
//  Created by Ahmed Eid on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol iPhoneViewTapsDelegate <NSObject>
-(void)iPhoneFrontTapped;
-(void)iPhoneRearTapped;
-(void)iPhoneBatteryTapped;
@end

@interface IphoneView : UIView
{
    CALayer *iPhoneContainerLayer;
    CALayer *iPhoneFrontLayer;
    CALayer *iPhoneRearLayer;
    CALayer *iPhoneBatteryLayer;
    
    CGPoint previousLocation;
    CGFloat startingTouchDistance, previousScale; 
    CGPoint centerPoint;
}

-(void)explodeIphone;
-(void)unExplodeIphone;

@property (nonatomic, assign) id <iPhoneViewTapsDelegate> delegate;
@property (nonatomic) BOOL exploded;

@end
