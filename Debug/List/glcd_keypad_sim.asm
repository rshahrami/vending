
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

_0x24:
	.DB  0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38
	.DB  0x39,0x2A,0x30,0x23,0x7,0x5,0x6,0x4
	.DB  0x0,0x1,0x2
_0x0:
	.DB  0x25,0x73,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x53,0x41,0x50,0x42,0x52,0x3D,0x32,0x2C
	.DB  0x31,0x0,0x2B,0x53,0x41,0x50,0x42,0x52
	.DB  0x3A,0x0,0x2B,0x53,0x41,0x50,0x42,0x52
	.DB  0x3A,0x20,0x31,0x2C,0x31,0x2C,0x0,0x53
	.DB  0x65,0x74,0x74,0x69,0x6E,0x67,0x20,0x53
	.DB  0x4D,0x53,0x20,0x4D,0x6F,0x64,0x65,0x2E
	.DB  0x2E,0x2E,0x0,0x41,0x54,0x2B,0x43,0x4D
	.DB  0x47,0x46,0x3D,0x31,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4E,0x4D,0x49,0x3D,0x32,0x2C,0x32
	.DB  0x2C,0x30,0x2C,0x30,0x2C,0x30,0x0,0x41
	.DB  0x54,0x2B,0x43,0x4D,0x47,0x44,0x41,0x3D
	.DB  0x22,0x44,0x45,0x4C,0x20,0x41,0x4C,0x4C
	.DB  0x22,0x0,0x41,0x54,0x2B,0x43,0x46,0x55
	.DB  0x4E,0x3D,0x31,0x0,0x41,0x54,0x2B,0x43
	.DB  0x53,0x43,0x4C,0x4B,0x3D,0x30,0x0,0x53
	.DB  0x4D,0x53,0x20,0x52,0x65,0x61,0x64,0x79
	.DB  0x2E,0x0,0x43,0x6F,0x6E,0x6E,0x65,0x63
	.DB  0x74,0x69,0x6E,0x67,0x20,0x74,0x6F,0x20
	.DB  0x47,0x50,0x52,0x53,0x2E,0x2E,0x2E,0x0
	.DB  0x41,0x54,0x2B,0x53,0x41,0x50,0x42,0x52
	.DB  0x3D,0x33,0x2C,0x31,0x2C,0x22,0x43,0x6F
	.DB  0x6E,0x74,0x79,0x70,0x65,0x22,0x2C,0x22
	.DB  0x47,0x50,0x52,0x53,0x22,0x0,0x41,0x54
	.DB  0x2B,0x53,0x41,0x50,0x42,0x52,0x3D,0x33
	.DB  0x2C,0x31,0x2C,0x22,0x41,0x50,0x4E,0x22
	.DB  0x2C,0x22,0x25,0x73,0x22,0x0,0x6D,0x63
	.DB  0x69,0x6E,0x65,0x74,0x0,0x41,0x54,0x2B
	.DB  0x53,0x41,0x50,0x42,0x52,0x3D,0x31,0x2C
	.DB  0x31,0x0,0x46,0x65,0x74,0x63,0x68,0x69
	.DB  0x6E,0x67,0x20,0x49,0x50,0x2E,0x2E,0x2E
	.DB  0x0,0x52,0x65,0x73,0x70,0x3A,0x0,0x47
	.DB  0x50,0x52,0x53,0x20,0x46,0x61,0x69,0x6C
	.DB  0x65,0x64,0x21,0x0,0x6C,0x65,0x76,0x20
	.DB  0x30,0x0,0x41,0x54,0x2B,0x48,0x54,0x54
	.DB  0x50,0x49,0x4E,0x49,0x54,0x0,0x4F,0x4B
	.DB  0x0,0x6C,0x65,0x76,0x20,0x31,0x0,0x41
	.DB  0x54,0x2B,0x48,0x54,0x54,0x50,0x50,0x41
	.DB  0x52,0x41,0x3D,0x22,0x43,0x49,0x44,0x22
	.DB  0x2C,0x31,0x0,0x6C,0x65,0x76,0x20,0x32
	.DB  0x0,0x25,0x73,0x3F,0x70,0x68,0x6F,0x6E
	.DB  0x65,0x5F,0x6E,0x75,0x6D,0x62,0x65,0x72
	.DB  0x3D,0x25,0x73,0x0,0x41,0x54,0x2B,0x48
	.DB  0x54,0x54,0x50,0x50,0x41,0x52,0x41,0x3D
	.DB  0x22,0x55,0x52,0x4C,0x22,0x2C,0x22,0x25
	.DB  0x73,0x22,0x0,0x6C,0x65,0x76,0x20,0x33
	.DB  0x0,0x41,0x54,0x2B,0x48,0x54,0x54,0x50
	.DB  0x41,0x43,0x54,0x49,0x4F,0x4E,0x3D,0x31
	.DB  0x0,0x2B,0x48,0x54,0x54,0x50,0x41,0x43
	.DB  0x54,0x49,0x4F,0x4E,0x3A,0x0,0x4E,0x6F
	.DB  0x20,0x41,0x63,0x74,0x69,0x6F,0x6E,0x20
	.DB  0x52,0x65,0x73,0x70,0x0,0x6C,0x65,0x76
	.DB  0x20,0x34,0x0,0x2B,0x48,0x54,0x54,0x50
	.DB  0x41,0x43,0x54,0x49,0x4F,0x4E,0x3A,0x20
	.DB  0x25,0x64,0x2C,0x25,0x64,0x2C,0x25,0x64
	.DB  0x0,0x50,0x61,0x72,0x73,0x65,0x20,0x45
	.DB  0x72,0x72,0x0,0x6C,0x65,0x76,0x20,0x35
	.DB  0x0,0x48,0x54,0x54,0x50,0x20,0x53,0x74
	.DB  0x61,0x74,0x75,0x73,0x3A,0x0,0x4E,0x6F
	.DB  0x74,0x20,0x4F,0x4B,0x0,0x6C,0x65,0x76
	.DB  0x20,0x36,0x0,0x41,0x54,0x2B,0x48,0x54
	.DB  0x54,0x50,0x52,0x45,0x41,0x44,0x0,0x6C
	.DB  0x65,0x76,0x20,0x37,0x0,0x41,0x54,0x2B
	.DB  0x48,0x54,0x54,0x50,0x54,0x45,0x52,0x4D
	.DB  0x0,0x6C,0x65,0x76,0x20,0x38,0x0,0x4D
	.DB  0x4F,0x54,0x4F,0x52,0x20,0x25,0x64,0x20
	.DB  0x4F,0x4E,0x21,0x0,0x4D,0x4F,0x54,0x4F
	.DB  0x52,0x20,0x25,0x64,0x20,0x4F,0x46,0x46
	.DB  0x21,0x0,0x68,0x74,0x74,0x70,0x3A,0x2F
	.DB  0x2F,0x31,0x39,0x33,0x2E,0x35,0x2E,0x34
	.DB  0x34,0x2E,0x31,0x39,0x31,0x2F,0x68,0x6F
	.DB  0x6D,0x65,0x2F,0x70,0x6F,0x73,0x74,0x2F
	.DB  0x0,0x2B,0x39,0x38,0x39,0x31,0x35,0x32
	.DB  0x36,0x30,0x38,0x35,0x38,0x32,0x0,0x4D
	.DB  0x6F,0x64,0x75,0x6C,0x65,0x20,0x49,0x6E
	.DB  0x69,0x74,0x2E,0x2E,0x2E,0x0,0x41,0x54
	.DB  0x45,0x30,0x0,0x41,0x54,0x0,0x53,0x4D
	.DB  0x53,0x20,0x49,0x6E,0x69,0x74,0x20,0x46
	.DB  0x61,0x69,0x6C,0x65,0x64,0x21,0x0,0x47
	.DB  0x50,0x52,0x53,0x20,0x49,0x6E,0x69,0x74
	.DB  0x20,0x46,0x61,0x69,0x6C,0x65,0x64,0x21
	.DB  0x0,0x53,0x79,0x73,0x74,0x65,0x6D,0x20
	.DB  0x52,0x65,0x61,0x64,0x79,0x2E,0x0,0x57
	.DB  0x61,0x69,0x74,0x69,0x6E,0x67,0x20,0x66
	.DB  0x6F,0x72,0x20,0x53,0x4D,0x53,0x2E,0x2E
	.DB  0x2E,0x0,0x2B,0x43,0x4D,0x54,0x3A,0x0
	.DB  0x46,0x61,0x69,0x6C,0x65,0x64,0x20,0x74
	.DB  0x6F,0x20,0x72,0x65,0x61,0x64,0x20,0x6D
	.DB  0x73,0x67,0x0,0x73,0x74,0x65,0x70,0x20
	.DB  0x31,0x0,0x73,0x74,0x65,0x70,0x20,0x32
	.DB  0x0,0x53,0x4D,0x53,0x20,0x43,0x6F,0x64
	.DB  0x65,0x3A,0x0,0x45,0x6E,0x74,0x65,0x72
	.DB  0x20,0x63,0x6F,0x64,0x65,0x20,0x6F,0x6E
	.DB  0x20,0x6B,0x65,0x79,0x70,0x61,0x64,0x3A
	.DB  0x0,0x54,0x69,0x6D,0x65,0x6F,0x75,0x74
	.DB  0x21,0x20,0x54,0x72,0x79,0x20,0x61,0x67
	.DB  0x61,0x69,0x6E,0x2E,0x0,0x59,0x6F,0x75
	.DB  0x20,0x70,0x72,0x65,0x73,0x73,0x65,0x64
	.DB  0x3A,0x0,0x43,0x6F,0x64,0x65,0x20,0x69
	.DB  0x73,0x20,0x43,0x4F,0x52,0x52,0x45,0x43
	.DB  0x54,0x21,0x0,0x45,0x72,0x72,0x6F,0x72
	.DB  0x20,0x69,0x6E,0x20,0x65,0x6E,0x74,0x72
	.DB  0x79,0x21,0x0,0x49,0x6E,0x76,0x61,0x6C
	.DB  0x69,0x64,0x20,0x53,0x4D,0x53,0x20,0x43
	.DB  0x6F,0x64,0x65,0x21,0x0,0x59,0x6F,0x75
	.DB  0x20,0x61,0x72,0x65,0x20,0x6E,0x6F,0x74
	.DB  0x20,0x61,0x75,0x74,0x68,0x6F,0x72,0x69
	.DB  0x7A,0x65,0x64,0x21,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0D
	.DW  _0xD
	.DW  _0x0*2+5

	.DW  0x08
	.DW  _0xD+13
	.DW  _0x0*2+18

	.DW  0x0D
	.DW  _0xD+21
	.DW  _0x0*2+26

	.DW  0x14
	.DW  _0x10
	.DW  _0x0*2+39

	.DW  0x0A
	.DW  _0x10+20
	.DW  _0x0*2+59

	.DW  0x12
	.DW  _0x10+30
	.DW  _0x0*2+69

	.DW  0x13
	.DW  _0x10+48
	.DW  _0x0*2+87

	.DW  0x0A
	.DW  _0x10+67
	.DW  _0x0*2+106

	.DW  0x0B
	.DW  _0x10+77
	.DW  _0x0*2+116

	.DW  0x0B
	.DW  _0x10+88
	.DW  _0x0*2+127

	.DW  0x16
	.DW  _0x11
	.DW  _0x0*2+138

	.DW  0x1E
	.DW  _0x11+22
	.DW  _0x0*2+160

	.DW  0x0D
	.DW  _0x11+52
	.DW  _0x0*2+221

	.DW  0x0F
	.DW  _0x11+65
	.DW  _0x0*2+234

	.DW  0x0D
	.DW  _0x11+80
	.DW  _0x0*2+5

	.DW  0x08
	.DW  _0x11+93
	.DW  _0x0*2+18

	.DW  0x06
	.DW  _0x11+101
	.DW  _0x0*2+249

	.DW  0x0D
	.DW  _0x11+107
	.DW  _0x0*2+26

	.DW  0x0D
	.DW  _0x17
	.DW  _0x0*2+255

	.DW  0x06
	.DW  _0x17+13
	.DW  _0x0*2+268

	.DW  0x0C
	.DW  _0x17+19
	.DW  _0x0*2+274

	.DW  0x03
	.DW  _0x17+31
	.DW  _0x0*2+286

	.DW  0x06
	.DW  _0x17+34
	.DW  _0x0*2+289

	.DW  0x14
	.DW  _0x17+40
	.DW  _0x0*2+295

	.DW  0x03
	.DW  _0x17+60
	.DW  _0x0*2+286

	.DW  0x06
	.DW  _0x17+63
	.DW  _0x0*2+315

	.DW  0x03
	.DW  _0x17+69
	.DW  _0x0*2+286

	.DW  0x06
	.DW  _0x17+72
	.DW  _0x0*2+363

	.DW  0x10
	.DW  _0x17+78
	.DW  _0x0*2+369

	.DW  0x0D
	.DW  _0x17+94
	.DW  _0x0*2+385

	.DW  0x0F
	.DW  _0x17+107
	.DW  _0x0*2+398

	.DW  0x06
	.DW  _0x17+122
	.DW  _0x0*2+413

	.DW  0x0D
	.DW  _0x17+128
	.DW  _0x0*2+385

	.DW  0x0A
	.DW  _0x17+141
	.DW  _0x0*2+441

	.DW  0x06
	.DW  _0x17+151
	.DW  _0x0*2+451

	.DW  0x0D
	.DW  _0x17+157
	.DW  _0x0*2+457

	.DW  0x03
	.DW  _0x17+170
	.DW  _0x0*2+286

	.DW  0x07
	.DW  _0x17+173
	.DW  _0x0*2+470

	.DW  0x06
	.DW  _0x17+180
	.DW  _0x0*2+477

	.DW  0x0C
	.DW  _0x17+186
	.DW  _0x0*2+483

	.DW  0x03
	.DW  _0x17+198
	.DW  _0x0*2+286

	.DW  0x06
	.DW  _0x17+201
	.DW  _0x0*2+495

	.DW  0x0C
	.DW  _0x17+207
	.DW  _0x0*2+501

	.DW  0x03
	.DW  _0x17+219
	.DW  _0x0*2+286

	.DW  0x06
	.DW  _0x17+222
	.DW  _0x0*2+513

	.DW  0x1F
	.DW  _0x37
	.DW  _0x0*2+546

	.DW  0x0E
	.DW  _0x37+31
	.DW  _0x0*2+577

	.DW  0x0F
	.DW  _0x37+45
	.DW  _0x0*2+591

	.DW  0x05
	.DW  _0x37+60
	.DW  _0x0*2+606

	.DW  0x03
	.DW  _0x37+65
	.DW  _0x0*2+611

	.DW  0x11
	.DW  _0x37+68
	.DW  _0x0*2+614

	.DW  0x12
	.DW  _0x37+85
	.DW  _0x0*2+631

	.DW  0x0E
	.DW  _0x37+103
	.DW  _0x0*2+649

	.DW  0x13
	.DW  _0x37+117
	.DW  _0x0*2+663

	.DW  0x06
	.DW  _0x37+136
	.DW  _0x0*2+682

	.DW  0x13
	.DW  _0x37+142
	.DW  _0x0*2+688

	.DW  0x07
	.DW  _0x37+161
	.DW  _0x0*2+707

	.DW  0x07
	.DW  _0x37+168
	.DW  _0x0*2+714

	.DW  0x0A
	.DW  _0x37+175
	.DW  _0x0*2+721

	.DW  0x16
	.DW  _0x37+185
	.DW  _0x0*2+731

	.DW  0x14
	.DW  _0x37+207
	.DW  _0x0*2+753

	.DW  0x0D
	.DW  _0x37+227
	.DW  _0x0*2+773

	.DW  0x11
	.DW  _0x37+240
	.DW  _0x0*2+786

	.DW  0x10
	.DW  _0x37+257
	.DW  _0x0*2+803

	.DW  0x12
	.DW  _0x37+273
	.DW  _0x0*2+819

	.DW  0x18
	.DW  _0x37+291
	.DW  _0x0*2+837

	.DW  0x0E
	.DW  _0x37+315
	.DW  _0x0*2+649

	.DW  0x13
	.DW  _0x37+329
	.DW  _0x0*2+663

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
;#include <glcd.h>
;#include <font5x7.h>
;#include <stdio.h>
;#include <string.h>
;#include <stdlib.h> // »—«Ì «” ›«œÂ «“  «»⁄ atoi
;
;// #define F_CPU 8000000UL
;#include <delay.h>
;
;// ---  ‰ŸÌ„«  «’·Ì ---
;#define APN "mcinet" // APN «Å—« Ê— ŒÊœ —« Ê«—œ ò‰Ìœ
;//#define SERVER_URL "http://google.com/api/authorize" // ¬œ—” ò«„· ”—Ê— ŒÊœ —« «Ì‰Ã« ﬁ—«— œÂÌœ
;#define SERVER_URL_POST "http://193.5.44.191/home/post/"
;
;#define HTTP_TIMEOUT_MS 500
;
;// --- »«›—Â«Ì ”—«”—Ì ---
;char header_buffer[100];
;char content_buffer[100];
;char ip_address_buffer[16];
;char phone_number[16];
;char response_buffer[256]; // «›“«Ì‘ ”«Ì“ »«›— »—«Ì œ—Ì«›  Å«”ŒùÂ«Ì HTTP
;
;// ---  ⁄—Ì› ÅÌ‰ùÂ«Ì „Ê Ê— ---
;#define MOTOR_DDR DDRE
;#define MOTOR_PORT PORTE
;#define MOTOR_PIN_1 2
;#define MOTOR_PIN_2 3
;#define MOTOR_PIN_3 4
;
;// ---  ⁄—Ì› ÅÌ‰ùÂ«Ì òÌùÅœ ---
;#define KEYPAD_PORT PORTC
;#define KEYPAD_DDR DDRC
;#define KEYPAD_PIN PINC
;#define COL1_PIN 0
;#define COL2_PIN 1
;#define COL3_PIN 2
;#define ROW1_PIN 7
;#define ROW2_PIN 5
;#define ROW3_PIN 6
;#define ROW4_PIN 4
;
;//  «»⁄ «—”«· œ” Ê— AT »Â „«éÊ·
;void send_at_command(char *command)
; 0000 002E {

	.CSEG
_send_at_command:
; .FSTART _send_at_command
; 0000 002F     printf("%s\r\n", command);
	ST   -Y,R27
	ST   -Y,R26
;	*command -> Y+0
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x0
	CALL _printf
	ADIW R28,6
; 0000 0030 }
	JMP  _0x212000E
