
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega64A
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega64A
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
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
	MOVW R26,R28
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
	MOVW R26,R28
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

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _pressed_key=R5

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_font5x7:
	.DB  0x5,0x7,0x20,0x60,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x5F,0x0,0x0,0x0,0x7
	.DB  0x0,0x7,0x0,0x14,0x7F,0x14,0x7F,0x14
	.DB  0x24,0x2A,0x7F,0x2A,0x12,0x23,0x13,0x8
	.DB  0x64,0x62,0x36,0x49,0x55,0x22,0x50,0x0
	.DB  0x5,0x3,0x0,0x0,0x0,0x1C,0x22,0x41
	.DB  0x0,0x0,0x41,0x22,0x1C,0x0,0x8,0x2A
	.DB  0x1C,0x2A,0x8,0x8,0x8,0x3E,0x8,0x8
	.DB  0x0,0x50,0x30,0x0,0x0,0x8,0x8,0x8
	.DB  0x8,0x8,0x0,0x30,0x30,0x0,0x0,0x20
	.DB  0x10,0x8,0x4,0x2,0x3E,0x51,0x49,0x45
	.DB  0x3E,0x0,0x42,0x7F,0x40,0x0,0x42,0x61
	.DB  0x51,0x49,0x46,0x21,0x41,0x45,0x4B,0x31
	.DB  0x18,0x14,0x12,0x7F,0x10,0x27,0x45,0x45
	.DB  0x45,0x39,0x3C,0x4A,0x49,0x49,0x30,0x1
	.DB  0x71,0x9,0x5,0x3,0x36,0x49,0x49,0x49
	.DB  0x36,0x6,0x49,0x49,0x29,0x1E,0x0,0x36
	.DB  0x36,0x0,0x0,0x0,0x56,0x36,0x0,0x0
	.DB  0x0,0x8,0x14,0x22,0x41,0x14,0x14,0x14
	.DB  0x14,0x14,0x41,0x22,0x14,0x8,0x0,0x2
	.DB  0x1,0x51,0x9,0x6,0x32,0x49,0x79,0x41
	.DB  0x3E,0x7E,0x11,0x11,0x11,0x7E,0x7F,0x49
	.DB  0x49,0x49,0x36,0x3E,0x41,0x41,0x41,0x22
	.DB  0x7F,0x41,0x41,0x22,0x1C,0x7F,0x49,0x49
	.DB  0x49,0x41,0x7F,0x9,0x9,0x1,0x1,0x3E
	.DB  0x41,0x41,0x51,0x32,0x7F,0x8,0x8,0x8
	.DB  0x7F,0x0,0x41,0x7F,0x41,0x0,0x20,0x40
	.DB  0x41,0x3F,0x1,0x7F,0x8,0x14,0x22,0x41
	.DB  0x7F,0x40,0x40,0x40,0x40,0x7F,0x2,0x4
	.DB  0x2,0x7F,0x7F,0x4,0x8,0x10,0x7F,0x3E
	.DB  0x41,0x41,0x41,0x3E,0x7F,0x9,0x9,0x9
	.DB  0x6,0x3E,0x41,0x51,0x21,0x5E,0x7F,0x9
	.DB  0x19,0x29,0x46,0x46,0x49,0x49,0x49,0x31
	.DB  0x1,0x1,0x7F,0x1,0x1,0x3F,0x40,0x40
	.DB  0x40,0x3F,0x1F,0x20,0x40,0x20,0x1F,0x7F
	.DB  0x20,0x18,0x20,0x7F,0x63,0x14,0x8,0x14
	.DB  0x63,0x3,0x4,0x78,0x4,0x3,0x61,0x51
	.DB  0x49,0x45,0x43,0x0,0x0,0x7F,0x41,0x41
	.DB  0x2,0x4,0x8,0x10,0x20,0x41,0x41,0x7F
	.DB  0x0,0x0,0x4,0x2,0x1,0x2,0x4,0x40
	.DB  0x40,0x40,0x40,0x40,0x0,0x1,0x2,0x4
	.DB  0x0,0x20,0x54,0x54,0x54,0x78,0x7F,0x48
	.DB  0x44,0x44,0x38,0x38,0x44,0x44,0x44,0x20
	.DB  0x38,0x44,0x44,0x48,0x7F,0x38,0x54,0x54
	.DB  0x54,0x18,0x8,0x7E,0x9,0x1,0x2,0x8
	.DB  0x14,0x54,0x54,0x3C,0x7F,0x8,0x4,0x4
	.DB  0x78,0x0,0x44,0x7D,0x40,0x0,0x20,0x40
	.DB  0x44,0x3D,0x0,0x0,0x7F,0x10,0x28,0x44
	.DB  0x0,0x41,0x7F,0x40,0x0,0x7C,0x4,0x18
	.DB  0x4,0x78,0x7C,0x8,0x4,0x4,0x78,0x38
	.DB  0x44,0x44,0x44,0x38,0x7C,0x14,0x14,0x14
	.DB  0x8,0x8,0x14,0x14,0x18,0x7C,0x7C,0x8
	.DB  0x4,0x4,0x8,0x48,0x54,0x54,0x54,0x20
	.DB  0x4,0x3F,0x44,0x40,0x20,0x3C,0x40,0x40
	.DB  0x20,0x7C,0x1C,0x20,0x40,0x20,0x1C,0x3C
	.DB  0x40,0x30,0x40,0x3C,0x44,0x28,0x10,0x28
	.DB  0x44,0xC,0x50,0x50,0x50,0x3C,0x44,0x64
	.DB  0x54,0x4C,0x44,0x0,0x8,0x36,0x41,0x0
	.DB  0x0,0x0,0x7F,0x0,0x0,0x0,0x41,0x36
	.DB  0x8,0x0,0x2,0x1,0x2,0x4,0x2,0x7F
	.DB  0x41,0x41,0x41,0x7F
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3:
	.DB  0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38
	.DB  0x39,0x2A,0x30,0x23,0x7,0x5,0x6,0x4
	.DB  0x0,0x1,0x2
