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
    for (int i=0; i<_pathList.count; i++) {
        CGPoint currentPoint=[(NSValue *)[_pathList objectAtIndex:i] CGPointValue];
        if(i==0)
           [path moveToPoint:currentPoint];
        else
            [path addLineToPoint:currentPoint];
    }
    
    [[UIColor greenColor] set];
    [path setLineWidth:3.0];
    [path stroke];
}


-(void)setPathList:(NSMutableArray *)pathList
{
    _pathList = pathList;
    [self setNeedsDisplay];
}
@end
