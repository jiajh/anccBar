//
//  x.h
//  SMT
//
//  Created by 张大蓓 on 15/5/31.
//  Copyright (c) 2015年 ZH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZXReader.h"
#import "ZBarSDK.h"


@class ZXBinaryBitmap, ZXDecodeHints, ZXResult;

@interface ZXHanxinReader : NSObject<ZXReader,ZBarReaderDelegate>

+ (id)reader;

@end
