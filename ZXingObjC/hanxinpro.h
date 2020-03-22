#ifndef __HANXINPRO_H_INCLUDED__
#define __HANXINPRO_H_INCLUDED__


/*
返回0代表成功，非0为失败；src为输入图像的灰度矩阵，
width为输入图像的宽，height为输入图像的高;
versionSize为输出的版本号对应的宽度；vecNetMap为输出的01网格方阵。
*/
int preprocessImg(unsigned char* src, int width, int height, unsigned char* vecNetMap);
/*
返回参数为译码字符数;bb为输入的01矩阵;iWidth为方阵的宽度;szInfo为输出译码结果
*/
int  DeCodeCsbyte(unsigned char* bb,int iWidth,unsigned char* szInfo);	//码流译码



#endif	//__HANXINPRO_H_INCLUDED__
