
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny13
;Program type             : Application
;Clock frequency          : 9.600000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 16 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Smart register allocation     : Off
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny13
	#pragma AVRPART MEMORY PROG_FLASH 1024
	#pragma AVRPART MEMORY EEPROM 64
	#pragma AVRPART MEMORY INT_SRAM SIZE 159
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x009F
	.EQU __DSTACK_SIZE=0x0010
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOV  R30,R0
	MOV  R31,R1
	.ENDM

	.MACRO __GETB2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOV  R26,R0
	MOV  R27,R1
	.ENDM

	.MACRO __GETBRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOV  R30,R28
	MOV  R31,R29
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOV  R26,R28
	MOV  R27,R29
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x70

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 05/02/2020
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATtiny13
;AVR Core Clock frequency: 9.600000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 16
;*****************************************************/
;
;#include <tiny13.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x18
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_powerdown=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0x20
;
;// Read the 8 most significant bits
;// of the AD conversion result
;//unsigned char read_adc(unsigned char adc_input)
;//{
;//ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;//// Delay needed for the stabilization of the ADC input voltage
;//delay_us(10);
;//// Start the AD conversion
;//ADCSRA|=0x40;
;//// Wait for the AD conversion to complete
;//while ((ADCSRA & 0x10)==0);
;//ADCSRA|=0x10;
;//return ADCH;
;//}
;
;// Declare your global variables here
;void calc_pump_delay(void);
;eeprom int save_delay;
;eeprom int pump_delay;
;eeprom char first_time_k;
;void main(void)
; 0000 0031 {

	.CSEG
_main:
; 0000 0032 // Declare your local variables here
; 0000 0033  int i,exist,not_exist;
; 0000 0034 
; 0000 0035 // Crystal Oscillator division factor: 1
; 0000 0036 #pragma optsize-
; 0000 0037 CLKPR=0x80;
;	i -> R16,R17
;	exist -> R18,R19
;	not_exist -> R20,R21
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0038 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0039 #ifdef _OPTIMIZE_SIZE_
; 0000 003A #pragma optsize+
; 0000 003B #endif
; 0000 003C 
; 0000 003D // Input/Output Ports initialization
; 0000 003E // Port B initialization
; 0000 003F // Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0040 // State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0041 //PORTB=0x00;
; 0000 0042 //DDRB=0x00;
; 0000 0043 
; 0000 0044 PORTB=0x00;
	OUT  0x18,R30
; 0000 0045 DDRB=0x07;
	RCALL SUBOPT_0x0
; 0000 0046 
; 0000 0047 // Timer/Counter 0 initialization
; 0000 0048 // Clock source: System Clock
; 0000 0049 // Clock value: Timer 0 Stopped
; 0000 004A // Mode: Normal top=0xFF
; 0000 004B // OC0A output: Disconnected
; 0000 004C // OC0B output: Disconnected
; 0000 004D TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 004E TCCR0B=0x00;
	OUT  0x33,R30
; 0000 004F TCNT0=0x00;
	OUT  0x32,R30
; 0000 0050 OCR0A=0x00;
	OUT  0x36,R30
; 0000 0051 OCR0B=0x00;
	OUT  0x29,R30
; 0000 0052 
; 0000 0053 // External Interrupt(s) initialization
; 0000 0054 // INT0: Off
; 0000 0055 // Interrupt on any change on pins PCINT0-5: Off
; 0000 0056 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 0057 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0058 
; 0000 0059 // Timer/Counter 0 Interrupt(s) initialization
; 0000 005A TIMSK0=0x00;
	OUT  0x39,R30
; 0000 005B 
; 0000 005C // Analog Comparator initialization
; 0000 005D // Analog Comparator: Off
; 0000 005E ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 005F ADCSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 0060 DIDR0=0x00;
	OUT  0x14,R30
; 0000 0061 
; 0000 0062 // ADC initialization
; 0000 0063 // ADC Clock frequency: 75.000 kHz
; 0000 0064 // ADC Bandgap Voltage Reference: Off
; 0000 0065 // ADC Auto Trigger Source: Free Running
; 0000 0066 // Only the 8 most significant bits of
; 0000 0067 // the AD conversion result are used
; 0000 0068 // Digital input buffers on ADC0: Off, ADC1: On, ADC2: Off, ADC3: Off
; 0000 0069 DIDR0&=0x03;
	IN   R30,0x14
	ANDI R30,LOW(0x3)
	OUT  0x14,R30
; 0000 006A DIDR0|=0x00;
	IN   R30,0x14
	OUT  0x14,R30
; 0000 006B ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 006C ADCSRA=0xA7;
	LDI  R30,LOW(167)
	OUT  0x6,R30
; 0000 006D ADCSRB&=0xF8;
	IN   R30,0x3
	ANDI R30,LOW(0xF8)
	OUT  0x3,R30
; 0000 006E 
; 0000 006F 
; 0000 0070 /////////////////////////////////////////
; 0000 0071 DDRB=0x07;
	RCALL SUBOPT_0x0
; 0000 0072 /////////////////////////////
; 0000 0073 PORTB.1 = 0; // pump
	CBI  0x18,1
; 0000 0074 PORTB.0 = 1; // cheragh
	SBI  0x18,0
; 0000 0075 PORTB.2 = 0; // sensor
	CBI  0x18,2
; 0000 0076 exist = 0;
	__GETWRN 18,19,0
; 0000 0077 not_exist = 0;
	__GETWRN 20,21,0
; 0000 0078 
; 0000 0079 if (first_time_k != 27)
	LDI  R26,LOW(_first_time_k)
	LDI  R27,HIGH(_first_time_k)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x1B)
	BREQ _0x9
