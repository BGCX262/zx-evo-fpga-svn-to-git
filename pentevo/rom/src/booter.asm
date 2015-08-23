;---------------------------------------

start   push bc
        ld hl, nsdc
        ld de, nsdc+1
        ld bc, zes-nsdc
        ld (hl), 0
        ldir
        pop af
        ld (device), a
        
        ld hl, 0
        ld (lstcat), hl
        ld (lstcat + 2), hl

        call ide_ini
;-------
        ld a, (device)
        or a
        jr z, one_dev
        dec a
one_dev call sel_dev
        jr nz, no_dev

        call hdd
		jr nz, no_fat

        ld hl, file1
        ld de, entry
        ld bc, 11
        ldir
        call srhdrn; Z - file not found
		jr z, no_file

        ld (lobu), hl
        ld (lobu + 2), de
        ld hl, lobu
        call gipag

        ld hl, lobu
        ld b, 1
        call load512

        ld hl, lobu + 17
        ld de, (lobu + 9)

;ld a, d
;cp h'60
;jr c, fail

        push de
        ld bc, 512-17
        ldir
        ex de, hl
thg     ld b, 1
        call load512
        ld a, (eoc)
        cp h'0f
        jr nz, thg

        ld ix, sysvars
        ld de, sys_var
		call DEHRUST

        pop de
		xor a
        ret

no_dev  ld a, 1
        jr er_exit
		
no_fat	ld a, 2	
        jr er_exit
		
no_file ld a, 3
er_exit scf
        ret
		
;---------------------------------------
;read data from fat32 (flow)
        
load512 ;i:        hl - address
;           b - lenght (512b blocks)
;     cuhl(4) - clusnum (if eoc + nsdc=0!)
;        o:        hl - new value
;           a - endofchain
        xor a
        ld (abt), a
        call lprex
        jr nz, rh
kukry   push bc
        ld hl, (ldhl)
        ld a, 1
        call newcla
        pop bc
        djnz kukry
rh      ld hl, (ldhl)
        ld a, (eoc)
        ret

;positioning to cluster,  if needed
        
lprex   ld (ldhl), hl
        ld a, (nsdc)
        or a
        jr nz, rx
        ld a, (eoc)
        or a
        ret nz
        push bc
        ld hl, cuhl
        call gipag
        pop bc
        ret

rx      xor a
        ret

;-------
newcla  ld (nr0), a
        push hl
        ld hl, (lthl)
        ld de, (ltde)
        call proz
        pop hl
        ld a, (nr0)
        call rddse;       read sector(s)
        ld (ldhl), hl;   updating address
        ld hl, lthl
        ld de, llhl
        ld bc, 4
        ldir
        ld hl, (lthl)
        ld de, (ltde)
        ld bc, (nr0)
        add hl, bc
        jr nc, $ + 3
        inc de
        ld (lthl), hl
        ld (ltde), de
        ld hl, nsdc
        ld a, c
        add a, (hl)
        ld (hl), a
        ld bc, (bsecpc)
        cp c
        ret c;      end of cluster?
;                        yes!
        ld hl, (cuhl)
        ld de, (cude)
        call curit
        call gipag
        ret z
eofc    pop bc
        pop bc
        jp rh
        
;------read sector from fat
curit   ;i:        [de, hl]-cluster number
;        o:        secbu(512)
;          hl-poz in secbu where cluster
        call del128
        sla c
        rl b
        sla c
        rl b
        push bc
        ld (lstse + 2), de
        ld (lstse), hl
        ld bc, (sfat)
        call add4b
        call xspoz
        call xpozi
        ld hl, secbu
        ld a, 1
        call rddse
        pop bc
        ld hl, secbu
        add hl, bc
        ret

;----pos. to first sector of cluster
gipag   ;i:        hl(4) - cluster number
        call tos
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        or h
        or e
        or d
        jr z, rdir
        
        ld a, h
        cp h'0f
        jr z, mdc
        ex de, hl
