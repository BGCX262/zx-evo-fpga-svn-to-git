//���� ������ �������� �����, � ����� ���������� ����������,
//������ ����� A-Z � ����� 0-9 �� ������� ������

#include <evo.h>
#include "resources.h"



//������� ���������� ������ ������

static u8 output_x;
static u8 output_y;



//����� ������ ������� �� ����� � �������������� ����������
//������� ������, ����� ������ '\n' ��������� ������

void put_char(u8 n)
{
	if(n>=' '&&n<='Z') draw_tile(output_x,output_y,n-' ');

	++output_x;

	if(output_x==39||n=='\n')
	{
		output_x=1;
		
		++output_y;
		
		if(output_y==24) output_y=1;
	}
}



//����� ������ ��������

void put_str(u8* str)
{
	u8 i;

	while(1)
	{
		i=*str++;

		if(!i) break;

		put_char(i);
	}
}



void main(void)
{
	static u8 i,key;
	static u8 keys[40];

	//������ ����� �� ����� ����������

	pal_bright(BRIGHT_MIN);

	//������� �������� ����� � ��������� �������

	clear_screen(1);

	pal_select(PAL_FONT);

	//����� ����������� ��� ������ ������

	select_image(IMG_FONT);

	//������������ �������, ������ ��� �� ������� ������

	swap_screen();

	//��������� ���������� �������

	pal_bright(BRIGHT_MID);

	//������� � ���� ������� �� ������������, �� ��� ����������� ��������
	//������������� ����������� ����������� ��������� ������� � ��� ������,
	//��� ��������� ��������� ���� ������

	sprites_start();

	//������������� ����������

	output_x=1;
	output_y=1;

	//������� ����

	put_str("HELLO WORLD\n\n");

	while(1)
	{
		//��������� ��������� ������

		keyboard(keys);

		//��������� ASCII-���� ������� �������, 255 ���� ��� �������
		//����� ������� � ������������� ���

		key=255;

		if(keys[KEY_0]&KEY_PRESS) key='0';
		if(keys[KEY_1]&KEY_PRESS) key='1';
		if(keys[KEY_2]&KEY_PRESS) key='2';
		if(keys[KEY_3]&KEY_PRESS) key='3';
		if(keys[KEY_4]&KEY_PRESS) key='4';
		if(keys[KEY_5]&KEY_PRESS) key='5';
		if(keys[KEY_6]&KEY_PRESS) key='6';
		if(keys[KEY_7]&KEY_PRESS) key='7';
		if(keys[KEY_8]&KEY_PRESS) key='8';
		if(keys[KEY_9]&KEY_PRESS) key='9';

		if(keys[KEY_A]&KEY_PRESS) key='A';
		if(keys[KEY_B]&KEY_PRESS) key='B';
		if(keys[KEY_C]&KEY_PRESS) key='C';
		if(keys[KEY_D]&KEY_PRESS) key='D';
		if(keys[KEY_E]&KEY_PRESS) key='E';
		if(keys[KEY_F]&KEY_PRESS) key='F';
		if(keys[KEY_G]&KEY_PRESS) key='G';
		if(keys[KEY_H]&KEY_PRESS) key='H';
		if(keys[KEY_I]&KEY_PRESS) key='I';
		if(keys[KEY_J]&KEY_PRESS) key='J';
		if(keys[KEY_K]&KEY_PRESS) key='K';
		if(keys[KEY_L]&KEY_PRESS) key='L';
		if(keys[KEY_M]&KEY_PRESS) key='M';
		if(keys[KEY_N]&KEY_PRESS) key='N';
		if(keys[KEY_O]&KEY_PRESS) key='O';
		if(keys[KEY_P]&KEY_PRESS) key='P';
		if(keys[KEY_Q]&KEY_PRESS) key='Q';
		if(keys[KEY_R]&KEY_PRESS) key='R';
		if(keys[KEY_S]&KEY_PRESS) key='S';
		if(keys[KEY_T]&KEY_PRESS) key='T';
		if(keys[KEY_U]&KEY_PRESS) key='U';
		if(keys[KEY_V]&KEY_PRESS) key='V';
		if(keys[KEY_W]&KEY_PRESS) key='W';
		if(keys[KEY_X]&KEY_PRESS) key='X';
		if(keys[KEY_Y]&KEY_PRESS) key='Y';
		if(keys[KEY_Z]&KEY_PRESS) key='Z';

		if(keys[KEY_SPACE]&KEY_PRESS) key=' ';
		if(keys[KEY_ENTER]&KEY_PRESS) key='\n';

		//���� ���� ������ �������, ������� �

		if(key!=255) put_char(key);

		//���������� ������

		swap_screen();
	}
}