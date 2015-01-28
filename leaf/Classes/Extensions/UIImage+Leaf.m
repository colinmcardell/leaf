//
//  UIImage+Leaf.m
//
//  leaf - iOS Synthesizer
//  Copyright (C) 2015 Colin McArdell
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "UIImage+Leaf.h"

@implementation UIImage (Leaf)

+ (void)beginImageContextWithSize:(CGSize)size
{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
}

+ (UIImage *)sineImageWithColor:(UIColor *)color
{
    CGRect size = CGRectMake(0, 0, 28, 18);
    [self beginImageContextWithSize:size.size];
    CGRect sineFrame = CGRectMake(2, 2, 24, 14);

    UIBezierPath *sinePath = [UIBezierPath bezierPath];
    CGFloat sineFrameWidth = CGRectGetWidth(sineFrame);
    CGFloat sineFrameHeight = CGRectGetHeight(sineFrame);
    CGFloat sineFrameMinX = CGRectGetMinX(sineFrame);
    CGFloat sineFrameMinY = CGRectGetMinY(sineFrame);

    [sinePath moveToPoint:CGPointMake(sineFrameMinX + 0.12505 * sineFrameWidth, sineFrameMinY + 0.55476 * sineFrameHeight)];

    [sinePath addCurveToPoint:CGPointMake(sineFrameMinX + 0.31743 * sineFrameWidth, sineFrameMinY + 0.18333 * sineFrameHeight)
                controlPoint1:CGPointMake(sineFrameMinX + 0.12505 * sineFrameWidth, sineFrameMinY + 0.55476 * sineFrameHeight)
                controlPoint2:CGPointMake(sineFrameMinX + 0.22124 * sineFrameWidth, sineFrameMinY + 0.18333 * sineFrameHeight)];

    [sinePath addCurveToPoint:CGPointMake(sineFrameMinX + 0.50980 * sineFrameWidth, sineFrameMinY + 0.48333 * sineFrameHeight)
                controlPoint1:CGPointMake(sineFrameMinX + 0.41361 * sineFrameWidth, sineFrameMinY + 0.18333 * sineFrameHeight)
                controlPoint2:CGPointMake(sineFrameMinX + 0.50980 * sineFrameWidth, sineFrameMinY + 0.48333 * sineFrameHeight)];

    [sinePath addCurveToPoint:CGPointMake(sineFrameMinX + 0.70218 * sineFrameWidth, sineFrameMinY + 0.81667 * sineFrameHeight)
                controlPoint1:CGPointMake(sineFrameMinX + 0.50980 * sineFrameWidth, sineFrameMinY + 0.48333 * sineFrameHeight)
                controlPoint2:CGPointMake(sineFrameMinX + 0.60599 * sineFrameWidth, sineFrameMinY + 0.80833 * sineFrameHeight)];

    [sinePath addCurveToPoint:CGPointMake(sineFrameMinX + 0.89456 * sineFrameWidth, sineFrameMinY + 0.44524 * sineFrameHeight)
                controlPoint1:CGPointMake(sineFrameMinX + 0.79837 * sineFrameWidth, sineFrameMinY + 0.82500 * sineFrameHeight)
                controlPoint2:CGPointMake(sineFrameMinX + 0.89456 * sineFrameWidth, sineFrameMinY + 0.44524 * sineFrameHeight)];
    
    [color setStroke];
    [sinePath setLineWidth:1];
    [sinePath stroke];
    
    UIImage *sine = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [sine resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (UIImage *)sawImageWithColor:(UIColor *)color
{
    CGRect size = CGRectMake(0, 0, 28, 18);
    [self beginImageContextWithSize:size.size];
    CGRect frame = CGRectMake(2, 2, 24, 14);
    
    UIColor *colorLight = [color colorWithAlphaComponent:0.4f];
    
    CGFloat frameMinX = CGRectGetMinX(frame);
    CGFloat frameMinY = CGRectGetMinY(frame);
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 21, frameMinY + 2, 1, 10)];
    [color setFill];
    [path1 fill];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 19, frameMinY + 3, 2, 1)];
    [color setFill];
    [path2 fill];
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 17, frameMinY + 4, 2, 1)];
    [color setFill];
    [path3 fill];
    
    UIBezierPath *path4 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 15, frameMinY + 5, 2, 1)];
    [color setFill];
    [path4 fill];
    
    UIBezierPath *path5 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 13, frameMinY + 6, 2, 1)];
    [color setFill];
    [path5 fill];
    
    UIBezierPath *path6 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 11, frameMinY + 7, 2, 1)];
    [color setFill];
    [path6 fill];
    
    UIBezierPath *path7 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 9, frameMinY + 8, 2, 1)];
    [color setFill];
    [path7 fill];
    
    UIBezierPath *path8 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 7, frameMinY + 9, 2, 1)];
    [color setFill];
    [path8 fill];
    
    UIBezierPath *path9 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 5, frameMinY + 10, 2, 1)];
    [color setFill];
    [path9 fill];
    
    UIBezierPath *path10 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 3, frameMinY + 11, 2, 1)];
    [color setFill];
    [path10 fill];
    
    UIBezierPath *path11 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 2, frameMinY + 11, 1, 1)];
    [colorLight setFill];
    [path11 fill];
    
    UIImage *saw = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [saw resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (UIImage *)squareImageWithColor:(UIColor *)color
{
    CGRect size = CGRectMake(0, 0, 28, 18);
    [self beginImageContextWithSize:size.size];
    CGRect frame = CGRectMake(2, 2, 24, 14);
    
    CGFloat frameMinX = CGRectGetMinX(frame);
    CGFloat frameMinY = CGRectGetMinY(frame);

    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 21, frameMinY + 6, 1, 6)];
    [color setFill];
    [path1 fill];

    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 12, frameMinY + 11, 9, 1)];
    [color setFill];
    [path2 fill];

    UIBezierPath *path3 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 11, frameMinY + 2, 1, 10)];
    [color setFill];
    [path3 fill];

    UIBezierPath *path4 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 3, frameMinY + 2, 8, 1)];
    [color setFill];
    [path4 fill];

    UIBezierPath *path5 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 2, frameMinY + 2, 1, 6)];
    [color setFill];
    [path5 fill];
    
    UIImage *square = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [square resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

+ (UIImage *)triangleImageWithColor:(UIColor *)color
{
    CGRect size = CGRectMake(0, 0, 28, 18);
    [self beginImageContextWithSize:size.size];
    CGRect frame = CGRectMake(2, 2, 24, 14);
    
    CGFloat frameMinX = CGRectGetMinX(frame);
    CGFloat frameMinY = CGRectGetMinY(frame);

    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 21, frameMinY + 6, 1, 1)];
    [color setFill];
    [path1 fill];

    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 20, frameMinY + 7, 1, 1)];
    [color setFill];
    [path2 fill];

    UIBezierPath *path3 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 19, frameMinY + 8, 1, 1)];
    [color setFill];
    [path3 fill];

    UIBezierPath *path4 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 18, frameMinY + 9, 1, 1)];
    [color setFill];
    [path4 fill];

    UIBezierPath *path5 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 17, frameMinY + 10, 1, 1)];
    [color setFill];
    [path5 fill];

    UIBezierPath *path6 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 16, frameMinY + 11, 1, 1)];
    [color setFill];
    [path6 fill];

    UIBezierPath *path7 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 15, frameMinY + 10, 1, 1)];
    [color setFill];
    [path7 fill];

    UIBezierPath *path8 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 14, frameMinY + 9, 1, 1)];
    [color setFill];
    [path8 fill];

    UIBezierPath *path9 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 13, frameMinY + 8, 1, 1)];
    [color setFill];
    [path9 fill];

    UIBezierPath *path10 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 12, frameMinY + 7, 1, 1)];
    [color setFill];
    [path10 fill];

    UIBezierPath *path11 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 11, frameMinY + 6, 1, 1)];
    [color setFill];
    [path11 fill];

    UIBezierPath *path12 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 10, frameMinY + 5, 1, 1)];
    [color setFill];
    [path12 fill];

    UIBezierPath *path13 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 9, frameMinY + 4, 1, 1)];
    [color setFill];
    [path13 fill];

    UIBezierPath *path14 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 8, frameMinY + 3, 1, 1)];
    [color setFill];
    [path14 fill];

    UIBezierPath *path15 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 7, frameMinY + 2, 1, 1)];
    [color setFill];
    [path15 fill];

    UIBezierPath *path16 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 6, frameMinY + 3, 1, 1)];
    [color setFill];
    [path16 fill];

    UIBezierPath *path17 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 5, frameMinY + 4, 1, 1)];
    [color setFill];
    [path17 fill];

    UIBezierPath *path18 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 4, frameMinY + 5, 1, 1)];
    [color setFill];
    [path18 fill];

    UIBezierPath *path19 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 3, frameMinY + 6, 1, 1)];
    [color setFill];
    [path19 fill];

    UIBezierPath *path20 = [UIBezierPath bezierPathWithRect:CGRectMake(frameMinX + 2, frameMinY + 7, 1, 1)];
    [color setFill];
    [path20 fill];
    
    UIImage *triangle = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [triangle resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
}

@end
