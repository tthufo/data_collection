//
//  VRPExtension.h
//
//  Created by Thanh Hai Tran on 9/18/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

@interface VRPExtension : NSObject

@end

@interface NSObject (extension)

- (NSString*)resultString:(NSDictionary*)data;

- (NSString*)toBase64:(UIImage*)image;

- (NSString*)toString:(NSDictionary*)data;

- (UIImage*)fixedOrientation:(UIImage*)image;

@end
