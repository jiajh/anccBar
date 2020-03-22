//
//  ZXHanxinReader.m
//  SMT
//
//  Created by 张大蓓 on 15/5/31.
//  Copyright (c) 2015年 ZH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXHanxinReader.h"

#import "ZXBinaryBitmap.h"
#import "ZXBitMatrix.h"
#import "ZXDecodeHints.h"
#import "ZXDecoderResult.h"
#import "ZXErrors.h"
#import "ZXIntArray.h"
#import "ZXResult.h"
#import "hanxinpro.h"
#import "ZXBinarizer.h"
#import "ZXLuminanceSource.h"
#import "ZXCGImageLuminanceSource.h"
#import "ZXByteArray.h"
#import "NSString+Extension.h"


#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    #define kCGImageAlphaNone  (kCGBitmapByteOrderDefault | kCGImageAlphaNone)
#else
    #define kCGImageAlphaNone  kCGImageAlphaNone
#endif


@interface ZXHanxinReader ()


@end

@implementation ZXHanxinReader

+ (id)reader {
    return [[ZXHanxinReader alloc] init];
}

- (ZXResult *)decode:(ZXBinaryBitmap *)image error:(NSError **)error {
    return [self decode:image hints:nil error:error];
}

- (ZXResult *)decode:(ZXBinaryBitmap *)image hints:(ZXDecodeHints *)hints error:(NSError **)error {
    ZXResult *result;
    ZXCGImageLuminanceSource *source = (ZXCGImageLuminanceSource *)image.binarizer.luminanceSource;
//    if (source.image) {
//        return nil;
//    }
    UIImage *img = [UIImage imageWithCGImage:source.image];
    
    
//------------------------新增ZBar框架，主要是为了识别kBarcodeFormatRSSExpanded格式,kBarcodeFormatRSS14格式zxing识别太慢。-----------------------------
    //初始化
    ZBarReaderController * read = [ZBarReaderController new];
    //设置代理
    read.readerDelegate = self;
    CGImageRef cgImageRef = img.CGImage;
    ZBarSymbol * symbol = nil;
    id <NSFastEnumeration> results = [read scanImage:cgImageRef];
    for (symbol in results)
    {
        break;
    }
    NSString * jq_resultText = symbol.data;
//    KDLOG(@"jq_resultText  ==%@",jq_resultText);
    
    if (jq_resultText.isNotNullStr&&symbol.type==ZBAR_DATABAR_EXP) {
        
        result = [ZXResult resultWithText:jq_resultText rawBytes:nil resultPoints:nil format:kBarcodeFormatRSSExpanded];
        
        return result;
    }
    else if (jq_resultText.isNotNullStr&&symbol.type==ZBAR_DATABAR)
    {
        result = [ZXResult resultWithText:jq_resultText rawBytes:nil resultPoints:nil format:kBarcodeFormatRSS14];
        
        return result;
    }
    else if (jq_resultText.isNotNullStr&&symbol.type==ZBAR_QRCODE) //部分QR码zxing识别不出来,这里选用zbar
    {
        
        result = [ZXResult resultWithText:jq_resultText rawBytes:nil resultPoints:nil format:kBarcodeFormatQRCode];
        
        return result;
        
    }

    
//
//    ZXCGImageLuminanceSource *source = (ZXCGImageLuminanceSource *)image.binarizer.luminanceSource;
//    UIImage *img = [UIImage imageWithCGImage:source.image];
    float width = img.size.width;
    float height = img.size.height;
    
    // 灰度像素数组
    unsigned char *pixels = (unsigned char *) calloc(sizeof(unsigned char),width * height);
    
    // 填充灰度像素数组方法1
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
//    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(unsigned char), colorSpace, kCGImageAlphaNone);
//    CGColorSpaceRelease(colorSpace);
//    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width,height), img.CGImage);
//    CGContextRelease(context);
    
    // 填充灰度像素数组方法2
    ZXByteArray *matrix = [source matrix];
    for (int y=0; y<source.height; y++) {
        for (int x=0; x<source.width; x++) {
            pixels[y * source.width + x] = matrix.array[y * source.width + x] & 0xff;
        }
    }
    
    // 根据灰度图像生成的01矩阵
    unsigned char *vecNetMap = (unsigned char *) calloc(sizeof(unsigned char),189 * 189);
    
    __block int len = 0;
    // 从图集选择的图片，本函数本身就在主队列运行，如果执行dispatch_sync(dispatch_get_main_queue())会造成死锁，程序无限挂起
    if ([hints.other boolValue]) {  // 来自图集
        len = preprocessImg(pixels, width, height, vecNetMap);
    }else{  // 来自摄像头
        dispatch_sync(dispatch_get_main_queue(), ^{
            // 该函数不在主线程执行的话，有很大几率报EXC_BAD_ACCESS(code=2,address=0x地址)的错误
            //TODO 该函数在主线程执行会占用大概0.05-0.1s左右的时间，这会影响扫码界面光栅的不断移动，会有卡顿的感觉
            len = preprocessImg(pixels, width, height, vecNetMap);
        });
    }
    
    free(pixels);// malloc申请的堆内存必须通过free手动释放，否则只有程序退出才会释放
    if (len >= 23 && len <=189) {
        // 不必截取字符串，因为calloc已经将所有内存空间初始化为0，而preprocessImg只填充了需要的部分
//        unsigned char *subch = calloc(sizeof(unsigned char),(len*len+1));
//        for(int i=0;i<len*len;i++){
//            subch[i]=*(vecNetMap++);
//        }
//        subch[len*len]='\0';//加上字符串结束符。
        
        unsigned char *szInfo = (unsigned char *) calloc(sizeof(unsigned char),7828);
        int ret2 = DeCodeCsbyte(vecNetMap, len, szInfo);
        if (ret2 > 0) {
            
/**#########################################################################################
            
            测试所有的转码格式，找到合适的编码。
            
#########################################################################################*/
            
//            const NSStringEncoding *encodings = [NSString availableStringEncodings];
//            NSStringEncoding encoding;
//            while ((encoding = *encodings++) != 0){
//                NSString *s = [[NSString alloc] initWithCString:(const char *)szInfo encoding:encoding];
//                KDLOG(@"zzzzz----%lu:%@",encoding,s);
//            }
//            
//            int codes[] = {
//                kCFStringEncodingGB_2312_80 ,
//                kCFStringEncodingGBK_95 ,		/* annex to GB 13000-93; for Windows 95 */
//                kCFStringEncodingGB_18030_2000,
//                kCFStringEncodingCNS_11643_92_P1,	/* CNS 11643-1992 plane 1 */
//                kCFStringEncodingCNS_11643_92_P2,	/* CNS 11643-1992 plane 2 */
//                kCFStringEncodingCNS_11643_92_P3,	/* CNS 11643-1992 plane 3 (was plane 14 in 1986 version) */
//                kCFStringEncodingISO_2022_CN ,
//                kCFStringEncodingISO_2022_CN_EXT ,
//                kCFStringEncodingEUC_CN ,		/* ISO 646, GB 2312-80 */
//                kCFStringEncodingEUC_TW ,		/* ISO 646, CNS 11643-1992 Planes 1-16 */
//                kCFStringEncodingHZ_GB_2312
//            };
//            for (int i=0; i<11; i++) {
//                NSString *s = [[NSString alloc] initWithCString:(const char *)szInfo encoding:CFStringConvertEncodingToNSStringEncoding(codes[i])];
//                KDLOG(@"i==%d,s==%@",i,s);
//            }
            
//-------------------------end----------------------------------
            
            
            
//            KDLOG(@"szInfo---%s",szInfo);

            
            NSString *text = [[NSString alloc] initWithCString:(const char *)szInfo encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
            
            
            
//            NSString *text = [NSString stringWithFormat:@"%s",szInfo];
//            text = [text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            
//            text = [text jq_URLEncodedString];
            
//
//            NSLog(@"szInfo---%@",text);

            // 用汉信二维码app生成的码的编码格式是utf-8
//            NSString *text = [[NSString alloc] initWithCString:(const char *)szInfo encoding:NSUTF8StringEncoding];
            
//            NSString *text = [NSString stringWithCString:(const char *)szInfo encoding:NSUTF8StringEncoding];
            
//            KDLOG(@"jjjjtext---%@",text);

            // demo给的汉信码图片编码格式是GB18030，在这里再判断处理一下
            if (text.isNotNullStr) {

                //gpk转utf-8格式字符串
                text = [text jq_URLDecodedString];
                
//                KDLOG(@"原始text---%@",text);

            }
            result = [ZXResult resultWithText:text rawBytes:nil resultPoints:nil format:kBarcodeFormatHanxin];
        }
        free(szInfo);
    }
    free(vecNetMap);
    return result;

}

- (void) check:(NSArray *)argu{
    
}

- (void)reset {
    // do nothing
}


@end
