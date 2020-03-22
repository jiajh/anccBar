//
//  对EnHanxin_API中的函数又包了一层，因为传bb的时候会有问题
//
//  Created by apple on 2017/7/28.
//  Copyright © 2017年 Mrhan. All rights reserved.
//

#ifndef HanXinTest_h
#define HanXinTest_h

#include <stdio.h>
#include <stdlib.h>


/**
     szText:输入的内容
     kPath：把输入的内容转成点阵后，把点阵转成bmp文件，文件所在的路径，即：kPath.
 */
const char * EncodeHXText(const char *szText,const char * kPath);


#endif /* HanXinTest_h */
