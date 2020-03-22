//
//  NSString+Extension.m
//  SMT
//
//  Created by apple on 2017/8/8.
//  Copyright © 2017年 ZH. All rights reserved.
//

#import "NSString+Extension.h"
#import "sys/utsname.h"

@implementation NSString (Extension)


// - url 中文格式化utf-8
+ (NSString*)jq_UTF8Encoding:(NSString*)str
{
    /*! ios9适配的话 打开第一个,不知道为何打不开 */
//    if ([[UIDevice currentDevice] systemVersion].floatValue >= 9.0) {
//        return [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
//    } else {
        return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
}

//utf-8转gpk格式
- (NSString *)jq_URLEncodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

//gpk格式转utf-8
- (NSString*)jq_URLDecodedString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self, CFSTR(""),kCFStringEncodingUTF8));CFSTR(""),kCFStringEncodingUTF8;

    return result;
}


-(BOOL)jq_isNotNullObject
{
    if (self==nil ||[self isEqual:[NSNull null]]||[self isKindOfClass:[NSNull class]]||[self isEqual:@""]||[self isEqual:NULL]||[self isEqual:@"null"]||[self isEqual:@"<null>"]||[self isEqual:@"(null)"]||[self isEqual:@"nil"]||[self isEqual:@"空"]||[self isEqual:nil]||[self?:@"®" isEqual:@"®"]) {
        
        return NO;
    }
    return YES;
}

-(BOOL)jq_isNullObject
{
    
    if (self==nil ||[self isEqual:[NSNull null]]||[self isKindOfClass:[NSNull class]]||[self isEqual:@""]||[self isEqual:NULL]||[self isEqual:@"null"]||[self isEqual:@"<null>"]||[self isEqual:@"(null)"]||[self isEqual:@"nil"]||[self isEqual:@"空"]||[self isEqual:nil]||[self?:@"®" isEqual:@"®"]) {
        
        return YES;
    }
    return NO;
}


/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)jq_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    /**
     不能在这里尝试判断一行（无法获取高度）和是否包含中文
     （重点是，一行的时候外面style就不能设置lineSpacing,因为那样虽然得到的高度是对的，
     但是一行的时候文字顶了上去，超过了控件的顶部。）
     */
    paragraphStyle.lineSpacing = lineSpacing;
    
    [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [attributeString boundingRectWithSize:size options:options context:nil];
    
    //    NSLog(@"size:%@", NSStringFromCGSize(rect.size));
    
    //文本的高度减去字体高度小于等于行间距，判断为当前只有1行.
    if ((rect.size.height - font.lineHeight) <= paragraphStyle.lineSpacing) {
        if ([self jq_containChinese:self]) {  //如果包含中文,需要去掉一个行间距。
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-paragraphStyle.lineSpacing);
        }
    }
    
    
    return rect.size;
}



//判断是否包含中文
- (BOOL)jq_containChinese:(NSString *)str {
    
    for(int i=0; i< [str length];i++){
        
        int a = [str characterAtIndex:i];
        
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}


/**
 *  计算最大行数文字高度,可以处理计算带行间距的
 */
- (CGFloat)jq_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines{
    
    if (maxLines <= 0) {
        return 0;
    }
    
    CGFloat maxHeight = font.lineHeight * maxLines + lineSpacing * (maxLines - 1);
    
    CGSize orginalSize = [self jq_boundingRectWithSize:size font:font lineSpacing:lineSpacing];
    
    if ( orginalSize.height >= maxHeight ) {
        return maxHeight;
    }else{
        return orginalSize.height;
    }
}

/**
 *  计算是否超过一行   用于给Label 赋值attribute text的时候 超过一行设置lineSpace
 */
- (BOOL)jq_isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing{
    
    if ( [self jq_boundingRectWithSize:size font:font lineSpacing:lineSpacing].height > font.lineHeight  ) {
        return YES;
    }else{
        return NO;
    }
}


-(BOOL)isNullStr
{
    if (self==nil ||[self isEqual:[NSNull null]]||[self isKindOfClass:[NSNull class]]||[self isEqual:@""]||[self isEqual:@"null"]||[self isEqual:@"<null>"]||[self isEqual:@"(null)"]||[self isEqual:@"nil"]||[self isEqual:@"空"]||self.length==0) {
        
        return YES;
    }
    return NO;
}

-(BOOL)isNotNullStr
{
    if (self==nil ||[self isEqual:[NSNull null]]||[self isKindOfClass:[NSNull class]]||[self isEqual:@""]||[self isEqual:@"null"]||[self isEqual:@"<null>"]||[self isEqual:@"(null)"]||[self isEqual:@"nil"]||[self isEqual:@"空"]||self.length==0) {
        
        return NO;
    }
    return YES;
}

/**
     如果为空,返回字符串@""
 
     如果是空对象,会走NSObject+Extension,
     如果是字符串,会走NSString+Extension.
 */
-(instancetype)jq_isNotReturnNull
{
    if (self==nil ||[self isEqual:[NSNull null]]||[self isKindOfClass:[NSNull class]]||[self isEqual:@""]||[self isEqual:@"null"]||[self isEqual:@"<null>"]||[self isEqual:@"(null)"]||[self isEqual:@"nil"]||[self isEqual:@"空"]) {
        
        return @"";
    }
    
    //不为空，返回调用者本身
    return self;
}


/*手机系统版本*/
+(NSString *)jq_getPhoneVersion{
    return [[UIDevice currentDevice] systemVersion];
}

/*手机(设备)版本*/
+ (NSString*)jq_getDeviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    
    //iPod
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,1"])       return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])     return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,11"])return @"iPad 5 (WiFi)";
    if ([deviceString isEqualToString:@"iPad6,12"])return @"iPad 5 (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,1"])return @"iPad Pro 12.9 inch 2nd gen (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,2"])return @"iPad Pro 12.9 inch 2nd gen (Cellular)";
    if ([deviceString isEqualToString:@"iPad7,3"])return @"iPad Pro 10.5 inch (WiFi)";
    if ([deviceString isEqualToString:@"iPad7,4"])return @"iPad Pro 10.5 inch (Cellular)";
    
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceString isEqualToString:@"iPad4,4"]
        ||[deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceString isEqualToString:@"iPad4,7"]
        ||[deviceString isEqualToString:@"iPad4,8"]
        ||[deviceString isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    
    return deviceString;
}


-(void)jq_showAppInfo
{
    NSString *iPhoneName = [UIDevice currentDevice].name;
    NSLog(@"iPhone名称-->%@", iPhoneName);
    
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"app版本号-->%@", appVerion);
    
    CGFloat batteryLevel = [[UIDevice currentDevice] batteryLevel];
    NSLog(@"电池电量-->%f", batteryLevel);
    
    NSString *localizedModel = [UIDevice currentDevice].localizedModel;
    NSLog(@"localizedModel-->%@", localizedModel);
    
    NSString *systemName = [UIDevice currentDevice].systemName;
    NSLog(@"当前系统名称-->%@", systemName);
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    NSLog(@"当前系统版本号-->%@", systemVersion);
}

@end