pom     ld (cuhl), hl
        ld (cude), de
        ld bc, 2
        or a
        sbc hl, bc
        jr nc, $ + 3
        dec de
        ld a, (bsecpc)
        call umnox2
        ld bc, (sdfat)
        call add4b
        ex de, hl
        ld bc, (sdfat + 2)
        add hl, bc
        ex de, hl
        call xspoz
        call xpozi
        xor a
        ret

rdir    ld hl, (brootc)
        ld de, (brootc + 2)
        jr pom
        
mdc     ld (eoc), a
        or a
        ret

;---getting absolute position of sec
xspoz   ld bc, (addtop)
        ld (clhl), bc
        ld bc, (addtop + 2)
        ld (clde), bc
        jp add4bf
        
;-----searching entry in active dir by name
srhdrn  ;i:        lstcat(4) - active dir
;          entry - name (11 chars)
;        o:        entry(32)
;          [de, hl] - cluster number

        ld hl, lstcat
        ld de, cuhl
        ld bc, 4
        ldir
        call tos
hdr     ld a, (eoc)
        cp h'0f
        ret z
        ld hl, lobu
        ld b, 1
        call load512
        ld (hl), 0
        ld hl, lobu-32
        call vega
        ret nz
        ld a, h
        cp high(lobu) + 2
        jr hdr
        
;-------
vega    ld bc, 32
        add hl, bc
        ld a, (hl)
        or a
        ret z
        call cheb
        jr nz, vega
        ld a, 1
        or a
        ret

;-------
cheb    push hl
        ld de, entry
        ld b, 11
        call chee
        pop hl
        ret nz
        ld de, entry
        ld bc, 32
        ldir
        ld hl, (clshl)
        ld de, (clsde)
        xor a
        ret

chee    ld a, (de)
        cp (hl)
        ret nz
        inc hl
        inc de
        djnz chee
        ret

;---------------------------------------
;search partition
        
hdd     ;i:        none
;        o:        nz - fat32 not found
;           z - all fat32 vars are
;               initialized
        ld de, 0
        ld hl, 0
        ld (cuhl), hl
        ld (cude), hl
        ld (dahl), hl
        ld (dade), hl
        ld (duhl), hl
        ld (dude), hl
        call xpozi
        ld hl, lobu
        ld a, 1
        call rddse
        ld a, 3
        ld (count), a
        ld (zes), a
        ld hl, lobu + 446 + 4
        ld de, 16
        ld b, 4
kko     ld a, (hl)
        cp h'05
        jr z, okk
        cp h'0b
        jr z, okk
        cp h'0c
        jr z, okk
        cp h'0f
        jr z, okk
        add hl, de
        djnz kko
fhdd    ld a, (zes)
        or a
        jp z, nhdd1
        ld de, (dade)
        ld hl, (dahl)
        call xpozi
        ld hl, lobu
        ld a, 1
        call rddse
        ld hl, count
        dec (hl)
        jp z, nhdd
        ld hl, lobu + 446 + 16
        ld b, 16
        xor a
        or (hl)
        inc hl
        djnz $-2
        jp nz, nhdd
        ld hl, (lobu + 446 + 16 + 8)
        ld de, (lobu + 446 + 16 + 8 + 2)
        ld (clhl), hl
        ld (clde), de
        ld hl, (dahl)
        ld de, (dade)
        call add4bf
        ld (dade), de
        ld (dahl), hl
        call xpozi
        ld hl, lobu
        ld a, 1
        call rddse
        ld hl, (lobu + 446 + 8)
        ld de, (lobu + 446 + 8 + 2)
        call add4bf
        jr ldbpb
        
okk     inc hl
        inc hl
        inc hl
        inc hl
        ld e, (hl)
        inc hl
        ld d, (hl)
        inc hl
        ld a, (hl)
        inc hl
        ld h, (hl)
        ld l, a
        ex de, hl
