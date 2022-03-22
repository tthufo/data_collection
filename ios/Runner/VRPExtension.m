//
//  VRPExtension.m
//
//  Created by Thanh Hai Tran on 9/18/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
#import "VRPExtension.h"

@implementation VRPExtension

@end

@implementation NSObject (extension)

- (NSString*)resultString:(NSDictionary*)data
{
    NSString * frontImage = [self toBase64:[self fixedOrientation:(UIImage*)data[@"front"][@"image"]]];
    NSString * backImage = [self toBase64:[self fixedOrientation:(UIImage*)data[@"back"][@"image"]]];
    NSString * faceImage = [self toBase64:[self fixedOrientation:(UIImage*)data[@"liveness"][@"image"]]];
    NSString * match = data[@"liveness"][@"data"][@"match"];
    NSString * percentage = data[@"liveness"][@"data"][@"percentage"];
    NSMutableDictionary * result = [[NSMutableDictionary alloc] initWithDictionary:data[@"front"][@"data"][@"value"]];
    result[@"match"] = match;
    result[@"percentage"] = percentage;
    NSMutableDictionary * backResult = [[NSMutableDictionary alloc] initWithDictionary:data[@"back"][@"data"][@"value"]];
    NSMutableDictionary * fraudResult = [[NSMutableDictionary alloc] initWithDictionary:data[@"front"][@"data"][@"fraud_info"]];
    NSMutableDictionary * resultObj = [NSMutableDictionary new];
    resultObj[@"face_item"] = result;
    resultObj[@"back_item"] = backResult;
    resultObj[@"fraud_info"] = fraudResult;
    resultObj[@"front_image"] = [[frontImage componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    resultObj[@"back_image"] = [[backImage componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    resultObj[@"face_image"] = [[faceImage componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@""];
    return [self toString:resultObj];
}

- (NSString*)toBase64:(UIImage*)image
{
  return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString*)toString:(NSDictionary*)data
{
  NSError * err;
  NSData * jsonData = [NSJSONSerialization dataWithJSONObject:data options:(NSJSONWritingOptions)NSJSONWritingPrettyPrinted error:&err];
  NSString * string = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  return string;
}

- (UIImage*)fixedOrientation:(UIImage*)image {
        
    if (image.imageOrientation == UIImageOrientationUp) {
        return image;
    }
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default: break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            // CORRECTION: Need to assign to transform here
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            // CORRECTION: Need to assign to transform here
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default: break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(nil, image.size.width, image.size.height, CGImageGetBitsPerComponent(image.CGImage), 0, CGImageGetColorSpace(image.CGImage), kCGImageAlphaPremultipliedLast);
    
    CGContextConcatCTM(ctx, transform);
    
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.height, image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
            break;
    }

    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    
    return [UIImage imageWithCGImage:cgImage];
}

@end
