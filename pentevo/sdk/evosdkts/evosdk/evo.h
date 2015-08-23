#pragma disable_warning 85

//����������� ����� ����������

typedef unsigned char u8;
typedef   signed char i8;
typedef unsigned  int u16;
typedef   signed  int i16;
typedef unsigned long u32;
typedef   signed long i32;

#define TRUE	1
#define FALSE	0

//����� ������ ���������

#define JOY_RIGHT	0x01
#define JOY_LEFT	0x02
#define JOY_DOWN	0x04
#define JOY_UP		0x08
#define JOY_FIRE	0x10

//�������� � ������� ������ ��� ������ ����������

#define KEY_SPACE	0x23
#define KEY_ENTER	0x1e
#define KEY_SYMBOL	0x24
#define KEY_CAPS	0x00

#define KEY_0		0x14
#define KEY_1		0x0f
#define KEY_2		0x10
#define KEY_3		0x11
#define KEY_4		0x12
#define KEY_5		0x13
#define KEY_6		0x18
#define KEY_7		0x17
#define KEY_8		0x16
#define KEY_9		0x15

#define KEY_A		0x05
#define KEY_B		0x27
#define KEY_C		0x03
#define KEY_D		0x07
#define KEY_E		0x0c
#define KEY_F		0x08
#define KEY_G		0x09
#define KEY_H		0x22
#define KEY_I		0x1b
#define KEY_J		0x21
#define KEY_K		0x20
#define KEY_L		0x1f
#define KEY_M		0x25
#define KEY_N		0x26
#define KEY_O		0x1a
#define KEY_P		0x19
#define KEY_Q		0x0a
#define KEY_R		0x0d
#define KEY_S		0x06
#define KEY_T		0x0e
#define KEY_U		0x1c
#define KEY_V		0x04
#define KEY_W		0x0b
#define KEY_X		0x02
#define KEY_Y		0x1d
#define KEY_Z		0x01

//����� ��������� ������

#define KEY_DOWN	0x01	//������ ������������
#define KEY_PRESS	0x02	//������ ������, ���� ������������ ����� ������ keyboard

//����� ������ ����

#define MOUSE_LBTN	0x01
#define MOUSE_RBTN	0x02
#define MOUSE_MBTN	0x04

//��������� ���� ����� �� RGB � ����������� ���������� �������

#define RGB222(r,g,b)	(((b)&3)|(((g)&3)<<2)|(((r)&3)<<4))

//������� � ������� ������ �������

#define BRIGHT_MIN	0
#define BRIGHT_MID	3
#define BRIGHT_MAX	6

//��� ����� ������ ��������

#define SPRITE_END	0xff00



//���������� ������ �������� ���������

void memset(void* m,u8 b,u16 len) _naked;

//����������� ������, ������� �� ������ ������������

void memcpy(void* d,void* s,u16 len) _naked;

//��������� 16-������� ���������������� �����

u16 rand16(void) _naked;

//��������� ����� �������, 0..15

void border(u8 n) _naked;

//�������� ���������� �� �����

void vsync(void) _naked;

//����� kempston ��������� � ��������� ������ � ��������
//��� ������ ������ ���� ��������� JOY_

u8 joystick(void) _naked;

//����� ����������, ���������� ��������� ������ � 40-������� ������
//��� ������ ������ ���� ��������� KEY_

void keyboard(u8* keys) _naked;

//��������� ������� ������� ��������� ����, ���������� �� x �������� �����, ��� ��� ��������
//���� ������������ � �������� ���� ���������

u8 mouse_pos(u8* x,u8* y) _naked;

//��������� ������� ������� ��������� ����

void mouse_set(u8 x,u8 y) _naked;

//��������� ���� ��������� ��� ��������� ����, �� ��������� 0..160, 0..200

void mouse_clip(u8 xmin,u8 ymin,u8 xmax,u8 ymax) _naked;

//��������� ������ ����������� ����, ��� ��������� ���������� �� x

u8 mouse_delta(i8* x,i8* y) _naked;

//������������ ��������� ������� � ��������� ������� � ������������� ���������� -8..8

void sfx_play(u8 sfx,i8 vol) _naked;

//������� ���� ������������� �������� ��������

void sfx_stop(void) _naked;

//������������ ������ � ��������� �������

void music_play(u8 mus) _naked;

//����������� ������������ ������

void music_stop(void) _naked;

//������������ ������ � ��������� ������� ����� Covox
//�� ����� ������������ ��������� ��� � ���������� ���������

void sample_play(u8 sample) _naked;

//��������� ���� �������� � ������� � 0 (������ ����)

void pal_clear(void) _naked;

//��������� ������� ������ BRIGHT_MIN..BRIGHT_MID..BRIGHT_MAX (0..3..6)
//�� ��������� ������� ������ �� ���������� ������� �� ��������� ������ ������

void pal_bright(u8 bright) _naked;

//����� ��������������� ������� �� ������

void pal_select(u8 id) _naked;

//����������� ��������������� ������� � ������ (16 ����)

void pal_copy(u8 id,u8* pal) _naked;

//��������� ����� � �������, id 0..15, col � ������� R2G2B2

void pal_col(u8 id,u8 col) _naked;

//��������� ���� 16 ������ � ������� ���������� R2G2B2 �� �������

void pal_custom(u8* pal) _naked;

//����� ����������� ��� ������� draw_tile

void select_image(u8 id) _naked;

//����� ����������� ����� 0..15 ��� ������� draw_tile_key

void color_key(u8 col) _naked;

//��������� ����� �� �������� ���������� �����������
//� ����� ����������� ����� ���� �� 65536 ������

void draw_tile(u8 x,u8 y,u16 tile) _naked;

//��������� ����� � ������, �������� ������� ����������� �����

void draw_tile_key(u8 x,u8 y,u16 tile) _naked;

//��������� ����������� �������

void draw_image(u8 x,u8 y,u8 id) _naked;

//������� �������� ������ ������ ������ 0..15

void clear_screen(u8 color) _naked;

//������������ �������, ������� ���������� �������
//�������� ����� ����������� �������������, vsync ����� ������� ���� ������� �� �����
//������� ����� ��������� �������, ���� ��� ��������

void swap_screen(void) _naked;

//������ ������� ������ ��������
//�� ������� ������ ������ ���� �����������, ������ �������� ����� �������� �������
//��� ������� ����������� ��������, ���������� ����������� �������� ������ ������
//����� ���� ��� ������� ���������, ��� ����� ������������� ���������� ��� swap_screen

void sprites_start(void) _naked;

//������� ������� ������ ��������

void sprites_stop(void) _naked;

//��������� ��������� �������
//id ����� � ������ 0..63
//x ���������� 0..152 (�������� ������ �� ����������� ��� �������� �������)
//y ���������� 0..184
//spr ����� ����������� �������, ���� SPRITE_END, �� ����� ������ ������������
//��������: �������� ��� ������ �����������, ������ �� ����� �������� ��������
//�� ������� ������

void set_sprite(u8 id,u8 x,u8 y,u16 spr) _naked;

//����� � ������� ������� ��������� � ������

u32 time(void) _naked;

//��������, �������� � ������ (1/50 �������)

void delay(u16 time) _naked;