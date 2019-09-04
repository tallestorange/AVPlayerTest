//
//  CVWrapper.h
//  AVPlayerTest
//
//  Created by Yuhel Tanaka on 2019/09/05.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

#ifdef __cplusplus
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#endif
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CVWrapper : NSObject
-(void)readFile:(NSString*)path;
-(void)readFrame;
-(UIImage*)outputUIImage;
-(void)getInfo;
-(void)seek:(double)position;
@end

NS_ASSUME_NONNULL_END