_0x0:
	.DB  0x25,0x73,0xD,0xA,0x0,0x4F,0x4B,0x0
	.DB  0x45,0x52,0x52,0x4F,0x52,0x0,0x3E,0x0
	.DB  0x44,0x4F,0x57,0x4E,0x4C,0x4F,0x41,0x44
	.DB  0x0,0x53,0x45,0x4E,0x44,0x20,0x4F,0x4B
	.DB  0x0,0x43,0x4C,0x4F,0x53,0x45,0x20,0x4F
	.DB  0x4B,0x0,0x2B,0x48,0x54,0x54,0x50,0x41
	.DB  0x43,0x54,0x49,0x4F,0x4E,0x0,0x53,0x65
	.DB  0x74,0x74,0x69,0x6E,0x67,0x20,0x53,0x4D
	.DB  0x53,0x20,0x4D,0x6F,0x64,0x65,0x2E,0x2E
	.DB  0x2E,0x0,0x41,0x54,0x2B,0x43,0x4D,0x47
	.DB  0x46,0x3D,0x31,0x0,0x41,0x54,0x2B,0x43
	.DB  0x4E,0x4D,0x49,0x3D,0x32,0x2C,0x32,0x2C
	.DB  0x30,0x2C,0x30,0x2C,0x30,0x0,0x41,0x54
	.DB  0x2B,0x43,0x4D,0x47,0x44,0x41,0x3D,0x22
	.DB  0x44,0x45,0x4C,0x20,0x41,0x4C,0x4C,0x22
	.DB  0x0,0x53,0x4D,0x53,0x20,0x52,0x65,0x61
	.DB  0x64,0x79,0x2E,0x0,0x4D,0x4F,0x54,0x4F
	.DB  0x52,0x20,0x25,0x64,0x20,0x4F,0x4E,0x21
	.DB  0x0,0x4D,0x4F,0x54,0x4F,0x52,0x20,0x25
	.DB  0x64,0x20,0x4F,0x46,0x46,0x21,0x0,0x25
	.DB  0x64,0x0,0x45,0x6E,0x74,0x65,0x72,0x20
	.DB  0x74,0x68,0x69,0x73,0x20,0x63,0x6F,0x64
	.DB  0x65,0x3A,0x0,0x59,0x6F,0x75,0x72,0x20
	.DB  0x69,0x6E,0x70,0x75,0x74,0x3A,0x20,0x0
	.DB  0x54,0x69,0x6D,0x65,0x3A,0x20,0x25,0x64
	.DB  0x20,0x0,0x54,0x69,0x6D,0x65,0x20,0x69
	.DB  0x73,0x20,0x75,0x70,0x21,0x0,0x43,0x6F
	.DB  0x64,0x65,0x20,0x43,0x6F,0x72,0x72,0x65
	.DB  0x63,0x74,0x21,0x0,0x57,0x72,0x6F,0x6E
	.DB  0x67,0x20,0x43,0x6F,0x64,0x65,0x21,0x0
	.DB  0x2B,0x39,0x38,0x0,0x43,0x68,0x65,0x63
	.DB  0x6B,0x69,0x6E,0x67,0x20,0x42,0x65,0x61
	.DB  0x72,0x65,0x72,0x2E,0x2E,0x2E,0x0,0x41
	.DB  0x54,0x2B,0x53,0x41,0x50,0x42,0x52,0x3D
	.DB  0x32,0x2C,0x31,0x0,0x30,0x2E,0x30,0x2E
	.DB  0x30,0x2E,0x30,0x0,0x42,0x65,0x61,0x72
	.DB  0x65,0x72,0x20,0x69,0x73,0x20,0x64,0x6F
	.DB  0x77,0x6E,0x2E,0x0,0x52,0x65,0x2D,0x6F
	.DB  0x70,0x65,0x6E,0x69,0x6E,0x67,0x2E,0x2E
	.DB  0x2E,0x0,0x41,0x54,0x2B,0x53,0x41,0x50
	.DB  0x42,0x52,0x3D,0x31,0x2C,0x31,0x0,0x52
	.DB  0x65,0x2D,0x6F,0x70,0x65,0x6E,0x65,0x64
	.DB  0x20,0x4F,0x4B,0x2E,0x0,0x52,0x65,0x2D
	.DB  0x6F,0x70,0x65,0x6E,0x20,0x46,0x61,0x69
	.DB  0x6C,0x65,0x64,0x21,0x0,0x42,0x65,0x61
	.DB  0x72,0x65,0x72,0x20,0x69,0x73,0x20,0x41
	.DB  0x63,0x74,0x69,0x76,0x65,0x2E,0x0,0x49
	.DB  0x6E,0x69,0x74,0x20,0x48,0x54,0x54,0x50
	.DB  0x20,0x42,0x65,0x61,0x72,0x65,0x72,0x2E
	.DB  0x2E,0x2E,0x0,0x43,0x68,0x65,0x63,0x6B
	.DB  0x69,0x6E,0x67,0x20,0x6E,0x65,0x74,0x77
	.DB  0x6F,0x72,0x6B,0x2E,0x2E,0x2E,0x0,0x41
	.DB  0x54,0x2B,0x43,0x52,0x45,0x47,0x3F,0x0
	.DB  0x2C,0x35,0x0,0x52,0x65,0x67,0x69,0x73
	.DB  0x74,0x65,0x72,0x65,0x64,0x21,0x0,0x41
	.DB  0x54,0x2B,0x53,0x41,0x50,0x42,0x52,0x3D
	.DB  0x33,0x2C,0x31,0x2C,0x22,0x43,0x6F,0x6E
	.DB  0x74,0x79,0x70,0x65,0x22,0x2C,0x22,0x47
	.DB  0x50,0x52,0x53,0x22,0x0,0x41,0x54,0x2B
	.DB  0x53,0x41,0x50,0x42,0x52,0x3D,0x33,0x2C
	.DB  0x31,0x2C,0x22,0x41,0x50,0x4E,0x22,0x2C
	.DB  0x22,0x25,0x73,0x22,0x0,0x6D,0x74,0x6E
	.DB  0x69,0x72,0x61,0x6E,0x63,0x65,0x6C,0x6C
	.DB  0x0,0x7B,0x22,0x70,0x68,0x6F,0x6E,0x65
	.DB  0x5F,0x6E,0x75,0x6D,0x62,0x65,0x72,0x22
	.DB  0x3A,0x25,0x73,0x2C,0x22,0x64,0x65,0x76
	.DB  0x69,0x63,0x65,0x5F,0x69,0x64,0x22,0x3A
	.DB  0x25,0x64,0x2C,0x22,0x70,0x72,0x6F,0x64
	.DB  0x75,0x63,0x74,0x5F,0x69,0x64,0x22,0x3A
	.DB  0x25,0x64,0x7D,0x0,0x48,0x54,0x54,0x50
	.DB  0x20,0x50,0x4F,0x53,0x54,0x20,0x52,0x65
	.DB  0x71,0x75,0x65,0x73,0x74,0x2E,0x2E,0x2E
	.DB  0x0,0x41,0x54,0x2B,0x48,0x54,0x54,0x50
	.DB  0x49,0x4E,0x49,0x54,0x0,0x41,0x54,0x2B
	.DB  0x48,0x54,0x54,0x50,0x54,0x45,0x52,0x4D
	.DB  0x0,0x41,0x54,0x2B,0x48,0x54,0x54,0x50
	.DB  0x41,0x43,0x54,0x49,0x4F,0x4E,0x3D,0x31
	.DB  0x0,0x2B,0x48,0x54,0x54,0x50,0x41,0x43
	.DB  0x54,0x49,0x4F,0x4E,0x3A,0x20,0x31,0x2C
	.DB  0x32,0x30,0x30,0x0,0x41,0x54,0x2B,0x48
	.DB  0x54,0x54,0x50,0x52,0x45,0x41,0x44,0x0
	.DB  0x6F,0x6B,0x0,0x2B,0x43,0x4D,0x54,0x3A
	.DB  0x0,0x4E,0x65,0x77,0x20,0x53,0x4D,0x53
	.DB  0x20,0x50,0x72,0x6F,0x63,0x65,0x73,0x73
	.DB  0x69,0x6E,0x67,0x2E,0x2E,0x2E,0x0,0x53
	.DB  0x65,0x72,0x76,0x65,0x72,0x20,0x54,0x78
	.DB  0x20,0x46,0x61,0x69,0x6C,0x65,0x64,0x21
	.DB  0x0,0x49,0x6E,0x76,0x61,0x6C,0x69,0x64
	.DB  0x20,0x50,0x72,0x6F,0x64,0x75,0x63,0x74
	.DB  0x20,0x49,0x44,0x21,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4D,0x47,0x44,0x41,0x3D,0x22,0x44
	.DB  0x45,0x4C,0x20,0x52,0x45,0x41,0x44,0x22
	.DB  0x0,0x4D,0x6F,0x64,0x75,0x6C,0x65,0x20
	.DB  0x49,0x6E,0x69,0x74,0x2E,0x2E,0x2E,0x0
	.DB  0x41,0x54,0x45,0x30,0x0,0x41,0x54,0x0
	.DB  0x4D,0x6F,0x64,0x75,0x6C,0x65,0x20,0x4E
	.DB  0x6F,0x74,0x20,0x46,0x6F,0x75,0x6E,0x64
	.DB  0x21,0x0,0x53,0x4D,0x53,0x20,0x49,0x6E
	.DB  0x69,0x74,0x20,0x46,0x61,0x69,0x6C,0x65
	.DB  0x64,0x21,0x0,0x48,0x54,0x54,0x50,0x20
	.DB  0x42,0x65,0x61,0x72,0x65,0x72,0x20,0x46
	.DB  0x61,0x69,0x6C,0x65,0x64,0x21,0x0,0x53
	.DB  0x79,0x73,0x74,0x65,0x6D,0x20,0x52,0x65
	.DB  0x61,0x64,0x79,0x2E,0x0,0x57,0x61,0x69
	.DB  0x74,0x69,0x6E,0x67,0x20,0x66,0x6F,0x72
	.DB  0x20,0x53,0x4D,0x53,0x2E,0x2E,0x2E,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  _0x13
	.DW  _0x0*2+3

	.DW  0x03
	.DW  _0x13+2
	.DW  _0x0*2+5

	.DW  0x06
	.DW  _0x13+5
	.DW  _0x0*2+8

	.DW  0x02
	.DW  _0x13+11
	.DW  _0x0*2+14

	.DW  0x09
	.DW  _0x13+13
	.DW  _0x0*2+16

	.DW  0x08
	.DW  _0x13+22
	.DW  _0x0*2+25

	.DW  0x09
	.DW  _0x13+30
	.DW  _0x0*2+33

	.DW  0x0C
	.DW  _0x13+39
	.DW  _0x0*2+42

	.DW  0x14
	.DW  _0x17
	.DW  _0x0*2+54

	.DW  0x0A
	.DW  _0x17+20
	.DW  _0x0*2+74

	.DW  0x03
	.DW  _0x17+30
	.DW  _0x0*2+5

	.DW  0x12
	.DW  _0x17+33
	.DW  _0x0*2+84

	.DW  0x03
	.DW  _0x17+51
	.DW  _0x0*2+5

	.DW  0x13
	.DW  _0x17+54
	.DW  _0x0*2+102

	.DW  0x03
	.DW  _0x17+73
	.DW  _0x0*2+5

	.DW  0x0B
	.DW  _0x17+76
	.DW  _0x0*2+121

	.DW  0x11
	.DW  _0x22
	.DW  _0x0*2+162

	.DW  0x0D
	.DW  _0x22+17
	.DW  _0x0*2+179

	.DW  0x0C
	.DW  _0x22+30
	.DW  _0x0*2+202

	.DW  0x0E
	.DW  _0x22+42
	.DW  _0x0*2+214

	.DW  0x0C
	.DW  _0x22+56
	.DW  _0x0*2+228

	.DW  0x04
	.DW  _0x30
	.DW  _0x0*2+240

	.DW  0x13
	.DW  _0x34
	.DW  _0x0*2+244

	.DW  0x0D
	.DW  _0x34+19
	.DW  _0x0*2+263

	.DW  0x08
	.DW  _0x34+32
	.DW  _0x0*2+276

	.DW  0x06
	.DW  _0x34+40
	.DW  _0x0*2+8

	.DW  0x10
	.DW  _0x34+46
	.DW  _0x0*2+284

	.DW  0x0E
	.DW  _0x34+62
	.DW  _0x0*2+300

	.DW  0x0D
	.DW  _0x34+76
	.DW  _0x0*2+314

	.DW  0x03
	.DW  _0x34+89
	.DW  _0x0*2+5

	.DW  0x0E
	.DW  _0x34+92
	.DW  _0x0*2+327

	.DW  0x10
	.DW  _0x34+106
	.DW  _0x0*2+341

	.DW  0x12
	.DW  _0x34+122
	.DW  _0x0*2+357

	.DW  0x14
	.DW  _0x3A
	.DW  _0x0*2+375

	.DW  0x14
	.DW  _0x3A+20
	.DW  _0x0*2+395

	.DW  0x09
	.DW  _0x3A+40
	.DW  _0x0*2+415

	.DW  0x03
	.DW  _0x3A+49
	.DW  _0x0*2+273

	.DW  0x03
	.DW  _0x3A+52
	.DW  _0x0*2+424

	.DW  0x0C
	.DW  _0x3A+55
	.DW  _0x0*2+427

	.DW  0x1E
	.DW  _0x3A+67
	.DW  _0x0*2+439

	.DW  0x03
	.DW  _0x3A+97
	.DW  _0x0*2+5

	.DW  0x03
	.DW  _0x3A+100
	.DW  _0x0*2+5

	.DW  0x15
	.DW  _0x44
	.DW  _0x0*2+556

	.DW  0x0C
	.DW  _0x44+21
	.DW  _0x0*2+577

	.DW  0x03
	.DW  _0x44+33
	.DW  _0x0*2+5

	.DW  0x0C
	.DW  _0x44+36
	.DW  _0x0*2+589

	.DW  0x10
	.DW  _0x44+48
	.DW  _0x0*2+601

	.DW  0x13
	.DW  _0x44+64
	.DW  _0x0*2+617

	.DW  0x0C
	.DW  _0x44+83
	.DW  _0x0*2+636

	.DW  0x03
	.DW  _0x44+95
	.DW  _0x0*2+648

	.DW  0x0C
	.DW  _0x44+98
	.DW  _0x0*2+589

	.DW  0x06
	.DW  _0x49
	.DW  _0x0*2+651

	.DW  0x16
	.DW  _0x49+6
	.DW  _0x0*2+657

	.DW  0x12
	.DW  _0x49+28
	.DW  _0x0*2+679

	.DW  0x14
	.DW  _0x49+46
	.DW  _0x0*2+697

	.DW  0x14
	.DW  _0x49+66
	.DW  _0x0*2+717

	.DW  0x0F
	.DW  _0x53
	.DW  _0x0*2+737

	.DW  0x05
	.DW  _0x53+15
	.DW  _0x0*2+752

	.DW  0x03
	.DW  _0x53+20
	.DW  _0x0*2+757

	.DW  0x03
	.DW  _0x53+23
	.DW  _0x0*2+5

	.DW  0x12
	.DW  _0x53+26
	.DW  _0x0*2+760

	.DW  0x11
	.DW  _0x53+44
	.DW  _0x0*2+778

	.DW  0x14
	.DW  _0x53+61
	.DW  _0x0*2+795

	.DW  0x0E
	.DW  _0x53+81
	.DW  _0x0*2+815

	.DW  0x13
	.DW  _0x53+95
	.DW  _0x0*2+829

	.DW  0x0E
	.DW  _0x53+114
	.DW  _0x0*2+815

	.DW  0x13
	.DW  _0x53+128
	.DW  _0x0*2+829

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;#include <mega64a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <glcd.h>
;#include <font5x7.h>
;#include <stdio.h>
;#include <string.h>   // ���� ��� �� ������
;#include <stdlib.h>   // ���� ����� ��� ����� rand() � atoi
;
;
;// =================================================================
;// ===== ������� GPRS� ���� � ��ʝ����� (��� ��� �� ������ ����) ===========
;// =================================================================
;#define APN "mtnirancell"
;#define SERVER_URL "http://192.168.1.100:8080/api/data" // ���� IP ���� ���
;//#define SERVER_PORT "8080"         // ����� ���� ���� ���
;#define DEVICE_ID 1                // ����� ���� ��ʐ�� ���
;
;
;
;// --- ����� ���� � ��� ����� ---
;#define MOTOR_DDR  DDRE
;#define MOTOR_PORT PORTE
;#define MOTOR_PIN_1  2
;#define MOTOR_PIN_2  3
;#define MOTOR_PIN_3  4
;#define MOTOR_PIN_4  5
;// =================================================================
;
;// ... (��� ������� ������ ������ �흁� � ����� get_key, send_at_command, get_full_response ���� �����) ...
;char response_buffer[256];
;char sender_number[20];
;char sms_content[100];
;char formatted_phone_number[15]; // ���� ����� ����� ������ ���� +98 �� 0
;
;
;// ����� ���� C ���� �흁�
;#define KEYPAD_PORT PORTC
;#define KEYPAD_DDR  DDRC
;#define KEYPAD_PIN  PINC
;
;// ����� ������ ���� (�����)
;#define COL1_PIN 0
;#define COL2_PIN 1
;#define COL3_PIN 2
;
;// ����� ������ ��� (�����) - �� ���� ������
;#define ROW1_PIN 7
;#define ROW2_PIN 5
;#define ROW3_PIN 6
;#define ROW4_PIN 4
;
;char pressed_key;
;
;// ���� ���� ������ ���� ����� ��� (���� �Ә� ����)
;char get_key(void)
; 0000 0038 {

	.CSEG
_get_key:
; .FSTART _get_key
; 0000 0039     unsigned char row, col;
; 0000 003A 
; 0000 003B     // ��������� ���� ������ ������ ������
; 0000 003C     const unsigned char column_pins[3] = {COL1_PIN, COL2_PIN, COL3_PIN};
; 0000 003D     const unsigned char row_pins[4] = {ROW1_PIN, ROW2_PIN, ROW3_PIN, ROW4_PIN};
; 0000 003E 
; 0000 003F     // ����� ���� ���� ���ǘ����� �흁�
; 0000 0040     const char key_map[4][3] = {
; 0000 0041         {'1', '2', '3'},
; 0000 0042         {'4', '5', '6'},
; 0000 0043         {'7', '8', '9'},
; 0000 0044         {'*', '0', '#'}
; 0000 0045     };
; 0000 0046 
; 0000 0047     // ���� ����: �Ә� ������
; 0000 0048     for (col = 0; col < 3; col++)
	SBIW R28,19
	LDI  R24,19
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x3*2)
	LDI  R31,HIGH(_0x3*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	row -> R17
;	col -> R16
;	column_pins -> Y+18
;	row_pins -> Y+14
;	key_map -> Y+2
	LDI  R16,LOW(0)
_0x5:
	CPI  R16,3
	BRSH _0x6
; 0000 0049     {
; 0000 004A         // ��� ������ �� � �흘��� (�� �� ���� ������ ���� ������)
; 0000 004B         KEYPAD_PORT |= (1 << COL1_PIN) | (1 << COL2_PIN) | (1 << COL3_PIN);
	IN   R30,0x15
	ORI  R30,LOW(0x7)
	OUT  0x15,R30
; 0000 004C 
; 0000 004D         // ���� ���� �� ��� �흘��� �� ���� ���
; 0000 004E         KEYPAD_PORT &= ~(1 << column_pins[col]);
	IN   R1,21
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,18
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R26,LOW(1)
	CALL SUBOPT_0x0
	OUT  0x15,R30
; 0000 004F 
; 0000 0050         // ����� �� ���� ����� ���� ����� ��� ����� �흘���
; 0000 0051         for (row = 0; row < 4; row++)
	LDI  R17,LOW(0)
_0x8:
	CPI  R17,4
	BRSH _0x9
; 0000 0052         {
; 0000 0053             // ǐ� � ��� ��� �� ���� ���� ���� ��� ��� ����
; 0000 0054             if (!(KEYPAD_PIN & (1 << row_pins[row])))
	CALL SUBOPT_0x1
	BRNE _0xA
; 0000 0055             {
; 0000 0056                 // ���� ��� ���� (Debouncing)
; 0000 0057                 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0058 
; 0000 0059                 // ������ �� �흘��� �� �� ����� ���� ����� ����
; 0000 005A                 if (!(KEYPAD_PIN & (1 << row_pins[row])))
	CALL SUBOPT_0x1
	BRNE _0xB
; 0000 005B                 {
; 0000 005C                     // ����� ������� �� ����� ��� ��� �� �� ��� ���� ������
; 0000 005D                     while (!(KEYPAD_PIN & (1 << row_pins[row])));
_0xC:
	CALL SUBOPT_0x1
	BREQ _0xC
; 0000 005E 
; 0000 005F                     // ���ǘ�� ������ �� ���흐������
; 0000 0060                     return key_map[row][col];
	LDI  R26,LOW(3)
	MUL  R17,R26
	MOVW R30,R0
	MOVW R26,R28
	ADIW R26,2
	ADD  R26,R30
	ADC  R27,R31
	CLR  R30
	ADD  R26,R16
	ADC  R27,R30
	LD   R30,X
	RJMP _0x2120012
; 0000 0061                 }
; 0000 0062             }
_0xB:
; 0000 0063         }
_0xA:
	SUBI R17,-1
	RJMP _0x8
_0x9:
; 0000 0064     }
	SUBI R16,-1
	RJMP _0x5
_0x6:
; 0000 0065 
; 0000 0066     // ǐ� �� ����� ����� ���� ��ϡ ����� ��� (NULL) �� �ѐ����
; 0000 0067     return 0;
	LDI  R30,LOW(0)
_0x2120012:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,21
	RET
; 0000 0068 }
; .FEND
;
;
;void send_at_command(char *command)
; 0000 006C {
_send_at_command:
; .FSTART _send_at_command
; 0000 006D     printf("%s\r\n", command);
	ST   -Y,R27
	ST   -Y,R26
;	*command -> Y+0
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x2
	CALL _printf
	ADIW R28,6
; 0000 006E }
	JMP  _0x212000C
