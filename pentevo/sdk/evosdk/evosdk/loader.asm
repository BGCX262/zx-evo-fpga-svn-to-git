	device pentagon1024

	include "target.asm"

colorTop =#47
colorLoad=#46
colorLeft=#04

	org #5d3b-17

;��������� hobeta, savehob �� ������������ ��� ��� ����� ������ ���������

hobeta
	db "boot    B"
	dw line_end-begin
	dw line_end-begin
	db 0,high ((end-begin)+4)
	dw 0	;����������� �����

	;org #5d3b

begin
	db 0,1			;����� ������
	dw line_end-line_start	;����� ������ � ������
line_start
	db #f9,#c0,#30	;randomize usr 0
	db #0e,#00,#00	;�����
	dw code_start
	db #00,#3a,#ea	;:rem


code_start
	ld sp,#6fff

	;��������� ������ 14 ���

	ifdef EVO
	
	ld a,1
	out (#bf),a
	ld bc,#ff77
	ld A,%10101011	;����� 6912 � ��������
	out (c),a
	ld a,#7f		;���������� ������� #7ffd
	ld bc,#fff7
	out (c),a
	ld a,16
	ld bc,#eff7
	out (c),a

	else
	
	ld a,#7f		;���������� ������� #7ffd
	ld bc,#fff7
	call outshad;out (c),a
	
	endif
	
	;������� ������

	halt
	xor a
	out (#fe),a
	ld hl,23295
	ld de,23294
	ld bc,6911
	ld (hl),a
	lddr

	;��������� �������

	ld a,#ee
	ld hl,20480+4*32+6*256
	call fill32bytes
	inc h
	call fill32bytes

	ld hl,20480+5*32
	ld b,4
.l1
	call fill32bytes
	inc h
	djnz .l1

	;����� ���������

	ld de,20480+6*32
	ld ix,messageStr
.l2
	ld a,(ix)
	or a
	jr z,.l4

	push de

	ld l,a
	ld h,0
	add hl,hl
	add hl,hl
	add hl,hl
	ld bc,15616-32*8
	add hl,bc
	ld b,8
.l3
	ld a,(hl)
	sla a
	or (hl)
	ld (de),a
	inc l
	inc d
	djnz .l3

	pop de
	inc e
	inc ix
	jr .l2

.l4
	ld hl,22528+22*32
	ld a,7+64
	call fill32bytes

	call displayBar

	;��������� ����������� ������

	ld hl,checkError
	ld (23747),hl
	ld a,#c3
	ld (23746),a

	;�������� ������ �� ������

	ld hl,fileList
loadLoop
	ld a,(hl)
	inc hl
	ld c,(hl)
	inc hl

	push af
	push hl
	
	ifdef EVO
	
	ld a,1
	out (#bf),a
	ld a,c		;�������� �������� C � ������� ����
	cpl
	ld bc,#f7f7
	out (c),a
	
	else
	
	ld a,c		;�������� �������� C � ������� ����
	xor 127;cpl
	ld bc,#fff7;#f7f7
	call outshad;out (c),a
       ld bc,#ff77
       ld a,%10101011	;����� 6912 � ��������
	call outshad;out (c),a ;shadow ports off
	
	endif

	pop hl
	pop af

	or a
	jr z,loadDone

	push hl

	ld de,(23796)	;����������� ���� ����������� � #7000
	ld b,a			;�� ������ ���� �� ������ ��������������
	ld c,#05
	ld hl,#7000
	call 15635

	call advanceBar

	di
	ld hl,#7000
	ld de,#c000
	call DEC40
	ei

	call advanceBar

	pop hl
	jr loadLoop

loadDone
	ld a,(hl)	;������ ����� �������
	inc hl
	ld h,(hl)
	ld l,a

	ld bc,32*256
	ld (progressNow),bc
	call displayBar

	;TR-DOS ������ �� �����, �������� ������� �����
	;� ��� � ������ ����

	ifdef EVO
	ld a,1
	out (#bf),a
	else
	call shadowports_on
	endif

	ld bc,#3ff7
	ld a,#7f
	out (c),a

	jp (hl)


	ifdef ATM
	
outshad
	ld ix,#2a53;#3ff0 ;out (c),a
	push ix
	jp #3d2f

shadowports_on
	ld bc,#2a53;#3ff0 ;out (c),a
	push bc
	ld bc,#4177
	ld a,%10101011	;����� 6912 � ��������
	jp #3d2f
	
	endif

fill32bytes
	push bc
	push hl
	ld b,32
.l1
	ld (hl),a
	inc l
	djnz .l1
	pop hl
	pop bc
	ret



displayBar
	ld a,(progressNow+1)
	cp 32
	jr c,$+4
	ld a,32

	ld ix,22528+20*32
	ld bc,32*256
.l1
	cp c
	ld de,colorLeft|(colorLeft<<8)
	jr c,.l2
	jr z,.l2
	ld de,colorTop|(colorLoad<<8)
.l2
	ld (ix),e
	ld (ix+32),d
	inc ixl
	inc c
	djnz .l1

	ret



advanceBar
	call displayBar
	ld hl,(progressNow)
	ld bc,(progressStep)
	add hl,bc
	ld (progressNow),hl
	ret



checkError
	ld a,(23823)
	or a
	ret z

showError
	xor a
.l1
	halt
	push af
	and 7
	out (#fe),a
	pop af
	ld hl,22528
	ld de,22529
	ld bc,767
	ld (hl),a
	ldir
	xor #12
	ld b,25
	halt
	djnz $-1
	jr .l1



	include "unmegalz.asm"


progressNow	dw 0	;������� �������� �������� 8:8, ������� ���� 0-31

;��������� ��������

;messageStr
;	db " SOMETHING IS LOADING",0

;progressStep
;	dw 10	;��� ��� ������������

;fileList	;� ������ ����� � �������� � ����� �������� (��� ��������)
;	db 100,0
;	db 0,0	;��������� ������ 0 ��������, ���������� ������ ��������
;	dw 0	;����� �������

	include "filelist.asm"

line_end

	display "Basic length ",/d,$-begin," bytes"

	db #80,#aa,#01,#00	;����� ������ ��� ����������

	ds (($-1-begin)&255)^255,0
end

	display "File size ",/d,end-begin," bytes"

	savebin "boot.$b",hobeta,end-hobeta