//
//  MapPathGenerator.m
//  iBeacon_Retail
//
//  Created by SHALINI on 4/15/15.
//  Copyright (c) 2015 TAVANT. All rights reserved.
//

#import "MapPathGenerator.h"

@implementation MapPathGenerator


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (_pathList==nil) {
        _pathList=[NSMutableArray array];
    }
    // Drawing code
    [self drawPath];

}
-(void)drawPath{

    UIBezierPath *path=[UIBezierPath bezierPath];
    CGPoint currentPoint;
    bool isSearchEnabled=NO;
    for (int i=0; i<_pathList.count; i++) {
        isSearchEnabled=YES;
        currentPoint=[(NSValue *)[_pathList objectAtIndex:i] CGPointValue];
        if(i==0)
           [path moveToPoint:currentPoint];
        else
            [path addLineToPoint:currentPoint];
    }
    
//    [[UIColor colorWithRed:61.0/255.0 green:185.0/255.0 blue:180.0/255.0 alpha:1.0] set];
    CAShapeLayer *progressLayer = [[CAShapeLayer alloc] init];
    
    [progressLayer setPath: path.CGPath];
    
    [progressLayer setStrokeColor:[UIColor colorWithRed:61.0/255.0 green:185.0/255.0 blue:180.0/255.0 alpha:1.0].CGColor];
    [progressLayer setFillColor:[UIColor clearColor].CGColor];
    [progressLayer setLineWidth:5.0];
    [progressLayer setStrokeStart:0.0];
    [progressLayer setStrokeEnd:1.0];
    
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation *animateStrokeEnd = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animateStrokeEnd.duration  = 1.0f;
    animateStrokeEnd.fromValue = [NSNumber numberWithFloat:0.0f];
    animateStrokeEnd.toValue   = [NSNumber numberWithFloat:1.0f];
    [progressLayer addAnimation:animateStrokeEnd forKey:nil];
    UIImageView *pin=[[UIImageView alloc]initWithFrame:CGRectMake(currentPoint.x, currentPoint.y-15, 25, 25)];
    [pin setImage:[UIImage imageNamed:@"map-pin-red.png"]];
    [self.layer addSublayer:pin.layer];
    pin.hidden=YES;
    if (isSearchEnabled==YES) {
        pin.hidden=NO;
    }
    
}


-(void)setPathList:(NSMutableArray *)pathList
{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    _pathList = pathList;
    [self setNeedsDisplay];
}
@end