; .FEND
;
;// ���� ���� ������ ���� ���� �� �ǎ�� �� ����� �� � ���� �����
;void get_full_response(unsigned int timeout_ms)
; 0000 0072 {
_get_full_response:
; .FSTART _get_full_response
; 0000 0073     char line_buffer[128];
; 0000 0074     unsigned long int counter = 0;
; 0000 0075     memset(response_buffer, 0, sizeof(response_buffer));
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,63
	SBIW R28,6
	CALL SUBOPT_0x3
;	timeout_ms -> Y+132
;	line_buffer -> Y+4
;	counter -> Y+0
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 0076     while(counter < timeout_ms)
_0xF:
	__GETW1SX 132
	CALL __GETD2S0
	CLR  R22
	CLR  R23
	CALL __CPD21
	BRLO PC+2
	RJMP _0x11
; 0000 0077     {
; 0000 0078         if (gets(line_buffer, sizeof(line_buffer)))
	CALL SUBOPT_0x6
	LDI  R26,LOW(128)
	LDI  R27,0
	CALL _gets
	SBIW R30,0
	BRNE PC+2
	RJMP _0x12
; 0000 0079         {
; 0000 007A             strncat(response_buffer, line_buffer, sizeof(response_buffer) - strlen(response_buffer) - 1);
	CALL SUBOPT_0x4
	MOVW R30,R28
	ADIW R30,6
	CALL SUBOPT_0x7
; 0000 007B             strncat(response_buffer, "\n", sizeof(response_buffer) - strlen(response_buffer) - 1);
	CALL SUBOPT_0x4
	__POINTW1MN _0x13,0
	CALL SUBOPT_0x7
; 0000 007C             if (strstr(line_buffer, "OK") || strstr(line_buffer, "ERROR") || strstr(line_buffer, ">") || strstr(line_buf ...
	CALL SUBOPT_0x6
	__POINTW2MN _0x13,2
	CALL _strstr
	SBIW R30,0
	BRNE _0x15
	CALL SUBOPT_0x6
	__POINTW2MN _0x13,5
	CALL _strstr
	SBIW R30,0
	BRNE _0x15
	CALL SUBOPT_0x6
	__POINTW2MN _0x13,11
	CALL _strstr
	SBIW R30,0
	BRNE _0x15
	CALL SUBOPT_0x6
	__POINTW2MN _0x13,13
	CALL _strstr
	SBIW R30,0
	BRNE _0x15
	CALL SUBOPT_0x6
	__POINTW2MN _0x13,22
	CALL _strstr
	SBIW R30,0
	BRNE _0x15
	CALL SUBOPT_0x6
	__POINTW2MN _0x13,30
	CALL _strstr
	SBIW R30,0
	BRNE _0x15
	CALL SUBOPT_0x6
	__POINTW2MN _0x13,39
	CALL _strstr
	SBIW R30,0
	BREQ _0x14
_0x15:
; 0000 007D             {
; 0000 007E                 break;
	RJMP _0x11
; 0000 007F             }
; 0000 0080         }
_0x14:
; 0000 0081         delay_ms(1);
_0x12:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0082         counter++;
	CALL __GETD1S0
	__SUBD1N -1
	CALL __PUTD1S0
; 0000 0083     }
	RJMP _0xF
_0x11:
; 0000 0084 }
	ADIW R28,63
	ADIW R28,63
	ADIW R28,8
	RET
; .FEND

	.DSEG
_0x13:
	.BYTE 0x33
;
;// =================================================================================
;// ===== ����� ��������� �ǎ�� ===================================================
;// =================================================================================
;
;// ���� ���� ��������� ����� ����� ����
;unsigned char init_sms(void)
; 0000 008C {

	.CSEG
_init_sms:
; .FSTART _init_sms
; 0000 008D     glcd_clear();
	CALL SUBOPT_0x8
; 0000 008E     glcd_outtextxy(0, 0, "Setting SMS Mode...");
	__POINTW2MN _0x17,0
	CALL _glcd_outtextxy
; 0000 008F     send_at_command("AT+CMGF=1");
	__POINTW2MN _0x17,20
	CALL SUBOPT_0x9
; 0000 0090     get_full_response(1000);
; 0000 0091     if (strstr(response_buffer, "OK") == NULL) return 0;
	__POINTW2MN _0x17,30
	CALL _strstr
	SBIW R30,0
	BRNE _0x18
	RJMP _0x2120010
; 0000 0092 
; 0000 0093     send_at_command("AT+CNMI=2,2,0,0,0");
_0x18:
	__POINTW2MN _0x17,33
	CALL SUBOPT_0x9
; 0000 0094     get_full_response(1000);
; 0000 0095     if (strstr(response_buffer, "OK") == NULL) return 0;
	__POINTW2MN _0x17,51
	CALL _strstr
	SBIW R30,0
	BRNE _0x19
	RJMP _0x2120010
; 0000 0096 
; 0000 0097     send_at_command("AT+CMGDA=\"DEL ALL\"");
_0x19:
	__POINTW2MN _0x17,54
	CALL SUBOPT_0xA
; 0000 0098     get_full_response(5000);
; 0000 0099     if (strstr(response_buffer, "OK") == NULL) return 0;
	__POINTW2MN _0x17,73
	CALL _strstr
	SBIW R30,0
	BRNE _0x1A
	RJMP _0x2120010
; 0000 009A 
; 0000 009B     glcd_outtextxy(0, 10, "SMS Ready.");
_0x1A:
	CALL SUBOPT_0xB
	__POINTW2MN _0x17,76
	RJMP _0x212000F
; 0000 009C     delay_ms(1000);
; 0000 009D     return 1;
; 0000 009E }
; .FEND

	.DSEG
_0x17:
	.BYTE 0x57
;
;// =================================================================================
;// ===== ����� ���� ���� ������ ====================================================
;// =================================================================================
;
;// ���� ���� �������� ����� ����� �� �����
;void activate_motor(int product_id)
; 0000 00A6 {

	.CSEG
_activate_motor:
; .FSTART _activate_motor
; 0000 00A7     unsigned char motor_pin;
; 0000 00A8     char motor_msg[20];
; 0000 00A9 
; 0000 00AA     switch (product_id)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,20
	ST   -Y,R17
;	product_id -> Y+21
;	motor_pin -> R17
;	motor_msg -> Y+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
; 0000 00AB     {
; 0000 00AC         case 1: motor_pin = MOTOR_PIN_1; break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1E
	LDI  R17,LOW(2)
	RJMP _0x1D
; 0000 00AD         case 2: motor_pin = MOTOR_PIN_2; break;
_0x1E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
	LDI  R17,LOW(3)
	RJMP _0x1D
; 0000 00AE         case 3: motor_pin = MOTOR_PIN_3; break;
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x21
	LDI  R17,LOW(4)
	RJMP _0x1D
; 0000 00AF         default: return;
_0x21:
	RJMP _0x2120011
; 0000 00B0     }
_0x1D:
; 0000 00B1 
; 0000 00B2     sprintf(motor_msg, "MOTOR %d ON!", product_id);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,132
	CALL SUBOPT_0xC
; 0000 00B3     glcd_clear();
	CALL SUBOPT_0xD
; 0000 00B4     glcd_outtextxy(10, 20, motor_msg);
	MOVW R26,R28
	ADIW R26,3
	CALL _glcd_outtextxy
; 0000 00B5     MOTOR_PORT |= (1 << motor_pin);
	IN   R1,3
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x3,R30
; 0000 00B6     delay_ms(10000);
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	CALL _delay_ms
; 0000 00B7     MOTOR_PORT &= ~(1 << motor_pin);
	IN   R1,3
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL SUBOPT_0x0
	OUT  0x3,R30
; 0000 00B8 
; 0000 00B9     sprintf(motor_msg, "MOTOR %d OFF!", product_id);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,145
	CALL SUBOPT_0xC
; 0000 00BA     glcd_outtextxy(10, 40, motor_msg);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL SUBOPT_0xE
; 0000 00BB     delay_ms(2000);
; 0000 00BC }
_0x2120011:
	LDD  R17,Y+0
	ADIW R28,23
	RET
; .FEND
;
;// ���� ���� ���� �� ? ����
;void start_challenge_game(int product_id)
; 0000 00C0 {
_start_challenge_game:
; .FSTART _start_challenge_game
; 0000 00C1     int random_code;
; 0000 00C2     char random_code_str[5];
; 0000 00C3     char user_input[5] = "";
; 0000 00C4     char key;
; 0000 00C5     unsigned char digit_count = 0;
; 0000 00C6     unsigned int time_left = 300; // 30 �����
; 0000 00C7 
; 0000 00C8     random_code = 1000 + (rand() % 9000);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,10
	CALL SUBOPT_0x3
	LDI  R30,LOW(0)
	STD  Y+4,R30
	CALL __SAVELOCR6
;	product_id -> Y+16
;	random_code -> R16,R17
;	random_code_str -> Y+11
;	user_input -> Y+6
;	key -> R19
;	digit_count -> R18
;	time_left -> R20,R21
	LDI  R18,0
	__GETWRN 20,21,300
	CALL _rand
	MOVW R26,R30
	LDI  R30,LOW(9000)
	LDI  R31,HIGH(9000)
	CALL __MODW21
	SUBI R30,LOW(-1000)
	SBCI R31,HIGH(-1000)
	MOVW R16,R30
; 0000 00C9     sprintf(random_code_str, "%d", random_code);
	MOVW R30,R28
	ADIW R30,11
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,159
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 00CA 
; 0000 00CB     glcd_clear();
	CALL SUBOPT_0x8
; 0000 00CC     glcd_outtextxy(0, 0, "Enter this code:");
	__POINTW2MN _0x22,0
	CALL _glcd_outtextxy
; 0000 00CD     glcd_outtextxy(30, 15, random_code_str);
	LDI  R30,LOW(30)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,13
	CALL _glcd_outtextxy
; 0000 00CE     glcd_outtextxy(0, 30, "Your input: ");
	CALL SUBOPT_0xF
	__POINTW2MN _0x22,17
	CALL _glcd_outtextxy
; 0000 00CF 
; 0000 00D0     while (digit_count < 4 && time_left > 0)
_0x23:
	CPI  R18,4
	BRSH _0x26
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BRLO _0x27
_0x26:
	RJMP _0x25
_0x27:
; 0000 00D1     {
; 0000 00D2         key = get_key();
	RCALL _get_key
	MOV  R19,R30
; 0000 00D3         if (key >= '0' && key <= '9')
	CPI  R19,48
	BRLO _0x29
	CPI  R19,58
	BRLO _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 00D4         {
; 0000 00D5             user_input[digit_count++] = key;
	MOV  R30,R18
	SUBI R18,-1
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R19
; 0000 00D6             user_input[digit_count] = '\0';
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00D7             glcd_outtextxy(70, 30, user_input);
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	CALL _glcd_outtextxy
; 0000 00D8         }
; 0000 00D9 
; 0000 00DA         { char time_str[10]; sprintf(time_str, "Time: %d ", time_left / 10); glcd_outtextxy(0, 50, time_str); }
_0x28:
	SBIW R28,10
;	product_id -> Y+26
;	random_code_str -> Y+21
;	user_input -> Y+16
;	time_str -> Y+0
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,192
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R20
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	CALL SUBOPT_0x2
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(50)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _glcd_outtextxy
	ADIW R28,10
; 0000 00DB 
; 0000 00DC         delay_ms(100);
	CALL SUBOPT_0x10
; 0000 00DD         time_left--;
	__SUBWRN 20,21,1
; 0000 00DE     }
	RJMP _0x23
_0x25:
; 0000 00DF 
; 0000 00E0     if (time_left == 0) { glcd_clear(); glcd_outtextxy(10, 20, "Time is up!"); delay_ms(2000); }
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x2B
	CALL SUBOPT_0xD
	__POINTW2MN _0x22,30
	RJMP _0x65
; 0000 00E1     else if (strcmp(user_input, random_code_str) == 0)
_0x2B:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,13
	CALL _strcmp
	CPI  R30,0
	BRNE _0x2D
; 0000 00E2     {
; 0000 00E3         glcd_clear(); glcd_outtextxy(10, 20, "Code Correct!"); delay_ms(2000);
	CALL SUBOPT_0xD
	__POINTW2MN _0x22,42
	CALL SUBOPT_0xE
; 0000 00E4         activate_motor(product_id);
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RCALL _activate_motor
; 0000 00E5     }
; 0000 00E6     else { glcd_clear(); glcd_outtextxy(10, 20, "Wrong Code!"); delay_ms(2000); }
	RJMP _0x2E
_0x2D:
	CALL SUBOPT_0xD
	__POINTW2MN _0x22,56
_0x65:
	CALL _glcd_outtextxy
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
_0x2E:
; 0000 00E7 }
	CALL __LOADLOCR6
	ADIW R28,18
	RET
; .FEND

	.DSEG
_0x22:
	.BYTE 0x44
;
;// ���� ���� �ǘ����� ����� ������
;void format_phone_number(char* raw_number)
; 0000 00EB {

	.CSEG
_format_phone_number:
; .FSTART _format_phone_number
; 0000 00EC     if (strncmp(raw_number, "+98", 3) == 0) strcpy(formatted_phone_number, raw_number + 3);
	ST   -Y,R27
	ST   -Y,R26
;	*raw_number -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x30,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _strncmp
	CPI  R30,0
	BRNE _0x2F
	CALL SUBOPT_0x11
	ADIW R26,3
	RJMP _0x66
; 0000 00ED     else if (raw_number[0] == '0') strcpy(formatted_phone_number, raw_number + 1);
_0x2F:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R26,X
	CPI  R26,LOW(0x30)
	BRNE _0x32
	CALL SUBOPT_0x11
	ADIW R26,1
	RJMP _0x66
; 0000 00EE     else strcpy(formatted_phone_number, raw_number);
_0x32:
	CALL SUBOPT_0x11
_0x66:
	CALL _strcpy
; 0000 00EF }
	JMP  _0x212000C
; .FEND

	.DSEG
_0x30:
	.BYTE 0x4
;
;
;// ���� ���� ���� ����� � ����� ���� ��Ϙ�� �� GPRS
;unsigned char check_and_reopen_bearer(void)
; 0000 00F4 {

	.CSEG
_check_and_reopen_bearer:
; .FSTART _check_and_reopen_bearer
; 0000 00F5     glcd_clear();
	CALL SUBOPT_0x8
; 0000 00F6     glcd_outtextxy(0,0,"Checking Bearer...");
	__POINTW2MN _0x34,0
	CALL _glcd_outtextxy
; 0000 00F7 
; 0000 00F8     send_at_command("AT+SAPBR=2,1"); // ������� ����� ����
	__POINTW2MN _0x34,19
	RCALL _send_at_command
; 0000 00F9     get_full_response(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL SUBOPT_0x12
; 0000 00FA 
; 0000 00FB     // ǐ� �� ���Ρ �흁� 0.0.0.0 ���� ���� ���� ����� ��� ���
; 0000 00FC     if(strstr(response_buffer, "0.0.0.0") || strstr(response_buffer, "ERROR"))
	__POINTW2MN _0x34,32
	CALL _strstr
	SBIW R30,0
	BRNE _0x36
	CALL SUBOPT_0x4
	__POINTW2MN _0x34,40
	CALL _strstr
	SBIW R30,0
	BREQ _0x35
_0x36:
; 0000 00FD     {
; 0000 00FE         glcd_outtextxy(0,10,"Bearer is down.");
	CALL SUBOPT_0xB
	__POINTW2MN _0x34,46
	CALL _glcd_outtextxy
; 0000 00FF         glcd_outtextxy(0,20,"Re-opening...");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x34,62
	CALL SUBOPT_0x13
; 0000 0100         delay_ms(1000);
; 0000 0101 
; 0000 0102         send_at_command("AT+SAPBR=1,1"); // ���� ���� ���� �����
	__POINTW2MN _0x34,76
	RCALL _send_at_command
; 0000 0103         get_full_response(15000); // ���� ����� ���� ���� ����
	LDI  R26,LOW(15000)
	LDI  R27,HIGH(15000)
	CALL SUBOPT_0x12
; 0000 0104 
; 0000 0105         if(strstr(response_buffer, "OK"))
	__POINTW2MN _0x34,89
	CALL _strstr
	SBIW R30,0
	BREQ _0x38
; 0000 0106         {
; 0000 0107             glcd_outtextxy(0,30,"Re-opened OK.");
	CALL SUBOPT_0xF
	__POINTW2MN _0x34,92
	RJMP _0x212000F
; 0000 0108             delay_ms(1000);
; 0000 0109             return 1; // ������ ����
; 0000 010A         }
; 0000 010B         else
_0x38:
; 0000 010C         {
; 0000 010D             glcd_outtextxy(0,30,"Re-open Failed!");
	CALL SUBOPT_0xF
	__POINTW2MN _0x34,106
	CALL SUBOPT_0x13
; 0000 010E             delay_ms(1000);
; 0000 010F             return 0; // ������
_0x2120010:
	LDI  R30,LOW(0)
	RET
; 0000 0110         }
; 0000 0111     }
; 0000 0112 
; 0000 0113     glcd_outtextxy(0,10,"Bearer is Active.");
_0x35:
	CALL SUBOPT_0xB
	__POINTW2MN _0x34,122
_0x212000F:
	CALL _glcd_outtextxy
; 0000 0114     delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 0115     return 1; // ����� �� ��� ������ ���
	LDI  R30,LOW(1)
	RET
; 0000 0116 }
; .FEND

	.DSEG
_0x34:
	.BYTE 0x8C
;
;
;// ��������� ����� ���� HTTP
;unsigned char init_http_bearer(void)
; 0000 011B {

	.CSEG
_init_http_bearer:
; .FSTART _init_http_bearer
; 0000 011C     char command[100];
; 0000 011D     glcd_clear();
	SBIW R28,63
	SBIW R28,37
;	command -> Y+0
	CALL SUBOPT_0x8
; 0000 011E     glcd_outtextxy(0, 0, "Init HTTP Bearer...");
	__POINTW2MN _0x3A,0
	CALL SUBOPT_0x14
; 0000 011F 
; 0000 0120     // �� ���� ��� ��� �� �Ș� ������
; 0000 0121     glcd_outtextxy(0, 10, "Checking network...");
	__POINTW2MN _0x3A,20
	CALL _glcd_outtextxy
; 0000 0122     while(1)
_0x3B:
; 0000 0123     {
; 0000 0124         send_at_command("AT+CREG?");
	__POINTW2MN _0x3A,40
	CALL SUBOPT_0x15
; 0000 0125         get_full_response(2000);
; 0000 0126         // ����� ���� "+CREG: 0,1" �� "+CREG: 0,5" �������
; 0000 0127         if(strstr(response_buffer, ",1") || strstr(response_buffer, ",5"))
	__POINTW2MN _0x3A,49
	CALL _strstr
	SBIW R30,0
	BRNE _0x3F
	CALL SUBOPT_0x4
	__POINTW2MN _0x3A,52
	CALL _strstr
	SBIW R30,0
	BREQ _0x3E
_0x3F:
; 0000 0128         {
; 0000 0129             glcd_outtextxy(0, 20, "Registered!");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	__POINTW2MN _0x3A,55
	CALL SUBOPT_0x13
; 0000 012A             delay_ms(1000);
; 0000 012B             break;
	RJMP _0x3D
; 0000 012C         }
; 0000 012D         delay_ms(2000); // �� 2 ����� �� ��
_0x3E:
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 012E     }
	RJMP _0x3B
_0x3D:
; 0000 012F 
; 0000 0130     send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
	__POINTW2MN _0x3A,67
	CALL SUBOPT_0x15
; 0000 0131     get_full_response(2000);
; 0000 0132     if (strstr(response_buffer, "OK") == NULL) return 0;
	__POINTW2MN _0x3A,97
	CALL _strstr
	SBIW R30,0
	BRNE _0x41
	LDI  R30,LOW(0)
	RJMP _0x212000E
; 0000 0133 
; 0000 0134     sprintf(command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
_0x41:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,469
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,493
	CALL SUBOPT_0x2
	CALL _sprintf
	ADIW R28,8
; 0000 0135     send_at_command(command);
	MOVW R26,R28
	CALL SUBOPT_0x15
; 0000 0136     get_full_response(2000);
; 0000 0137     if (strstr(response_buffer, "OK") == NULL) return 0;
	__POINTW2MN _0x3A,100
	CALL _strstr
	SBIW R30,0
	BRNE _0x42
	LDI  R30,LOW(0)
	RJMP _0x212000E
; 0000 0138 
; 0000 0139     return check_and_reopen_bearer(); // ���� ����� ����� �� �� ���� �������㝐� ������� �흘���
_0x42:
	RCALL _check_and_reopen_bearer
_0x212000E:
	ADIW R28,63
	ADIW R28,37
	RET
; 0000 013A }
; .FEND

	.DSEG
_0x3A:
	.BYTE 0x67
;
;// ����� ������� HTTP POST (�� ����� ����� ��� �� �����)
;unsigned char send_http_post_request(char* phone, int product_id)
; 0000 013E {

	.CSEG
_send_http_post_request:
; .FSTART _send_http_post_request
; 0000 013F     char command[200], json_payload[128];
; 0000 0140     int json_len;
; 0000 0141     unsigned char success = 0;
; 0000 0142 
; 0000 0143     // ����� 1: ��� �� �� ���� ����� �� �� ��
; 0000 0144     if (!check_and_reopen_bearer())
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,9
	SUBI R29,1
	CALL __SAVELOCR4
;	*phone -> Y+334
;	product_id -> Y+332
;	command -> Y+132
;	json_payload -> Y+4
;	json_len -> R16,R17
;	success -> R19
	LDI  R19,0
	RCALL _check_and_reopen_bearer
	CPI  R30,0
	BRNE _0x43
; 0000 0145     {
; 0000 0146         return 0; // ǐ� ����� ������ ��ϡ ���� ��
	LDI  R30,LOW(0)
	RJMP _0x212000D
; 0000 0147     }
; 0000 0148 
; 0000 0149     sprintf(json_payload, "{\"phone_number\":%s,\"device_id\":%d,\"product_id\":%d}", phone, DEVICE_ID, product_id);
_0x43:
	CALL SUBOPT_0x6
	__POINTW1FN _0x0,505
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 338
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x1
	CALL __PUTPARD1
	__GETW1SX 344
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 014A     json_len = strlen(json_payload);
	MOVW R26,R28
	ADIW R26,4
	CALL _strlen
	MOVW R16,R30
; 0000 014B 
; 0000 014C     glcd_clear();
	CALL SUBOPT_0x8
; 0000 014D     glcd_outtextxy(0, 0, "HTTP POST Request...");
	__POINTW2MN _0x44,0
	CALL _glcd_outtextxy
; 0000 014E 
; 0000 014F     send_at_command("AT+HTTPINIT");
	__POINTW2MN _0x44,21
	CALL SUBOPT_0x15
; 0000 0150     get_full_response(2000);
; 0000 0151     if (strstr(response_buffer, "OK") == NULL) { send_at_command("AT+HTTPTERM"); return 0; }
	__POINTW2MN _0x44,33
	CALL _strstr
	SBIW R30,0
	BRNE _0x45
	__POINTW2MN _0x44,36
	RCALL _send_at_command
	LDI  R30,LOW(0)
	RJMP _0x212000D
; 0000 0152 
; 0000 0153     // ... (���� ����� ����� HTTP ����� ���) ...
; 0000 0154 
; 0000 0155     send_at_command("AT+HTTPACTION=1");
_0x45:
	__POINTW2MN _0x44,48
	RCALL _send_at_command
; 0000 0156     get_full_response(20000); // ������ ���� ������ ���� ���� ����
	LDI  R26,LOW(20000)
	LDI  R27,HIGH(20000)
	CALL SUBOPT_0x12
; 0000 0157 
; 0000 0158     if (strstr(response_buffer, "+HTTPACTION: 1,200"))
	__POINTW2MN _0x44,64
	CALL _strstr
	SBIW R30,0
	BREQ _0x46
; 0000 0159     {
; 0000 015A         send_at_command("AT+HTTPREAD");
	__POINTW2MN _0x44,83
	CALL SUBOPT_0xA
; 0000 015B         get_full_response(5000);
; 0000 015C         if(strstr(response_buffer, "ok")) { success = 1; }
	__POINTW2MN _0x44,95
	CALL _strstr
	SBIW R30,0
	BREQ _0x47
	LDI  R19,LOW(1)
; 0000 015D     }
_0x47:
; 0000 015E 
; 0000 015F     send_at_command("AT+HTTPTERM");
_0x46:
	__POINTW2MN _0x44,98
	CALL SUBOPT_0x16
; 0000 0160     get_full_response(1000);
; 0000 0161     return success;
	MOV  R30,R19
_0x212000D:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,17
	SUBI R29,-1
	RET
; 0000 0162 }
; .FEND

	.DSEG
_0x44:
	.BYTE 0x6E
;
;// ������ ����
;void process_sms(void)
; 0000 0166 {

	.CSEG
_process_sms:
; .FSTART _process_sms
; 0000 0167     char* token;
; 0000 0168     int product_id;
; 0000 0169     char sms_header_copy[100];
; 0000 016A 
; 0000 016B     // ��� ǐ� ���� ���� ��� ������ ��
; 0000 016C     if (strstr(response_buffer, "+CMT:"))
	SBIW R28,63
	SBIW R28,37
	CALL __SAVELOCR4
;	*token -> R16,R17
;	product_id -> R18,R19
;	sms_header_copy -> Y+4
	CALL SUBOPT_0x4
	__POINTW2MN _0x49,0
	CALL _strstr
	SBIW R30,0
	BRNE PC+2
	RJMP _0x48
; 0000 016D     {
; 0000 016E         // � ��� �� ��� ���� ���� �흘��� �� gets ���� �� �� �� ��� ����
; 0000 016F         strcpy(sms_header_copy, response_buffer);
	CALL SUBOPT_0x6
	LDI  R26,LOW(_response_buffer)
	LDI  R27,HIGH(_response_buffer)
	CALL _strcpy
; 0000 0170 
; 0000 0171         // ������ ���� �� �� �� ���� �����
; 0000 0172         memset(response_buffer, 0, sizeof(response_buffer));
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 0173         gets(response_buffer, sizeof(response_buffer));
	CALL SUBOPT_0x4
	LDI  R26,LOW(256)
	LDI  R27,HIGH(256)
	CALL _gets
; 0000 0174 
; 0000 0175         glcd_clear();
	CALL SUBOPT_0x8
; 0000 0176         glcd_outtextxy(0, 0, "New SMS Processing...");
	__POINTW2MN _0x49,6
	CALL _glcd_outtextxy
; 0000 0177 
; 0000 0178         // ���� ����� �� �� ��� ��� ������� ��
; 0000 0179         token = strtok(sms_header_copy, "\"");
	CALL SUBOPT_0x6
	__POINTW2FN _0x0,119
	CALL _strtok
	MOVW R16,R30
; 0000 017A         token = strtok(NULL, "\"");
	CALL SUBOPT_0x17
	__POINTW2FN _0x0,119
	CALL _strtok
	MOVW R16,R30
; 0000 017B         if (token) { strcpy(sender_number, token); }
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x4A
	LDI  R30,LOW(_sender_number)
	LDI  R31,HIGH(_sender_number)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R16
	CALL _strcpy
; 0000 017C 
; 0000 017D         // ����� �� ������ ��
; 0000 017E         if (strlen(response_buffer) > 0)
_0x4A:
	CALL SUBOPT_0x18
	BRSH _0x4B
; 0000 017F         {
; 0000 0180             char* p = strchr(response_buffer, '\r'); if(p) *p = '\0';
	SBIW R28,2
;	sms_header_copy -> Y+6
;	*p -> Y+0
	CALL SUBOPT_0x4
	LDI  R26,LOW(13)
	CALL _strchr
	ST   Y,R30
	STD  Y+1,R31
	SBIW R30,0
	BREQ _0x4C
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 0181             product_id = atoi(response_buffer);
_0x4C:
	LDI  R26,LOW(_response_buffer)
	LDI  R27,HIGH(_response_buffer)
	CALL _atoi
	MOVW R18,R30
; 0000 0182 
; 0000 0183             if (product_id >= 1 && product_id <= 3)
	__CPWRN 18,19,1
	BRLT _0x4E
	__CPWRN 18,19,4
	BRLT _0x4F
_0x4E:
	RJMP _0x4D
_0x4F:
; 0000 0184             {
; 0000 0185                 format_phone_number(sender_number);
	LDI  R26,LOW(_sender_number)
	LDI  R27,HIGH(_sender_number)
	RCALL _format_phone_number
; 0000 0186                 if (send_http_post_request(formatted_phone_number, product_id))
	LDI  R30,LOW(_formatted_phone_number)
	LDI  R31,HIGH(_formatted_phone_number)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R18
	RCALL _send_http_post_request
	CPI  R30,0
	BREQ _0x50
; 0000 0187                 {
; 0000 0188                     start_challenge_game(product_id);
	MOVW R26,R18
	RCALL _start_challenge_game
; 0000 0189                 }
; 0000 018A                 else { glcd_clear(); glcd_outtextxy(0, 10, "Server Tx Failed!"); delay_ms(2000); }
	RJMP _0x51
_0x50:
	RCALL _glcd_clear
	CALL SUBOPT_0xB
	__POINTW2MN _0x49,28
	CALL SUBOPT_0xE
_0x51:
; 0000 018B             }
; 0000 018C             else { glcd_clear(); glcd_outtextxy(0, 10, "Invalid Product ID!"); delay_ms(2000); }
	RJMP _0x52
_0x4D:
	RCALL _glcd_clear
	CALL SUBOPT_0xB
	__POINTW2MN _0x49,46
	CALL SUBOPT_0xE
_0x52:
; 0000 018D         }
	ADIW R28,2
; 0000 018E 
; 0000 018F         // ���� �� �� �� ��� ���� ������ �ϡ �� �� �ǘ ��
; 0000 0190         send_at_command("AT+CMGDA=\"DEL READ\"");
_0x4B:
	__POINTW2MN _0x49,66
	RCALL _send_at_command
; 0000 0191         get_full_response(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RCALL _get_full_response
; 0000 0192     }
; 0000 0193 }
_0x48:
	CALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,41
	RET
; .FEND

	.DSEG
_0x49:
	.BYTE 0x56
;
;// =================================================================================
;// ===== ���� ���� ������ (main) ===================================================
;// =============================================================================
;
;
;
;void main(void)
; 0000 019C {

	.CSEG
_main:
; .FSTART _main
; 0000 019D 
; 0000 019E     // Declare your local variables here
; 0000 019F     // Variable used to store graphic display
; 0000 01A0     // controller initialization data
; 0000 01A1     GLCDINIT_t glcd_init_data;
; 0000 01A2 
; 0000 01A3     // Input/Output Ports initialization
; 0000 01A4     // Port A initialization
; 0000 01A5     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01A6     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 01A7     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01A8     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 01A9 
; 0000 01AA     // Port B initialization
; 0000 01AB     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01AC     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 01AD     // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01AE     PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 01AF 
; 0000 01B0     // Port C initialization
; 0000 01B1     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 01B2     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 01B3     // State: Bit7=P Bit6=P Bit5=P Bit4=P Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 01B4     PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 01B5 
; 0000 01B6     // Port D initialization
; 0000 01B7     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01B8     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 01B9     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01BA     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	OUT  0x12,R30
; 0000 01BB 
; 0000 01BC     // Port E initialization
; 0000 01BD     // Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 01BE     DDRE=(0<<DDE7) | (0<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (0<<DDE1) | (0<<DDE0);
	LDI  R30,LOW(60)
	OUT  0x2,R30
; 0000 01BF     // State: Bit7=T Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 01C0     PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 01C1 
; 0000 01C2     // Port F initialization
; 0000 01C3     // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01C4     DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 01C5     // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01C6     PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 01C7 
; 0000 01C8     // Port G initialization
; 0000 01C9     // Function: Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 01CA     DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 01CB     // State: Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 01CC     PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 01CD 
; 0000 01CE     // Timer/Counter 0 initialization
; 0000 01CF     // Clock source: System Clock
; 0000 01D0     // Clock value: Timer 0 Stopped
; 0000 01D1     // Mode: Normal top=0xFF
; 0000 01D2     // OC0 output: Disconnected
; 0000 01D3     ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 01D4     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 01D5     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 01D6     OCR0=0x00;
	OUT  0x31,R30
; 0000 01D7 
; 0000 01D8     // Timer/Counter 1 initialization
; 0000 01D9     // Clock source: System Clock
; 0000 01DA     // Clock value: Timer1 Stopped
; 0000 01DB     // Mode: Normal top=0xFFFF
; 0000 01DC     // OC1A output: Disconnected
; 0000 01DD     // OC1B output: Disconnected
; 0000 01DE     // OC1C output: Disconnected
; 0000 01DF     // Noise Canceler: Off
; 0000 01E0     // Input Capture on Falling Edge
; 0000 01E1     // Timer1 Overflow Interrupt: Off
; 0000 01E2     // Input Capture Interrupt: Off
; 0000 01E3     // Compare A Match Interrupt: Off
; 0000 01E4     // Compare B Match Interrupt: Off
; 0000 01E5     // Compare C Match Interrupt: Off
; 0000 01E6     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 01E7     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 01E8     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 01E9     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 01EA     ICR1H=0x00;
	OUT  0x27,R30
; 0000 01EB     ICR1L=0x00;
	OUT  0x26,R30
; 0000 01EC     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 01ED     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 01EE     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 01EF     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 01F0     OCR1CH=0x00;
	STS  121,R30
; 0000 01F1     OCR1CL=0x00;
	STS  120,R30
; 0000 01F2 
; 0000 01F3     // Timer/Counter 2 initialization
; 0000 01F4     // Clock source: System Clock
; 0000 01F5     // Clock value: Timer2 Stopped
; 0000 01F6     // Mode: Normal top=0xFF
; 0000 01F7     // OC2 output: Disconnected
; 0000 01F8     TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 01F9     TCNT2=0x00;
	OUT  0x24,R30
; 0000 01FA     OCR2=0x00;
	OUT  0x23,R30
; 0000 01FB 
; 0000 01FC     // Timer/Counter 3 initialization
; 0000 01FD     // Clock source: System Clock
; 0000 01FE     // Clock value: Timer3 Stopped
; 0000 01FF     // Mode: Normal top=0xFFFF
; 0000 0200     // OC3A output: Disconnected
; 0000 0201     // OC3B output: Disconnected
; 0000 0202     // OC3C output: Disconnected
; 0000 0203     // Noise Canceler: Off
; 0000 0204     // Input Capture on Falling Edge
; 0000 0205     // Timer3 Overflow Interrupt: Off
; 0000 0206     // Input Capture Interrupt: Off
; 0000 0207     // Compare A Match Interrupt: Off
; 0000 0208     // Compare B Match Interrupt: Off
; 0000 0209     // Compare C Match Interrupt: Off
; 0000 020A     TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 020B     TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 020C     TCNT3H=0x00;
	STS  137,R30
; 0000 020D     TCNT3L=0x00;
	STS  136,R30
; 0000 020E     ICR3H=0x00;
	STS  129,R30
; 0000 020F     ICR3L=0x00;
	STS  128,R30
; 0000 0210     OCR3AH=0x00;
	STS  135,R30
; 0000 0211     OCR3AL=0x00;
	STS  134,R30
; 0000 0212     OCR3BH=0x00;
	STS  133,R30
; 0000 0213     OCR3BL=0x00;
	STS  132,R30
; 0000 0214     OCR3CH=0x00;
	STS  131,R30
; 0000 0215     OCR3CL=0x00;
	STS  130,R30
; 0000 0216 
; 0000 0217     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0218     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
	OUT  0x37,R30
; 0000 0219     ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	STS  125,R30
; 0000 021A 
; 0000 021B     // External Interrupt(s) initialization
; 0000 021C     // INT0: Off
; 0000 021D     // INT1: Off
; 0000 021E     // INT2: Off
; 0000 021F     // INT3: Off
; 0000 0220     // INT4: Off
; 0000 0221     // INT5: Off
; 0000 0222     // INT6: Off
; 0000 0223     // INT7: Off
; 0000 0224     EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 0225     EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 0226     EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 0227 
; 0000 0228     // USART0 initialization
; 0000 0229     // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 022A     // USART0 Receiver: On
; 0000 022B     // USART0 Transmitter: On
; 0000 022C     // USART0 Mode: Asynchronous
; 0000 022D     // USART0 Baud Rate: 9600
; 0000 022E     UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 022F     UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0230     UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0231     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0232     UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0233 
; 0000 0234     // USART1 initialization
; 0000 0235     // USART1 disabled
; 0000 0236     UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 0237 
; 0000 0238     // Analog Comparator initialization
; 0000 0239     // Analog Comparator: Off
; 0000 023A     // The Analog Comparator's positive input is
; 0000 023B     // connected to the AIN0 pin
; 0000 023C     // The Analog Comparator's negative input is
; 0000 023D     // connected to the AIN1 pin
; 0000 023E     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 023F     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0240 
; 0000 0241     // ADC initialization
; 0000 0242     // ADC disabled
; 0000 0243     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 0244 
; 0000 0245     // SPI initialization
; 0000 0246     // SPI disabled
; 0000 0247     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 0248 
; 0000 0249     // TWI initialization
; 0000 024A     // TWI disabled
; 0000 024B     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 024C     // ----- ������� ���� JTAG (���� ������� �� ���ʝ��� C � F �� ���� ����) -----
; 0000 024D     MCUCSR = (1 << JTD);
	LDI  R30,LOW(128)
	OUT  0x34,R30
; 0000 024E     MCUCSR = (1 << JTD);
	OUT  0x34,R30
; 0000 024F     // Graphic Display Controller initialization
; 0000 0250     // The KS0108 connections are specified in the
; 0000 0251     // Project|Configure|C Compiler|Libraries|Graphic Display menu:
; 0000 0252     // DB0 - PORTA Bit 0
; 0000 0253     // DB1 - PORTA Bit 1
; 0000 0254     // DB2 - PORTA Bit 2
; 0000 0255     // DB3 - PORTA Bit 3
; 0000 0256     // DB4 - PORTA Bit 4
; 0000 0257     // DB5 - PORTA Bit 5
; 0000 0258     // DB6 - PORTA Bit 6
; 0000 0259     // DB7 - PORTA Bit 7
; 0000 025A     // E - PORTF Bit 4
; 0000 025B     // RD /WR - PORTF Bit 3
; 0000 025C     // RS - PORTF Bit 2
; 0000 025D     // /RST - PORTF Bit 7
; 0000 025E     // CS1 - PORTF Bit 5
; 0000 025F     // CS2 - PORTF Bit 6
; 0000 0260 
; 0000 0261     // �������� ����� ����� ����� ����� ������
; 0000 0262     // ���� ������ ���� ����ѡ ������ �� ����� � ����� ���� ������� ���
; 0000 0263     // srand(TCNT0);
; 0000 0264     srand(TCNT0); // � ��� ��������� ��� ��� ��� �� ��� ���������� embedded ��� ���
	IN   R30,0x32
	LDI  R31,0
	MOVW R26,R30
	CALL _srand
; 0000 0265                        // ������� �� rand() �� ������ �� ���� ���� ���� ���.
; 0000 0266 
; 0000 0267     // Specify the current font for displaying text
; 0000 0268     glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0269     // No function is used for reading
; 0000 026A     // image data from external memory
; 0000 026B     glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 026C     // No function is used for writing
; 0000 026D     // image data to external memory
; 0000 026E     glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 026F 
; 0000 0270     glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 0271 
; 0000 0272 
; 0000 0273     glcd_setfont(font5x7);
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	CALL SUBOPT_0x19
; 0000 0274 
; 0000 0275     // ----- ��������� �ǎ�� SIM800 -----
; 0000 0276     glcd_clear();
	CALL SUBOPT_0x8
; 0000 0277     glcd_outtextxy(0, 0, "Module Init...");
	__POINTW2MN _0x53,0
	CALL _glcd_outtextxy
; 0000 0278     delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 0279 
; 0000 027A     send_at_command("ATE0"); get_full_response(1000);
	__POINTW2MN _0x53,15
	CALL SUBOPT_0x16
; 0000 027B     send_at_command("AT"); get_full_response(1000);
	__POINTW2MN _0x53,20
	CALL SUBOPT_0x9
; 0000 027C     if(strstr(response_buffer, "OK") == NULL) { glcd_outtextxy(0, 10, "Module Not Found!"); while(1); }
	__POINTW2MN _0x53,23
	CALL _strstr
	SBIW R30,0
	BRNE _0x54
	CALL SUBOPT_0xB
	__POINTW2MN _0x53,26
	CALL _glcd_outtextxy
_0x55:
	RJMP _0x55
; 0000 027D 
; 0000 027E     // ----- ��������� ����ӝ��� ���� � HTTP -----
; 0000 027F     if (!init_sms()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
_0x54:
	RCALL _init_sms
	CPI  R30,0
	BRNE _0x58
	CALL SUBOPT_0xB
	__POINTW2MN _0x53,44
	CALL _glcd_outtextxy
_0x59:
	RJMP _0x59
; 0000 0280     if (!init_http_bearer()) { glcd_outtextxy(0, 10, "HTTP Bearer Failed!"); while(1); }
_0x58:
	RCALL _init_http_bearer
	CPI  R30,0
	BRNE _0x5C
	CALL SUBOPT_0xB
	__POINTW2MN _0x53,61
	CALL _glcd_outtextxy
_0x5D:
	RJMP _0x5D
; 0000 0281 
; 0000 0282     glcd_clear();
_0x5C:
	CALL SUBOPT_0x8
; 0000 0283     glcd_outtextxy(0, 0, "System Ready.");
	__POINTW2MN _0x53,81
	CALL SUBOPT_0x14
; 0000 0284     glcd_outtextxy(0, 10, "Waiting for SMS...");
	__POINTW2MN _0x53,95
	CALL _glcd_outtextxy
; 0000 0285 
; 0000 0286     // ----- ���� ���� ������ -----
; 0000 0287     while (1)
_0x60:
; 0000 0288     {
; 0000 0289         memset(response_buffer, 0, sizeof(response_buffer));
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 028A         // ����� ��� ����� �� ��� (���) ���� �������
; 0000 028B         gets(response_buffer, sizeof(response_buffer));
	CALL SUBOPT_0x4
	LDI  R26,LOW(256)
	LDI  R27,HIGH(256)
	CALL _gets
; 0000 028C 
; 0000 028D         if (strlen(response_buffer) > 0)
	CALL SUBOPT_0x18
	BRSH _0x63
; 0000 028E         {
; 0000 028F             process_sms(); // ���� ������ ��� ����� �� ����� �����
	RCALL _process_sms
; 0000 0290             glcd_clear();
	CALL SUBOPT_0x8
; 0000 0291             glcd_outtextxy(0, 0, "System Ready.");
	__POINTW2MN _0x53,114
	CALL SUBOPT_0x14
; 0000 0292             glcd_outtextxy(0, 10, "Waiting for SMS...");
	__POINTW2MN _0x53,128
	CALL _glcd_outtextxy
; 0000 0293         }
; 0000 0294 
; 0000 0295         delay_ms(100);
_0x63:
	CALL SUBOPT_0x10
; 0000 0296     }
	RJMP _0x60
; 0000 0297 }
_0x64:
	RJMP _0x64
; .FEND

	.DSEG
_0x53:
	.BYTE 0x93
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_ks0108_enable_G100:
; .FSTART _ks0108_enable_G100
	nop
	LDS  R30,98
	ORI  R30,0x10
	STS  98,R30
	nop
	RET
; .FEND
_ks0108_disable_G100:
; .FSTART _ks0108_disable_G100
	LDS  R30,98
	ANDI R30,0xEF
	CALL SUBOPT_0x1A
	ANDI R30,0xDF
	CALL SUBOPT_0x1A
	ANDI R30,0xBF
	STS  98,R30
	RET
; .FEND
_ks0108_rdbus_G100:
; .FSTART _ks0108_rdbus_G100
	ST   -Y,R17
	RCALL _ks0108_enable_G100
	IN   R17,25
	LDS  R30,98
	ANDI R30,0xEF
	STS  98,R30
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G100:
; .FSTART _ks0108_busy_G100
	ST   -Y,R26
	ST   -Y,R17
	CALL SUBOPT_0x1B
	ANDI R30,0xFB
	STS  98,R30
	LDD  R30,Y+1
	SUBI R30,-LOW(1)
	MOV  R17,R30
	SBRS R17,0
	RJMP _0x2000003
	LDS  R30,98
	ORI  R30,0x20
	RJMP _0x20000AC
_0x2000003:
	LDS  R30,98
	ANDI R30,0xDF
_0x20000AC:
	STS  98,R30
	SBRS R17,1
	RJMP _0x2000005
	LDS  R30,98
	ORI  R30,0x40
	RJMP _0x20000AD
_0x2000005:
	LDS  R30,98
	ANDI R30,0xBF
_0x20000AD:
	STS  98,R30
_0x2000007:
	RCALL _ks0108_rdbus_G100
	ANDI R30,LOW(0x80)
	BRNE _0x2000007
	LDD  R17,Y+0
	RJMP _0x212000C
; .FEND
_ks0108_wrcmd_G100:
; .FSTART _ks0108_wrcmd_G100
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G100
	LDS  R30,98
	CALL SUBOPT_0x1C
	RJMP _0x212000C
; .FEND
_ks0108_setloc_G100:
; .FSTART _ks0108_setloc_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	ORI  R30,0x40
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	__GETB1MN _ks0108_coord_G100,1
	ST   -Y,R30
	__GETB1MN _ks0108_coord_G100,2
	ORI  R30,LOW(0xB8)
	MOV  R26,R30
	RCALL _ks0108_wrcmd_G100
	RET
; .FEND
_ks0108_gotoxp_G100:
; .FSTART _ks0108_gotoxp_G100
	ST   -Y,R26
	LDD  R30,Y+1
	STS  _ks0108_coord_G100,R30
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	LSR  R30
	__PUTB1MN _ks0108_coord_G100,1
	LD   R30,Y
	__PUTB1MN _ks0108_coord_G100,2
	RCALL _ks0108_setloc_G100
	RJMP _0x212000C
; .FEND
_ks0108_nextx_G100:
; .FSTART _ks0108_nextx_G100
	LDS  R26,_ks0108_coord_G100
	SUBI R26,-LOW(1)
	STS  _ks0108_coord_G100,R26
	CPI  R26,LOW(0x80)
	BRLO _0x200000A
	LDI  R30,LOW(0)
	STS  _ks0108_coord_G100,R30
_0x200000A:
	LDS  R30,_ks0108_coord_G100
	ANDI R30,LOW(0x3F)
	BRNE _0x200000B
	LDS  R30,_ks0108_coord_G100
	ST   -Y,R30
	__GETB2MN _ks0108_coord_G100,2
	RCALL _ks0108_gotoxp_G100
_0x200000B:
	RET
; .FEND
_ks0108_wrdata_G100:
; .FSTART _ks0108_wrdata_G100
	ST   -Y,R26
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	LDS  R30,98
	ORI  R30,4
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1C
	JMP  _0x2120008
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0x1B
	ORI  R30,4
	STS  98,R30
	RCALL _ks0108_rdbus_G100
	RET
; .FEND
_ks0108_rdbyte_G100:
; .FSTART _ks0108_rdbyte_G100
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	CALL SUBOPT_0x1D
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	RCALL _ks0108_rddata_G100
_0x212000C:
	ADIW R28,2
	RET
; .FEND
_glcd_init:
; .FSTART _glcd_init
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDS  R30,97
	ORI  R30,0x10
	CALL SUBOPT_0x1E
	ORI  R30,8
	CALL SUBOPT_0x1E
	ORI  R30,4
	CALL SUBOPT_0x1E
	ORI  R30,0x80
	STS  97,R30
	LDS  R30,98
	ORI  R30,0x80
	STS  98,R30
	LDS  R30,97
	ORI  R30,0x20
	CALL SUBOPT_0x1E
	ORI  R30,0x40
	STS  97,R30
	RCALL _ks0108_disable_G100
	LDS  R30,98
	ANDI R30,0x7F
	STS  98,R30
	CALL SUBOPT_0x10
	LDS  R30,98
	ORI  R30,0x80
	STS  98,R30
	LDI  R17,LOW(0)
_0x200000C:
	CPI  R17,2
	BRSH _0x200000E
	ST   -Y,R17
	LDI  R26,LOW(63)
	RCALL _ks0108_wrcmd_G100
	ST   -Y,R17
	INC  R17
	LDI  R26,LOW(192)
	RCALL _ks0108_wrcmd_G100
	RJMP _0x200000C
_0x200000E:
	LDI  R30,LOW(1)
	STS  _glcd_state,R30
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,1
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BREQ _0x200000F
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __GETW1P
	CALL SUBOPT_0x19
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,2
	CALL __GETW1P
	__PUTW1MN _glcd_state,25
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,4
	CALL __GETW1P
	RJMP _0x20000AE
_0x200000F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x19
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	__PUTW1MN _glcd_state,25
_0x20000AE:
	__PUTW1MN _glcd_state,27
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,6
	__PUTB1MN _glcd_state,7
	__PUTB1MN _glcd_state,8
	LDI  R30,LOW(255)
	__PUTB1MN _glcd_state,9
	LDI  R30,LOW(1)
	__PUTB1MN _glcd_state,16
	__POINTW1MN _glcd_state,17
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDI  R26,LOW(8)
	LDI  R27,0
	CALL _memset
	RCALL _glcd_clear
	LDI  R30,LOW(1)
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_glcd_clear:
; .FSTART _glcd_clear
	CALL __SAVELOCR4
	LDI  R16,0
	LDI  R19,0
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x2000015
	LDI  R16,LOW(255)
_0x2000015:
_0x2000016:
	CPI  R19,8
	BRSH _0x2000018
	LDI  R30,LOW(0)
	ST   -Y,R30
	MOV  R26,R19
	SUBI R19,-1
	RCALL _ks0108_gotoxp_G100
	LDI  R17,LOW(0)
_0x2000019:
	MOV  R26,R17
	SUBI R17,-1
	CPI  R26,LOW(0x80)
	BRSH _0x200001B
	MOV  R26,R16
	CALL SUBOPT_0x1F
	RJMP _0x2000019
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _ks0108_gotoxp_G100
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _glcd_moveto
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_ks0108_wrmasked_G100:
; .FSTART _ks0108_wrmasked_G100
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R26,Y+5
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x200002B
	CPI  R30,LOW(0x8)
	BRNE _0x200002C
_0x200002B:
	LDD  R30,Y+3
	ST   -Y,R30
	LDD  R26,Y+2
	CALL _glcd_mappixcolor1bit
	STD  Y+3,R30
	RJMP _0x200002D
_0x200002C:
	CPI  R30,LOW(0x3)
	BRNE _0x200002F
	LDD  R30,Y+3
	COM  R30
	STD  Y+3,R30
	RJMP _0x2000030
_0x200002F:
	CPI  R30,0
	BRNE _0x2000031
_0x2000030:
_0x200002D:
	LDD  R30,Y+2
	COM  R30
	AND  R17,R30
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x2)
	BRNE _0x2000033
_0x2000032:
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	OR   R17,R30
	RJMP _0x2000029
_0x2000033:
	CPI  R30,LOW(0x1)
	BRNE _0x2000034
	LDD  R30,Y+2
	LDD  R26,Y+3
	AND  R30,R26
	EOR  R17,R30
	RJMP _0x2000029
_0x2000034:
	CPI  R30,LOW(0x4)
	BRNE _0x2000029
	LDD  R30,Y+2
	COM  R30
	LDD  R26,Y+3
	OR   R30,R26
	AND  R17,R30
_0x2000029:
	MOV  R26,R17
	CALL SUBOPT_0x1F
	LDD  R17,Y+0
	JMP  _0x2120005
; .FEND
_glcd_block:
; .FSTART _glcd_block
	ST   -Y,R26
	SBIW R28,3
	CALL __SAVELOCR6
	LDD  R26,Y+16
	CPI  R26,LOW(0x80)
	BRSH _0x2000037
	LDD  R26,Y+15
	CPI  R26,LOW(0x40)
	BRSH _0x2000037
	LDD  R26,Y+14
	CPI  R26,LOW(0x0)
	BREQ _0x2000037
	LDD  R26,Y+13
	CPI  R26,LOW(0x0)
	BRNE _0x2000036
_0x2000037:
	RJMP _0x212000B
_0x2000036:
	LDD  R30,Y+14
	STD  Y+8,R30
	LDD  R26,Y+16
	CLR  R27
	LDD  R30,Y+14
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x81)
	LDI  R30,HIGH(0x81)
	CPC  R27,R30
	BRLO _0x2000039
	LDD  R26,Y+16
	LDI  R30,LOW(128)
	SUB  R30,R26
	STD  Y+14,R30
_0x2000039:
	LDD  R18,Y+13
	LDD  R26,Y+15
	CLR  R27
	LDD  R30,Y+13
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRLO _0x200003A
	LDD  R26,Y+15
	LDI  R30,LOW(64)
	SUB  R30,R26
	STD  Y+13,R30
_0x200003A:
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BREQ PC+2
	RJMP _0x200003B
	LDD  R30,Y+12
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	RJMP _0x212000B
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x212000B
_0x2000041:
_0x2000042:
	LDD  R16,Y+8
	LDD  R30,Y+13
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R19,R30
	MOV  R30,R18
	ANDI R30,LOW(0x7)
	BRNE _0x2000044
	LDD  R26,Y+13
	CP   R18,R26
	BREQ _0x2000043
_0x2000044:
	MOV  R26,R16
	CLR  R27
	MOV  R30,R19
	LDI  R31,0
	CALL __MULW12U
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL SUBOPT_0x20
	LSR  R18
	LSR  R18
	LSR  R18
	MOV  R21,R19
_0x2000046:
	PUSH R21
	SUBI R21,-1
	MOV  R30,R18
	POP  R26
	CP   R30,R26
	BRLO _0x2000048
	MOV  R17,R16
_0x2000049:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200004B
	CALL SUBOPT_0x21
	RJMP _0x2000049
_0x200004B:
	RJMP _0x2000046
_0x2000048:
_0x2000043:
	LDD  R26,Y+14
	CP   R16,R26
	BREQ _0x200004C
	LDD  R30,Y+14
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	CALL SUBOPT_0x20
	LDD  R30,Y+13
	ANDI R30,LOW(0x7)
	BREQ _0x200004D
	SUBI R19,-LOW(1)
_0x200004D:
	LDI  R18,LOW(0)
_0x200004E:
	PUSH R18
	SUBI R18,-1
	MOV  R30,R19
	POP  R26
	CP   R26,R30
	BRSH _0x2000050
	LDD  R17,Y+14
_0x2000051:
	PUSH R17
	SUBI R17,-1
	MOV  R30,R16
	POP  R26
	CP   R26,R30
	BRSH _0x2000053
	CALL SUBOPT_0x21
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x20
	RJMP _0x200004E
_0x2000050:
_0x200004C:
_0x200003B:
	LDD  R30,Y+15
	ANDI R30,LOW(0x7)
	MOV  R19,R30
_0x2000054:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000056
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(0)
	LDD  R16,Y+16
	CPI  R19,0
	BREQ PC+2
	RJMP _0x2000057
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH PC+2
	RJMP _0x2000058
	LDD  R30,Y+9
	CPI  R30,0
	BREQ _0x200005D
	CPI  R30,LOW(0x3)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x7)
	BRNE _0x2000060
_0x200005F:
	RJMP _0x2000061
_0x2000060:
	CPI  R30,LOW(0x8)
	BRNE _0x2000062
_0x2000061:
	RJMP _0x2000063
_0x2000062:
	CPI  R30,LOW(0x6)
	BRNE _0x2000064
_0x2000063:
	RJMP _0x2000065
_0x2000064:
	CPI  R30,LOW(0x9)
	BRNE _0x2000066
_0x2000065:
	RJMP _0x2000067
_0x2000066:
	CPI  R30,LOW(0xA)
	BRNE _0x200005B
_0x2000067:
	ST   -Y,R16
	LDD  R30,Y+16
	CALL SUBOPT_0x1D
_0x200005B:
_0x2000069:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200006B
	LDD  R26,Y+9
	CPI  R26,LOW(0x6)
	BRNE _0x200006C
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	RCALL _ks0108_rddata_G100
	MOV  R26,R30
	CALL _glcd_writemem
	RCALL _ks0108_nextx_G100
	RJMP _0x200006D
_0x200006C:
	LDD  R30,Y+9
	CPI  R30,LOW(0x9)
	BRNE _0x2000071
	LDI  R21,LOW(0)
	RJMP _0x2000072
_0x2000071:
	CPI  R30,LOW(0xA)
	BRNE _0x2000070
	LDI  R21,LOW(255)
	RJMP _0x2000072
_0x2000070:
	CALL SUBOPT_0x22
	CALL SUBOPT_0x23
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x24
	MOV  R21,R30
	RJMP _0x200007B
_0x200007A:
	CPI  R30,LOW(0x3)
	BRNE _0x200007D
	COM  R21
	RJMP _0x200007E
_0x200007D:
	CPI  R30,0
	BRNE _0x2000080
_0x200007E:
_0x200007B:
	MOV  R26,R21
	CALL SUBOPT_0x1F
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x25
	LDI  R30,LOW(255)
	ST   -Y,R30
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
_0x2000077:
_0x200006D:
	RJMP _0x2000069
_0x200006B:
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDD  R30,Y+13
	SUBI R30,LOW(8)
	STD  Y+13,R30
	RJMP _0x2000081
_0x2000058:
	LDD  R21,Y+13
	LDI  R18,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000082
_0x2000057:
	MOV  R30,R19
	LDD  R26,Y+13
	ADD  R26,R30
	CPI  R26,LOW(0x9)
	BRSH _0x2000083
	LDD  R18,Y+13
	LDI  R30,LOW(0)
	STD  Y+13,R30
	RJMP _0x2000084
_0x2000083:
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
_0x2000084:
	ST   -Y,R19
	MOV  R26,R18
	CALL _glcd_getmask
	MOV  R20,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x2000088
_0x2000089:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x200008B
	CALL SUBOPT_0x26
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x27
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x2000089
_0x200008B:
	RJMP _0x2000087
_0x2000088:
	CPI  R30,LOW(0x9)
	BRNE _0x200008C
	LDI  R21,LOW(0)
	RJMP _0x200008D
_0x200008C:
	CPI  R30,LOW(0xA)
	BRNE _0x2000093
	LDI  R21,LOW(255)
_0x200008D:
	CALL SUBOPT_0x24
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	MOV  R21,R30
_0x2000090:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000092
	CALL SUBOPT_0x25
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000090
_0x2000092:
	RJMP _0x2000087
_0x2000093:
_0x2000094:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x2000096
	CALL SUBOPT_0x28
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSLB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x2000094
_0x2000096:
_0x2000087:
	LDD  R30,Y+13
	CPI  R30,0
	BRNE _0x2000097
	RJMP _0x2000056
_0x2000097:
	LDD  R26,Y+13
	CPI  R26,LOW(0x8)
	BRSH _0x2000098
	LDD  R30,Y+13
	SUB  R30,R18
	MOV  R21,R30
	LDI  R30,LOW(0)
	RJMP _0x20000AF
_0x2000098:
	MOV  R21,R19
	LDD  R30,Y+13
	SUBI R30,LOW(8)
_0x20000AF:
	STD  Y+13,R30
	LDI  R17,LOW(0)
	LDD  R30,Y+15
	SUBI R30,-LOW(8)
	STD  Y+15,R30
	LDI  R30,LOW(8)
	SUB  R30,R19
	MOV  R18,R30
	LDD  R16,Y+16
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000082:
	MOV  R30,R21
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R20,Z
	LDD  R30,Y+9
	CPI  R30,LOW(0x6)
	BRNE _0x200009D
_0x200009E:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A0
	CALL SUBOPT_0x26
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x27
	MOV  R30,R18
	MOV  R26,R20
	CALL SUBOPT_0x0
	OR   R21,R30
	CALL SUBOPT_0x22
	ST   -Y,R31
	ST   -Y,R30
	MOV  R26,R21
	CALL _glcd_writemem
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x200009C
_0x200009D:
	CPI  R30,LOW(0x9)
	BRNE _0x20000A1
	LDI  R21,LOW(0)
	RJMP _0x20000A2
_0x20000A1:
	CPI  R30,LOW(0xA)
	BRNE _0x20000A8
	LDI  R21,LOW(255)
_0x20000A2:
	CALL SUBOPT_0x24
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	MOV  R21,R30
_0x20000A5:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000A7
	CALL SUBOPT_0x25
	ST   -Y,R20
	LDI  R26,LOW(0)
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A5
_0x20000A7:
	RJMP _0x200009C
_0x20000A8:
_0x20000A9:
	PUSH R17
	SUBI R17,-1
	LDD  R30,Y+14
	POP  R26
	CP   R26,R30
	BRSH _0x20000AB
	CALL SUBOPT_0x28
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSRB12
	ST   -Y,R30
	ST   -Y,R20
	LDD  R26,Y+13
	RCALL _ks0108_wrmasked_G100
	RJMP _0x20000A9
_0x20000AB:
_0x200009C:
_0x2000081:
	LDD  R30,Y+8
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000054
_0x2000056:
_0x212000B:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x29
	BRLT _0x2020003
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120003
_0x2020003:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x80)
	LDI  R30,HIGH(0x80)
	CPC  R27,R30
	BRLT _0x2020004
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	JMP  _0x2120003
_0x2020004:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120003
; .FEND
_glcd_clipy:
; .FSTART _glcd_clipy
	CALL SUBOPT_0x29
	BRLT _0x2020005
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	JMP  _0x2120003
_0x2020005:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x2020006
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	JMP  _0x2120003
_0x2020006:
	LD   R30,Y
	LDD  R31,Y+1
	JMP  _0x2120003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x2A
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000A
_0x202000B:
	CALL SUBOPT_0x2B
	STD  Y+7,R0
	CALL SUBOPT_0x2B
	STD  Y+6,R0
	CALL SUBOPT_0x2B
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000A
_0x202000C:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R21,Z
	LDD  R26,Y+8
	CLR  R27
	CLR  R30
	ADD  R26,R21
	ADC  R27,R30
	LDD  R30,Y+11
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRLO _0x202000D
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000A
_0x202000D:
	LDD  R30,Y+6
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R20,R30
	LDD  R30,Y+6
	ANDI R30,LOW(0x7)
	BREQ _0x202000E
	SUBI R20,-LOW(1)
_0x202000E:
	LDD  R30,Y+7
	CPI  R30,0
	BREQ _0x202000F
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	LDD  R26,Y+8
	LDD  R30,Y+11
	SUB  R30,R26
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+7
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	ADD  R30,R16
	ADC  R31,R17
	RJMP _0x212000A
_0x202000F:
	MOVW R18,R16
	MOV  R30,R21
	LDI  R31,0
	__ADDWRR 16,17,30,31
_0x2020010:
	LDD  R26,Y+8
	SUBI R26,-LOW(1)
	STD  Y+8,R26
	SUBI R26,LOW(1)
	LDD  R30,Y+11
	CP   R26,R30
	BRSH _0x2020012
	MOVW R30,R18
	__ADDWRN 18,19,1
	LPM  R26,Z
	LDI  R27,0
	MOV  R30,R20
	LDI  R31,0
	CALL __MULW12U
	__ADDWRR 16,17,30,31
	RJMP _0x2020010
_0x2020012:
	MOVW R30,R18
	LPM  R30,Z
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ST   X,R30
	MOVW R30,R16
_0x212000A:
	CALL __LOADLOCR6
	ADIW R28,12
	RET
; .FEND
_glcd_new_line_G101:
; .FSTART _glcd_new_line_G101
	LDI  R30,LOW(0)
	__PUTB1MN _glcd_state,2
	__GETB2MN _glcd_state,3
	CLR  R27
	CALL SUBOPT_0x2C
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _glcd_state,7
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	RET
; .FEND
_glcd_putchar:
; .FSTART _glcd_putchar
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x2A
	SBIW R30,0
	BRNE PC+2
	RJMP _0x202001F
	LDD  R26,Y+7
	CPI  R26,LOW(0xA)
	BRNE _0x2020020
	RJMP _0x2020021
_0x2020020:
	LDD  R30,Y+7
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,7
	RCALL _glcd_getcharw_G101
	MOVW R20,R30
	SBIW R30,0
	BRNE _0x2020022
	RJMP _0x2120009
_0x2020022:
	__GETB1MN _glcd_state,6
	LDD  R26,Y+6
	ADD  R30,R26
	MOV  R19,R30
	__GETB2MN _glcd_state,2
	CLR  R27
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R16,R30
	__CPWRN 16,17,129
	BRLO _0x2020023
	MOV  R16,R19
	CLR  R17
	RCALL _glcd_new_line_G101
_0x2020023:
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	LDD  R30,Y+8
	ST   -Y,R30
	CALL SUBOPT_0x2C
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R21
	ST   -Y,R20
	LDI  R26,LOW(7)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	LDD  R26,Y+6
	ADD  R30,R26
	ST   -Y,R30
	__GETB1MN _glcd_state,3
	ST   -Y,R30
	__GETB1MN _glcd_state,6
	ST   -Y,R30
	CALL SUBOPT_0x2C
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x17
	LDI  R26,LOW(9)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x2C
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x17
	LDI  R26,LOW(9)
	RCALL _glcd_block
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x2120009
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x2120009:
	CALL __LOADLOCR6
	ADIW R28,8
	RET
; .FEND
_glcd_outtextxy:
; .FSTART _glcd_outtextxy
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _glcd_moveto
_0x2020025:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020027
	MOV  R26,R17
	RCALL _glcd_putchar
	RJMP _0x2020025
_0x2020027:
	LDD  R17,Y+0
	JMP  _0x2120006
; .FEND
_glcd_moveto:
; .FSTART _glcd_moveto
	ST   -Y,R26
	LDD  R26,Y+1
	CLR  R27
	RCALL _glcd_clipx
	__PUTB1MN _glcd_state,2
	LD   R26,Y
	CLR  R27
	RCALL _glcd_clipy
	__PUTB1MN _glcd_state,3
	JMP  _0x2120003
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
; .FSTART _getchar
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET
; .FEND
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2120008:
	ADIW R28,1
	RET
; .FEND
_gets:
; .FSTART _gets
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
	__GETWRS 16,17,6
	__GETWRS 18,19,8
_0x2060009:
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x206000B
_0x206000C:
	RCALL _getchar
	MOV  R21,R30
	CPI  R21,8
	BRNE _0x206000D
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R16,R26
	CPC  R17,R27
	BRSH _0x206000E
	__SUBWRN 18,19,1
	__ADDWRN 16,17,1
_0x206000E:
	RJMP _0x206000C
_0x206000D:
	CPI  R21,10
	BREQ _0x206000B
	PUSH R19
	PUSH R18
	__ADDWRN 18,19,1
	MOV  R30,R21
	POP  R26
	POP  R27
	ST   X,R30
	__SUBWRN 16,17,1
	RJMP _0x2060009
_0x206000B:
	MOVW R26,R18
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CALL __LOADLOCR6
	ADIW R28,10
	RET
; .FEND
_put_usart_G103:
; .FSTART _put_usart_G103
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x2D
	JMP  _0x2120002
; .FEND
_put_buff_G103:
; .FSTART _put_buff_G103
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2060010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2060012
	__CPWRN 16,17,2
	BRLO _0x2060013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2060012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x2D
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	CALL SUBOPT_0x2D
_0x2060014:
	RJMP _0x2060015
_0x2060010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2060015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x2120006
; .FEND
__print_G103:
; .FSTART __print_G103
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2060016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x206001C
	CPI  R18,37
	BRNE _0x206001D
	LDI  R17,LOW(1)
	RJMP _0x206001E
_0x206001D:
	CALL SUBOPT_0x2E
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x2E
	RJMP _0x20600CC
_0x2060020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2060021
	LDI  R16,LOW(1)
	RJMP _0x206001B
_0x2060021:
	CPI  R18,43
	BRNE _0x2060022
	LDI  R20,LOW(43)
	RJMP _0x206001B
_0x2060022:
	CPI  R18,32
	BRNE _0x2060023
	LDI  R20,LOW(32)
	RJMP _0x206001B
_0x2060023:
	RJMP _0x2060024
_0x206001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2060025
_0x2060024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2060026
	ORI  R16,LOW(128)
	RJMP _0x206001B
_0x2060026:
	RJMP _0x2060027
_0x2060025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x206001B
_0x2060027:
	CPI  R18,48
	BRLO _0x206002A
	CPI  R18,58
	BRLO _0x206002B
_0x206002A:
	RJMP _0x2060029
_0x206002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206001B
_0x2060029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x206002F
	CALL SUBOPT_0x2F
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x30
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2060033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2060036
_0x2060035:
	CPI  R30,LOW(0x64)
	BREQ _0x2060039
	CPI  R30,LOW(0x69)
	BRNE _0x206003A
_0x2060039:
	ORI  R16,LOW(4)
	RJMP _0x206003B
_0x206003A:
	CPI  R30,LOW(0x75)
	BRNE _0x206003C
_0x206003B:
	LDI  R30,LOW(_tbl10_G103*2)
	LDI  R31,HIGH(_tbl10_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x206003D
_0x206003C:
	CPI  R30,LOW(0x58)
	BRNE _0x206003F
	ORI  R16,LOW(8)
	RJMP _0x2060040
_0x206003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2060071
_0x2060040:
	LDI  R30,LOW(_tbl16_G103*2)
	LDI  R31,HIGH(_tbl16_G103*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x206003D:
	SBRS R16,2
	RJMP _0x2060042
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x32
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2060043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2060043:
	CPI  R20,0
	BREQ _0x2060044
	SUBI R17,-LOW(1)
	RJMP _0x2060045
_0x2060044:
	ANDI R16,LOW(251)
_0x2060045:
	RJMP _0x2060046
_0x2060042:
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x32
_0x2060046:
_0x2060036:
	SBRC R16,0
	RJMP _0x2060047
_0x2060048:
	CP   R17,R21
	BRSH _0x206004A
	SBRS R16,7
	RJMP _0x206004B
	SBRS R16,2
	RJMP _0x206004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x206004D
_0x206004C:
	LDI  R18,LOW(48)
_0x206004D:
	RJMP _0x206004E
_0x206004B:
	LDI  R18,LOW(32)
_0x206004E:
	CALL SUBOPT_0x2E
	SUBI R21,LOW(1)
	RJMP _0x2060048
_0x206004A:
_0x2060047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x206004F
_0x2060050:
	CPI  R19,0
	BREQ _0x2060052
	SBRS R16,3
	RJMP _0x2060053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2060054
_0x2060053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2060054:
	CALL SUBOPT_0x2E
	CPI  R21,0
	BREQ _0x2060055
	SUBI R21,LOW(1)
_0x2060055:
	SUBI R19,LOW(1)
	RJMP _0x2060050
_0x2060052:
	RJMP _0x2060056
_0x206004F:
_0x2060058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x206005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x206005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x206005A
_0x206005C:
	CPI  R18,58
	BRLO _0x206005D
	SBRS R16,3
	RJMP _0x206005E
	SUBI R18,-LOW(7)
	RJMP _0x206005F
_0x206005E:
	SUBI R18,-LOW(39)
_0x206005F:
_0x206005D:
	SBRC R16,4
	RJMP _0x2060061
	CPI  R18,49
	BRSH _0x2060063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2060062
_0x2060063:
	RJMP _0x20600CD
_0x2060062:
	CP   R21,R19
	BRLO _0x2060067
	SBRS R16,0
	RJMP _0x2060068
_0x2060067:
	RJMP _0x2060066
_0x2060068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2060069
	LDI  R18,LOW(48)
_0x20600CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x206006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x30
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x2E
	CPI  R21,0
	BREQ _0x206006C
	SUBI R21,LOW(1)
_0x206006C:
_0x2060066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2060059
	RJMP _0x2060058
_0x2060059:
_0x2060056:
	SBRS R16,0
	RJMP _0x206006D
_0x206006E:
	CPI  R21,0
	BREQ _0x2060070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x30
	RJMP _0x206006E
_0x2060070:
_0x206006D:
_0x2060071:
_0x2060030:
_0x20600CC:
	LDI  R17,LOW(0)
_0x206001B:
	RJMP _0x2060016
_0x2060018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x33
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x33
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x34
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2120007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL SUBOPT_0x34
	LDI  R30,LOW(_put_usart_G103)
	LDI  R31,HIGH(_put_usart_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G103
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_memset:
; .FSTART _memset
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+1
    ld   r26,y
    adiw r26,0
    breq memset1
    ldd  r31,y+4
    ldd  r30,y+3
    ldd  r22,y+2
memset0:
    st   z+,r22
    sbiw r26,1
    brne memset0
memset1:
    ldd  r30,y+3
    ldd  r31,y+4
_0x2120006:
	ADIW R28,5
	RET
; .FEND
_strchr:
; .FSTART _strchr
	ST   -Y,R26
    ld   r26,y+
    ld   r30,y+
    ld   r31,y+
strchr0:
    ld   r27,z
    cp   r26,r27
    breq strchr1
    adiw r30,1
    tst  r27
    brne strchr0
    clr  r30
    clr  r31
strchr1:
    ret
; .FEND
_strcmp:
; .FSTART _strcmp
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strcmp0:
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strcmp1
    tst  r22
    brne strcmp0
strcmp3:
    clr  r30
    ret
strcmp1:
    sub  r22,r23
    breq strcmp3
    ldi  r30,1
    brcc strcmp2
    subi r30,2
strcmp2:
    ret
; .FEND
_strcpy:
; .FSTART _strcpy
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpy0:
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strcpy0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND
_strncat:
; .FSTART _strncat
	ST   -Y,R26
    ld   r23,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strncat0:
    ld   r22,x+
    tst  r22
    brne strncat0
    sbiw r26,1
strncat1:
    st   x,r23
    tst  r23
    breq strncat2
    dec  r23
    ld   r22,z+
    st   x+,r22
    tst  r22
    brne strncat1
strncat2:
    movw r30,r24
    ret
; .FEND
_strncmp:
; .FSTART _strncmp
	ST   -Y,R26
    clr  r22
    clr  r23
    ld   r24,y+
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
strncmp0:
    tst  r24
    breq strncmp1
    dec  r24
    ld   r22,x+
    ld   r23,z+
    cp   r22,r23
    brne strncmp1
    tst  r22
    brne strncmp0
strncmp3:
    clr  r30
    ret
strncmp1:
    sub  r22,r23
    breq strncmp3
    ldi  r30,1
    brcc strncmp2
    subi r30,2
strncmp2:
    ret
; .FEND
_strpbrkf:
; .FSTART _strpbrkf
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
strpbrkf0:
    ld   r22,x
    tst  r22
    breq strpbrkf2
    ldd  r31,y+1
    ld   r30,y
strpbrkf1:
	lpm
    tst  r0
    breq strpbrkf3
    adiw r30,1
    cp   r22,r0
    brne strpbrkf1
    movw r30,r26
    rjmp strpbrkf4
strpbrkf3:
    adiw r26,1
    rjmp strpbrkf0
strpbrkf2:
    clr  r30
    clr  r31
strpbrkf4:
	JMP  _0x2120001
; .FEND
_strstr:
; .FSTART _strstr
	ST   -Y,R27
	ST   -Y,R26
    ldd  r26,y+2
    ldd  r27,y+3
    movw r24,r26
strstr0:
    ld   r30,y
    ldd  r31,y+1
strstr1:
    ld   r23,z+
    tst  r23
    brne strstr2
    movw r30,r24
    rjmp strstr3
strstr2:
    ld   r22,x+
    cp   r22,r23
    breq strstr1
    adiw r24,1
    movw r26,r24
    tst  r22
    brne strstr0
    clr  r30
    clr  r31
strstr3:
	JMP  _0x2120001
; .FEND
_strspnf:
; .FSTART _strspnf
	ST   -Y,R27
	ST   -Y,R26
    ldd  r27,y+3
    ldd  r26,y+2
    clr  r24
    clr  r25
strspnf0:
    ld   r22,x+
    tst  r22
    breq strspnf2
    ldd  r31,y+1
    ld   r30,y
strspnf1:
	lpm  r0,z+
    tst  r0
    breq strspnf2
    cp   r22,r0
    brne strspnf1
    adiw r24,1
    rjmp strspnf0
strspnf2:
    movw r30,r24
	JMP  _0x2120001
; .FEND
_strtok:
; .FSTART _strtok
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	SBIW R30,0
	BRNE _0x2080003
	LDS  R30,_p_S1040026000
	LDS  R31,_p_S1040026000+1
	SBIW R30,0
	BRNE _0x2080004
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120004
_0x2080004:
	LDS  R30,_p_S1040026000
	LDS  R31,_p_S1040026000+1
	STD  Y+4,R30
	STD  Y+4+1,R31
_0x2080003:
	CALL SUBOPT_0x35
	CALL _strspnf
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+4,R30
	STD  Y+4+1,R31
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	CPI  R30,0
	BRNE _0x2080005
	LDI  R30,LOW(0)
	STS  _p_S1040026000,R30
	STS  _p_S1040026000+1,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2120004
_0x2080005:
	CALL SUBOPT_0x35
	CALL _strpbrkf
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2080006
	MOVW R26,R16
	__ADDWRN 16,17,1
	LDI  R30,LOW(0)
	ST   X,R30
_0x2080006:
	__PUTWMRN _p_S1040026000,0,16,17
	LDD  R30,Y+4
	LDD  R31,Y+4+1
_0x2120004:
	LDD  R17,Y+1
	LDD  R16,Y+0
_0x2120005:
	ADIW R28,6
	RET
; .FEND

	.CSEG
_atoi:
; .FSTART _atoi
	ST   -Y,R27
	ST   -Y,R26
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isspace
        mov  r26,r24
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
        mov  r24,r26
	MOV  R26,R30
	CALL _isdigit
        mov  r26,r24
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
; .FEND

	.DSEG

	.CSEG
_srand:
; .FSTART _srand
	ST   -Y,R27
	ST   -Y,R26
	LD   R30,Y
	LDD  R31,Y+1
	CALL __CWD1
	CALL SUBOPT_0x36
	RJMP _0x2120003
; .FEND
_rand:
; .FSTART _rand
	LDS  R30,__seed_G105
	LDS  R31,__seed_G105+1
	LDS  R22,__seed_G105+2
	LDS  R23,__seed_G105+3
	__GETD2N 0x41C64E6D
	CALL __MULD12U
	__ADDD1N 30562
	CALL SUBOPT_0x36
	movw r30,r22
	andi r31,0x7F
	RET
; .FEND

	.CSEG
_glcd_getmask:
; .FSTART _glcd_getmask
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__glcd_mask*2)
	SBCI R31,HIGH(-__glcd_mask*2)
	LPM  R26,Z
	LDD  R30,Y+1
	CALL __LSLB12
_0x2120003:
	ADIW R28,2
	RET
; .FEND
_glcd_mappixcolor1bit:
; .FSTART _glcd_mappixcolor1bit
	ST   -Y,R26
	ST   -Y,R17
	LDD  R30,Y+1
	CPI  R30,LOW(0x7)
	BREQ _0x20C0007
	CPI  R30,LOW(0xA)
	BRNE _0x20C0008
_0x20C0007:
	LDS  R17,_glcd_state
	RJMP _0x20C0009
_0x20C0008:
	CPI  R30,LOW(0x9)
	BRNE _0x20C000B
	__GETBRMN 17,_glcd_state,1
	RJMP _0x20C0009
_0x20C000B:
	CPI  R30,LOW(0x8)
	BRNE _0x20C0005
	__GETBRMN 17,_glcd_state,16
_0x20C0009:
	__GETB1MN _glcd_state,1
	CPI  R30,0
	BREQ _0x20C000E
	CPI  R17,0
	BREQ _0x20C000F
	LDI  R30,LOW(255)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20C000F:
	LDD  R30,Y+2
	COM  R30
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20C000E:
	CPI  R17,0
	BRNE _0x20C0011
	LDI  R30,LOW(0)
	LDD  R17,Y+0
	RJMP _0x2120002
_0x20C0011:
_0x20C0005:
	LDD  R30,Y+2
	LDD  R17,Y+0
	RJMP _0x2120002
; .FEND
_glcd_readmem:
; .FSTART _glcd_readmem
	ST   -Y,R27
	ST   -Y,R26
	LDD  R30,Y+2
	CPI  R30,LOW(0x1)
	BRNE _0x20C0015
	LD   R30,Y
	LDD  R31,Y+1
	LPM  R30,Z
	RJMP _0x2120002
_0x20C0015:
	CPI  R30,LOW(0x2)
	BRNE _0x20C0016
	LD   R26,Y
	LDD  R27,Y+1
	CALL __EEPROMRDB
	RJMP _0x2120002
_0x20C0016:
	CPI  R30,LOW(0x3)
	BRNE _0x20C0018
	LD   R26,Y
	LDD  R27,Y+1
	__CALL1MN _glcd_state,25
	RJMP _0x2120002
_0x20C0018:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
_0x2120002:
	ADIW R28,3
	RET
; .FEND
_glcd_writemem:
; .FSTART _glcd_writemem
	ST   -Y,R26
	LDD  R30,Y+3
	CPI  R30,0
	BRNE _0x20C001C
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ST   X,R30
	RJMP _0x20C001B
_0x20C001C:
	CPI  R30,LOW(0x2)
	BRNE _0x20C001D
	LD   R30,Y
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __EEPROMWRB
	RJMP _0x20C001B
_0x20C001D:
	CPI  R30,LOW(0x3)
	BRNE _0x20C001B
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	__CALL1MN _glcd_state,27
_0x20C001B:
_0x2120001:
	ADIW R28,4
	RET
; .FEND

	.CSEG

	.CSEG
_isdigit:
; .FSTART _isdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
; .FEND
_isspace:
; .FSTART _isspace
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret
; .FEND

	.DSEG
_glcd_state:
	.BYTE 0x1D
_response_buffer:
	.BYTE 0x100
_sender_number:
	.BYTE 0x14
_formatted_phone_number:
	.BYTE 0xF
_ks0108_coord_G100:
	.BYTE 0x3
_p_S1040026000:
	.BYTE 0x2
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1:
	IN   R1,19
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,14
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(_response_buffer)
	LDI  R31,HIGH(_response_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(256)
	LDI  R27,HIGH(256)
	JMP  _memset

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_response_buffer)
	LDI  R27,HIGH(_response_buffer)
	CALL _strlen
	LDI  R26,LOW(0)
	SUB  R26,R30
	SUBI R26,LOW(1)
	JMP  _strncat

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x8:
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	CALL _send_at_command
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _get_full_response
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	CALL _send_at_command
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _get_full_response
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xC:
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+25
	LDD  R31,Y+25+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	CALL _glcd_clear
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	CALL _glcd_outtextxy
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(30)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(_formatted_phone_number)
	LDI  R31,HIGH(_formatted_phone_number)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	CALL _get_full_response
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x13:
	CALL _glcd_outtextxy
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	CALL _glcd_outtextxy
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x15:
	CALL _send_at_command
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RJMP SUBOPT_0x12

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	CALL _send_at_command
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _get_full_response

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_response_buffer)
	LDI  R27,HIGH(_response_buffer)
	CALL _strlen
	CALL __CPW01
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	STS  98,R30
	LDS  R30,98
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDS  R30,98
	ORI  R30,8
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	ANDI R30,0XF7
	STS  98,R30
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LD   R30,Y
	OUT  0x1B,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	STS  97,R30
	LDS  R30,97
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x21:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _glcd_writemem

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x22:
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	ADIW R30,1
	STD  Y+7,R30
	STD  Y+7+1,R31
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	MOV  R21,R30
	LDD  R30,Y+12
	ST   -Y,R30
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	CLR  R24
	CLR  R25
	CALL _glcd_readmem
	MOV  R1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x28:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	LDD  R30,Y+14
	ST   -Y,R30
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ADIW R30,1
	STD  Y+9,R30
	STD  Y+9+1,R31
	SBIW R30,1
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2C:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2E:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x30:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x31:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	STS  __seed_G105,R30
	STS  __seed_G105+1,R31
	STS  __seed_G105+2,R22
	STS  __seed_G105+3,R23
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
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
	OUT  EEARH,R27
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

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	RET

__CPD21:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R25,R23
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
