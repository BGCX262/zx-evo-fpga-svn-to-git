//���� ������ ���������� ���������� ������� �� ���� �����������


#include <evo.h>
#include "resources.h"



//��������� �������

struct spriteStruct {
	i16 x,y;	//����������
	i16 dx,dy;	//������ ��������
};

//������ ��������

#define SPRITES_ALL	22	//� ���� ������� ������� �������� �������� ������������ �� ����

struct spriteStruct spriteList[SPRITES_ALL];



void main(void)
{
	static u8 i;
	static u8 palette[16];

	//������ ����� �� ����� ����������

	pal_bright(BRIGHT_MIN);

	//������������� ���������� ��������

	for(i=0;i<SPRITES_ALL;++i)
	{
		spriteList[i].x=1+rand16()%(160-8-2);
		spriteList[i].y=1+rand16()%(200-16-2);
		spriteList[i].dx=rand16()&1?-1:1;
		spriteList[i].dy=rand16()&1?-1:1;
	}

	//����� ���� �� ������� �����

	draw_image(0,0,IMG_BACK);

	//������������ �������, ������ ��� �� ������� ������

	swap_screen();

	//������ ��������

	sprites_start();

	//��������� �������, ��� ���������� �� ���� ������ ������
	//����� 0..5 ��� ����, ����� 6..15 ��� ��������

	pal_copy(PAL_BACK,palette);

	for(i=0;i<6;++i) pal_col(i,palette[i]);

	pal_copy(PAL_BALLS,palette);

	for(i=6;i<16;++i) pal_col(i,palette[i]);

	//��������� ���������� �������

	pal_bright(BRIGHT_MID);

	//������� ����

	while(1)
	{
		//����������� �������� � ���������� ������ ��������

		for(i=0;i<SPRITES_ALL;++i)
		{
			//i&3 �������� ���� �� ������� ������������ �������

			set_sprite(i,spriteList[i].x,spriteList[i].y,i&3);

			if(spriteList[i].x==160-8 ||spriteList[i].x==0) spriteList[i].dx=-spriteList[i].dx;
			if(spriteList[i].y==200-16||spriteList[i].y==0) spriteList[i].dy=-spriteList[i].dy;

			spriteList[i].x+=spriteList[i].dx;
			spriteList[i].y+=spriteList[i].dy;
		}

		//���������� ������, ������� ��������� �������������

		swap_screen();
	}
}