@echo off

rem ��� SCL �����

set output=empty.scl

rem ��� SPG �����

set outspg=empty.spg

rem ���������, ������� ������������ ��� ��������
rem 32 �������, ����������� �����

set title=" NOTHING IS LOADING"

rem ������ �����������, ������ ����� �������
rem � ��������� ��� ���������� �� ������������� ������������
rem ��������������� � ����� resources.h
rem ��������� ����� ����� ������ ���� ������������

set palette.0=

rem ������ �����������, ������ ����� �������

set image.0=

rem �������

set sprite.0=

rem ����� �������� ��������, ���� �����
rem �� ����� ���� ������ ����

set soundfx=

rem ������, ������ ����� ������

set music.0=

rem ������

set sample.0=

call ..\evosdk\_compile.bat
@if %error% ==0 ..\evosdk\tools\unreal_evo\unreal %output%