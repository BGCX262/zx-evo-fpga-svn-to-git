@echo off

rem ��� SCL �����

set output=font_keyboard.scl

rem ��� SPG �����

set outspg=font_keyboard.spg

rem ���������, ������� ������������ ��� ��������
rem 32 �������, ����������� �����

set title=" FONT AND KEYBOARD DEMO"

rem ������ �����������, ������ ����� �������
rem � ��������� ��� ���������� �� ������������� ������������
rem ��������������� � ����� resources.h
rem ��������� ����� ����� ������ ���� ������������

set palette.0=font.bmp

rem ������ �����������, ������ ����� �������

set image.0=font.bmp

rem �������

set sprite.0=

rem ����� �������� ��������, ���� �����
rem �� ����� ���� ������ ����

set soundfx=

rem ������, ������ ����� ������

set music.0=

call ..\evosdk\_compile.bat
@if %error% ==0 ..\evosdk\tools\unreal_evo\unreal %output%