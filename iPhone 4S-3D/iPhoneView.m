//
//  LogoView.m
//  iPhone4S-3D
//
//  Created by Ahmed Eid on 4/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IphoneView.h"

@implementation IphoneView
@synthesize delegate, exploded;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        CGRect iPhoneSize = CGRectMake(0, 0, 200, 350);
        
        iPhoneContainerLayer = [CALayer layer];
        iPhoneContainerLayer.frame = self.bounds;
        [self.layer addSublayer:iPhoneContainerLayer];
        
        //Create front iPhone image layer
        iPhoneFrontLayer= [CALayer layer];
        iPhoneFrontLayer.bounds =iPhoneSize;
        iPhoneFrontLayer.position = centerPoint;
        
        //Set front iPhone as image of contents of layer 
        UIImage *image = [UIImage imageNamed:@"iPhone4SFront.png"];
        CGImageRef iPhoneFrontCGImage = [image CGImage];
        iPhoneFrontLayer.contents =(__bridge id)iPhoneFrontCGImage;
        [iPhoneContainerLayer addSublayer:iPhoneFrontLayer];
        
        //Create rear iPhone image layer 
        iPhoneRearLayer = [CALayer layer];
        iPhoneRearLayer.bounds = iPhoneSize;
        iPhoneRearLayer.position = centerPoint;
        UIImage *iPhoneRearImage = [UIImage imageNamed:@"iPhone4SRear.png"];
        UIImage *iPhoneRearImageMirrored = [UIImage imageWithCGImage:iPhoneRearImage.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
        CGImageRef iPhoneRearCGImage = [iPhoneRearImageMirrored CGImage];
        iPhoneRearLayer.contents =(__bridge id)iPhoneRearCGImage;

        //Set initial zPosition of RearLayer
        iPhoneRearLayer.zPosition = -20;
        [iPhoneContainerLayer addSublayer:iPhoneRearLayer];
        
        //Create the iPhone battery layer 
        iPhoneBatteryLayer = [CALayer layer];
        iPhoneBatteryLayer.bounds = iPhoneSize;
        iPhoneBatteryLayer.position = centerPoint;
        UIImage *iPhoneBatteryImage = [UIImage imageNamed:@"iPhone4SBattery.png"];
        UIImage *iPhoneBatteryImageMirrored = [UIImage imageWithCGImage:iPhoneBatteryImage.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
        CGImageRef iPhoneBatteryCGImage = [iPhoneBatteryImageMirrored CGImage];
        iPhoneBatteryLayer.contents =(__bridge id)iPhoneBatteryCGImage;
        iPhoneBatteryLayer.zPosition = -10;
        [iPhoneContainerLayer addSublayer:iPhoneBatteryLayer];
        
        //Add Perspective Effect 
        CATransform3D initialTransform = iPhoneContainerLayer.sublayerTransform;
        initialTransform.m34 = 1.0 / -500;
        iPhoneContainerLayer.sublayerTransform = initialTransform;
        
        self.multipleTouchEnabled = YES;
        self.exploded = NO;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    NSMutableSet *currenttouches = [[event touchesForView:self] mutableCopy];
    [currenttouches minusSet:touches];

    //New Touches are not included in th current touches for the view 
    NSSet *totalTouches = [touches setByAddingObjectsFromSet:[event touchesForView:self]];
    if ([totalTouches count] >1)
    {
        startingTouchDistance = [self distanceBetweenTwoTouches:totalTouches];
        previousScale = 1.0;
    } else {
        previousLocation = [[touches anyObject] locationInView:self];
    } 

    //On Double Tap, show detailed info for any part 
    UITouch *touch = [touches anyObject];
    if (touch.tapCount >1)
    {
        //For delegate Method
        CGPoint point = [[touches anyObject] locationInView:self];
        CALayer *touchedLayer = [self.layer hitTest:point];
        if (delegate)
        {
            if (touchedLayer == iPhoneFrontLayer)           [delegate iPhoneFrontTapped];
             else if (touchedLayer == iPhoneRearLayer)      [delegate iPhoneRearTapped];
             else if (touchedLayer == iPhoneBatteryLayer)   [delegate iPhoneBatteryTapped];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //Handle Pinch Gesture
    if ([[event touchesForView:self] count] >1)
    {
        CGFloat newTouchDistance = [self distanceBetweenTwoTouches:[event touchesForView:self]];
        CGFloat incrementalScaleFactor = (newTouchDistance / startingTouchDistance) / previousScale;
        if (incrementalScaleFactor >2.0)
        {
            return;
        }
        CATransform3D currentTransform = iPhoneContainerLayer.sublayerTransform;
        CATransform3D scaleTransform = CATransform3DScale(currentTransform, incrementalScaleFactor, incrementalScaleFactor, incrementalScaleFactor);
        iPhoneContainerLayer.sublayerTransform = scaleTransform;
        previousScale = (newTouchDistance / startingTouchDistance);
    } else {
        //Handle swipe gesture 
        CGPoint location = [[touches anyObject] locationInView:self];        
        CATransform3D currentTransform = iPhoneContainerLayer.sublayerTransform;
        CGFloat displacementInX = location.x - previousLocation.x;
        CGFloat displacementInY = previousLocation.y - location.y;
        
        //Pythagorean theorem
        CGFloat totalRotation = sqrt(displacementInX * displacementInX + displacementInY * displacementInY);
        CATransform3D rotationalTransform = CATransform3DRotate(currentTransform, totalRotation * M_PI / 180.0, 
            ((displacementInX/totalRotation) * currentTransform.m12 + (displacementInY/totalRotation) * currentTransform.m11), 
            ((displacementInX/totalRotation) * currentTransform.m22 + (displacementInY/totalRotation) * currentTransform.m21), 
            ((displacementInX/totalRotation) * currentTransform.m32 + (displacementInY/totalRotation) * currentTransform.m31));
        previousLocation = location;
        iPhoneContainerLayer.sublayerTransform = rotationalTransform;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //If transitioning from a pinch gesture to a rotation, make sure the starting touch location is set properly
	NSMutableSet *remainingTouches = [[event touchesForView:self] mutableCopy];
    [remainingTouches minusSet:touches];
	if ([remainingTouches count] < 2)
	{
		previousLocation = [[remainingTouches anyObject] locationInView:self];
	}
}

-(float)distanceBetweenTwoTouches:(NSSet *)touches
{
    int currentStage = 0;
    CGPoint point1, point2;
    
    for (UITouch *currentTouch in touches)
    {
        if (currentStage ==0)
        {
            point1 = [currentTouch locationInView:self];
            currentStage ++;
        }
        else if (currentStage ==1)
        {
            point2 = [currentTouch locationInView:self];
            currentStage ++;
        }
    }
	return (sqrt((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y)));
}

-(void)explodeIphone
{
    self.exploded = YES;
    iPhoneRearLayer.zPosition = -60;
    iPhoneRearLayer.position = CGPointMake(centerPoint.x -30, centerPoint.y +30);
    iPhoneBatteryLayer.zPosition = -40;
    iPhoneBatteryLayer.position = CGPointMake(centerPoint.x - 20, centerPoint.y + 20);
}

-(void)unExplodeIphone
{
    self.exploded = NO;
    iPhoneRearLayer.zPosition = -30;
    iPhoneBatteryLayer.zPosition = -20; 
    iPhoneRearLayer.position = centerPoint;
    iPhoneBatteryLayer.position = centerPoint;
}

#pragma mark Helper Methods 

-(CALayer *)layerWithBounds:(CGRect )bounds position:(CGPoint )position image:(UIImage *)image
{
    CALayer *layer = [CALayer layer];
    layer.bounds = bounds;
    layer.position = position;
    
    UIImage *layerImageMirrored = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationDownMirrored];
    CGImageRef layerCGImage = [layerImageMirrored CGImage];
    iPhoneRearLayer.contents =(__bridge id)layerCGImage;
    
    return layer;
}

@end
