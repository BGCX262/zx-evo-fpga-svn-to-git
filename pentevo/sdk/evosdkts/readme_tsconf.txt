  ������ EVO SDCC/SDK ��� ZX Evo TSConf.
��������� �������� ������� �� EVO SDCC/SDK ��� ZX Evo BASECONF. ��� ����������� �������
��������� ���� ��������������� ��������� ������ � compile.bat:
@if %error% ==0 ..\evosdk\tools\unreal_evo\unreal %output%

  ����� *.scl ����� �������� SPG �����. ��� ����� ���� �������� � ������ compile.bat 
��������� ������:
set outspg=filename.spg  ; ��� ��� SPG �����
set spgpack = 2  ; ����� �������� SPG �����: 0 - ��� ������, 1 - MegaLZ, 2 - Hrust. ���� ������ ���, ��
����� �������� ���������� �������������.