ldbpb   ld (addtop), hl
        ld (addtop + 2), de
        call xpozi
        ld hl, lobu ;load bpb sector
        ld a, 1
        call rddse

    ;ld hl, lobu + 3
    ;ld b, 6
    ;ld a, h'1d
    ;five    cp (hl)
    ;inc hl
    ;jp nc, fhdd
    ;djnz five

        ld hl, (lobu + 11)
        ld a, h
        dec a
        dec a
        or l
        jp nz, fhdd
        ld a, (lobu + 13)
        or a
        jp z, fhdd
        ld a, (lobu + 14)
        or a
        jp z, fhdd
        ld a, (lobu + 16)
        or a
        jp z, fhdd
        ld hl, (lobu + 17)
        ld a, h
        or l
        ; ld hl, (lobu + 19)
        ; or h
        ; or l
        ld hl, (lobu + 22)
        or h
        or l
        jp nz, fhdd
        ld hl, (lobu + 36)
        or h
        or l
        ld hl, (lobu + 36 + 2)
        or h
        or l
        jp z, fhdd

        ld a, (lobu + 13)
        ld (bsecpc), a
        ld b, 8
        srl a
        jr c, ner
        djnz $-4
        ld a, 1
ner     or a
        jp nz, fhdd
        ld hl, (lobu + 14)
        ld (brezs), hl
        
        ld a, (lobu + 16)
        ld (bfats), a
        ld hl, (lobu + 36)
        ld (bftsz), hl
        ld hl, (lobu + 36 + 2)
        ld (bftsz + 2), hl
        ld hl, (lobu + 44)
        ld (brootc), hl
        ld hl, (lobu + 44 + 2)
        ld (brootc + 2), hl
        ld hl, (bftsz)
        ld de, (bftsz + 2)
        ld bc, (bfats)
        ld b, 0
        call umn4b
        push hl
        push de
        ld hl, (brezs)
        ld (sfat), hl
        pop de
        pop bc
        call add4b
        ld (sdfat), hl
        ld (sdfat + 2), de
        ld hl, 0
        ld (cuhl), hl
        ld (cude), hl
        ld (lstcat), hl
        ld (lstcat + 2), hl
        xor a
        ret

nhdd    ld hl, (duhl)
        ld de, (dude)
        xor a
        ld (zes), a
        jp ldbpb
        
nhdd1   ld a, 1
        or a
        ret

;---------------------------------------
;arithmetics block
        
del128  ;i:        [de, hl]/128
;        o:        [de, hl]
;          bc - remainder
        ld a, l
        ex af, af'
        ld a, l
        ld l, h
        ld h, e
        ld e, d
        ld d, 0
        rla
        rl l
        rl h
        rl e
        rl d
        ex af, af'
        and 127
        ld b, 0
        ld c, a
        ret

;-------
umnox2  ;i:        [de, hl]*a
;                a - power of two
;        o:        [de, hl]
        cp 2
        ret c
        srl a
l33t1   sla l
        rl h
        rl e
        rl d
        srl a
        jr nc, l33t1
        ret

;-------
add4b   add hl, bc
        ret nc
        inc de
        ret

add4bf  ;i:        [de, hl] + [clde, clhl]
;        o:        [de, hl]
        ex de, hl
        ld bc, (clde)
        add hl, bc
        ex de, hl
        ld bc, (clhl)
        add hl, bc
        jr nc, knh
        inc de
knh     ld (clhl), hl
        ld (clde), de
        ret

umn4b   ;i:        [de, hl]*bc
        ; o:        [de, hl]
        ld a, b
        ld b, c
        ld c, a
        inc c
        or a
        jr nz, tekno
        dec b
        jr z, umn1
        inc b
tekno   xor a
        cp b
        jr nz, tys
        dec c
tys     dec b
        push hl
        push bc
        ld h, d
        ld l, e
        cp b
        jr z, negry
efro    add hl, de
        djnz efro
        
        ld b, a
negry   dec c
        jr nz, efro
        ld (rezde), hl
        pop bc
        pop hl
        ld d, h
        ld e, l
        cp b
        jr z, negra
ofer    add hl, de
        jr c, incde