; 0000 007A {
; 0000 007B save_delay = 2;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __EEPROMWRW
; 0000 007C pump_delay = 550;
	RCALL SUBOPT_0x2
	LDI  R30,LOW(550)
	LDI  R31,HIGH(550)
	RCALL __EEPROMWRW
; 0000 007D first_time_k = 27;
	LDI  R26,LOW(_first_time_k)
	LDI  R27,HIGH(_first_time_k)
	LDI  R30,LOW(27)
	RCALL __EEPROMWRB
; 0000 007E }
; 0000 007F 
; 0000 0080 delay_ms(500);
_0x9:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x3
; 0000 0081 //////////////////////////
; 0000 0082 
; 0000 0083  calc_pump_delay();
	RCALL _calc_pump_delay
; 0000 0084 
; 0000 0085 DDRB=0x07;
	RCALL SUBOPT_0x0
; 0000 0086 while (1)
_0xA:
; 0000 0087       {
; 0000 0088 
; 0000 0089       //////////////////////
; 0000 008A 
; 0000 008B 
; 0000 008C           PORTB.2 = 1; // sensor pulse
	RCALL SUBOPT_0x4
; 0000 008D           delay_us(20);
; 0000 008E           PORTB.2 = 0;
; 0000 008F 
; 0000 0090           DDRB=0x03;    //pb.2 = input
; 0000 0091 
; 0000 0092           while (!PINB.2)
_0x11:
	SBIS 0x16,2
; 0000 0093           {
; 0000 0094           };
	RJMP _0x11
; 0000 0095 
; 0000 0096           i = 0;
	__GETWRN 16,17,0
; 0000 0097           while (PINB.2)
_0x14:
	SBIS 0x16,2
	RJMP _0x16
; 0000 0098           {
; 0000 0099           i++;
	RCALL SUBOPT_0x5
; 0000 009A           delay_us(10);
; 0000 009B           };
	RJMP _0x14
_0x16:
; 0000 009C 
; 0000 009D 
; 0000 009E           DDRB=0x07;   //pb.2 = output
	RCALL SUBOPT_0x0
; 0000 009F 
; 0000 00A0           if (i<100) // ›«’·Â
	RCALL SUBOPT_0x6
	BRGE _0x17
; 0000 00A1           {
; 0000 00A2           if (exist <= 2) exist ++;  // «ê— œÊ »«— Å‘  ”— Â„ ”‰”Ê—  ‘ŒÌ’ Õ÷Ê— œ«œ ⁄„· ò‰œ
	__CPWRN 18,19,3
	BRGE _0x18
	__ADDWRN 18,19,1
; 0000 00A3 
; 0000 00A4 
; 0000 00A5               if (exist == 2)
_0x18:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x19
; 0000 00A6               {
; 0000 00A7               not_exist = 0;
	__GETWRN 20,21,0
; 0000 00A8 
; 0000 00A9               /////////wash hands///////////
; 0000 00AA                PORTB.0 = 0; //led
	CBI  0x18,0
; 0000 00AB                PORTB.1 = 1; //pump
	SBI  0x18,1
; 0000 00AC                delay_ms(pump_delay);   // relay pulse delay
	RCALL SUBOPT_0x2
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x3
; 0000 00AD                PORTB.1 = 0;
	CBI  0x18,1
; 0000 00AE                PORTB.0 = 1;
	RCALL SUBOPT_0x7
; 0000 00AF               //////////////////////////////
; 0000 00B0                delay_ms(100);
; 0000 00B1               }
; 0000 00B2 
; 0000 00B3 
; 0000 00B4           }
_0x19:
; 0000 00B5 
; 0000 00B6           if (i>=100)  // ›«’·Â
_0x17:
	RCALL SUBOPT_0x6
	BRLT _0x22
; 0000 00B7           {
; 0000 00B8           if (not_exist <= 2) not_exist ++;
	__CPWRN 20,21,3
	BRGE _0x23
	__ADDWRN 20,21,1
; 0000 00B9           if (not_exist == 2)
_0x23:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CP   R30,R20
	CPC  R31,R21
	BRNE _0x24
; 0000 00BA           {
; 0000 00BB           exist = 0;
	__GETWRN 18,19,0
; 0000 00BC           }
; 0000 00BD           }
_0x24:
; 0000 00BE 
; 0000 00BF  delay_ms(100);
_0x22:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x3
; 0000 00C0 
; 0000 00C1 //
; 0000 00C2 /////////////////////////////////
; 0000 00C3 
; 0000 00C4 
; 0000 00C5       }
	RJMP _0xA
