//���� ������ ���������� ����� ���� � ����� ��������� � �������������� �������
//� ����� ����� ��������� � ��������� ��������� ���� � ����� ����������

#include <evo.h>
#include "resources.h"




void main(void)
{
	static u8 i,col;
	static u8 mouse_x,mouse_y;

	//������ ����� �� ����� ����������

	pal_bright(BRIGHT_MIN);

	//����� ���� �� ������� ����� � ��������� �������

	draw_image(0,0,IMG_BACK);
	pal_select(PAL_BACK);

	//������������ �������, ������ ��� �� ������� ������

	swap_screen();

	//������ ��������

	sprites_start();

	//��������� ���������� �������

	pal_bright(BRIGHT_MID);

	//��������� ������� � ������� ����������� ����

	mouse_clip(0,0,160-8,200-16);
	mouse_set(80,100);

	//������� ����

	while(1)
	{
		//����� ����

		i=mouse_pos(&mouse_x,&mouse_y);

		//��������� ����� ������� ��� ������� ������

		switch(i)
		{
		case MOUSE_LBTN: col=12; break;
		case MOUSE_MBTN: col=14; break;
		case MOUSE_RBTN: col=15; break;
		default: col=0;
		}

		border(col);

		//����� ��������� � ��������� ��������� ���� �� �������� �����������

		i=joystick();

		if(i&JOY_LEFT)
		{
			mouse_x-=2;
			if(mouse_x>160-8) mouse_x=0;
		}
		
		if(i&JOY_RIGHT)
		{
			mouse_x+=2;
			if(mouse_x>160-8) mouse_x=160-8;
		}
		
		if(i&JOY_UP)
		{
			mouse_y-=4;
			if(mouse_y>200-16) mouse_y=0;
		}
		
		if(i&JOY_DOWN)
		{
			mouse_y+=4;
			if(mouse_y>200-16) mouse_y=200-16;
		}

		mouse_set(mouse_x,mouse_y);

		//����� �������

		set_sprite(0,mouse_x,mouse_y,0);

		//���������� ������, ������� ��������� �������������

		swap_screen();
	}
}