enjo    djnz ofer
        ld b, a
negra   dec c
        jr nz, ofer
        ld de, (rezde)
umn1    ret

incde   exx
        ld hl, (rezde)
        inc hl
        ld (rezde), hl
        exx
        jr enjo
        
;---------------------------------------
tos     xor a
        ld (nsdc), a
        ld (eoc), a
        ret

        
;---------------------------------------
;   SD DRIVER
;---------------------------------------

sdcnf   equ h'77; ZC spi configuration port
data    equ h'57; ZC spi data port

cmd_1   equ %01000000+1; init
cmd_12  equ %01000000+12;stop transmission
cmd_16  equ %01000000+16;block size
cmd_18  equ %01000000+18;mult read
acmd_41 equ %01000000+41;init (sdc only)
cmd_55  equ %01000000+55;app cmd
cmd_58  equ %01000000+58;read OCR

cmd00   defb 0x40, 0, 0, 0, 0, 0x95;   Software reset
cmd08   defb 0x48, 0, 0, 1, 0xAA, 0x87;Check voltage range (SDCv2 only)
cmd16   defb 0x50, 0, 0, 2, 0, 0xFF;   Change R/W block size

;=======================================
xpozi_sd
        ld (lthl), hl
        ld (ltde), de
        
proz_sd ld (blknum), hl
        ld (blknum+2), de
        ret

;i:HL - Address
;   A - Blocks
;o:HL - NEW Address

rddse_sd
        ld de, (blknum)
        ld bc, (blknum+2)
        ex af, af'
        call cmd18
        jr nz, $
        ex af, af'
rd1     ex af, af'
        call wtdo
        cp h'FE
        jr nz,$-5
        call reads
        ex af, af'
        dec a
        jr nz, rd1

        call cmd12
        call snb
        jp csh
        
;---------------------------------------
reads   push bc
        push de
        ld bc, data
        inir
        inir
        in a, (c)
        in a, (c)
        pop de
        pop bc
        ret

;---------------------------------------
;detecting device:

sel_dev_sd
;i:        a - n of dev
        or a
        ret nz
        call sd_init
        ld de, 2
        or a
        ret nz
        ld de, 0
        ret

ini_sd  call sdoff
        ret

;---------------------------------------
sd_init 
        call csh
        ld de, 512+10
        call cycl

        ld de, 8000
sdwt    dec de
        ld a, d
        or e
        jp z, nosd
        call cmd0
        jr nz, sdwt
        dec a
        jr nz, sdwt

        call cmd8
        push af
        in e, (c)
        in e, (c)
        in h, (c)
        in l, (c)
        pop af
        jr nz, sdwt
        bit 2, a
        jr z, sdnew
;-------
sdold   ld de, 8000
aa      dec de
        ld a, d
        or e
        jr z, lc
        ld h, 0
        call acmd41
        jr nz, aa
        cp 1
        jr z, aa
        or a
        jr nz, lc
;sdv1 detected
        jr fbs
;-------
lc      ld de, 8000
oo      dec de
        ld a, d
        or e
        jr z, nosd
        call cmd1
        jr nz, oo
        cp 1
        jr z, oo
        or a
        jr nz, nosd
;mmc ver.3 detected
        jr fbs
;-------
sdnew   ld de, h'01AA
        or a
        sbc hl, de
        jr nz, nosd

        ld de, 8000
yy      dec de
        ld a, d
        or e
        jr z, nosd
        ld h, h'40
        call acmd41
        jr nz, yy
        cp 1
        jr z, yy
        or a
        jr nz, nosd
;sdv2 detected

        call cmd58
        jr nz, nosd
        ld bc, data
        in a, (c)
        in l, (c)
        in l, (c)
        in l, (c)
        bit 6, a
        jr z, fbs;sdv2 byte address
;sdv2 block address

        ld a, 1
sdfnd   ld (blkt), a
        xor a
        jr csh
;-------
fbs     call cmdi6
        jr nz, nosd
        or a
        jr z, sdfnd
