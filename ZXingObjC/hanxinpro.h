#ifndef __HANXINPRO_H_INCLUDED__
#define __HANXINPRO_H_INCLUDED__


/*
����0����ɹ�����0Ϊʧ�ܣ�srcΪ����ͼ��ĻҶȾ���
widthΪ����ͼ��Ŀ�heightΪ����ͼ��ĸ�;
versionSizeΪ����İ汾�Ŷ�Ӧ�Ŀ�ȣ�vecNetMapΪ�����01������
*/
int preprocessImg(unsigned char* src, int width, int height, unsigned char* vecNetMap);
/*
���ز���Ϊ�����ַ���;bbΪ�����01����;iWidthΪ����Ŀ��;szInfoΪ���������
*/
int  DeCodeCsbyte(unsigned char* bb,int iWidth,unsigned char* szInfo);	//��������



#endif	//__HANXINPRO_H_INCLUDED__