; 0000 00C6 };
_0x25:
	RJMP _0x25
;//
;
; void calc_pump_delay(void)
; 0000 00CA  {
_calc_pump_delay:
; 0000 00CB  int h,s;
; 0000 00CC 
; 0000 00CD h = 0;
	RCALL __SAVELOCR4
;	h -> R16,R17
;	s -> R18,R19
	__GETWRN 16,17,0
; 0000 00CE DDRB=0x07;
	RCALL SUBOPT_0x0
; 0000 00CF 
; 0000 00D0  while (h<100)
_0x26:
	RCALL SUBOPT_0x6
	BRGE _0x28
; 0000 00D1  {
; 0000 00D2 
; 0000 00D3           PORTB.2 = 1; // sensor pulse
	RCALL SUBOPT_0x4
; 0000 00D4           delay_us(20);
; 0000 00D5           PORTB.2 = 0;
; 0000 00D6 
; 0000 00D7           DDRB=0x03;    //pb.2 = input
; 0000 00D8 
; 0000 00D9           while (!PINB.2)
_0x2D:
	SBIS 0x16,2
; 0000 00DA           {
; 0000 00DB           };
	RJMP _0x2D
; 0000 00DC 
; 0000 00DD           h = 0;
	__GETWRN 16,17,0
; 0000 00DE           while (PINB.2)
_0x30:
	SBIS 0x16,2
	RJMP _0x32
; 0000 00DF           {
; 0000 00E0           h++;
	RCALL SUBOPT_0x5
; 0000 00E1           delay_us(10);
; 0000 00E2           };
	RJMP _0x30
_0x32:
; 0000 00E3 
; 0000 00E4 
; 0000 00E5           DDRB=0x07;   //pb.2 = output
	RCALL SUBOPT_0x0
; 0000 00E6 
; 0000 00E7           if (h<100) // ›«’·Â
	RCALL SUBOPT_0x6
	BRGE _0x33
; 0000 00E8           {
; 0000 00E9           save_delay ++;
	RCALL SUBOPT_0x8
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0000 00EA 
; 0000 00EB           if (save_delay > 3)
	RCALL SUBOPT_0x8
	SBIW R30,4
	BRLT _0x34
; 0000 00EC            {
; 0000 00ED            save_delay = 1;
	RCALL SUBOPT_0x1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RCALL __EEPROMWRW
; 0000 00EE            }
; 0000 00EF 
; 0000 00F0            for (s=1;s<=save_delay ;s++)
_0x34:
	__GETWRN 18,19,1
_0x36:
	RCALL SUBOPT_0x8
	CP   R30,R18
	CPC  R31,R19
	BRLT _0x37
; 0000 00F1            {
; 0000 00F2              /////////blink hand led///////////
; 0000 00F3                PORTB.0 = 0; //led
	CBI  0x18,0
; 0000 00F4                delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x3
; 0000 00F5                PORTB.0 = 1;
	RCALL SUBOPT_0x7
; 0000 00F6                delay_ms(100);
; 0000 00F7               //////////////////////////////
; 0000 00F8            }
	__ADDWRN 18,19,1
	RJMP _0x36
_0x37:
; 0000 00F9            delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RCALL SUBOPT_0x3
; 0000 00FA 
; 0000 00FB           }
; 0000 00FC  }
_0x33:
	RJMP _0x26
_0x28:
; 0000 00FD 
; 0000 00FE if (save_delay == 1){pump_delay = 350; }
	RCALL SUBOPT_0x8
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x3C
	RCALL SUBOPT_0x2
	LDI  R30,LOW(350)
	LDI  R31,HIGH(350)
	RCALL __EEPROMWRW
; 0000 00FF if (save_delay == 2){pump_delay = 550; }
_0x3C:
	RCALL SUBOPT_0x8
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3D
	RCALL SUBOPT_0x2
	LDI  R30,LOW(550)
	LDI  R31,HIGH(550)
	RCALL __EEPROMWRW
; 0000 0100 if (save_delay == 3){pump_delay = 950; }
_0x3D:
	RCALL SUBOPT_0x8
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3E
	RCALL SUBOPT_0x2
	LDI  R30,LOW(950)
	LDI  R31,HIGH(950)
	RCALL __EEPROMWRW
; 0000 0101 
; 0000 0102  };
_0x3E:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET

	.ESEG
_save_delay:
	.BYTE 0x2
_pump_delay:
	.BYTE 0x2
_first_time_k:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(7)
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_save_delay)
	LDI  R27,HIGH(_save_delay)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_pump_delay)
	LDI  R27,HIGH(_pump_delay)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	SBI  0x18,2
	__DELAY_USB 64
	CBI  0x18,2
	LDI  R30,LOW(3)
	OUT  0x17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	__ADDWRN 16,17,1
	__DELAY_USB 32
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	__CPWRN 16,17,100
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	SBI  0x18,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	RCALL SUBOPT_0x1
	RCALL __EEPROMRDW
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x960
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