;-------
nosd    call sdoff
        ld a, 1
        ret
;---------------------------------------
csh     push bc
        push af
        ld bc, sdcnf
        ld a, %00000011
        out (c), a
        ld bc, data
        ld a, h'FF
        out (c), a
        pop af
        pop bc
        ret
        
csl     push bc
        push af
        ld bc, sdcnf
        ld a, %00000001
        out (c), a
        ld bc, data
        ld a, h'FF
        out (c), a
        pop af
        pop bc
        jp wait

snb     push bc
        push af
        ld b,16
snbb    xor a
        in a,(data)
        djnz snbb
        pop af
        pop bc
        ret

cycl    ld bc, data
cy      ld a, h'FF
        out (c), a
        dec de
        ld a, d
        or e
        jr nz, cy
        ret
;-------
cmdo    call csh
        call csl
cmdx    push bc
        ld bc, data
        out (c), a
        xor a
        out (c), a
        out (c), a
        out (c), a
        out (c), a
        dec a
        out (c), a
        pop bc
        ret
cmd1    ld a, cmd_1
        call cmdo
        jp resp
cmd12   ld a, cmd_12
        call cmdx
        xor a
        in a, (data)
        jp resp
cmd55   ld a, cmd_55
        call cmdo
        jp resp
cmd58   ld a, cmd_58
        call cmdo
        jp resp
;-------
acmd41  call cmd55
        call csh
        call csl

        ld bc, data
        ld a, acmd_41
        out (c), a
        ld l, 0
        out (c), h
        out (c), l
        out (c), l
        out (c), l
        dec l
        out (c), l
        jp resp
;-------
cmd18   call csh
        call csl
        push hl
        push bc
        push de

        ld l, c
        ld h, b

        ld a, (blkt)
        or a
        jr nz, cmzz
        ex de, hl
        add hl, hl
        ex de, hl
        adc hl, hl
        ld h, l
        ld l, d
        ld d, e
        ld e, a

cmzz    ld a, cmd_18
        ld bc, data
        out (c), a
        out (c), h
        out (c), l
        out (c), d
        out (c), e
        ld a, h'FF
        out (c), a
        
        pop de
        pop bc
        pop hl
        jp resp
;-------
cmdi6   ld hl, cmd16
        jr cmd
cmd8    ld hl, cmd08
        jr cmd
cmd0    ld hl, cmd00
cmd     call csh
        call csl
        ld bc, data
        outi
        outi
        outi
        outi
        outi
        outi

resp    push de
        push bc
        ld bc, data
        ld d, 10
resz    in a, (c)
        bit 7, a
        jr z, rez
        dec d
        jr nz, resz
        inc d
rez     pop bc
        pop de
        ret
;-------
wtdo    push bc
        ld bc, data
        in a, (c)
        cp h'FF
        jr z, $-4
        pop bc
        ret

wait    push bc
        push af
        ld bc, data
        in a, (c)
        inc a
        jr nz, $-3
        pop af
        pop bc
        ret
;-------
sdoff   xor a
        out (sdcnf), a
        out (data), a
        ret
;---------------------------------------



;---------------------------------------
;   IDE NEMO DRIVER
;---------------------------------------

xpozi_nemo
        ld (lthl), hl
        ld (ltde), de
proz_nemo
        ld a, h
        ld h, d
        ld d, e
        ld e, a
        
;DE,cyl H,head L,sec

        ld (blknum), hl
        LD (blknum+2), de
        RET

rereg   push hl
        push de
        ld hl, (blknum)
        ld de, (blknum+2)

        ld a, h
        and %00001111
        ld h, a
        ld a, (drvre)
        or h
        ld bc, h'FFD0
        out (c), a
        ld c, h'70
        out (c), l
        ld c, h'B0
        out (c), d
        ld c, h'90
        out (c), e
        pop de
        pop hl
        RET

;---------------------------------------
rpoz    ld bc, h'ffd0
        in a, (c)
        and h'0f
        ld h,a
        ld c, h'70
        in l, (c)
        ld c, h'b0
        in d, (c)
        ld c, h'90
        in e, (c)
        ret

