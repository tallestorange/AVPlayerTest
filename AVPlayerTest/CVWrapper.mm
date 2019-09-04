//
//  CVWrapper.m
//  AVPlayerTest
//
//  Created by Yuhel Tanaka on 2019/09/05.
//  Copyright © 2019 Yuhel Tanaka. All rights reserved.
//

#import "CVWrapper.h"

using namespace cv;
using namespace std;

@implementation CVWrapper

VideoCapture cap;
Mat frame;

-(void)readFile:(NSString*)path {
    cap = VideoCapture([path UTF8String]);
}

-(void)readFrame {
    cap.read(frame);
}

-(UIImage*)outputUIImage {
    return MatToUIImage(frame);
}

-(void)getInfo {
    cout << cap.get(CAP_PROP_FRAME_WIDTH) << endl;
    cout << cap.get(CAP_PROP_FRAME_HEIGHT) << endl;
    cout << cap.get(CAP_PROP_FPS) << endl;
    cout << cap.get(CAP_PROP_FRAME_COUNT) << endl;
    cout << cap.get(CAP_PROP_POS_FRAMES) << endl;
}

-(void)seek:(double)position {
    cap.set(CAP_PROP_POS_AVI_RATIO, position);
}


@end
