@echo off

rem ��� SCL �����

set output=sprites.scl

rem ���������, ������� ������������ ��� ��������
rem 32 �������, ����������� �����

set title=" SPRITES DEMO"

rem ������ �����������, ������ ����� �������
rem � ��������� ��� ���������� �� ������������� ������������
rem ��������������� � ����� resources.h
rem ��������� ����� ����� ������ ���� ������������

set palette.0=back.bmp
set palette.1=balls.bmp

rem ������ �����������, ������ ����� �������

set image.0=back.bmp

rem �������

set sprite.0=balls.bmp

rem ����� �������� ��������, ���� �����
rem �� ����� ���� ������ ����

set soundfx=

rem ������, ������ ����� ������

set music.0=

call ..\evosdk\_compile.bat
@if %error% ==0 ..\evosdk\tools\unreal_evo\emullvd %output%