;---------------------------------------
;---------------------------------------
;hl,in da kudy a,secs

rddse_nemo
        push af
        call drdy
        ld bc, h'50
        out (c), a
        call rereg
        ld a, h'20
        call comah
        pop bc
rdh1    push bc
        call waitdrq
        call reads_nemo
        call ready
        pop bc
        djnz rdh1
        ret

;---------------------------------------
reads_nemo
        ld bc, h'0010
        inir
        inir
        ret

;---------------------------------------
sel_sla ld a, h'F0
sel_ide ld (drvre), a
        ld bc, h'D0
        out (c), a
        
        ld de, 0
sdr     call loll
        rlca
        ret nc
        dec de
        ld a, d
        or e
        jr nz, sdr
        scf
        ret

sel_mas ld a, h'E0
        jr sel_ide

;---------------------------------------
dv2     call sel_sla
        jr drdet
;-------
sel_dev_nemo
;i:a - n of dev
        cp 2
        jr nc, ru
		
        dec a
        jr z,dv2
        call sel_mas
drdet   jr c, ru
        ld a, h'08
        call comm
        call error_7
        jr c, rrr

        ld hl, 16384
ydet    call loll
        rlca
        jr nc, rrr
        
        call hult
		
        dec hl
        ld a, h
        or l
        jr nz, ydet

        ld de, 500
        jr ru

rrr     ld de, 0
        ld hl, 2
        call xpozi_nemo
        call rereg
        ld a, h'ec
        call comm
        
        call hult2
        
        call rpoz
        ld a, d
        or e
        or h
        jr nz, ru
        ld a, l
        cp 2
        jr z, kru
        
;ld hl,#eb14
;or a:sbc hl,de:ret z;atapi
ru      ld a, 1
        or a
        ret
;-------
kru     ld hl, lobu
        call reads_nemo
        ld de, 0
        xor a
        ret

hult2   ld hl, 192
huu     call hult
        dec hl
        ld a, h
        or l
        jr nz, huu
        ret
hult    ld b, 0
haalt   add a, (ix+0)
        djnz haalt
        ret
;---------------------------------------
loll    ld bc, h'f0
        in a, (c)
        ret

comah   call comm
ready   call loll
        rlca
        ret nc
        jr ready

waitdrq call loll
        and 8
        ret nz
        jr waitdrq

drdy    call loll
        and %11000000
        cp %01000000
        ret z
        jr drdy

comm    ld bc, h'f0
        out (c), a
        ret

error_7 ld bc, h'f0
        in a, (c)
        rrca
        ret

;---------------------------------------



;=======================================
ide_ini ld a, (device)
        or a
        jp z, ini_sd
        ret
		
xpozi   ld a, (device)
        or a
        jp z, xpozi_sd
        dec a
        jp z, xpozi_nemo
        dec a
        jp z, xpozi_nemo
        ret
		
proz    ld a, (device)
        or a
        jp z, proz_sd
        dec a
        jp z, proz_nemo
        dec a
        jp z, proz_nemo
        ret

rddse   ld c, a
        ld a, (device)
        or a
        jr z, to_rddse_sd
        dec a
        jr z, to_rddse_nemo
        dec a
        jr z, to_rddse_nemo
        ld a, c
        ret
to_rddse_sd
        ld a, c
        jp rddse_sd
to_rddse_nemo
        ld a, c
        jp rddse_nemo
		
sel_dev ld c, a
        ld a, (device)
        or a
        jr z, to_sel_dev_sd
        dec a
        jr z, to_sel_dev_nemo
        dec a
        jr z, to_sel_dev_nemo
        ld c, a
        ret
to_sel_dev_sd
        ld a, c
        jp sel_dev_sd
to_sel_dev_nemo
        ld a, c
        jp sel_dev_nemo
;---------------------------------------        
;---------------------------------------
;---------------------------------------
file1   defb "BOOT    $C "