; .FEND
;
;unsigned char read_serial_response(char* buffer, int buffer_size, int timeout_ms, char* expected_response) {
; 0000 0032 unsigned char read_serial_response(char* buffer, int buffer_size, int timeout_ms, char* expected_response) {
_read_serial_response:
; .FSTART _read_serial_response
; 0000 0033     int i = 0;
; 0000 0034     unsigned int timeout_counter = 0;
; 0000 0035     char c;
; 0000 0036 
; 0000 0037     // Clear the buffer at the start
; 0000 0038     memset(buffer, 0, buffer_size);
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR6
;	*buffer -> Y+12
;	buffer_size -> Y+10
;	timeout_ms -> Y+8
;	*expected_response -> Y+6
;	i -> R16,R17
;	timeout_counter -> R18,R19
;	c -> R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	CALL SUBOPT_0x1
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CALL _memset
; 0000 0039 
; 0000 003A     // Loop until the timeout period is reached
; 0000 003B     while (timeout_counter < timeout_ms) {
_0x3:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x5
; 0000 003C         // This is the correct way to check if a character has been received on USART0
; 0000 003D         if (UCSR0A & (1 << RXC0)) {
	SBIS 0xB,7
	RJMP _0x6
; 0000 003E             c = getchar(); // Read the character from the buffer
	CALL _getchar
	MOV  R21,R30
; 0000 003F             if (i < (buffer_size - 1)) {
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SBIW R30,1
	CP   R16,R30
	CPC  R17,R31
	BRGE _0x7
; 0000 0040                 buffer[i++] = c; // Add it to our response buffer
	MOVW R30,R16
	__ADDWRN 16,17,1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R21
; 0000 0041             }
; 0000 0042             // Optional: You can reset the timeout counter each time a character is received
; 0000 0043             // to wait for the *entire* message to finish. For simplicity, we'll use a fixed timeout.
; 0000 0044         } else {
_0x7:
	RJMP _0x8
_0x6:
; 0000 0045             // If no character is waiting, wait 1ms and increment the counter
; 0000 0046             delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 0047             timeout_counter++;
	__ADDWRN 18,19,1
; 0000 0048         }
_0x8:
; 0000 0049     }
	RJMP _0x3
_0x5:
; 0000 004A 
; 0000 004B     // After the loop finishes, check if the expected text exists in the buffer
; 0000 004C     if (strstr(buffer, expected_response) != NULL) {
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	CALL _strstr
	SBIW R30,0
	BREQ _0x9
; 0000 004D         return 1; // Success!
	LDI  R30,LOW(1)
	RJMP _0x2120014
; 0000 004E     }
; 0000 004F 
; 0000 0050     return 0; // Failed to find the response
_0x9:
	LDI  R30,LOW(0)
_0x2120014:
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; 0000 0051 }
; .FEND
;
;
;void usart_puts(const char* str)
; 0000 0055 {
; 0000 0056     while (*str)
;	*str -> Y+0
; 0000 0057     {
; 0000 0058         putchar(*str++); // 'usart_putchar' is your function to send a single byte
; 0000 0059     }
; 0000 005A }
;
;
;unsigned char check_gprs_status(void) {
; 0000 005D unsigned char check_gprs_status(void) {
_check_gprs_status:
; .FSTART _check_gprs_status
; 0000 005E     char response[100];
; 0000 005F 
; 0000 0060     send_at_command("AT+SAPBR=2,1");
	SBIW R28,63
	SBIW R28,37
;	response -> Y+0
	__POINTW2MN _0xD,0
	CALL SUBOPT_0x2
; 0000 0061     if (read_serial_response(response, sizeof(response), 200, "+SAPBR:")) {
	__POINTW2MN _0xD,13
	RCALL _read_serial_response
	CPI  R30,0
	BREQ _0xE
; 0000 0062         if (strstr(response, "+SAPBR: 1,1,") != NULL) {
	CALL SUBOPT_0x3
	__POINTW2MN _0xD,21
	CALL _strstr
	SBIW R30,0
	BREQ _0xF
; 0000 0063             return 1; // Already connected
	LDI  R30,LOW(1)
	RJMP _0x2120013
; 0000 0064         }
; 0000 0065     }
_0xF:
; 0000 0066     return 0; // Not connected
_0xE:
	LDI  R30,LOW(0)
_0x2120013:
	ADIW R28,63
	ADIW R28,37
	RET
; 0000 0067 }
; .FEND

	.DSEG
_0xD:
	.BYTE 0x22
;
;
;unsigned char init_sms(void)
; 0000 006B {

	.CSEG
_init_sms:
; .FSTART _init_sms
; 0000 006C     glcd_clear();
	CALL SUBOPT_0x4
; 0000 006D     glcd_outtextxy(0, 0, "Setting SMS Mode...");
	__POINTW2MN _0x10,0
	CALL _glcd_outtextxy
; 0000 006E     send_at_command("AT+CMGF=1");
	__POINTW2MN _0x10,20
	CALL SUBOPT_0x5
; 0000 006F     delay_ms(100);
; 0000 0070 
; 0000 0071     send_at_command("AT+CNMI=2,2,0,0,0");
	__POINTW2MN _0x10,30
	CALL SUBOPT_0x5
; 0000 0072     delay_ms(100);
; 0000 0073 
; 0000 0074     send_at_command("AT+CMGDA=\"DEL ALL\"");
	__POINTW2MN _0x10,48
	RCALL _send_at_command
; 0000 0075     delay_ms(200);
	CALL SUBOPT_0x6
; 0000 0076 
; 0000 0077 
; 0000 0078     // «ÿ„Ì‰«‰ «“ ›⁄«· »Êœ‰ ò«„· „«éÊ· Ê €Ì—›⁄«· »Êœ‰ sleep
; 0000 0079     send_at_command("AT+CFUN=1");    // ›⁄«·ù”«“Ì ò«„· „«éÊ·
	__POINTW2MN _0x10,67
	CALL SUBOPT_0x5
; 0000 007A     delay_ms(100);
; 0000 007B     send_at_command("AT+CSCLK=0");   // €Ì—›⁄«·ù”«“Ì Õ«·  sleep
	__POINTW2MN _0x10,77
	CALL SUBOPT_0x5
; 0000 007C     delay_ms(100);
; 0000 007D 
; 0000 007E     glcd_outtextxy(0, 10, "SMS Ready.");
	CALL SUBOPT_0x7
	__POINTW2MN _0x10,88
	CALL SUBOPT_0x8
; 0000 007F     delay_ms(200);
; 0000 0080     return 1;
	LDI  R30,LOW(1)
	RET
; 0000 0081 }
; .FEND

	.DSEG
_0x10:
	.BYTE 0x63
;
;
;unsigned char init_GPRS(void)
; 0000 0085 {

	.CSEG
_init_GPRS:
; .FSTART _init_GPRS
; 0000 0086     char at_command[50];
; 0000 0087     char response[100]; // Local buffer for the response
; 0000 0088 
; 0000 0089     glcd_clear();
	SBIW R28,63
	SBIW R28,63
	SBIW R28,24
;	at_command -> Y+100
;	response -> Y+0
	CALL SUBOPT_0x4
; 0000 008A     glcd_outtextxy(0, 0, "Connecting to GPRS...");
	__POINTW2MN _0x11,0
	CALL _glcd_outtextxy
; 0000 008B 
; 0000 008C     send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
	__POINTW2MN _0x11,22
	CALL SUBOPT_0x9
; 0000 008D     delay_ms(300);
; 0000 008E 
; 0000 008F     sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
	MOVW R30,R28
	SUBI R30,LOW(-(100))
	SBCI R31,HIGH(-(100))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,190
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,214
	CALL SUBOPT_0x0
	CALL _sprintf
	ADIW R28,8
; 0000 0090     send_at_command(at_command);
	MOVW R26,R28
	SUBI R26,LOW(-(100))
	SBCI R27,HIGH(-(100))
	CALL SUBOPT_0x9
; 0000 0091     delay_ms(300);
; 0000 0092 
; 0000 0093     send_at_command("AT+SAPBR=1,1");
	__POINTW2MN _0x11,52
	CALL SUBOPT_0x9
; 0000 0094     delay_ms(300);
; 0000 0095 
; 0000 0096     glcd_clear();
	CALL SUBOPT_0x4
; 0000 0097     glcd_outtextxy(0, 0, "Fetching IP...");
	__POINTW2MN _0x11,65
	CALL _glcd_outtextxy
; 0000 0098     send_at_command("AT+SAPBR=2,1"); // Request IP
	__POINTW2MN _0x11,80
	CALL SUBOPT_0x2
; 0000 0099     // delay_ms(5000);
; 0000 009A 
; 0000 009B     // Attempt to read the response for 5 seconds, looking for "+SAPBR:"
; 0000 009C     // FIX: Added the 4th argument, "+SAPBR:", to the function call.
; 0000 009D     if (read_serial_response(response, sizeof(response), 200, "+SAPBR:")) {
	__POINTW2MN _0x11,93
	RCALL _read_serial_response
	CPI  R30,0
	BREQ _0x12
; 0000 009E         glcd_outtextxy(0, 10, "Resp:");
	CALL SUBOPT_0x7
	__POINTW2MN _0x11,101
	CALL SUBOPT_0xA
; 0000 009F         glcd_outtextxy(0, 20, response); // Display the received response for debugging
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x8
; 0000 00A0         delay_ms(200);
; 0000 00A1 
; 0000 00A2         // Check if the response contains the IP address part
; 0000 00A3         if (strstr(response, "+SAPBR: 1,1,") != NULL) {
	CALL SUBOPT_0x3
	__POINTW2MN _0x11,107
	CALL _strstr
	SBIW R30,0
	BREQ _0x13
; 0000 00A4             char* token = strtok(response, "\"");
; 0000 00A5             token = strtok(NULL, "\"");
	SBIW R28,2
;	at_command -> Y+102
;	response -> Y+2
;	*token -> Y+0
	MOVW R30,R28
	ADIW R30,2
	CALL SUBOPT_0xB
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0xB
; 0000 00A6 
; 0000 00A7             if (token) {
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BREQ _0x14
; 0000 00A8                 strcpy(ip_address_buffer, token);
	LDI  R30,LOW(_ip_address_buffer)
	LDI  R31,HIGH(_ip_address_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _strcpy
; 0000 00A9                 return 1; // Success
	LDI  R30,LOW(1)
	ADIW R28,2
	RJMP _0x2120012
; 0000 00AA             }
; 0000 00AB         }
_0x14:
	ADIW R28,2
; 0000 00AC     }
_0x13:
; 0000 00AD 
; 0000 00AE     // If we reach here, it means getting the IP address failed
; 0000 00AF     return 0; // Failure
_0x12:
	LDI  R30,LOW(0)
_0x2120012:
	ADIW R28,63
	ADIW R28,63
	ADIW R28,24
	RET
; 0000 00B0 }
; .FEND

	.DSEG
_0x11:
	.BYTE 0x78
;
;
;unsigned char send_json_post(const char* base_url, const char* phone_number) {
; 0000 00B3 unsigned char send_json_post(const char* base_url, const char* phone_number) {

	.CSEG
_send_json_post:
; .FSTART _send_json_post
; 0000 00B4     char cmd[256];
; 0000 00B5     char response[256];
; 0000 00B6     char full_url[256];
; 0000 00B7     char* action_ptr;
; 0000 00B8     int method = 0, status_code = 0, data_len = 0;
; 0000 00B9 
; 0000 00BA     if (!check_gprs_status()) {
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,2
	SUBI R29,3
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL __SAVELOCR6
;	*base_url -> Y+778
;	*phone_number -> Y+776
;	cmd -> Y+520
;	response -> Y+264
;	full_url -> Y+8
;	*action_ptr -> R16,R17
;	method -> R18,R19
;	status_code -> R20,R21
;	data_len -> Y+6
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	RCALL _check_gprs_status
	CPI  R30,0
	BRNE _0x15
; 0000 00BB         if (!init_GPRS()) {
	RCALL _init_GPRS
	CPI  R30,0
	BRNE _0x16
; 0000 00BC             glcd_clear();
	CALL SUBOPT_0x4
; 0000 00BD             glcd_outtextxy(0, 0, "GPRS Failed!");
	__POINTW2MN _0x17,0
	CALL SUBOPT_0xC
; 0000 00BE             delay_ms(1000);
; 0000 00BF             return 0;
	LDI  R30,LOW(0)
	RJMP _0x2120011
; 0000 00C0         }
; 0000 00C1     }
_0x16:
; 0000 00C2 
; 0000 00C3 
; 0000 00C4     glcd_clear();
_0x15:
	CALL _glcd_clear
; 0000 00C5     glcd_outtextxy(0,10,phone_number);
	CALL SUBOPT_0x7
	__GETW2SX 778
	CALL SUBOPT_0xA
; 0000 00C6     glcd_outtextxy(0,20,"lev 0");
	__POINTW2MN _0x17,13
	CALL _glcd_outtextxy
; 0000 00C7 
; 0000 00C8     // 1. Initialize HTTP service
; 0000 00C9     send_at_command("AT+HTTPINIT");
	__POINTW2MN _0x17,19
	CALL SUBOPT_0xD
; 0000 00CA     if (!read_serial_response(response, sizeof(response), 100, "OK")) return 0;
	__POINTW2MN _0x17,31
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0x18
	LDI  R30,LOW(0)
	RJMP _0x2120011
; 0000 00CB 
; 0000 00CC //    glcd_clear();
; 0000 00CD //    glcd_outtextxy(0,10,phone_number);
; 0000 00CE     glcd_outtextxy(0,20,"lev 1");
_0x18:
	CALL SUBOPT_0xE
	__POINTW2MN _0x17,34
	CALL _glcd_outtextxy
; 0000 00CF 
; 0000 00D0     // 2. Set CID to bearer profile 1
; 0000 00D1     send_at_command("AT+HTTPPARA=\"CID\",1");
	__POINTW2MN _0x17,40
	CALL SUBOPT_0xD
; 0000 00D2     if (!read_serial_response(response, sizeof(response), 100, "OK")) return 0;
	__POINTW2MN _0x17,60
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0x19
	LDI  R30,LOW(0)
	RJMP _0x2120011
; 0000 00D3 
; 0000 00D4     glcd_outtextxy(0,20,"lev 2");
_0x19:
	CALL SUBOPT_0xE
	__POINTW2MN _0x17,63
	CALL _glcd_outtextxy
; 0000 00D5 
; 0000 00D6     // 3. Build the full URL with query parameter
; 0000 00D7     sprintf(full_url, "%s?phone_number=%s", base_url, phone_number);
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,321
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 782
	CALL SUBOPT_0xF
	__GETW1SX 784
	CALL SUBOPT_0xF
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 00D8 
; 0000 00D9     // 4. Set the target URL
; 0000 00DA     sprintf(cmd, "AT+HTTPPARA=\"URL\",\"%s\"", full_url);
	MOVW R30,R28
	SUBI R30,LOW(-(520))
	SBCI R31,HIGH(-(520))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,340
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,12
	CALL SUBOPT_0x0
	CALL _sprintf
	ADIW R28,8
; 0000 00DB     send_at_command(cmd);
	MOVW R26,R28
	SUBI R26,LOW(-(520))
	SBCI R27,HIGH(-(520))
	CALL SUBOPT_0xD
; 0000 00DC     if (!read_serial_response(response, sizeof(response), 100, "OK")) return 0;
	__POINTW2MN _0x17,69
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0x1A
	LDI  R30,LOW(0)
	RJMP _0x2120011
; 0000 00DD 
; 0000 00DE     glcd_outtextxy(0,20,"lev 3");
_0x1A:
	CALL SUBOPT_0xE
	__POINTW2MN _0x17,72
	CALL _glcd_outtextxy
; 0000 00DF 
; 0000 00E0     // 5. Start POST action
; 0000 00E1     send_at_command("AT+HTTPACTION=1");
	__POINTW2MN _0x17,78
	RCALL _send_at_command
; 0000 00E2     if (!read_serial_response(response, sizeof(response), HTTP_TIMEOUT_MS, "+HTTPACTION:")) {
	MOVW R30,R28
	SUBI R30,LOW(-(264))
	SBCI R31,HIGH(-(264))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x17,94
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0x1B
; 0000 00E3         glcd_clear();
	CALL SUBOPT_0x4
; 0000 00E4         glcd_outtextxy(0,0,"No Action Resp");
	__POINTW2MN _0x17,107
	CALL _glcd_outtextxy
; 0000 00E5         delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 00E6         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2120011
; 0000 00E7     }
; 0000 00E8 
; 0000 00E9     glcd_outtextxy(0,20,"lev 4");
_0x1B:
	CALL SUBOPT_0xE
	__POINTW2MN _0x17,122
	CALL _glcd_outtextxy
; 0000 00EA 
; 0000 00EB     // 6. Parse status code from response
; 0000 00EC 
; 0000 00ED     action_ptr = strstr(response, "+HTTPACTION:");
	MOVW R30,R28
	SUBI R30,LOW(-(264))
	SBCI R31,HIGH(-(264))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x17,128
	CALL _strstr
	MOVW R16,R30
; 0000 00EE     if (action_ptr == NULL || sscanf(action_ptr, "+HTTPACTION: %d,%d,%d", &method, &status_code, &data_len) != 3) {
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BREQ _0x1D
	ST   -Y,R17
	ST   -Y,R16
	__POINTW1FN _0x0,419
	ST   -Y,R31
	ST   -Y,R30
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	CALL __PUTPARD1L
	PUSH R19
	PUSH R18
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	CALL __PUTPARD1L
	PUSH R21
	PUSH R20
	MOVW R30,R28
	ADIW R30,18
	CALL SUBOPT_0xF
	LDI  R24,12
	CALL _sscanf
	ADIW R28,16
	POP  R20
	POP  R21
	POP  R18
	POP  R19
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ _0x1C
_0x1D:
; 0000 00EF         glcd_clear();
	CALL SUBOPT_0x4
; 0000 00F0         glcd_outtextxy(0,0,"Parse Err");
	__POINTW2MN _0x17,141
	CALL SUBOPT_0x10
; 0000 00F1         glcd_outtextxy(0,10,response);  // ‰„«Ì‘ „Õ Ê«Ì response ò«„· »—«Ì œÌ»«ê
	MOVW R26,R28
	SUBI R26,LOW(-(266))
	SBCI R27,HIGH(-(266))
	CALL _glcd_outtextxy
; 0000 00F2         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 00F3         return 0;
	LDI  R30,LOW(0)
	RJMP _0x2120011
; 0000 00F4     }
; 0000 00F5 
; 0000 00F6     glcd_outtextxy(0,20,"lev 5");
_0x1C:
	CALL SUBOPT_0xE
	__POINTW2MN _0x17,151
	CALL _glcd_outtextxy
; 0000 00F7     //delay_ms(200);
; 0000 00F8     // 7. Show response based on status
; 0000 00F9     glcd_clear();
	CALL SUBOPT_0x4
; 0000 00FA     glcd_outtextxy(0,0,"HTTP Status:");
	__POINTW2MN _0x17,157
	CALL SUBOPT_0x11
; 0000 00FB     if (status_code == 200) {
	BRNE _0x1F
; 0000 00FC         glcd_outtextxy(0,10,"OK");
	CALL SUBOPT_0x7
	__POINTW2MN _0x17,170
	RJMP _0x57
; 0000 00FD     } else {
_0x1F:
; 0000 00FE         glcd_outtextxy(0,10,"Not OK");
	CALL SUBOPT_0x7
	__POINTW2MN _0x17,173
_0x57:
	CALL _glcd_outtextxy
; 0000 00FF     }
; 0000 0100     //delay_ms(200);
; 0000 0101     glcd_outtextxy(0,20,"lev 6");
	CALL SUBOPT_0xE
	__POINTW2MN _0x17,180
	CALL _glcd_outtextxy
; 0000 0102 
; 0000 0103     // 8. Read server response if needed
; 0000 0104     send_at_command("AT+HTTPREAD");
	__POINTW2MN _0x17,186
	CALL SUBOPT_0xD
; 0000 0105     read_serial_response(response, sizeof(response), 100, "OK");
	__POINTW2MN _0x17,198
	RCALL _read_serial_response
; 0000 0106 
; 0000 0107     glcd_outtextxy(0,20,"lev 7");
	CALL SUBOPT_0xE
	__POINTW2MN _0x17,201
	CALL _glcd_outtextxy
; 0000 0108 
; 0000 0109     // 9. Terminate HTTP service
; 0000 010A     send_at_command("AT+HTTPTERM");
	__POINTW2MN _0x17,207
	CALL SUBOPT_0xD
; 0000 010B     read_serial_response(response, sizeof(response), 100, "OK");
	__POINTW2MN _0x17,219
	RCALL _read_serial_response
; 0000 010C 
; 0000 010D     glcd_outtextxy(0,20,"lev 8");
	CALL SUBOPT_0xE
	__POINTW2MN _0x17,222
	CALL SUBOPT_0x11
; 0000 010E     return (status_code == 200) ? 1 : 0;
	BRNE _0x21
	LDI  R30,LOW(1)
	RJMP _0x22
_0x21:
	LDI  R30,LOW(0)
_0x22:
_0x2120011:
	CALL __LOADLOCR6
	ADIW R28,12
	SUBI R29,-3
	RET
; 0000 010F }
; .FEND

	.DSEG
_0x17:
	.BYTE 0xE4
;
;
;///////////////////////////////////////////////////////////////////////////////////////////
;
;
;
;
;
;//unsigned char init_GPRS(void)
;//{
;//    char at_command[50];
;//    char response[100]; // Local buffer for the response
;//
;//    glcd_clear();
;//    glcd_outtextxy(0, 0, "Connecting to GPRS...");
;//
;//    send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
;//    delay_ms(300);
;//
;//    sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
;//    send_at_command(at_command);
;//    delay_ms(300);
;//
;//    send_at_command("AT+SAPBR=1,1");
;//    delay_ms(300);
;//
;//    glcd_clear();
;//    glcd_outtextxy(0, 0, "Fetching IP...");
;//    send_at_command("AT+SAPBR=2,1"); // Request IP
;//    // delay_ms(5000);
;//
;//    // Attempt to read the response for 5 seconds, looking for "+SAPBR:"
;//    // FIX: Added the 4th argument, "+SAPBR:", to the function call.
;//    if (read_serial_response(response, sizeof(response), 200, "+SAPBR:")) {
;//        glcd_outtextxy(0, 10, "Resp:");
;//        glcd_outtextxy(0, 20, response); // Display the received response for debugging
;//        delay_ms(200);
;//
;//        // Check if the response contains the IP address part
;//        if (strstr(response, "+SAPBR: 1,1,") != NULL) {
;//            char* token = strtok(response, "\"");
;//            token = strtok(NULL, "\"");
;//
;//            if (token) {
;//                strcpy(ip_address_buffer, token);
;//                return 1; // Success
;//            }
;//        }
;//    }
;//
;//    // If we reach here, it means getting the IP address failed
;//    return 0; // Failure
;//}
;
;
;
;
;char get_key(void)
; 0000 014A {

	.CSEG
_get_key:
; .FSTART _get_key
; 0000 014B     unsigned char row, col;
; 0000 014C     const unsigned char column_pins[3] = {COL1_PIN, COL2_PIN, COL3_PIN};
; 0000 014D     const unsigned char row_pins[4] = {ROW1_PIN, ROW2_PIN, ROW3_PIN, ROW4_PIN};
; 0000 014E 
; 0000 014F     const char key_map[4][3] = {
; 0000 0150         {'1', '2', '3'},
; 0000 0151         {'4', '5', '6'},
; 0000 0152         {'7', '8', '9'},
; 0000 0153         {'*', '0', '#'}
; 0000 0154     };
; 0000 0155 
; 0000 0156     for (col = 0; col < 3; col++)
	SBIW R28,19
	LDI  R24,19
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x24*2)
	LDI  R31,HIGH(_0x24*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	row -> R17
;	col -> R16
;	column_pins -> Y+18
;	row_pins -> Y+14
;	key_map -> Y+2
	LDI  R16,LOW(0)
_0x26:
	CPI  R16,3
	BRSH _0x27
; 0000 0157     {
; 0000 0158         KEYPAD_PORT |= (1 << COL1_PIN) | (1 << COL2_PIN) | (1 << COL3_PIN);
	IN   R30,0x15
	ORI  R30,LOW(0x7)
	OUT  0x15,R30
; 0000 0159         KEYPAD_PORT &= ~(1 << column_pins[col]);
	IN   R1,21
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,18
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R26,LOW(1)
	CALL SUBOPT_0x12
	OUT  0x15,R30
; 0000 015A 
; 0000 015B         for (row = 0; row < 4; row++)
	LDI  R17,LOW(0)
_0x29:
	CPI  R17,4
	BRSH _0x2A
; 0000 015C         {
; 0000 015D             if (!(KEYPAD_PIN & (1 << row_pins[row])))
	CALL SUBOPT_0x13
	BRNE _0x2B
; 0000 015E             {
; 0000 015F                 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0160 
; 0000 0161                 if (!(KEYPAD_PIN & (1 << row_pins[row])))
	CALL SUBOPT_0x13
	BRNE _0x2C
; 0000 0162                 {
; 0000 0163                     while (!(KEYPAD_PIN & (1 << row_pins[row])));
_0x2D:
	CALL SUBOPT_0x13
	BREQ _0x2D
; 0000 0164                     return key_map[row][col];
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
	RJMP _0x2120010
; 0000 0165                 }
; 0000 0166             }
_0x2C:
; 0000 0167         }
_0x2B:
	SUBI R17,-1
	RJMP _0x29
_0x2A:
; 0000 0168     }
	SUBI R16,-1
	RJMP _0x26
_0x27:
; 0000 0169 
; 0000 016A     // C?? ??? ???I? ?O?I? ?OI? E?I? ??IC? ??? (NULL) ?C E???IC?
; 0000 016B     return 0;
	LDI  R30,LOW(0)
_0x2120010:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,21
	RET
; 0000 016C }
; .FEND
;
;
;
;
;void activate_motor(int product_id)
; 0000 0172 {
_activate_motor:
; .FSTART _activate_motor
; 0000 0173     unsigned char motor_pin;
; 0000 0174     char motor_msg[20];
; 0000 0175 
; 0000 0176     switch (product_id)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,20
	ST   -Y,R17
;	product_id -> Y+21
;	motor_pin -> R17
;	motor_msg -> Y+1
	LDD  R30,Y+21
	LDD  R31,Y+21+1
; 0000 0177     {
; 0000 0178         case 1: motor_pin = MOTOR_PIN_1; break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x33
	LDI  R17,LOW(2)
	RJMP _0x32
; 0000 0179         case 2: motor_pin = MOTOR_PIN_2; break;
_0x33:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x34
	LDI  R17,LOW(3)
	RJMP _0x32
; 0000 017A         case 3: motor_pin = MOTOR_PIN_3; break;
_0x34:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x36
	LDI  R17,LOW(4)
	RJMP _0x32
; 0000 017B         default: return;
_0x36:
	RJMP _0x212000F
; 0000 017C     }
_0x32:
; 0000 017D 
; 0000 017E     sprintf(motor_msg, "MOTOR %d ON!", product_id);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,519
	CALL SUBOPT_0x14
; 0000 017F     glcd_clear();
	CALL SUBOPT_0x15
; 0000 0180     glcd_outtextxy(10, 20, motor_msg);
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL _glcd_outtextxy
; 0000 0181     MOTOR_PORT |= (1 << motor_pin);
	IN   R1,3
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x3,R30
; 0000 0182     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
; 0000 0183     MOTOR_PORT &= ~(1 << motor_pin);
	IN   R1,3
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL SUBOPT_0x12
	OUT  0x3,R30
; 0000 0184 
; 0000 0185     sprintf(motor_msg, "MOTOR %d OFF!", product_id);
	MOVW R30,R28
	ADIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,532
	CALL SUBOPT_0x14
; 0000 0186     glcd_outtextxy(10, 40, motor_msg);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(40)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,3
	CALL SUBOPT_0x8
; 0000 0187     delay_ms(200);
; 0000 0188 }
_0x212000F:
	LDD  R17,Y+0
	ADIW R28,23
	RET
; .FEND
;
;///////////////////////////////////////////////////////////////////////////////////
;
;void main(void)
; 0000 018D {
_main:
; .FSTART _main
; 0000 018E     const char* server_url = "http://193.5.44.191/home/post/";
; 0000 018F     const char* my_phone    = "+989152608582";
; 0000 0190 
; 0000 0191     GLCDINIT_t glcd_init_data;
; 0000 0192 
; 0000 0193     // --- C?? EIO ??IC?I?? C???? ???E??C ? USART C?E ?? C? ?I I?IEC? ??? OI? ---
; 0000 0194     // --- ? ???? C?E. ??C?? E? EU??? A? ???E.                             ---
; 0000 0195     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,6
;	*server_url -> R16,R17
;	*my_phone -> R18,R19
;	glcd_init_data -> Y+0
	__POINTWRMN 16,17,_0x37,0
	__POINTWRMN 18,19,_0x37,31
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0196     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0197     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0198     PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 0199     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 019A     PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 019B     DDRE=(0<<DDE7) | (0<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (0<<DDE1) | (0<<DDE0);
	LDI  R30,LOW(60)
	OUT  0x2,R30
; 0000 019C     PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 019D     DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 019E     PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 019F     UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 01A0     UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 01A1     UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 01A2     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 01A3     UBRR0L=0x33; // 9600 Baud Rate for 8MHz clock
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 01A4     MCUCSR = (1 << JTD);
	LDI  R30,LOW(128)
	OUT  0x34,R30
; 0000 01A5     MCUCSR = (1 << JTD);
	OUT  0x34,R30
; 0000 01A6     glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 01A7     glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 01A8     glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 01A9     glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 01AA     glcd_setfont(font5x7);
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	CALL SUBOPT_0x16
; 0000 01AB     // --- ?C?C? EIO ??IC?I?? C???? ---
; 0000 01AC 
; 0000 01AD     glcd_clear();
	CALL SUBOPT_0x4
; 0000 01AE     glcd_outtextxy(0, 0, "Module Init...");
	__POINTW2MN _0x37,45
	CALL _glcd_outtextxy
; 0000 01AF     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 01B0 
; 0000 01B1     send_at_command("ATE0");
	__POINTW2MN _0x37,60
	CALL SUBOPT_0x9
; 0000 01B2     delay_ms(300);
; 0000 01B3     send_at_command("AT");
	__POINTW2MN _0x37,65
	CALL SUBOPT_0x9
; 0000 01B4     delay_ms(300);
; 0000 01B5 
; 0000 01B6     if (!init_sms()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
	RCALL _init_sms
	CPI  R30,0
	BRNE _0x38
	CALL SUBOPT_0x7
	__POINTW2MN _0x37,68
	CALL _glcd_outtextxy
_0x39:
	RJMP _0x39
; 0000 01B7     if (!init_GPRS()) { glcd_outtextxy(0, 10, "GPRS Init Failed!"); while(1); }
_0x38:
	RCALL _init_GPRS
	CPI  R30,0
	BRNE _0x3C
	CALL SUBOPT_0x7
	__POINTW2MN _0x37,85
	CALL _glcd_outtextxy
_0x3D:
	RJMP _0x3D
; 0000 01B8 
; 0000 01B9     glcd_clear();
_0x3C:
	CALL SUBOPT_0x4
; 0000 01BA     glcd_outtextxy(0, 0, "System Ready.");
	__POINTW2MN _0x37,103
	CALL SUBOPT_0x10
; 0000 01BB     glcd_outtextxy(0, 10, "Waiting for SMS...");
	__POINTW2MN _0x37,117
	CALL _glcd_outtextxy
; 0000 01BC 
; 0000 01BD 
; 0000 01BE //    glcd_clear();
; 0000 01BF //    glcd_outtextxy(0,0,"Sending POST...");
; 0000 01C0 //    if (send_json_post(server_url, my_phone)) {
; 0000 01C1 //        glcd_outtextxy(0,10,"POST OK");
; 0000 01C2 //    } else {
; 0000 01C3 //        glcd_outtextxy(0,10,"POST Fail");
; 0000 01C4 //    }
; 0000 01C5 
; 0000 01C6     while (1)
_0x40:
; 0000 01C7     {
; 0000 01C8         char sms_char;
; 0000 01C9         char key_pressed;
; 0000 01CA         char display_buffer[2] = {0};
; 0000 01CB         int product_id = 0;
; 0000 01CC         int timeout_counter = 0;
; 0000 01CD         char* token;
; 0000 01CE 
; 0000 01CF         char content_buffer[32];
; 0000 01D0         memset(header_buffer, 0, sizeof(header_buffer));
	SBIW R28,42
	LDI  R30,LOW(0)
	STD  Y+34,R30
	STD  Y+35,R30
	STD  Y+36,R30
	STD  Y+37,R30
	STD  Y+38,R30
	STD  Y+39,R30
;	glcd_init_data -> Y+42
;	sms_char -> Y+41
;	key_pressed -> Y+40
;	display_buffer -> Y+38
;	product_id -> Y+36
;	timeout_counter -> Y+34
;	*token -> Y+32
;	content_buffer -> Y+0
	LDI  R30,LOW(_header_buffer)
	LDI  R31,HIGH(_header_buffer)
	CALL SUBOPT_0x1
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _memset
; 0000 01D1         memset(content_buffer, 0, sizeof(content_buffer));
	MOVW R30,R28
	CALL SUBOPT_0x1
	LDI  R26,LOW(32)
	LDI  R27,0
	CALL _memset
; 0000 01D2 
; 0000 01D3         if (gets(header_buffer, sizeof(header_buffer)))
	CALL SUBOPT_0x17
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _gets
	SBIW R30,0
	BRNE PC+2
	RJMP _0x43
; 0000 01D4         {
; 0000 01D5             if (strstr(header_buffer, "+CMT:") != NULL)
	CALL SUBOPT_0x17
	__POINTW2MN _0x37,136
	CALL _strstr
	SBIW R30,0
	BRNE PC+2
	RJMP _0x44
; 0000 01D6             {
; 0000 01D7                 // ?? ›Ê—« „ ‰ ÅÌ«„ò —Ê »ŒÊ‰ Ê ‰êÂ œ«—
; 0000 01D8                 if (!gets(content_buffer, sizeof(content_buffer))) {
	CALL SUBOPT_0x3
	LDI  R26,LOW(32)
	LDI  R27,0
	CALL _gets
	SBIW R30,0
	BRNE _0x45
; 0000 01D9                     glcd_clear();
	CALL SUBOPT_0x4
; 0000 01DA                     glcd_outtextxy(0, 0, "Failed to read msg");
	__POINTW2MN _0x37,142
	CALL SUBOPT_0xC
; 0000 01DB                     delay_ms(1000);
; 0000 01DC                     continue;
	ADIW R28,42
	RJMP _0x40
; 0000 01DD                 }
; 0000 01DE 
; 0000 01DF                 // ?? ‘„«—Â  ·›‰ —Ê »êÌ—
; 0000 01E0                 token = strtok(header_buffer, "\"");
_0x45:
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
; 0000 01E1                 if (token != NULL) token = strtok(NULL, "\"");
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	SBIW R30,0
	BREQ _0x46
	CALL SUBOPT_0x19
	CALL SUBOPT_0x18
; 0000 01E2                 if (token != NULL)
_0x46:
	LDD  R30,Y+32
	LDD  R31,Y+32+1
	SBIW R30,0
	BRNE PC+2
	RJMP _0x47
; 0000 01E3                 {
; 0000 01E4                     strcpy(phone_number, token);
	LDI  R30,LOW(_phone_number)
	LDI  R31,HIGH(_phone_number)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	CALL _strcpy
; 0000 01E5 
; 0000 01E6                     // ?? Õ«·« „ÃÊ“ —Ê »——”Ì ò‰
; 0000 01E7                     if (send_json_post(server_url, phone_number))
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(_phone_number)
	LDI  R27,HIGH(_phone_number)
	RCALL _send_json_post
	CPI  R30,0
	BRNE PC+2
	RJMP _0x48
; 0000 01E8                     {
; 0000 01E9                         glcd_clear();
	CALL SUBOPT_0x1A
; 0000 01EA                         glcd_outtextxy(0, 5, "step 1");
	__POINTW2MN _0x37,161
	CALL SUBOPT_0x8
; 0000 01EB                         delay_ms(200);
; 0000 01EC 
; 0000 01ED                         sms_char = content_buffer[0];  // „À·« '1'
	LD   R30,Y
	STD  Y+41,R30
; 0000 01EE 
; 0000 01EF                         glcd_outtextxy(0, 5, "step 2");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	__POINTW2MN _0x37,168
	CALL SUBOPT_0x8
; 0000 01F0                         delay_ms(200);
; 0000 01F1 
; 0000 01F2                         if (sms_char == '1' || sms_char == '2' || sms_char == '3')
	LDD  R26,Y+41
	CPI  R26,LOW(0x31)
	BREQ _0x4A
	CPI  R26,LOW(0x32)
	BREQ _0x4A
	CPI  R26,LOW(0x33)
	BREQ _0x4A
	RJMP _0x49
_0x4A:
; 0000 01F3                         {
; 0000 01F4                             glcd_clear();
	CALL SUBOPT_0x1A
; 0000 01F5                             glcd_outtextxy(0, 5, "SMS Code:");
	__POINTW2MN _0x37,175
	CALL _glcd_outtextxy
; 0000 01F6                             display_buffer[0] = sms_char;
	LDD  R30,Y+41
	STD  Y+38,R30
; 0000 01F7                             glcd_outtextxy(70, 5, display_buffer);
	LDI  R30,LOW(70)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,40
	CALL _glcd_outtextxy
; 0000 01F8                             glcd_outtextxy(0, 25, "Enter code on keypad:");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x37,185
	CALL _glcd_outtextxy
; 0000 01F9 
; 0000 01FA                             key_pressed = 0;
	LDI  R30,LOW(0)
	STD  Y+40,R30
; 0000 01FB                             for (timeout_counter = 0; timeout_counter < 200; timeout_counter++)
	STD  Y+34,R30
	STD  Y+34+1,R30
_0x4D:
	LDD  R26,Y+34
	LDD  R27,Y+34+1
	CPI  R26,LOW(0xC8)
	LDI  R30,HIGH(0xC8)
	CPC  R27,R30
	BRGE _0x4E
; 0000 01FC                             {
; 0000 01FD                                 key_pressed = get_key();
	RCALL _get_key
	STD  Y+40,R30
; 0000 01FE                                 if (key_pressed != 0) break;
	CPI  R30,0
	BRNE _0x4E
; 0000 01FF                                 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0200                             }
	LDD  R30,Y+34
	LDD  R31,Y+34+1
	ADIW R30,1
	STD  Y+34,R30
	STD  Y+34+1,R31
	RJMP _0x4D
_0x4E:
; 0000 0201 
; 0000 0202                             if (key_pressed == 0)
	LDD  R30,Y+40
	CPI  R30,0
	BRNE _0x50
; 0000 0203                             {
; 0000 0204                                 glcd_clear();
	CALL SUBOPT_0x15
; 0000 0205                                 glcd_outtextxy(10, 25, "Timeout! Try again.");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x37,207
	CALL _glcd_outtextxy
; 0000 0206                                 delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RJMP _0x58
; 0000 0207                             }
; 0000 0208                             else
_0x50:
; 0000 0209                             {
; 0000 020A                                 glcd_outtextxy(0, 45, "You pressed:");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(45)
	ST   -Y,R30
	__POINTW2MN _0x37,227
	CALL _glcd_outtextxy
; 0000 020B                                 display_buffer[0] = key_pressed;
	LDD  R30,Y+40
	STD  Y+38,R30
; 0000 020C                                 glcd_outtextxy(90, 45, display_buffer);
	LDI  R30,LOW(90)
	ST   -Y,R30
	LDI  R30,LOW(45)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,40
	CALL SUBOPT_0x8
; 0000 020D                                 delay_ms(200);
; 0000 020E 
; 0000 020F                                 if (key_pressed == sms_char)
	LDD  R30,Y+41
	LDD  R26,Y+40
	CP   R30,R26
	BRNE _0x52
; 0000 0210                                 {
; 0000 0211                                     glcd_clear();
	CALL SUBOPT_0x15
; 0000 0212                                     glcd_outtextxy(10, 25, "Code is CORRECT!");
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x37,240
	CALL SUBOPT_0x1B
; 0000 0213                                     delay_ms(300);
	CALL _delay_ms
; 0000 0214                                     product_id = sms_char - '0';
	LDD  R30,Y+41
	LDI  R31,0
	SBIW R30,48
	STD  Y+36,R30
	STD  Y+36+1,R31
; 0000 0215                                     activate_motor(product_id);
	LDD  R26,Y+36
	LDD  R27,Y+36+1
	RCALL _activate_motor
; 0000 0216                                 }
; 0000 0217                                 else
	RJMP _0x53
_0x52:
; 0000 0218                                 {
; 0000 0219                                     glcd_clear();
	CALL SUBOPT_0x1C
; 0000 021A                                     glcd_outtextxy(5, 25, "Error in entry!");
	__POINTW2MN _0x37,257
	CALL SUBOPT_0x1B
; 0000 021B                                     delay_ms(300);
_0x58:
	CALL _delay_ms
; 0000 021C                                 }
_0x53:
; 0000 021D                             }
; 0000 021E                         }
; 0000 021F                         else
	RJMP _0x54
_0x49:
; 0000 0220                         {
; 0000 0221                             glcd_clear();
	CALL SUBOPT_0x1C
; 0000 0222                             glcd_outtextxy(5, 25, "Invalid SMS Code!");
	__POINTW2MN _0x37,273
	CALL SUBOPT_0x1B
; 0000 0223                             delay_ms(300);
	CALL _delay_ms
; 0000 0224                         }
_0x54:
; 0000 0225                     }
; 0000 0226                     else
	RJMP _0x55
_0x48:
; 0000 0227                     {
; 0000 0228                         glcd_clear();
	RCALL _glcd_clear
; 0000 0229                         glcd_outtextxy(0, 25, "You are not authorized!");
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x37,291
	CALL SUBOPT_0x1B
; 0000 022A                         delay_ms(300);
	CALL _delay_ms
; 0000 022B                     }
_0x55:
; 0000 022C                 }
; 0000 022D 
; 0000 022E                 // »«“ê‘  »Â Ê÷⁄Ì  ¬„«œÂù»Âùò«—
; 0000 022F                 glcd_clear();
_0x47:
	CALL SUBOPT_0x4
; 0000 0230                 glcd_outtextxy(0, 0, "System Ready.");
	__POINTW2MN _0x37,315
	CALL SUBOPT_0x10
; 0000 0231                 glcd_outtextxy(0, 10, "Waiting for SMS...");
	__POINTW2MN _0x37,329
	CALL _glcd_outtextxy
; 0000 0232             }
; 0000 0233         }
_0x44:
; 0000 0234     }
_0x43:
	ADIW R28,42
	RJMP _0x40
; 0000 0235 
; 0000 0236 }
_0x56:
	RJMP _0x56
; .FEND

	.DSEG
_0x37:
	.BYTE 0x15C
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
	CALL SUBOPT_0x1D
	ANDI R30,0xDF
	CALL SUBOPT_0x1D
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
	CALL SUBOPT_0x1E
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
	RJMP _0x212000E
; .FEND
_ks0108_wrcmd_G100:
; .FSTART _ks0108_wrcmd_G100
	ST   -Y,R26
	LDD  R26,Y+1
	RCALL _ks0108_busy_G100
	LDS  R30,98
	CALL SUBOPT_0x1F
	RJMP _0x212000E
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
	RJMP _0x212000E
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
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
	JMP  _0x212000A
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0x1E
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
	CALL SUBOPT_0x20
	RCALL _ks0108_rddata_G100
	RCALL _ks0108_setloc_G100
	RCALL _ks0108_rddata_G100
_0x212000E:
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
	CALL SUBOPT_0x21
	ORI  R30,8
	CALL SUBOPT_0x21
	ORI  R30,4
	CALL SUBOPT_0x21
	ORI  R30,0x80
	STS  97,R30
	LDS  R30,98
	ORI  R30,0x80
	STS  98,R30
	LDS  R30,97
	ORI  R30,0x20
	CALL SUBOPT_0x21
	ORI  R30,0x40
	STS  97,R30
	RCALL _ks0108_disable_G100
	LDS  R30,98
	ANDI R30,0x7F
	STS  98,R30
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
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
	CALL SUBOPT_0x16
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
	CALL SUBOPT_0x16
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
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x22
	LDD  R17,Y+0
	ADIW R28,6
	RET
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
	RJMP _0x212000D
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
	RJMP _0x212000D
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x212000D
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
	CALL SUBOPT_0x23
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
	CALL SUBOPT_0x24
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
	CALL SUBOPT_0x23
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
	CALL SUBOPT_0x24
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x23
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
	CALL SUBOPT_0x20
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
	CALL SUBOPT_0x25
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
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x27
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
	CALL SUBOPT_0x22
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x29
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x2A
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x25
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
	CALL SUBOPT_0x27
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
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x2B
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
	CALL SUBOPT_0x29
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x2A
	MOV  R30,R18
	MOV  R26,R20
	CALL SUBOPT_0x12
	OR   R21,R30
	CALL SUBOPT_0x25
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
	CALL SUBOPT_0x27
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
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x2B
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
_0x212000D:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x2C
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
	CALL SUBOPT_0x2C
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
	CALL SUBOPT_0x2D
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000C
_0x202000B:
	CALL SUBOPT_0x2E
	STD  Y+7,R0
	CALL SUBOPT_0x2E
	STD  Y+6,R0
	CALL SUBOPT_0x2E
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000C
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
	RJMP _0x212000C
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
	RJMP _0x212000C
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
_0x212000C:
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
	CALL SUBOPT_0x2F
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
	CALL SUBOPT_0x2D
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
	RJMP _0x212000B
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
	CALL SUBOPT_0x2F
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
	CALL SUBOPT_0x2F
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x19
	LDI  R26,LOW(9)
	RCALL _glcd_block
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x2F
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x19
	LDI  R26,LOW(9)
	RCALL _glcd_block
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x212000B
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x212000B:
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
	JMP  _0x2120005
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
_0x212000A:
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
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	CALL SUBOPT_0x30
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
	JMP  _0x2120005
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
	CALL SUBOPT_0x31
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x32
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x33
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x32
	CALL SUBOPT_0x34
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
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
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
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x33
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x33
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
	CALL SUBOPT_0x36
	SBIW R30,0
	BRNE _0x2060072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120009
_0x2060072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x36
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x37
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
_0x2120009:
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
	CALL SUBOPT_0x37
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
_get_buff_G103:
; .FSTART _get_buff_G103
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206007A
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x206007B
_0x206007A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x206007C
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LDD  R26,Z+1
	LDD  R27,Z+2
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206007D
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	ADIW R26,1
	CALL SUBOPT_0x30
_0x206007D:
	RJMP _0x206007E
_0x206007C:
	LDI  R17,LOW(0)
_0x206007E:
_0x206007B:
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x2120005
; .FEND
__scanf_G103:
; .FSTART __scanf_G103
	PUSH R15
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL __SAVELOCR6
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STD  Y+8,R30
	STD  Y+8+1,R31
	MOV  R20,R30
_0x206007F:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2060081
	CALL SUBOPT_0x38
	BREQ _0x2060082
_0x2060083:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x39
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2060086
	CALL SUBOPT_0x38
	BRNE _0x2060087
_0x2060086:
	RJMP _0x2060085
_0x2060087:
	CALL SUBOPT_0x3A
	BRGE _0x2060088
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x2060088:
	RJMP _0x2060083
_0x2060085:
	MOV  R20,R19
	RJMP _0x2060089
_0x2060082:
	CPI  R19,37
	BREQ PC+2
	RJMP _0x206008A
	LDI  R21,LOW(0)
_0x206008B:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LPM  R19,Z+
	STD  Y+16,R30
	STD  Y+16+1,R31
	CPI  R19,48
	BRLO _0x206008F
	CPI  R19,58
	BRLO _0x206008E
_0x206008F:
	RJMP _0x206008D
_0x206008E:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R19
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x206008B
_0x206008D:
	CPI  R19,0
	BRNE _0x2060091
	RJMP _0x2060081
_0x2060091:
_0x2060092:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x39
	POP  R20
	MOV  R18,R30
	MOV  R26,R30
	CALL _isspace
	CPI  R30,0
	BREQ _0x2060094
	CALL SUBOPT_0x3A
	BRGE _0x2060095
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x2060095:
	RJMP _0x2060092
_0x2060094:
	CPI  R18,0
	BRNE _0x2060096
	RJMP _0x2060097
_0x2060096:
	MOV  R20,R18
	CPI  R21,0
	BRNE _0x2060098
	LDI  R21,LOW(255)
_0x2060098:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x206009C
	CALL SUBOPT_0x3B
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x39
	POP  R20
	MOVW R26,R16
	ST   X,R30
	CALL SUBOPT_0x3A
	BRGE _0x206009D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x206009D:
	RJMP _0x206009B
_0x206009C:
	CPI  R30,LOW(0x73)
	BRNE _0x20600A6
	CALL SUBOPT_0x3B
_0x206009F:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BREQ _0x20600A1
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x39
	POP  R20
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x20600A3
	CALL SUBOPT_0x38
	BREQ _0x20600A2
_0x20600A3:
	CALL SUBOPT_0x3A
	BRGE _0x20600A5
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x20600A5:
	RJMP _0x20600A1
_0x20600A2:
	PUSH R17
	PUSH R16
	__ADDWRN 16,17,1
	MOV  R30,R19
	POP  R26
	POP  R27
	ST   X,R30
	RJMP _0x206009F
_0x20600A1:
	MOVW R26,R16
	LDI  R30,LOW(0)
	ST   X,R30
	RJMP _0x206009B
_0x20600A6:
	SET
	BLD  R15,1
	CLT
	BLD  R15,2
	MOV  R30,R19
	CPI  R30,LOW(0x64)
	BREQ _0x20600AB
	CPI  R30,LOW(0x69)
	BRNE _0x20600AC
_0x20600AB:
	CLT
	BLD  R15,1
	RJMP _0x20600AD
_0x20600AC:
	CPI  R30,LOW(0x75)
	BRNE _0x20600AE
_0x20600AD:
	LDI  R18,LOW(10)
	RJMP _0x20600A9
_0x20600AE:
	CPI  R30,LOW(0x78)
	BRNE _0x20600AF
	LDI  R18,LOW(16)
	RJMP _0x20600A9
_0x20600AF:
	CPI  R30,LOW(0x25)
	BRNE _0x20600B2
	RJMP _0x20600B1
_0x20600B2:
	RJMP _0x2120008
_0x20600A9:
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
	SET
	BLD  R15,0
_0x20600B3:
	MOV  R30,R21
	SUBI R21,1
	CPI  R30,0
	BRNE PC+2
	RJMP _0x20600B5
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x39
	POP  R20
	MOV  R19,R30
	CPI  R30,LOW(0x21)
	BRSH _0x20600B6
	CALL SUBOPT_0x3A
	BRGE _0x20600B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x20600B7:
	RJMP _0x20600B8
_0x20600B6:
	SBRC R15,1
	RJMP _0x20600B9
	SET
	BLD  R15,1
	CPI  R19,45
	BRNE _0x20600BA
	BLD  R15,2
	RJMP _0x20600B3
_0x20600BA:
	CPI  R19,43
	BREQ _0x20600B3
_0x20600B9:
	CPI  R18,16
	BRNE _0x20600BC
	MOV  R26,R19
	CALL _isxdigit
	CPI  R30,0
	BREQ _0x20600B8
	RJMP _0x20600BE
_0x20600BC:
	MOV  R26,R19
	CALL _isdigit
	CPI  R30,0
	BRNE _0x20600BF
_0x20600B8:
	SBRC R15,0
	RJMP _0x20600C1
	MOV  R20,R19
	RJMP _0x20600B5
_0x20600BF:
_0x20600BE:
	CPI  R19,97
	BRLO _0x20600C2
	SUBI R19,LOW(87)
	RJMP _0x20600C3
_0x20600C2:
	CPI  R19,65
	BRLO _0x20600C4
	SUBI R19,LOW(55)
	RJMP _0x20600C5
_0x20600C4:
	SUBI R19,LOW(48)
_0x20600C5:
_0x20600C3:
	MOV  R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL __MULW12U
	MOVW R26,R30
	MOV  R30,R19
	LDI  R31,0
	CALL SUBOPT_0x23
	CLT
	BLD  R15,0
	RJMP _0x20600B3
_0x20600B5:
	CALL SUBOPT_0x3B
	SBRS R15,2
	RJMP _0x20600C6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __ANEGW1
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x20600C6:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	MOVW R26,R16
	ST   X+,R30
	ST   X,R31
_0x206009B:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RJMP _0x20600C7
_0x206008A:
_0x20600B1:
	IN   R30,SPL
	IN   R31,SPH
	ST   -Y,R31
	ST   -Y,R30
	PUSH R20
	CALL SUBOPT_0x39
	POP  R20
	CP   R30,R19
	BREQ _0x20600C8
	CALL SUBOPT_0x3A
	BRGE _0x20600C9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x20600C9:
_0x2060097:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	SBIW R30,0
	BRNE _0x20600CA
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x20600CA:
	RJMP _0x2060081
_0x20600C8:
_0x20600C7:
_0x2060089:
	RJMP _0x206007F
_0x2060081:
_0x20600C1:
_0x2120008:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
_0x2120007:
	CALL __LOADLOCR6
	ADIW R28,18
	POP  R15
	RET
; .FEND
_sscanf:
; .FSTART _sscanf
	PUSH R15
	MOV  R15,R24
	SBIW R28,3
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x3C
	SBIW R30,0
	BRNE _0x20600CB
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120006
_0x20600CB:
	MOVW R26,R28
	ADIW R26,1
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x3C
	STD  Y+3,R30
	STD  Y+3+1,R31
	MOVW R26,R28
	ADIW R26,5
	CALL SUBOPT_0x37
	LDI  R30,LOW(_get_buff_G103)
	LDI  R31,HIGH(_get_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __scanf_G103
_0x2120006:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
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
_0x2120005:
	ADIW R28,5
	RET
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
	RJMP _0x2120001
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
	CALL SUBOPT_0x3D
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
	CALL SUBOPT_0x3D
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
	ADIW R28,6
	RET
; .FEND

	.CSEG

	.DSEG

	.CSEG

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
_isxdigit:
; .FSTART _isxdigit
	ST   -Y,R26
    ldi  r30,1
    ld   r31,y+
    subi r31,0x30
    brcs isxdigit0
    cpi  r31,10
    brcs isxdigit1
    andi r31,0x5f
    subi r31,7
    cpi  r31,10
    brcs isxdigit0
    cpi  r31,16
    brcs isxdigit1
isxdigit0:
    clr  r30
isxdigit1:
    ret
; .FEND

	.DSEG
_glcd_state:
	.BYTE 0x1D
_header_buffer:
	.BYTE 0x64
_ip_address_buffer:
	.BYTE 0x10
_phone_number:
	.BYTE 0x10
_ks0108_coord_G100:
	.BYTE 0x3
_p_S1040026000:
	.BYTE 0x2
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	CALL _send_at_command
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x4:
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	CALL _send_at_command
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(200)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	CALL _glcd_outtextxy
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x9:
	CALL _send_at_command
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CALL _glcd_outtextxy
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x0,104
	CALL _strtok
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL _glcd_outtextxy
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0xD:
	CALL _send_at_command
	MOVW R30,R28
	SUBI R30,LOW(-(264))
	SBCI R31,HIGH(-(264))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	CALL _glcd_outtextxy
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	CALL _glcd_outtextxy
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	CP   R30,R20
	CPC  R31,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x13:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	CALL _glcd_clear
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(_header_buffer)
	LDI  R31,HIGH(_header_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	__POINTW2FN _0x0,104
	CALL _strtok
	STD  Y+32,R30
	STD  Y+32+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	CALL _glcd_outtextxy
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	CALL _glcd_clear
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	STS  98,R30
	LDS  R30,98
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDS  R30,98
	ORI  R30,8
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1F:
	ANDI R30,0XF7
	STS  98,R30
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LD   R30,Y
	OUT  0x1B,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	STS  97,R30
	LDS  R30,97
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x24:
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
SUBOPT_0x25:
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
SUBOPT_0x26:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
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
SUBOPT_0x2B:
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
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2F:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x31:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x32:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x34:
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
SUBOPT_0x35:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x37:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	MOV  R26,R19
	CALL _isspace
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x39:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3A:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LD   R26,X
	CPI  R26,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3B:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R16,X+
	LD   R17,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	MOVW R26,R28
	ADIW R26,7
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+4
	LDD  R27,Y+4+1
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

__PUTPARD1L:
	LDI  R22,0
	LDI  R23,0
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
