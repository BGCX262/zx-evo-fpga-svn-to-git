@echo off

rem ��� SCL �����

set output=slideshow.scl

rem ���������, ������� ������������ ��� ��������
rem 32 �������, ����������� �����

set title=" SLIDESHOW IS LOADING"

rem ������ �����������, ������ ����� �������
rem � ��������� ��� ���������� �� ������������� ������������
rem ��������������� � ����� resources.h
rem ��������� ����� ����� ������ ���� ������������

set palette.0=gfx\pic1.bmp
set palette.1=gfx\pic2.bmp
set palette.2=gfx\pic3.bmp
set palette.3=gfx\pic4.bmp
set palette.4=gfx\pic5.bmp

rem ������ �����������, ������ ����� �������

set image.0=gfx\pic1.bmp
set image.1=gfx\pic2.bmp
set image.2=gfx\pic3.bmp
set image.3=gfx\pic4.bmp
set image.4=gfx\pic5.bmp

rem �������

set sprite.0=

rem ����� �������� ��������, ���� �����
rem �� ����� ���� ������ ����

set soundfx=

rem ������, ������ ����� ������

set music.0=

call ..\evosdk\_compile.bat
@if %error% ==0 ..\evosdk\tools\unreal_evo\emullvd %output%