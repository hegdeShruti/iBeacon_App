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
    
    [[UIColor colorWithRed:61.0/255.0 green:185.0/255.0 blue:180.0/255.0 alpha:1.0] set];
    [path setLineWidth:7.0];
    [path stroke];
    [[UIColor colorWithRed:61.0/255.0 green:185.0/255.0 blue:180.0/255.0 alpha:1.0] set];
    [path setLineWidth:7.0];
    [path stroke];
    UIImageView *pin=[[UIImageView alloc]initWithFrame:CGRectMake(currentPoint.x, currentPoint.y, 10, 20)];
    [pin setImage:[UIImage imageNamed:@"map-pin-green.png"]];
    [self addSubview:pin];
    pin.hidden=YES;
    if (isSearchEnabled==YES) {
        pin.hidden=YES;
    }

    
}


-(void)setPathList:(NSMutableArray *)pathList
{
    _pathList = pathList;
    [self setNeedsDisplay];
}
@end
