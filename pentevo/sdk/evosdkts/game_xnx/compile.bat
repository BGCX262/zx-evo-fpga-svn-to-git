@echo off

rem ��� SCL �����

set output=xnx.scl

rem ��� SPG �����

set outspg=xnx.spg
rem set spgpack=0

rem ���������, ������� ������������ ��� ��������
rem 32 �������, ����������� �����

set title=" XNX IS LOADING"

rem ������ �����������, ������ ����� �������
rem � ��������� ��� ���������� �� ������������� ������������
rem ��������������� � ����� resources.h
rem ��������� ����� ����� ������ ���� ������������

set palette.0=gfx\title.bmp
set palette.1=gfx\textback1.bmp
set palette.2=gfx\textback2.bmp
set palette.3=gfx\textback3.bmp
set palette.10=gfx\pic1.bmp
set palette.11=gfx\pic2.bmp
set palette.12=gfx\pic3.bmp
set palette.13=gfx\pic4.bmp
set palette.14=gfx\pic5.bmp
set palette.15=gfx\pic6.bmp
set palette.16=gfx\pic7.bmp
set palette.17=gfx\pic8.bmp
set palette.18=gfx\pic9.bmp
set palette.19=gfx\pic10.bmp

rem ������ �����������, ������ ����� �������

set image.0=gfx\title.bmp
set image.1=gfx\font816.bmp
set image.2=gfx\font2432.bmp
set image.3=gfx\bgmask.bmp
set image.4=gfx\textback1.bmp
set image.10=gfx\pic1.bmp
set image.11=gfx\pic2.bmp
set image.12=gfx\pic3.bmp
set image.13=gfx\pic4.bmp
set image.14=gfx\pic5.bmp
set image.15=gfx\pic6.bmp
set image.16=gfx\pic7.bmp
set image.17=gfx\pic8.bmp
set image.18=gfx\pic9.bmp
set image.19=gfx\pic10.bmp

rem �������

set sprites.0=gfx\player.bmp
set sprites.1=gfx\titlemask.bmp
set sprites.2=gfx\spikeball.bmp

rem ����� �������� ��������, ���� �����
rem �� ����� ���� ������ ����

set soundfx=sfx\sounds.afb

rem ������, ������ ����� ������

set music.0=mus\intro.pt3
set music.1=mus\level.pt3
set music.2=mus\gameover.pt3
set music.3=mus\welldone.pt3
set music.10=mus\loop1.pt3

rem ������

set sample.0=sfx\start.wav
set sample.1=sfx\meow.wav

call ..\evosdk\_compile.bat
@if %error% ==0 ..\evosdk\tools\unreal_evo\unreal %output%