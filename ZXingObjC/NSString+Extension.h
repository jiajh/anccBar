/**
     注意:
     刚进入改页,直接点击cell时,获取xib中控件的font和width可能是不准确的.
     解决方式:  按比例指定屏幕宽度,指定label的字体大小.
 
 */

#import <Foundation/Foundation.h>

@interface NSString (Extension)

// - url 中文格式化utf-8
+ (NSString*)jq_UTF8Encoding:(NSString*)str;

/**
 文字编码，汉字的 GBK 和 国际通用的 UTF-8 的互相转化
 */
//utf-8转gpk格式
- (NSString *)jq_URLEncodedString;

//gpk格式转utf-8
- (NSString *)jq_URLDecodedString;


-(BOOL)jq_isNotNullObject;

-(BOOL)jq_isNullObject;


/* ----------------------------------------------------------------------------------------------
                                         自适应高度
  ----------------------------------------------------------------------------------------------*/
/**
 *  判断是否包含中文
 */
- (BOOL)jq_containChinese:(NSString *)str;

/**
 * 计算文字高度，可以处理计算带行间距的
 * 如果是普通文本，lineSpacing 传 0 即可。
 */
- (CGSize)jq_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;

/**
 *  计算最大行数文字高度,可以处理计算带行间距的
 */
- (CGFloat)jq_boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines;

/**
 *  计算是否超过一行   用于给Label 赋值attribute text的时候 超过一行设置lineSpace
 */
- (BOOL)jq_isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;


/* ----------------------------------------------------------------------------------------------
                    原来的文件中用到了该方法
 ----------------------------------------------------------------------------------------------*/

/**空字符串 */
-(BOOL)isNullStr;

/**非空字符串 */
-(BOOL)isNotNullStr;

/**
    如果为空,返回字符串@""
 */
-(instancetype)jq_isNotReturnNull;

/*手机(设备)版本*/
+ (NSString*)jq_getDeviceVersion;

/*手机系统版本*/
+(NSString *)jq_getPhoneVersion;

@end
