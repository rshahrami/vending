
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
	.DEF _device_id=R4
	.DEF _device_id_msb=R5
	.DEF _header_index=R6
	.DEF _header_index_msb=R7
	.DEF _content_index=R8
	.DEF _content_index_msb=R9
	.DEF _attempts=R11

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
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart0_rx_isr
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
_kode_mahsol_payamak_konid:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x80,0xC0,0x80,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0xF8,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0x80,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x10,0x8,0x8
	.DB  0x20,0x0,0x80,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x80,0xE0,0x0,0x0,0x0,0x0,0x0
	.DB  0x80,0x0,0x0,0x0,0x0,0x78,0xFC,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x38
	.DB  0xF8,0x0,0x0,0x0,0x80,0x80,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x80
	.DB  0x80,0x80,0x0,0x0,0x80,0xC0,0xC0,0xC0
	.DB  0xC0,0x80,0x80,0x80,0x0,0x0,0x0,0x0
	.DB  0x80,0x80,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x40,0xE0,0x0,0x0,0x0,0x0
	.DB  0x70,0xF0,0x98,0x18,0x1C,0x4,0x0,0x0
	.DB  0x0,0x0,0x7,0xC,0xC,0xD,0x7,0x0
	.DB  0x80,0x80,0xC0,0xE7,0x3E,0x0,0x7,0xC
	.DB  0xC,0x0,0xC,0xC,0x7,0xD,0xD,0x7
	.DB  0xC,0xC,0xC,0xC,0xE,0xC,0xC,0x6
	.DB  0xC,0xD,0x7,0x0,0x0,0x0,0x0,0x7
	.DB  0x7,0x6,0x5,0xF,0xC,0xC,0x2C,0x6D
	.DB  0x67,0x0,0x0,0x0,0x0,0x0,0x7,0x0
	.DB  0x80,0x80,0xC0,0xE7,0x3E,0x0,0x0,0x0
	.DB  0x0,0x78,0xE0,0xC0,0xC0,0xC0,0xC0,0x60
	.DB  0x3F,0x0,0x80,0x8F,0xCD,0xED,0x3F,0xC
	.DB  0xC,0xC,0x7,0xC,0xE,0xF,0xD,0xD
	.DB  0x5,0xF,0xC,0xC,0xD,0xC,0x4,0x6
	.DB  0x3,0x7,0xD,0xC,0xC,0xC,0xC,0x7
	.DB  0xD,0xD,0x7,0x0,0x0,0x0,0x0,0xE
	.DB  0xC,0xC,0xC,0x7,0x7,0xC,0xC,0xC
	.DB  0xC,0xC,0x7,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x80
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0xC0,0x80,0x0,0x0,0x0
	.DB  0xC0,0xC0,0x60,0x60,0x70,0x10,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0xC0,0xC0,0xE0,0x60,0x60,0x30,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0xE0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x80,0x80
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x38,0x30,0x30,0x31,0x1F
	.DB  0x1C,0x30,0x30,0x30,0x30,0x18,0x1C,0x30
	.DB  0x30,0x30,0x30,0x31,0x18,0x30,0x30,0x30
	.DB  0x31,0x33,0x1E,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1C,0x30,0x30,0x30,0x30,0x30,0x30
	.DB  0x31,0x33,0x1E,0xC,0x18,0x30,0x30,0x30
	.DB  0x30,0x30,0x1C,0x36,0x36,0x1C,0x0,0x1F
	.DB  0x30,0x30,0x0,0x30,0x30,0x18,0x1C,0x30
	.DB  0x30,0x30,0xB4,0x1E,0x80,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xC,0xD8,0x30,0x30
	.DB  0x34,0x1E,0x0,0x0,0x0,0x0,0x1,0x9D
	.DB  0xF9,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x1,0x1,0x1
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x1,0x1,0x1
	.DB  0x0,0x0,0x1,0x2,0x1,0x0,0x0,0x0
	.DB  0x0,0x2,0x2,0x3,0x3,0x1,0x0,0x0
	.DB  0x1,0x0,0x1,0x0,0x2,0x2,0x3,0x3
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_mahsol_ra_bardarid:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0xC0,0xC0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x80,0x80,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xFC,0xFC,0x0,0x0,0x0,0x40
	.DB  0x40,0xC0,0xC0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x80,0x80,0x0,0x0
	.DB  0x0,0x0,0x0,0xFC,0xFC,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x4,0xFC,0xFC,0x0
	.DB  0x0,0x0,0x80,0x80,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x80,0x80
	.DB  0x80,0x80,0x0,0x0,0x0,0x80,0x80,0x80
	.DB  0x80,0x80,0x80,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0x80,0x80,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xC,0xC,0x0,0x0,0xE,0xE
	.DB  0x8,0x8,0xF,0xF,0x8,0x28,0x68,0x68
	.DB  0x68,0x4F,0xF,0x40,0x40,0x63,0x7F,0x1C
	.DB  0x0,0x0,0xF,0xF,0x0,0x0,0xE,0xE
	.DB  0x8,0x8,0xF,0x7,0x40,0x40,0x61,0x7F
	.DB  0x3F,0x8,0x68,0x68,0x4F,0xF,0x0,0x0
	.DB  0x0,0x0,0x0,0xF,0xF,0x40,0x40,0x61
	.DB  0x7F,0x3F,0x0,0x0,0x0,0x0,0x0,0x3E
	.DB  0x7E,0x60,0x40,0x60,0x60,0x3F,0x1F,0x0
	.DB  0x0,0x4F,0x4F,0x49,0x7B,0x3F,0xC,0x8
	.DB  0x8,0x8,0xF,0xF,0xE,0xB,0x9,0x8
	.DB  0x9,0xF,0xF,0x8,0x8,0xB,0xB,0xC
	.DB  0xC,0x6,0xF,0xD,0x9,0x8,0x8,0xC
	.DB  0x6,0xF,0xD,0xF,0xF,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_adad_ra_vared_namaeid:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xC0,0xC0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x80,0x80
	.DB  0x0,0x0,0xFC,0xFC,0x0,0x0,0x0,0x0
	.DB  0x0,0x80,0x80,0x80,0x0,0x0,0x0,0x10
	.DB  0xB0,0xA0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x40,0x40,0xC0,0xC0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xFC,0xFC,0x0,0x0
	.DB  0x0,0x80,0x80,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0xFC,0xFC,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x40
	.DB  0x40,0xC0,0xC0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0xC0,0xC0,0x0,0x0,0x0,0x80,0xC0
	.DB  0xC0,0xC0,0xC0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xC,0xC,0x0,0x0,0xE
	.DB  0xE,0x8,0x8,0xF,0xF,0x8,0x48,0x68
	.DB  0x68,0x6F,0x6F,0x68,0x68,0x68,0x6F,0x4F
	.DB  0x0,0x0,0x7,0xF,0x8,0x8,0xC,0x6
	.DB  0xF,0xD,0xB,0xF,0xC,0x8,0x8,0x8
	.DB  0xF,0xF,0x0,0x0,0x0,0x0,0x0,0xE
	.DB  0xE,0x8,0x8,0xF,0x7,0x40,0x40,0x61
	.DB  0x7F,0x3F,0x0,0x0,0xF,0xF,0x0,0x0
	.DB  0x4F,0x4F,0x69,0x7F,0x3F,0x0,0x0,0x0
	.DB  0x0,0x0,0xF,0xF,0x40,0x40,0x61,0x7F
	.DB  0x3F,0x0,0x0,0x0,0x0,0x0,0xE,0xE
	.DB  0x8,0x8,0xF,0x7,0x0,0x0,0xE,0xE
	.DB  0x8,0x8,0xF,0xF,0x8,0x8,0xB,0xF
	.DB  0xC,0xC,0x4,0x4,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x80,0x80,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_lotfan_montazer_bemanid:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x80
	.DB  0x80,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0x80,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0x80,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x80,0x80
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x80
	.DB  0x80,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x80,0x80,0x0,0x0,0x80,0x80,0x0,0x0
	.DB  0x80,0x80,0x0,0x0,0xC0,0xC0,0x0,0x18
	.DB  0xF8,0xE0,0x0,0x0,0x0,0xE0,0xE0,0x80
	.DB  0x0,0x0,0x2,0xF6,0xF4,0x0,0x0,0xFF
	.DB  0xFF,0x0,0x0,0x80,0xC0,0xE0,0xB0,0x70
	.DB  0xF0,0x80,0x0,0x0,0x0,0xF0,0xF0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0xE0,0xE0,0x0
	.DB  0x0,0x80,0xFF,0x7F,0x20,0x32,0x36,0xF4
	.DB  0xE0,0x0,0x0,0x4,0xC,0xEC,0xEC,0x4
	.DB  0x0,0x8,0xEC,0xEC,0x80,0x0,0x0,0x80
	.DB  0xC0,0xE0,0xB0,0xF0,0xF0,0x0,0x0,0x0
	.DB  0x0,0x0,0xFF,0xFF,0x0,0x0,0x60,0xF3
	.DB  0x9B,0xFA,0xF0,0x0,0x0,0x80,0xFF,0x7F
	.DB  0x20,0x30,0x30,0xF0,0xE0,0x0,0x0,0x3
	.DB  0xFF,0xFC,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x0,0x0,0x1,0x1,0x0,0x0
	.DB  0x1,0x1,0x0,0x0,0x1,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0x5,0xD,0xD,0xD,0x9
	.DB  0x1,0x1,0x1,0x1,0x1,0x0,0x0,0x0
	.DB  0x1,0x1,0x1,0x1,0x0,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0xD,0xD,0x9,0x1,0x0
	.DB  0x0,0x0,0x8,0x8,0xC,0xF,0x7,0x1
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
	.DB  0x0,0x1,0x1,0x1,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_shomare_dorost_payamak_nashode:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0xE0,0xE0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x80,0x80,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x38,0x78,0x42,0x43,0x43,0x43,0x43
	.DB  0x60,0x78,0x78,0x40,0x40,0x40,0x78,0x78
	.DB  0x40,0x60,0x78,0x78,0x44,0x7C,0x3C,0x0
	.DB  0x0,0x8,0xF8,0xF8,0x0,0x0,0x70,0x72
	.DB  0x42,0x46,0x7E,0x38,0x0,0x0,0x0,0x0
	.DB  0x0,0xF0,0xF0,0x2,0x6,0x6,0x0,0xFC
	.DB  0xFC,0x0,0x0,0x78,0x7C,0x4C,0xD8,0xF8
	.DB  0x60,0x40,0x42,0x43,0x7B,0x7B,0x63,0x40
	.DB  0x40,0x40,0x78,0x78,0x40,0x60,0x78,0x78
	.DB  0x44,0x7C,0x3C,0x0,0x0,0x0,0x0,0x0
	.DB  0x78,0x7E,0x46,0x7C,0x78,0x0,0x0,0x8
	.DB  0xF8,0xF8,0x0,0x0,0x3F,0x7F,0x40,0x40
	.DB  0x60,0x30,0x78,0x6C,0x5C,0x7C,0x60,0x40
	.DB  0x40,0x40,0x78,0x78,0x43,0x63,0x7B,0x7B
	.DB  0x46,0x7C,0x3C,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x2
	.DB  0x2,0x3,0x3,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1,0x3,0x3,0x2,0x3,0x3,0x1
	.DB  0x1,0x0,0x0,0x2,0x2,0x2,0x3,0x1
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x2,0x2,0x3
	.DB  0x3,0x1,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0xE0,0xE0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0x80,0x80,0x0,0x0,0x0
	.DB  0x0,0x0,0x80,0x80,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x80,0x80
	.DB  0x80,0x80,0xC0,0x40,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0xE0,0xE0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x60,0x60,0x0,0x0
	.DB  0x38,0x78,0x42,0x43,0x43,0x43,0x43,0x60
	.DB  0x78,0x78,0x40,0x40,0x40,0x78,0x78,0x40
	.DB  0x60,0x78,0x78,0x44,0x7C,0x3C,0x0,0x0
	.DB  0x7F,0x7F,0x0,0x0,0x0,0x0,0x0,0x78
	.DB  0x7E,0x46,0x7C,0x78,0x0,0x0,0x70,0x70
	.DB  0x40,0x46,0x7E,0x78,0x40,0x40,0x40,0x78
	.DB  0x78,0x43,0x63,0x7B,0x7B,0x42,0x78,0x78
	.DB  0x40,0x40,0x40,0x7D,0x7D,0x0,0x0,0x0
	.DB  0x0,0x0,0x38,0x78,0x40,0x40,0x41,0x43
	.DB  0x46,0x6E,0x78,0x70,0x40,0x40,0x60,0x30
	.DB  0x78,0x6C,0x7C,0x7C,0x0,0x0,0x3F,0x7F
	.DB  0x40,0x40,0x40,0x40,0x78,0x78,0x40,0x40
	.DB  0x40,0x7C,0x7C,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x2,0x3,0x3,0x3,0x3,0x3,0xB
	.DB  0xF,0xF,0x2,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_tedad_bish_az_had:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x80,0x80,0x20,0x30,0x30,0x30,0x30,0x0
	.DB  0x80,0x80,0x0,0x0,0x0,0x80,0x80,0x0
	.DB  0x0,0x80,0x80,0x40,0xC0,0xC0,0x0,0x0
	.DB  0xFE,0xFE,0x0,0x0,0x80,0xC0,0xC0,0x80
	.DB  0x80,0x0,0x0,0x0,0xC0,0xCC,0x4C,0x48
	.DB  0x40,0xC0,0x80,0x80,0x0,0x0,0x80,0x80
	.DB  0x80,0x0,0x0,0x0,0x20,0x20,0x60,0xE0
	.DB  0x80,0x0,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x60,0xE0,0x80,0x0,0x0,0xFE,0xFE
	.DB  0x0,0x0,0x0,0x0,0x0,0x60,0xE0,0x80
	.DB  0x0,0x0,0x40,0xC0,0xC0,0x40,0x40,0xC0
	.DB  0xC0,0x0,0x8,0x18,0xD8,0xD8,0x10,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x3,0x7,0x4,0x4,0x4,0x4,0x4,0x6
	.DB  0x7,0x7,0x4,0x4,0x4,0x7,0x7,0x4
	.DB  0x6,0x7,0x7,0x4,0x7,0x3,0x0,0x0
	.DB  0x7,0x7,0x0,0x0,0x27,0x27,0x24,0x3D
	.DB  0x1F,0x6,0x4,0x4,0x5,0x5,0x6,0x6
	.DB  0x3,0x1,0x0,0x0,0x20,0x20,0x30,0x3F
	.DB  0x1F,0x0,0x0,0x7,0x7,0x4,0x4,0x7
	.DB  0x3,0x0,0x0,0x0,0x0,0x0,0x7,0x7
	.DB  0x4,0x4,0x7,0x3,0x0,0x0,0x7,0x7
	.DB  0x0,0x0,0x7,0x7,0x4,0x4,0x7,0x7
	.DB  0x4,0x4,0x4,0x5,0x7,0x6,0x7,0x5
	.DB  0x4,0x4,0x4,0x4,0x7,0x7,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0xB0,0xB0
	.DB  0xA0,0x0,0x0,0xFE,0xFE,0x0,0x0,0xC0
	.DB  0xC0,0x40,0x40,0x40,0xC0,0x80,0x80,0x0
	.DB  0x0,0x0,0x0,0x80,0xC0,0xC0,0xC0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x60
	.DB  0xE0,0x80,0x0,0x0,0xC0,0xC0,0x40,0x40
	.DB  0x40,0xC0,0x80,0x80,0x0,0x0,0x0,0x0
	.DB  0x0,0xB0,0xB0,0xA0,0x0,0x0,0xFE,0xFE
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x80,0x80,0x20,0x38,0xB8
	.DB  0xB8,0x30,0x80,0x80,0x0,0x0,0x0,0x0
	.DB  0x80,0x80,0x0,0x0,0x0,0xC0,0xC0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x30,0x3F
	.DB  0x1F,0x0,0x0,0x3,0x7,0x4,0x4,0x5
	.DB  0x5,0x36,0x36,0x23,0x7,0x6,0x4,0x4
	.DB  0x4,0x6,0x3,0x7,0x6,0x7,0x7,0x0
	.DB  0x0,0x0,0x0,0x0,0x7,0x7,0x4,0x4
	.DB  0x7,0x7,0x4,0x4,0x5,0x5,0x6,0x6
	.DB  0x3,0x1,0x0,0x0,0x0,0x0,0x0,0x20
	.DB  0x20,0x30,0x3F,0x1F,0x0,0x0,0x7,0x7
	.DB  0x0,0x0,0x0,0x0,0x0,0x3E,0x3E,0x60
	.DB  0x60,0x60,0x20,0x3F,0x3F,0x4,0x4,0x7
	.DB  0x7,0x4,0x7,0x7,0x4,0x24,0x34,0x34
	.DB  0x37,0x37,0x4,0x34,0x34,0x27,0x7,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_square:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xF8,0xF8,0xF8,0x38,0x38
	.DB  0x38,0x38,0x38,0x38,0x38,0x38,0x38,0x38
	.DB  0x38,0x38,0x38,0x38,0x38,0x38,0x38,0x38
	.DB  0x38,0x38,0x38,0x38,0x38,0x38,0x38,0x38
	.DB  0x38,0x38,0x38,0x38,0x38,0x38,0x38,0x38
	.DB  0x38,0x38,0x38,0xF8,0xF8,0xF8,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0xFF,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0xFF,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0xFF,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xFF,0xFF,0xFF,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0xF,0xF,0xF,0xE,0xE
	.DB  0xE,0xE,0xE,0xE,0xE,0xE,0xE,0xE
	.DB  0xE,0xE,0xE,0xE,0xE,0xE,0xE,0xE
	.DB  0xE,0xE,0xE,0xE,0xE,0xE,0xE,0xE
	.DB  0xE,0xE,0xE,0xE,0xE,0xE,0xE,0xE
	.DB  0xE,0xE,0xE,0xF,0xF,0xF,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
_APN:
	.DB  0x6D,0x63,0x69,0x6E,0x65,0x74,0x0
__glcd_mask:
	.DB  0x0,0x1,0x3,0x7,0xF,0x1F,0x3F,0x7F
	.DB  0xFF
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0x4D,0x4F,0x54,0x4F,0x52,0x20,0x25,0x64
	.DB  0x20,0x4F,0x4E,0x21,0x0,0x41,0x54,0x2B
	.DB  0x48,0x54,0x54,0x50,0x54,0x45,0x52,0x4D
	.DB  0x0,0x41,0x54,0x2B,0x48,0x54,0x54,0x50
	.DB  0x49,0x4E,0x49,0x54,0x0,0x41,0x54,0x2B
	.DB  0x48,0x54,0x54,0x50,0x50,0x41,0x52,0x41
	.DB  0x3D,0x22,0x43,0x49,0x44,0x22,0x2C,0x31
	.DB  0x0,0x25,0x73,0x3F,0x70,0x68,0x6F,0x6E
	.DB  0x65,0x5F,0x6E,0x75,0x6D,0x62,0x65,0x72
	.DB  0x3D,0x25,0x73,0x26,0x64,0x65,0x76,0x69
	.DB  0x63,0x65,0x5F,0x69,0x64,0x3D,0x25,0x64
	.DB  0x26,0x70,0x72,0x6F,0x64,0x75,0x63,0x74
	.DB  0x5F,0x69,0x64,0x3D,0x25,0x64,0x0,0x41
	.DB  0x54,0x2B,0x48,0x54,0x54,0x50,0x50,0x41
	.DB  0x52,0x41,0x3D,0x22,0x55,0x52,0x4C,0x22
	.DB  0x2C,0x22,0x25,0x73,0x22,0x0,0x41,0x54
	.DB  0x2B,0x48,0x54,0x54,0x50,0x41,0x43,0x54
	.DB  0x49,0x4F,0x4E,0x3D,0x31,0x0,0x48,0x54
	.DB  0x54,0x50,0x41,0x43,0x54,0x49,0x4F,0x4E
	.DB  0x0,0x2B,0x48,0x54,0x54,0x50,0x41,0x43
	.DB  0x54,0x49,0x4F,0x4E,0x3A,0x0,0x25,0x73
	.DB  0x3F,0x70,0x68,0x6F,0x6E,0x65,0x5F,0x6E
	.DB  0x75,0x6D,0x62,0x65,0x72,0x3D,0x25,0x73
	.DB  0x0,0x41,0x54,0x2B,0x48,0x54,0x54,0x50
	.DB  0x41,0x43,0x54,0x49,0x4F,0x4E,0x3D,0x30
	.DB  0x0,0x68,0x74,0x74,0x70,0x3A,0x2F,0x2F
	.DB  0x31,0x38,0x35,0x2E,0x38,0x2E,0x31,0x37
	.DB  0x33,0x2E,0x31,0x37,0x3A,0x38,0x30,0x30
	.DB  0x30,0x2F,0x68,0x6F,0x6D,0x65,0x2F,0x70
	.DB  0x6F,0x73,0x74,0x2F,0x0,0x75,0x6E,0x6B
	.DB  0x6E,0x6F,0x77,0x6E,0x0,0x53,0x4D,0x53
	.DB  0x20,0x66,0x72,0x6F,0x6D,0x3A,0x0,0x32
	.DB  0x0,0x33,0x0,0x54,0x69,0x6D,0x65,0x6F
	.DB  0x75,0x74,0x21,0x20,0x54,0x72,0x79,0x20
	.DB  0x61,0x67,0x61,0x69,0x6E,0x2E,0x0,0x74
	.DB  0x65,0x73,0x74,0x20,0x32,0x21,0x0,0x2B
	.DB  0x43,0x4D,0x54,0x3A,0x0,0x4D,0x6F,0x64
	.DB  0x75,0x6C,0x65,0x20,0x49,0x6E,0x69,0x74
	.DB  0x2E,0x2E,0x2E,0x0,0x47,0x50,0x52,0x53
	.DB  0x20,0x49,0x6E,0x69,0x74,0x20,0x46,0x61
	.DB  0x69,0x6C,0x65,0x64,0x21,0x0
_0x20000:
	.DB  0x25,0x73,0xD,0xA,0x0
_0x40003:
	.DB  0x23,0x30,0x2A,0x39,0x38,0x37,0x36,0x35
	.DB  0x34,0x33,0x32,0x31,0x7,0x5,0x6,0x4
	.DB  0x0,0x1,0x2
_0x40000:
	.DB  0x50,0x72,0x65,0x73,0x73,0x20,0x61,0x20
	.DB  0x6B,0x65,0x79,0x2E,0x2E,0x2E,0x0,0x4B
	.DB  0x65,0x79,0x20,0x50,0x72,0x65,0x73,0x73
	.DB  0x65,0x64,0x3A,0x0
_0x60000:
	.DB  0x52,0x65,0x73,0x74,0x61,0x72,0x74,0x69
	.DB  0x6E,0x67,0x20,0x53,0x49,0x4D,0x38,0x30
	.DB  0x30,0x2E,0x2E,0x2E,0x0,0x41,0x54,0x2B
	.DB  0x48,0x54,0x54,0x50,0x54,0x45,0x52,0x4D
	.DB  0x0,0x4F,0x4B,0x0,0x45,0x52,0x52,0x4F
	.DB  0x52,0x0,0x57,0x61,0x69,0x74,0x69,0x6E
	.DB  0x67,0x20,0x48,0x54,0x54,0x50,0x54,0x45
	.DB  0x52,0x4D,0x2E,0x2E,0x2E,0x0,0x41,0x54
	.DB  0x2B,0x53,0x41,0x50,0x42,0x52,0x3D,0x30
	.DB  0x2C,0x31,0x0,0x57,0x61,0x69,0x74,0x69
	.DB  0x6E,0x67,0x20,0x53,0x41,0x50,0x42,0x52
	.DB  0x3D,0x30,0x2C,0x31,0x2E,0x2E,0x2E,0x0
	.DB  0x41,0x54,0x2B,0x53,0x41,0x50,0x42,0x52
	.DB  0x3D,0x32,0x2C,0x31,0x0,0x53,0x41,0x50
	.DB  0x42,0x52,0x0,0x30,0x2E,0x30,0x2E,0x30
	.DB  0x2E,0x30,0x0,0x2C,0x30,0x2C,0x0,0x2C
	.DB  0x33,0x2C,0x0,0x43,0x68,0x65,0x63,0x6B
	.DB  0x69,0x6E,0x67,0x20,0x53,0x41,0x50,0x42
	.DB  0x52,0x20,0x63,0x6C,0x6F,0x73,0x65,0x64
	.DB  0x2E,0x2E,0x2E,0x0,0x41,0x54,0x2B,0x43
	.DB  0x47,0x41,0x54,0x54,0x3D,0x30,0x0,0x57
	.DB  0x61,0x69,0x74,0x69,0x6E,0x67,0x20,0x43
	.DB  0x47,0x41,0x54,0x54,0x3D,0x30,0x2E,0x2E
	.DB  0x2E,0x0,0x41,0x54,0x2B,0x43,0x46,0x55
	.DB  0x4E,0x3D,0x31,0x2C,0x31,0x0,0x52,0x65
	.DB  0x62,0x6F,0x6F,0x74,0x69,0x6E,0x67,0x2C
	.DB  0x20,0x77,0x61,0x69,0x74,0x20,0x66,0x6F
	.DB  0x72,0x20,0x41,0x54,0x2E,0x2E,0x2E,0x0
	.DB  0x41,0x54,0x0,0x41,0x54,0x45,0x30,0x0
	.DB  0x57,0x61,0x69,0x74,0x69,0x6E,0x67,0x20
	.DB  0x41,0x54,0x45,0x30,0x2E,0x2E,0x2E,0x0
	.DB  0x46,0x69,0x6E,0x61,0x6C,0x20,0x41,0x54
	.DB  0x20,0x63,0x68,0x65,0x63,0x6B,0x2E,0x2E
	.DB  0x2E,0x0,0x52,0x65,0x73,0x74,0x61,0x72
	.DB  0x74,0x20,0x44,0x6F,0x6E,0x65,0x21,0x0
	.DB  0x41,0x54,0x2B,0x43,0x50,0x49,0x4E,0x3F
	.DB  0x0,0x43,0x50,0x49,0x4E,0x0,0x2B,0x43
	.DB  0x50,0x49,0x4E,0x3A,0x0,0x41,0x54,0x2B
	.DB  0x43,0x52,0x45,0x47,0x3F,0x0,0x43,0x52
	.DB  0x45,0x47,0x0,0x2B,0x43,0x52,0x45,0x47
	.DB  0x3A,0x0,0x57,0x61,0x69,0x74,0x69,0x6E
	.DB  0x67,0x20,0x66,0x6F,0x72,0x20,0x6E,0x65
	.DB  0x74,0x77,0x6F,0x72,0x6B,0x2E,0x2E,0x2E
	.DB  0x0,0x4E,0x65,0x74,0x77,0x6F,0x72,0x6B
	.DB  0x20,0x4F,0x4B,0x21,0x0,0x41,0x54,0x2B
	.DB  0x43,0x53,0x51,0x0,0x2B,0x43,0x53,0x51
	.DB  0x3A,0x0,0x4E,0x6F,0x20,0x73,0x69,0x67
	.DB  0x6E,0x61,0x6C,0x20,0x61,0x66,0x74,0x65
	.DB  0x72,0x20,0x25,0x64,0x20,0x72,0x65,0x74
	.DB  0x72,0x69,0x65,0x73,0x21,0xA,0x0,0x53
	.DB  0x65,0x74,0x74,0x69,0x6E,0x67,0x20,0x53
	.DB  0x4D,0x53,0x20,0x4D,0x6F,0x64,0x65,0x2E
	.DB  0x2E,0x2E,0x0,0x41,0x54,0x2B,0x43,0x46
	.DB  0x55,0x4E,0x3D,0x31,0x0,0x41,0x54,0x2B
	.DB  0x43,0x53,0x43,0x4C,0x4B,0x3D,0x30,0x0
	.DB  0x41,0x54,0x2B,0x43,0x4D,0x47,0x46,0x3D
	.DB  0x31,0x0,0x41,0x54,0x2B,0x43,0x4E,0x4D
	.DB  0x49,0x3D,0x32,0x2C,0x32,0x2C,0x30,0x2C
	.DB  0x30,0x2C,0x30,0x0,0x41,0x54,0x2B,0x43
	.DB  0x4D,0x47,0x44,0x41,0x3D,0x22,0x44,0x45
	.DB  0x4C,0x20,0x41,0x4C,0x4C,0x22,0x0,0x53
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
	.DB  0x2C,0x22,0x25,0x73,0x22,0x0,0x41,0x54
	.DB  0x2B,0x53,0x41,0x50,0x42,0x52,0x3D,0x31
	.DB  0x2C,0x31,0x0,0x46,0x65,0x74,0x63,0x68
	.DB  0x69,0x6E,0x67,0x20,0x49,0x50,0x2E,0x2E
	.DB  0x2E,0x0,0x2B,0x53,0x41,0x50,0x42,0x52
	.DB  0x3A,0x0,0x4E,0x6F,0x20,0x49,0x50,0x0
	.DB  0x41,0x54,0x2B,0x48,0x54,0x54,0x50,0x49
	.DB  0x4E,0x49,0x54,0x0,0x41,0x54,0x2B,0x48
	.DB  0x54,0x54,0x50,0x50,0x41,0x52,0x41,0x3D
	.DB  0x22,0x43,0x49,0x44,0x22,0x2C,0x31,0x0
	.DB  0x41,0x54,0x2B,0x48,0x54,0x54,0x50,0x50
	.DB  0x41,0x52,0x41,0x3D,0x22,0x55,0x52,0x4C
	.DB  0x22,0x2C,0x22,0x68,0x74,0x74,0x70,0x3A
	.DB  0x2F,0x2F,0x77,0x77,0x77,0x2E,0x67,0x6F
	.DB  0x6F,0x67,0x6C,0x65,0x2E,0x63,0x6F,0x6D
	.DB  0x22,0x0,0x41,0x54,0x2B,0x48,0x54,0x54
	.DB  0x50,0x41,0x43,0x54,0x49,0x4F,0x4E,0x3D
	.DB  0x30,0x0,0x48,0x54,0x54,0x50,0x41,0x43
	.DB  0x54,0x49,0x4F,0x4E,0x0,0x2B,0x48,0x54
	.DB  0x54,0x50,0x41,0x43,0x54,0x49,0x4F,0x4E
	.DB  0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0C
	.DW  _0x20
	.DW  _0x0*2+13

	.DW  0x0C
	.DW  _0x20+12
	.DW  _0x0*2+25

	.DW  0x14
	.DW  _0x20+24
	.DW  _0x0*2+37

	.DW  0x10
	.DW  _0x20+44
	.DW  _0x0*2+126

	.DW  0x0B
	.DW  _0x20+60
	.DW  _0x0*2+142

	.DW  0x0D
	.DW  _0x20+71
	.DW  _0x0*2+153

	.DW  0x0C
	.DW  _0x20+84
	.DW  _0x0*2+13

	.DW  0x0C
	.DW  _0x26
	.DW  _0x0*2+13

	.DW  0x0C
	.DW  _0x26+12
	.DW  _0x0*2+25

	.DW  0x14
	.DW  _0x26+24
	.DW  _0x0*2+37

	.DW  0x10
	.DW  _0x26+44
	.DW  _0x0*2+185

	.DW  0x0B
	.DW  _0x26+60
	.DW  _0x0*2+142

	.DW  0x0D
	.DW  _0x26+71
	.DW  _0x0*2+153

	.DW  0x0C
	.DW  _0x26+84
	.DW  _0x0*2+13

	.DW  0x24
	.DW  _0x2C
	.DW  _0x0*2+201

	.DW  0x08
	.DW  _0x2C+36
	.DW  _0x0*2+237

	.DW  0x0A
	.DW  _0x2C+44
	.DW  _0x0*2+245

	.DW  0x02
	.DW  _0x2C+54
	.DW  _0x0*2+55

	.DW  0x02
	.DW  _0x2C+56
	.DW  _0x0*2+255

	.DW  0x02
	.DW  _0x2C+58
	.DW  _0x0*2+257

	.DW  0x14
	.DW  _0x2C+60
	.DW  _0x0*2+259

	.DW  0x08
	.DW  _0x2C+80
	.DW  _0x0*2+279

	.DW  0x06
	.DW  _0x45
	.DW  _0x0*2+287

	.DW  0x0F
	.DW  _0x4E
	.DW  _0x0*2+293

	.DW  0x12
	.DW  _0x4E+15
	.DW  _0x0*2+308

	.DW  0x0F
	.DW  _0x4000F
	.DW  _0x40000*2

	.DW  0x0D
	.DW  _0x4000F+15
	.DW  _0x40000*2+15

	.DW  0x15
	.DW  _0x60003
	.DW  _0x60000*2

	.DW  0x0C
	.DW  _0x60003+21
	.DW  _0x60000*2+21

	.DW  0x03
	.DW  _0x60003+33
	.DW  _0x60000*2+33

	.DW  0x06
	.DW  _0x60003+36
	.DW  _0x60000*2+36

	.DW  0x14
	.DW  _0x60003+42
	.DW  _0x60000*2+42

	.DW  0x0D
	.DW  _0x60003+62
	.DW  _0x60000*2+62

	.DW  0x03
	.DW  _0x60003+75
	.DW  _0x60000*2+33

	.DW  0x15
	.DW  _0x60003+78
	.DW  _0x60000*2+75

	.DW  0x0D
	.DW  _0x60003+99
	.DW  _0x60000*2+96

	.DW  0x06
	.DW  _0x60003+112
	.DW  _0x60000*2+109

	.DW  0x08
	.DW  _0x60003+118
	.DW  _0x60000*2+115

	.DW  0x04
	.DW  _0x60003+126
	.DW  _0x60000*2+123

	.DW  0x04
	.DW  _0x60003+130
	.DW  _0x60000*2+127

	.DW  0x19
	.DW  _0x60003+134
	.DW  _0x60000*2+131

	.DW  0x0B
	.DW  _0x60003+159
	.DW  _0x60000*2+156

	.DW  0x03
	.DW  _0x60003+170
	.DW  _0x60000*2+33

	.DW  0x13
	.DW  _0x60003+173
	.DW  _0x60000*2+167

	.DW  0x0C
	.DW  _0x60003+192
	.DW  _0x60000*2+186

	.DW  0x03
	.DW  _0x60003+204
	.DW  _0x60000*2+33

	.DW  0x1A
	.DW  _0x60003+207
	.DW  _0x60000*2+198

	.DW  0x03
	.DW  _0x60003+233
	.DW  _0x60000*2+224

	.DW  0x03
	.DW  _0x60003+236
	.DW  _0x60000*2+33

	.DW  0x05
	.DW  _0x60003+239
	.DW  _0x60000*2+227

	.DW  0x03
	.DW  _0x60003+244
	.DW  _0x60000*2+33

	.DW  0x10
	.DW  _0x60003+247
	.DW  _0x60000*2+232

	.DW  0x03
	.DW  _0x60003+263
	.DW  _0x60000*2+224

	.DW  0x03
	.DW  _0x60003+266
	.DW  _0x60000*2+33

	.DW  0x12
	.DW  _0x60003+269
	.DW  _0x60000*2+248

	.DW  0x0E
	.DW  _0x60003+287
	.DW  _0x60000*2+266

	.DW  0x09
	.DW  _0x60028
	.DW  _0x60000*2+280

	.DW  0x05
	.DW  _0x60028+9
	.DW  _0x60000*2+289

	.DW  0x07
	.DW  _0x60028+14
	.DW  _0x60000*2+294

	.DW  0x09
	.DW  _0x60028+21
	.DW  _0x60000*2+301

	.DW  0x05
	.DW  _0x60028+30
	.DW  _0x60000*2+310

	.DW  0x07
	.DW  _0x60028+35
	.DW  _0x60000*2+315

	.DW  0x17
	.DW  _0x60028+42
	.DW  _0x60000*2+322

	.DW  0x0C
	.DW  _0x60028+65
	.DW  _0x60000*2+345

	.DW  0x07
	.DW  _0x60031
	.DW  _0x60000*2+357

	.DW  0x04
	.DW  _0x60031+7
	.DW  _0x60000*2+360

	.DW  0x06
	.DW  _0x60031+11
	.DW  _0x60000*2+364

	.DW  0x14
	.DW  _0x6003A
	.DW  _0x60000*2+399

	.DW  0x0A
	.DW  _0x6003A+20
	.DW  _0x60000*2+419

	.DW  0x0B
	.DW  _0x6003A+30
	.DW  _0x60000*2+429

	.DW  0x0A
	.DW  _0x6003A+41
	.DW  _0x60000*2+440

	.DW  0x12
	.DW  _0x6003A+51
	.DW  _0x60000*2+450

	.DW  0x13
	.DW  _0x6003A+69
	.DW  _0x60000*2+468

	.DW  0x0B
	.DW  _0x6003A+88
	.DW  _0x60000*2+487

	.DW  0x16
	.DW  _0x6003B
	.DW  _0x60000*2+498

	.DW  0x1E
	.DW  _0x6003B+22
	.DW  _0x60000*2+520

	.DW  0x0D
	.DW  _0x6003B+52
	.DW  _0x60000*2+574

	.DW  0x03
	.DW  _0x6003B+65
	.DW  _0x60000*2+33

	.DW  0x0F
	.DW  _0x6003B+68
	.DW  _0x60000*2+587

	.DW  0x0D
	.DW  _0x6003B+83
	.DW  _0x60000*2+96

	.DW  0x06
	.DW  _0x6003B+96
	.DW  _0x60000*2+109

	.DW  0x08
	.DW  _0x6003B+102
	.DW  _0x60000*2+602

	.DW  0x08
	.DW  _0x6003B+110
	.DW  _0x60000*2+602

	.DW  0x06
	.DW  _0x6003B+118
	.DW  _0x60000*2+610

	.DW  0x0C
	.DW  _0x60044
	.DW  _0x60000*2+21

	.DW  0x0C
	.DW  _0x60044+12
	.DW  _0x60000*2+616

	.DW  0x14
	.DW  _0x60044+24
	.DW  _0x60000*2+628

	.DW  0x2A
	.DW  _0x60044+44
	.DW  _0x60000*2+648

	.DW  0x10
	.DW  _0x60044+86
	.DW  _0x60000*2+690

	.DW  0x0B
	.DW  _0x60044+102
	.DW  _0x60000*2+706

	.DW  0x0C
	.DW  _0x60044+113
	.DW  _0x60000*2+717

	.DW  0x0C
	.DW  _0x60044+125
	.DW  _0x60000*2+21

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
;#include <stdlib.h> // E?C? C?E?CI? C? ECE? atoi
;#include <delay.h>
;
;#include "bitmaps.h"
;#include "common.h"
;#include "keypad.h"
;#include "motor.h"
;#include "init_sms.h"
;#include "sim800.h"
;
;
;typedef unsigned char uint8_t;
;typedef unsigned int  uint16_t;
;typedef signed char   int8_t;
;
;volatile unsigned long millis_counter = 0;
;//#define APN "mcinet" // APN C??CE?? I?I ?C ?C?I ???I
;const char APN[] = "mcinet";
;
;unsigned long last_time = 0;
;int device_id = 1;
;
;#define glcd_pixel(x, y, color) glcd_setpixel(x, y)
;#define read_flash_byte(p) (*(p))
;
;//#define BUFFER_SIZE 512
;#define HTTP_TIMEOUT_MS 5000
;
;
;#define MOTOR_DDR DDRE
;#define MOTOR_PORT PORTE
;#define MOTOR_PIN_1 2
;#define MOTOR_PIN_2 3
;#define MOTOR_PIN_3 4
;
;char ip_address_buffer[16];
;
;char value[16];
;char buffer[BUFFER_SIZE];
;
;volatile bit sms_received = 0;
;
;char header_buffer[100];
;char content_buffer[100];
;int header_index = 0;
;int content_index = 0;
;
;
;#define DATA_REGISTER_EMPTY (1<<UDRE0)
;#define RX_COMPLETE (1<<RXC0)
;#define FRAMING_ERROR (1<<FE0)
;#define PARITY_ERROR (1<<UPE0)
;#define DATA_OVERRUN (1<<DOR0)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 100
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0=0,rx_rd_index0=0;
;#else
;unsigned int rx_wr_index0=0,rx_rd_index0=0;
;#endif
;
;#if RX_BUFFER_SIZE0 < 256
;unsigned char rx_counter0=0;
;#else
;unsigned int rx_counter0=0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0051 {

	.CSEG
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0052     char status,data;
; 0000 0053     status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0054     data=UDR0;
	IN   R16,12
; 0000 0055     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0056     {
; 0000 0057         rx_buffer0[rx_wr_index0++]=data;
	LDS  R30,_rx_wr_index0
	SUBI R30,-LOW(1)
	STS  _rx_wr_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0058         #if RX_BUFFER_SIZE0 == 256
; 0000 0059         // special case for receiver buffer size=256
; 0000 005A         if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 005B         #else
; 0000 005C         if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDS  R26,_rx_wr_index0
	CPI  R26,LOW(0x64)
	BRNE _0x4
	LDI  R30,LOW(0)
	STS  _rx_wr_index0,R30
; 0000 005D         if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	LDS  R26,_rx_counter0
	SUBI R26,-LOW(1)
	STS  _rx_counter0,R26
	CPI  R26,LOW(0x64)
	BRNE _0x5
; 0000 005E             {
; 0000 005F             rx_counter0=0;
	LDI  R30,LOW(0)
	STS  _rx_counter0,R30
; 0000 0060             rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0061             }
; 0000 0062         #endif
; 0000 0063     }
_0x5:
; 0000 0064 }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 006B {
_getchar:
; .FSTART _getchar
; 0000 006C     char data;
; 0000 006D     while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	LDS  R30,_rx_counter0
	CPI  R30,0
	BREQ _0x6
; 0000 006E     data=rx_buffer0[rx_rd_index0++];
	LDS  R30,_rx_rd_index0
	SUBI R30,-LOW(1)
	STS  _rx_rd_index0,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 006F     #if RX_BUFFER_SIZE0 != 256
; 0000 0070     if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDS  R26,_rx_rd_index0
	CPI  R26,LOW(0x64)
	BRNE _0x9
	LDI  R30,LOW(0)
	STS  _rx_rd_index0,R30
; 0000 0071     #endif
; 0000 0072     #asm("cli")
_0x9:
	cli
; 0000 0073     --rx_counter0;
	LDS  R30,_rx_counter0
	SUBI R30,LOW(1)
	STS  _rx_counter0,R30
; 0000 0074     #asm("sei")
	sei
; 0000 0075     return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0076 }
; .FEND
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 007F {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0080     //  «Ì„— 0 œ— „œ ›⁄·Ì Â— ~32.768ms ”——Ì“ „Ìùò‰Â
; 0000 0081     millis_counter += 33;  // ÕœÊœÌ („Ìù Ê‰Ì œﬁÌﬁù — »« „Õ«”»Â prescaler œ—” ‘ ò‰Ì)
	CALL SUBOPT_0x0
	__ADDD1N 33
	STS  _millis_counter,R30
	STS  _millis_counter+1,R31
	STS  _millis_counter+2,R22
	STS  _millis_counter+3,R23
; 0000 0082 
; 0000 0083 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
; .FEND
;
;////////////////////////////////////////////////////////////////////////////////////////////////////////////
;
;
;void draw_bitmap(uint8_t x, uint8_t y, __flash unsigned char* bmp, uint8_t width, uint8_t height)
; 0000 0089 {
_draw_bitmap:
; .FSTART _draw_bitmap
; 0000 008A     uint16_t byte_index;
; 0000 008B     uint8_t page;
; 0000 008C     uint8_t col;
; 0000 008D     uint8_t bit_pos;
; 0000 008E     uint8_t data;
; 0000 008F     uint8_t pages;
; 0000 0090 
; 0000 0091     byte_index = 0;
	ST   -Y,R26
	SBIW R28,1
	CALL SUBOPT_0x1
;	x -> Y+12
;	y -> Y+11
;	*bmp -> Y+9
;	width -> Y+8
;	height -> Y+7
;	byte_index -> R16,R17
;	page -> R19
;	col -> R18
;	bit_pos -> R21
;	data -> R20
;	pages -> Y+6
; 0000 0092     pages = height / 8;
	LDD  R26,Y+7
	LDI  R27,0
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	STD  Y+6,R30
; 0000 0093 
; 0000 0094     for (page = 0; page < pages; page++) {
	LDI  R19,LOW(0)
_0xB:
	LDD  R30,Y+6
	CP   R19,R30
	BRSH _0xC
; 0000 0095         for (col = 0; col < width; col++) {
	LDI  R18,LOW(0)
_0xE:
	LDD  R30,Y+8
	CP   R18,R30
	BRSH _0xF
; 0000 0096             data = read_flash_byte(&bmp[byte_index++]);
	MOVW R30,R16
	__ADDWRN 16,17,1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R30,R26
	ADC  R31,R27
	LPM  R20,Z
; 0000 0097             for (bit_pos = 0; bit_pos < 8; bit_pos++) {
	LDI  R21,LOW(0)
_0x11:
	CPI  R21,8
	BRSH _0x12
; 0000 0098                 if (data & (1 << bit_pos)) {
	MOV  R30,R21
	CALL SUBOPT_0x2
	MOV  R26,R20
	CALL SUBOPT_0x3
	BREQ _0x13
; 0000 0099                     glcd_pixel(x + col, y + (page * 8) + bit_pos, 1);
	MOV  R30,R18
	LDD  R26,Y+12
	ADD  R30,R26
	ST   -Y,R30
	MOV  R30,R19
	LSL  R30
	LSL  R30
	LSL  R30
	LDD  R26,Y+12
	ADD  R30,R26
	ADD  R30,R21
	MOV  R26,R30
	CALL _glcd_setpixel
; 0000 009A                 }
; 0000 009B             }
_0x13:
	SUBI R21,-1
	RJMP _0x11
_0x12:
; 0000 009C         }
	SUBI R18,-1
	RJMP _0xE
_0xF:
; 0000 009D     }
	SUBI R19,-1
	RJMP _0xB
_0xC:
; 0000 009E }
	CALL __LOADLOCR6
	ADIW R28,13
	RET
; .FEND
;
;
;
;unsigned long millis(void)
; 0000 00A3 {
_millis:
; .FSTART _millis
; 0000 00A4     unsigned long ms;
; 0000 00A5     #asm("cli")
	SBIW R28,4
;	ms -> Y+0
	cli
; 0000 00A6     ms = millis_counter;
	CALL SUBOPT_0x0
	CALL __PUTD1S0
; 0000 00A7     #asm("sei")
	sei
; 0000 00A8     return ms;
	CALL __GETD1S0
	ADIW R28,4
	RET
; 0000 00A9 }
; .FEND
;
;
;void activate_motor(int product_id)
; 0000 00AD {
_activate_motor:
; .FSTART _activate_motor
; 0000 00AE     unsigned char motor_pin;
; 0000 00AF     char motor_msg[20];
; 0000 00B0     int timeout = 1000;
; 0000 00B1 
; 0000 00B2     switch (product_id)
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,20
	CALL __SAVELOCR4
;	product_id -> Y+24
;	motor_pin -> R17
;	motor_msg -> Y+4
;	timeout -> R18,R19
	__GETWRN 18,19,1000
	LDD  R30,Y+24
	LDD  R31,Y+24+1
; 0000 00B3     {
; 0000 00B4         case 1: motor_pin = MOTOR_PIN_1; break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x17
	LDI  R17,LOW(2)
	RJMP _0x16
; 0000 00B5         case 2: motor_pin = MOTOR_PIN_2; break;
_0x17:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x18
	LDI  R17,LOW(3)
	RJMP _0x16
; 0000 00B6         case 3: motor_pin = MOTOR_PIN_3; break;
_0x18:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1A
	LDI  R17,LOW(4)
	RJMP _0x16
; 0000 00B7         default: return;
_0x1A:
	RJMP _0x2120017
; 0000 00B8     }
_0x16:
; 0000 00B9 
; 0000 00BA     sprintf(motor_msg, "MOTOR %d ON!", product_id);
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+28
	LDD  R31,Y+28+1
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
; 0000 00BB     glcd_clear();
	CALL _glcd_clear
; 0000 00BC     glcd_outtextxy(10, 20, motor_msg);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,6
	CALL _glcd_outtextxy
; 0000 00BD     MOTOR_PORT |= (1 << motor_pin);
	IN   R1,3
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL __LSLB12
	OR   R30,R1
	OUT  0x3,R30
; 0000 00BE 
; 0000 00BF     while (!(PIND & (1 << PIND1)) && timeout > 0)
_0x1B:
	SBIC 0x10,1
	RJMP _0x1E
	CLR  R0
	CP   R0,R18
	CPC  R0,R19
	BRLT _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 00C0     {
; 0000 00C1         delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0000 00C2         timeout--;
	__SUBWRN 18,19,1
; 0000 00C3     }
	RJMP _0x1B
_0x1D:
; 0000 00C4 
; 0000 00C5     MOTOR_PORT &= ~(1 << motor_pin);
	IN   R1,3
	MOV  R30,R17
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
	OUT  0x3,R30
; 0000 00C6 //    glcd_clear();
; 0000 00C7 //    glcd_outtextxy(10, 20, motor_msg);
; 0000 00C8 
; 0000 00C9     glcd_clear();
	CALL SUBOPT_0x7
; 0000 00CA     draw_bitmap(0, 0, mahsol_ra_bardarid, 128, 64);
	CALL SUBOPT_0x8
	LDI  R26,LOW(64)
	RCALL _draw_bitmap
; 0000 00CB     delay_ms(500);
	CALL SUBOPT_0x9
; 0000 00CC }
_0x2120017:
	CALL __LOADLOCR4
	ADIW R28,26
	RET
; .FEND
;
;
;///////////////////////////////////////////////////////////////////////////////
;unsigned char send_data(const char* base_url, const char* phone_number, int product_id, int device_id) {
; 0000 00D0 unsigned char send_data(const char* base_url, const char* phone_number, int product_id, int device_id) {
_send_data:
; .FSTART _send_data
; 0000 00D1     // C??C? ?EU???C (C89)
; 0000 00D2     char cmd[100];
; 0000 00D3     char full_url[255];
; 0000 00D4     char *action_ptr;
; 0000 00D5     int method = 0, status_code = 0, data_len = 0;
; 0000 00D6 
; 0000 00D7     // ??C?O ??C? ??? GLCD
; 0000 00D8 //    glcd_clear();
; 0000 00D9 //    draw_bitmap(0, 0, lotfan_montazer_bemanid, 128, 64);
; 0000 00DA 
; 0000 00DB     uart_buffer_reset();
	CALL SUBOPT_0xA
;	*base_url -> Y+369
;	*phone_number -> Y+367
;	product_id -> Y+365
;	device_id -> Y+363
;	cmd -> Y+263
;	full_url -> Y+8
;	*action_ptr -> R16,R17
;	method -> R18,R19
;	status_code -> R20,R21
;	data_len -> Y+6
	CALL _uart_buffer_reset
; 0000 00DC     send_at_command("AT+HTTPTERM");
	__POINTW2MN _0x20,0
	CALL SUBOPT_0xB
; 0000 00DD     delay_ms(100);
; 0000 00DE 
; 0000 00DF     // --- ‘—Ê⁄ HTTP ---
; 0000 00E0     uart_buffer_reset();
; 0000 00E1     send_at_command("AT+HTTPINIT");
	__POINTW2MN _0x20,12
	CALL SUBOPT_0xB
; 0000 00E2     delay_ms(100);
; 0000 00E3 
; 0000 00E4     // --- «‰ Œ«» ò«‰ò‘‰ GPRS ---
; 0000 00E5     uart_buffer_reset();
; 0000 00E6     send_at_command("AT+HTTPPARA=\"CID\",1");
	__POINTW2MN _0x20,24
	CALL SUBOPT_0xB
; 0000 00E7     delay_ms(100);
; 0000 00E8 
; 0000 00E9     // ---  ‰ŸÌ„ URL ---
; 0000 00EA     uart_buffer_reset();
; 0000 00EB     snprintf(full_url, sizeof(full_url),
; 0000 00EC              "%s?phone_number=%s&device_id=%d&product_id=%d",
; 0000 00ED              base_url, phone_number, device_id, product_id);
	CALL SUBOPT_0xC
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,57
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 375
	CALL SUBOPT_0xD
	CALL SUBOPT_0xD
	CALL SUBOPT_0x4
	__GETW1SX 383
	CALL SUBOPT_0x4
	LDI  R24,16
	CALL _snprintf
	ADIW R28,22
; 0000 00EE 
; 0000 00EF     sprintf(cmd, "AT+HTTPPARA=\"URL\",\"%s\"", full_url);
	CALL SUBOPT_0xE
; 0000 00F0     send_at_command(cmd);
	MOVW R26,R28
	SUBI R26,LOW(-(263))
	SBCI R27,HIGH(-(263))
	CALL SUBOPT_0xB
; 0000 00F1     delay_ms(100);
; 0000 00F2 
; 0000 00F3 //    glcd_clear();
; 0000 00F4 //    glcd_outtextxy(0,10,full_url);
; 0000 00F5 //    delay_ms(500);
; 0000 00F6 
; 0000 00F7     // --- «—”«· œ—ŒÊ«”  GET ---
; 0000 00F8     uart_buffer_reset();
; 0000 00F9     send_at_command("AT+HTTPACTION=1"); // 0=GET
	__POINTW2MN _0x20,44
	CALL SUBOPT_0xB
; 0000 00FA     delay_ms(100); // ’»— »—«Ì Å«”Œ HTTP
; 0000 00FB 
; 0000 00FC     // --- »——”Ì Å«”Œ ---
; 0000 00FD     uart_buffer_reset();
; 0000 00FE     if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "HTTPACTION")) {
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	__POINTW2MN _0x20,60
	RCALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x21
; 0000 00FF         // „À«· Œ—ÊÃÌ: +HTTPACTION:0,200,1256
; 0000 0100 //        glcd_clear();
; 0000 0101 //        glcd_outtextxy(0,10,value);
; 0000 0102 //        delay_ms(500);
; 0000 0103         if (extract_field_after_keyword(buffer, "+HTTPACTION:", 1, value, sizeof(value))) {
	CALL SUBOPT_0xF
	__POINTW1MN _0x20,71
	CALL SUBOPT_0x11
; 0000 0104 //            glcd_clear();
; 0000 0105 //            glcd_outtextxy(0,10,value);
; 0000 0106 //            delay_ms(500);
; 0000 0107         }
; 0000 0108     }
; 0000 0109 
; 0000 010A //
; 0000 010B //    // 8) Terminate HTTP service
; 0000 010C     uart_buffer_reset();
_0x21:
	RCALL _uart_buffer_reset
; 0000 010D     send_at_command("AT+HTTPTERM");
	__POINTW2MN _0x20,84
	CALL SUBOPT_0x12
; 0000 010E     delay_ms(100);
; 0000 010F 
; 0000 0110     // 9) ?E???
; 0000 0111     return (atoi(value) == 200) ? 1 : 0;
	BRNE _0x23
	LDI  R30,LOW(1)
	RJMP _0x24
_0x23:
	LDI  R30,LOW(0)
_0x24:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,52
	SUBI R29,-1
	RET
; 0000 0112 }
; .FEND

	.DSEG
_0x20:
	.BYTE 0x60
;/////////////////////////////////////////////////////////////////////////////////
;
;
;
;unsigned char get_data(const char* base_url, const char* phone_number) {
; 0000 0117 unsigned char get_data(const char* base_url, const char* phone_number) {

	.CSEG
_get_data:
; .FSTART _get_data
; 0000 0118     // C??C? ?EU???C (C89)
; 0000 0119     char cmd[100];
; 0000 011A     char full_url[255];
; 0000 011B     char *action_ptr;
; 0000 011C     int method = 0, status_code = 0, data_len = 0;
; 0000 011D 
; 0000 011E     // ??C?O ??C? ??? GLCD
; 0000 011F     glcd_clear();
	CALL SUBOPT_0xA
;	*base_url -> Y+365
;	*phone_number -> Y+363
;	cmd -> Y+263
;	full_url -> Y+8
;	*action_ptr -> R16,R17
;	method -> R18,R19
;	status_code -> R20,R21
;	data_len -> Y+6
	CALL SUBOPT_0x7
; 0000 0120     draw_bitmap(0, 0, lotfan_montazer_bemanid, 128, 64);
	LDI  R30,LOW(_lotfan_montazer_bemanid*2)
	LDI  R31,HIGH(_lotfan_montazer_bemanid*2)
	CALL SUBOPT_0x13
; 0000 0121 
; 0000 0122     uart_buffer_reset();
	RCALL _uart_buffer_reset
; 0000 0123     send_at_command("AT+HTTPTERM");
	__POINTW2MN _0x26,0
	CALL SUBOPT_0xB
; 0000 0124     delay_ms(100);
; 0000 0125 
; 0000 0126     // --- ‘—Ê⁄ HTTP ---
; 0000 0127     uart_buffer_reset();
; 0000 0128     send_at_command("AT+HTTPINIT");
	__POINTW2MN _0x26,12
	CALL SUBOPT_0xB
; 0000 0129     delay_ms(100);
; 0000 012A 
; 0000 012B     // --- «‰ Œ«» ò«‰ò‘‰ GPRS ---
; 0000 012C     uart_buffer_reset();
; 0000 012D     send_at_command("AT+HTTPPARA=\"CID\",1");
	__POINTW2MN _0x26,24
	CALL SUBOPT_0xB
; 0000 012E     delay_ms(100);
; 0000 012F 
; 0000 0130     // ---  ‰ŸÌ„ URL ---
; 0000 0131     uart_buffer_reset();
; 0000 0132     sprintf(full_url, "%s?phone_number=%s", base_url, phone_number);
	CALL SUBOPT_0xC
	__POINTW1FN _0x0,166
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 369
	CALL SUBOPT_0x14
	CALL SUBOPT_0x15
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 0133     snprintf(full_url, sizeof(full_url),
; 0000 0134              "%s?phone_number=%s",
; 0000 0135              base_url, phone_number);
	CALL SUBOPT_0xC
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,166
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x15
	__GETW1SX 373
	CALL SUBOPT_0x14
	LDI  R24,8
	CALL _snprintf
	ADIW R28,14
; 0000 0136     sprintf(cmd, "AT+HTTPPARA=\"URL\",\"%s\"", full_url);
	CALL SUBOPT_0xE
; 0000 0137     send_at_command(cmd);
	MOVW R26,R28
	SUBI R26,LOW(-(263))
	SBCI R27,HIGH(-(263))
	CALL SUBOPT_0xB
; 0000 0138     delay_ms(100);
; 0000 0139 
; 0000 013A 
; 0000 013B //    glcd_clear();
; 0000 013C //    glcd_outtextxy(0,10,full_url);
; 0000 013D //    delay_ms(500);
; 0000 013E 
; 0000 013F 
; 0000 0140     // --- «—”«· œ—ŒÊ«”  GET ---
; 0000 0141     uart_buffer_reset();
; 0000 0142     send_at_command("AT+HTTPACTION=0"); // 0=GET
	__POINTW2MN _0x26,44
	CALL SUBOPT_0xB
; 0000 0143     delay_ms(100); // ’»— »—«Ì Å«”Œ HTTP
; 0000 0144 
; 0000 0145     // --- »——”Ì Å«”Œ ---
; 0000 0146     uart_buffer_reset();
; 0000 0147     if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "HTTPACTION")) {
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	__POINTW2MN _0x26,60
	RCALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x27
; 0000 0148         // „À«· Œ—ÊÃÌ: +HTTPACTION:0,200,1256
; 0000 0149 //        glcd_clear();
; 0000 014A //        glcd_outtextxy(0,10,value);
; 0000 014B //        delay_ms(500);
; 0000 014C         if (extract_field_after_keyword(buffer, "+HTTPACTION:", 1, value, sizeof(value))) {
	CALL SUBOPT_0xF
	__POINTW1MN _0x26,71
	CALL SUBOPT_0x11
; 0000 014D //            glcd_clear();
; 0000 014E //            glcd_outtextxy(0,10,value);
; 0000 014F //            delay_ms(500);
; 0000 0150         }
; 0000 0151     }
; 0000 0152 
; 0000 0153 //
; 0000 0154 //    // 8) Terminate HTTP service
; 0000 0155     uart_buffer_reset();
_0x27:
	RCALL _uart_buffer_reset
; 0000 0156     send_at_command("AT+HTTPTERM");
	__POINTW2MN _0x26,84
	CALL SUBOPT_0x12
; 0000 0157     delay_ms(100);
; 0000 0158 
; 0000 0159     // 9) ?E???
; 0000 015A     return (atoi(value) == 200) ? 1 : 0;
	BRNE _0x29
	LDI  R30,LOW(1)
	RJMP _0x2A
_0x29:
	LDI  R30,LOW(0)
_0x2A:
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,48
	SUBI R29,-1
	RET
; 0000 015B }
; .FEND

	.DSEG
_0x26:
	.BYTE 0x60
;
;
;void handle_sms(void)
; 0000 015F {

	.CSEG
_handle_sms:
; .FSTART _handle_sms
; 0000 0160     char tmp[2];
; 0000 0161     const char* server_url_post = "http://185.8.173.17:8000/home/post/";
; 0000 0162     int product_id = 0;
; 0000 0163     int timeout_counter = 0;
; 0000 0164     char key_pressed;
; 0000 0165     char *tok, phone[32];
; 0000 0166     tok = strtok(header_buffer, "\"");      // ?IC ??I? +CMT:
	SBIW R28,37
	CALL __SAVELOCR6
;	tmp -> Y+41
;	*server_url_post -> R16,R17
;	product_id -> R18,R19
;	timeout_counter -> R20,R21
;	key_pressed -> Y+40
;	*tok -> Y+38
;	phone -> Y+6
	__POINTWRMN 16,17,_0x2C,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(_header_buffer)
	LDI  R31,HIGH(_header_buffer)
	CALL SUBOPT_0x16
; 0000 0167     tok = strtok(NULL, "\"");               // C???EC? O?C?? ICI? ??E?O?
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL SUBOPT_0x16
; 0000 0168     if (tok) strcpy(phone, tok);
	LDD  R30,Y+38
	LDD  R31,Y+38+1
	SBIW R30,0
	BREQ _0x2D
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+40
	LDD  R27,Y+40+1
	RJMP _0x5C
; 0000 0169     else    strcpy(phone, "unknown");
_0x2D:
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x2C,36
_0x5C:
	CALL _strcpy
; 0000 016A 
; 0000 016B     glcd_clear();
	CALL SUBOPT_0x7
; 0000 016C     glcd_outtextxy(0,0,"SMS from:");
	__POINTW2MN _0x2C,44
	CALL _glcd_outtextxy
; 0000 016D     glcd_outtextxy(0,10,phone);
	CALL SUBOPT_0x17
	MOVW R26,R28
	ADIW R26,8
	CALL _glcd_outtextxy
; 0000 016E     glcd_outtextxy(0,20,content_buffer);
	CALL SUBOPT_0x18
	LDI  R26,LOW(_content_buffer)
	LDI  R27,HIGH(_content_buffer)
	CALL _glcd_outtextxy
; 0000 016F     delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 0170 
; 0000 0171 //////////////////////////////////////////////////////////////////////////////////////////////
; 0000 0172 
; 0000 0173     if (strcmp(content_buffer, "1") == 0 || strcmp(content_buffer, "2") == 0 || strcmp(content_buffer, "3") == 0)
	CALL SUBOPT_0x19
	__POINTW2MN _0x2C,54
	CALL _strcmp
	CPI  R30,0
	BREQ _0x30
	CALL SUBOPT_0x19
	__POINTW2MN _0x2C,56
	CALL _strcmp
	CPI  R30,0
	BREQ _0x30
	CALL SUBOPT_0x19
	__POINTW2MN _0x2C,58
	CALL _strcmp
	CPI  R30,0
	BREQ _0x30
	RJMP _0x2F
_0x30:
; 0000 0174     {
; 0000 0175 //        product_id = 1;
; 0000 0176 //        device_id = 1;
; 0000 0177 //        send_data(server_url_post, phone, product_id, device_id);
; 0000 0178 
; 0000 0179         if (get_data(server_url_post, phone))
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,8
	RCALL _get_data
	CPI  R30,0
	BRNE PC+2
	RJMP _0x32
; 0000 017A         {
; 0000 017B             glcd_clear();
	CALL SUBOPT_0x7
; 0000 017C 
; 0000 017D             draw_bitmap(0, 0, adad_ra_vared_namaeid, 128, 64);
	LDI  R30,LOW(_adad_ra_vared_namaeid*2)
	LDI  R31,HIGH(_adad_ra_vared_namaeid*2)
	CALL SUBOPT_0x13
; 0000 017E             draw_bitmap(0, 32, square, 128, 32);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R30,LOW(_square*2)
	LDI  R31,HIGH(_square*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDI  R26,LOW(32)
	RCALL _draw_bitmap
; 0000 017F             glcd_outtextxy(64, 42, content_buffer);
	LDI  R30,LOW(64)
	ST   -Y,R30
	LDI  R30,LOW(42)
	ST   -Y,R30
	LDI  R26,LOW(_content_buffer)
	LDI  R27,HIGH(_content_buffer)
	CALL _glcd_outtextxy
; 0000 0180 
; 0000 0181             key_pressed = 0;
	LDI  R30,LOW(0)
	STD  Y+40,R30
; 0000 0182             for (timeout_counter = 0; timeout_counter < 200; timeout_counter++)
	__GETWRN 20,21,0
_0x34:
	__CPWRN 20,21,200
	BRGE _0x35
; 0000 0183             {
; 0000 0184                 key_pressed = get_key();
	CALL _get_key
	STD  Y+40,R30
; 0000 0185                 if (key_pressed != 0) break;
	CPI  R30,0
	BRNE _0x35
; 0000 0186                 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0000 0187             }
	__ADDWRN 20,21,1
	RJMP _0x34
_0x35:
; 0000 0188 
; 0000 0189             if (key_pressed == 0)
	LDD  R30,Y+40
	CPI  R30,0
	BRNE _0x37
; 0000 018A             {
; 0000 018B                 glcd_clear();
	CALL _glcd_clear
; 0000 018C                 glcd_outtextxy(10, 25, "Timeout! Try again.");
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x2C,60
	CALL _glcd_outtextxy
; 0000 018D                 delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RJMP _0x5D
; 0000 018E             }
; 0000 018F             else
_0x37:
; 0000 0190             {
; 0000 0191 //                glcd_clear();
; 0000 0192 //                tmp[0] = content_buffer[0];
; 0000 0193 //                tmp[1] = '\0';
; 0000 0194 //                glcd_outtextxy(5, 25, tmp);
; 0000 0195 //
; 0000 0196 //                // ‰„«Ì‘ key_pressed
; 0000 0197 //                tmp[0] = key_pressed;
; 0000 0198 //                tmp[1] = '\0';
; 0000 0199 //                glcd_outtextxy(5, 45, tmp);
; 0000 019A //                delay_ms(1000);
; 0000 019B                 // Êﬁ Ì ò·ÌœÂ« 0..9 »Â ’Ê—  ⁄œœ »—„Ìùê—œ‰
; 0000 019C //                if (key_pressed >= 0 && key_pressed <= 9) {
; 0000 019D //                    key_pressed = '0' + key_pressed;   //  »œÌ· »Â ò«—«ò — '0'..'9'
; 0000 019E //                }
; 0000 019F                 if (key_pressed == content_buffer[0])
	LDS  R30,_content_buffer
	LDD  R26,Y+40
	CP   R30,R26
	BRNE _0x39
; 0000 01A0                 {
; 0000 01A1                     glcd_clear();
	CALL _glcd_clear
; 0000 01A2 //                    glcd_outtextxy(5, 25, "test 3!");
; 0000 01A3 //                    delay_ms(300);
; 0000 01A4                     product_id = content_buffer[0] - '0';
	LDS  R30,_content_buffer
	LDI  R31,0
	SBIW R30,48
	MOVW R18,R30
; 0000 01A5                     activate_motor(product_id);
	MOVW R26,R18
	RCALL _activate_motor
; 0000 01A6 //                    glcd_clear();
; 0000 01A7                     draw_bitmap(0, 32, mahsol_ra_bardarid, 128, 32);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x8
	LDI  R26,LOW(32)
	RCALL _draw_bitmap
; 0000 01A8                     send_data(server_url_post, phone, product_id, device_id);
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0xC
	ST   -Y,R19
	ST   -Y,R18
	MOVW R26,R4
	RCALL _send_data
; 0000 01A9                 }
; 0000 01AA                 else
	RJMP _0x3A
_0x39:
; 0000 01AB                 {
; 0000 01AC 
; 0000 01AD                     glcd_clear();
	CALL _glcd_clear
; 0000 01AE                     glcd_outtextxy(5, 25, "test 2!");
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(25)
	ST   -Y,R30
	__POINTW2MN _0x2C,80
	CALL _glcd_outtextxy
; 0000 01AF //                    draw_bitmap(0, 0, shomare_soton_dorost_vared_nashode, 128, 32);
; 0000 01B0                     delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
_0x5D:
	CALL _delay_ms
; 0000 01B1                 }
_0x3A:
; 0000 01B2             }
; 0000 01B3         }
; 0000 01B4         else
	RJMP _0x3B
_0x32:
; 0000 01B5         {
; 0000 01B6             glcd_clear();
	CALL SUBOPT_0x7
; 0000 01B7             draw_bitmap(0, 0, tedad_bish_az_had, 128, 64);
	LDI  R30,LOW(_tedad_bish_az_had*2)
	LDI  R31,HIGH(_tedad_bish_az_had*2)
	CALL SUBOPT_0x13
; 0000 01B8             delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 01B9         }
_0x3B:
; 0000 01BA     }
; 0000 01BB 
; 0000 01BC     else
	RJMP _0x3C
_0x2F:
; 0000 01BD     {
; 0000 01BE         glcd_clear();
	CALL SUBOPT_0x7
; 0000 01BF         draw_bitmap(0, 0, shomare_dorost_payamak_nashode, 128, 64);
	LDI  R30,LOW(_shomare_dorost_payamak_nashode*2)
	LDI  R31,HIGH(_shomare_dorost_payamak_nashode*2)
	CALL SUBOPT_0x13
; 0000 01C0         delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	CALL _delay_ms
; 0000 01C1 
; 0000 01C2     }
_0x3C:
; 0000 01C3 
; 0000 01C4 ////////////////////////////////////////////////////////////////////////////////////////////
; 0000 01C5     sms_received = 0;  // A?CI? E?C? ??C? E?I?
	CLT
	BLD  R2,1
; 0000 01C6 }
	CALL __LOADLOCR6
	ADIW R28,43
	RET
; .FEND

	.DSEG
_0x2C:
	.BYTE 0x58
;
;
;void process_uart_data(void)
; 0000 01CA {

	.CSEG
_process_uart_data:
; .FSTART _process_uart_data
; 0000 01CB     static uint8_t phase = 0;   // 0=I?C?I? ?I?? 1=I?C?I? ??E?C
; 0000 01CC     static uint8_t h_idx = 0;
; 0000 01CD     static uint8_t c_idx = 0;
; 0000 01CE     char d;
; 0000 01CF 
; 0000 01D0     while (rx_counter0 > 0 && !sms_received) {
	ST   -Y,R17
;	d -> R17
_0x3D:
	LDS  R26,_rx_counter0
	CPI  R26,LOW(0x1)
	BRLO _0x40
	SBRS R2,1
	RJMP _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 01D1         d = getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 01D2 
; 0000 01D3         if (phase == 0) {
	LDS  R30,_phase_S0000009000
	CPI  R30,0
	BRNE _0x42
; 0000 01D4             // -- I?C?I? ?I? EC '\n' --
; 0000 01D5             if (d == '\n') {
	CPI  R17,10
	BRNE _0x43
; 0000 01D6                 header_buffer[h_idx] = '\0';
	LDS  R30,_h_idx_S0000009000
	LDI  R31,0
	SUBI R30,LOW(-_header_buffer)
	SBCI R31,HIGH(-_header_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01D7                 // ??? C?? ?I? ?C??? SMS ECOI? E??? ??CU I?C?I? ??E?C
; 0000 01D8                 if (strstr(header_buffer, "+CMT:") != NULL) {
	LDI  R30,LOW(_header_buffer)
	LDI  R31,HIGH(_header_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x45,0
	CALL _strstr
	SBIW R30,0
	BREQ _0x44
; 0000 01D9                     phase = 1;
	LDI  R30,LOW(1)
	STS  _phase_S0000009000,R30
; 0000 01DA                     c_idx = 0;  // A?CI? E?C? ?? ??I? content_buffer
	LDI  R30,LOW(0)
	STS  _c_idx_S0000009000,R30
; 0000 01DB                 }
; 0000 01DC                 // ???O? h_idx ?C ???E ?? EC I??? E?I? C? C?? ?? O??I
; 0000 01DD                 h_idx = 0;
_0x44:
	LDI  R30,LOW(0)
	STS  _h_idx_S0000009000,R30
; 0000 01DE             }
; 0000 01DF             else if (d != '\r') {
	RJMP _0x46
_0x43:
	CPI  R17,13
	BREQ _0x47
; 0000 01E0                 // ?I???? ?C?C?E? I? header_buffer
; 0000 01E1                 if (h_idx < sizeof(header_buffer) - 1)
	LDS  R26,_h_idx_S0000009000
	CPI  R26,LOW(0x63)
	BRSH _0x48
; 0000 01E2                     header_buffer[h_idx++] = d;
	LDS  R30,_h_idx_S0000009000
	SUBI R30,-LOW(1)
	STS  _h_idx_S0000009000,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_header_buffer)
	SBCI R31,HIGH(-_header_buffer)
	ST   Z,R17
; 0000 01E3             }
_0x48:
; 0000 01E4         }
_0x47:
_0x46:
; 0000 01E5         else {
	RJMP _0x49
_0x42:
; 0000 01E6             // -- I?C?I? ??E?C EC '\n' --
; 0000 01E7             if (d == '\n') {
	CPI  R17,10
	BRNE _0x4A
; 0000 01E8                 content_buffer[c_idx] = '\0';
	LDS  R30,_c_idx_S0000009000
	LDI  R31,0
	SUBI R30,LOW(-_content_buffer)
	SBCI R31,HIGH(-_content_buffer)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 01E9                 sms_received = 1;    // ?? SMS ?C?? I??C?E OI
	SET
	BLD  R2,1
; 0000 01EA                 phase = 0;           // E?C? ??C? E?I? I?EC?? E??????I?? E? ?C? 0
	LDI  R30,LOW(0)
	STS  _phase_S0000009000,R30
; 0000 01EB                 h_idx = 0;           // C??I????C ?C ?? ?C? ???????
	STS  _h_idx_S0000009000,R30
; 0000 01EC                 c_idx = 0;
	STS  _c_idx_S0000009000,R30
; 0000 01ED             }
; 0000 01EE             else if (d != '\r') {
	RJMP _0x4B
_0x4A:
	CPI  R17,13
	BREQ _0x4C
; 0000 01EF                 if (c_idx < sizeof(content_buffer) - 1)
	LDS  R26,_c_idx_S0000009000
	CPI  R26,LOW(0x63)
	BRSH _0x4D
; 0000 01F0                     content_buffer[c_idx++] = d;
	LDS  R30,_c_idx_S0000009000
	SUBI R30,-LOW(1)
	STS  _c_idx_S0000009000,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_content_buffer)
	SBCI R31,HIGH(-_content_buffer)
	ST   Z,R17
; 0000 01F1             }
_0x4D:
; 0000 01F2         }
_0x4C:
_0x4B:
_0x49:
; 0000 01F3     }
	RJMP _0x3D
_0x3F:
; 0000 01F4 }
	JMP  _0x212000F
; .FEND

	.DSEG
_0x45:
	.BYTE 0x6
;
;
;
;void main(void)
; 0000 01F9 {

	.CSEG
_main:
; .FSTART _main
; 0000 01FA 
; 0000 01FB     GLCDINIT_t glcd_init_data;
; 0000 01FC 
; 0000 01FD 
; 0000 01FE     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,6
;	glcd_init_data -> Y+0
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 01FF     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0200 
; 0000 0201     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0202     PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 0203 
; 0000 0204     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 0205     PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 0206 
; 0000 0207     DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0208     PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (1<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(2)
	OUT  0x12,R30
; 0000 0209 
; 0000 020A     DDRE=(0<<DDE7) | (0<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (0<<DDE1) | (0<<DDE0);
	LDI  R30,LOW(60)
	OUT  0x2,R30
; 0000 020B     PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 020C 
; 0000 020D     DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 020E     PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 020F 
; 0000 0210     DDRG=(0<<DDG4) | (0<<DDG3) | (0<<DDG2) | (0<<DDG1) | (0<<DDG0);
	STS  100,R30
; 0000 0211     PORTG=(0<<PORTG4) | (0<<PORTG3) | (0<<PORTG2) | (0<<PORTG1) | (0<<PORTG0);
	STS  101,R30
; 0000 0212 
; 0000 0213     // Timer Period: 32.768 ms
; 0000 0214     ASSR=0<<AS0;
	OUT  0x30,R30
; 0000 0215     TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (1<<CS01) | (1<<CS00);
	LDI  R30,LOW(7)
	OUT  0x33,R30
; 0000 0216     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0217     OCR0=0x00;
	OUT  0x31,R30
; 0000 0218 
; 0000 0219     TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<COM1C1) | (0<<COM1C0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 021A     TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 021B     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 021C     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 021D     ICR1H=0x00;
	OUT  0x27,R30
; 0000 021E     ICR1L=0x00;
	OUT  0x26,R30
; 0000 021F     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0220     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0221     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0222     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0223     OCR1CH=0x00;
	STS  121,R30
; 0000 0224     OCR1CL=0x00;
	STS  120,R30
; 0000 0225 
; 0000 0226     TCCR2=(0<<WGM20) | (0<<COM21) | (0<<COM20) | (0<<WGM21) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0227     TCNT2=0x00;
	OUT  0x24,R30
; 0000 0228     OCR2=0x00;
	OUT  0x23,R30
; 0000 0229 
; 0000 022A 
; 0000 022B     TCCR3A=(0<<COM3A1) | (0<<COM3A0) | (0<<COM3B1) | (0<<COM3B0) | (0<<COM3C1) | (0<<COM3C0) | (0<<WGM31) | (0<<WGM30);
	STS  139,R30
; 0000 022C     TCCR3B=(0<<ICNC3) | (0<<ICES3) | (0<<WGM33) | (0<<WGM32) | (0<<CS32) | (0<<CS31) | (0<<CS30);
	STS  138,R30
; 0000 022D     TCNT3H=0x00;
	STS  137,R30
; 0000 022E     TCNT3L=0x00;
	STS  136,R30
; 0000 022F     ICR3H=0x00;
	STS  129,R30
; 0000 0230     ICR3L=0x00;
	STS  128,R30
; 0000 0231     OCR3AH=0x00;
	STS  135,R30
; 0000 0232     OCR3AL=0x00;
	STS  134,R30
; 0000 0233     OCR3BH=0x00;
	STS  133,R30
; 0000 0234     OCR3BL=0x00;
	STS  132,R30
; 0000 0235     OCR3CH=0x00;
	STS  131,R30
; 0000 0236     OCR3CL=0x00;
	STS  130,R30
; 0000 0237 
; 0000 0238     TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 0239     ETIMSK=(0<<TICIE3) | (0<<OCIE3A) | (0<<OCIE3B) | (0<<TOIE3) | (0<<OCIE3C) | (0<<OCIE1C);
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 023A 
; 0000 023B     EICRA=(0<<ISC31) | (0<<ISC30) | (0<<ISC21) | (0<<ISC20) | (0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	STS  106,R30
; 0000 023C     EICRB=(0<<ISC71) | (0<<ISC70) | (0<<ISC61) | (0<<ISC60) | (0<<ISC51) | (0<<ISC50) | (0<<ISC41) | (0<<ISC40);
	OUT  0x3A,R30
; 0000 023D     EIMSK=(0<<INT7) | (0<<INT6) | (0<<INT5) | (0<<INT4) | (0<<INT3) | (0<<INT2) | (0<<INT1) | (0<<INT0);
	OUT  0x39,R30
; 0000 023E 
; 0000 023F     UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0240     UCSR0B=(1<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0241     UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0242     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0243     UBRR0L=0x33;
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0244 
; 0000 0245     UCSR1B=(0<<RXCIE1) | (0<<TXCIE1) | (0<<UDRIE1) | (0<<RXEN1) | (0<<TXEN1) | (0<<UCSZ12) | (0<<RXB81) | (0<<TXB81);
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 0246 
; 0000 0247     ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0248     SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0249 
; 0000 024A     ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 024B 
; 0000 024C     SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	OUT  0xD,R30
; 0000 024D 
; 0000 024E     TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	STS  116,R30
; 0000 024F 
; 0000 0250     MCUCSR = (1 << JTD);
	LDI  R30,LOW(128)
	OUT  0x34,R30
; 0000 0251     MCUCSR = (1 << JTD);
	OUT  0x34,R30
; 0000 0252 
; 0000 0253     glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0254     glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0255     glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 0256     glcd_init(&glcd_init_data);
	MOVW R26,R28
	CALL _glcd_init
; 0000 0257     glcd_setfont(font5x7);
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	CALL SUBOPT_0x1A
; 0000 0258 
; 0000 0259     // Global enable interrupts
; 0000 025A     #asm("sei")
	sei
; 0000 025B 
; 0000 025C     glcd_clear();
	CALL SUBOPT_0x7
; 0000 025D     glcd_outtextxy(0, 0, "Module Init...");
	__POINTW2MN _0x4E,0
	CALL _glcd_outtextxy
; 0000 025E     delay_ms(500);
	CALL SUBOPT_0x9
; 0000 025F 
; 0000 0260 //    sim800_restart();
; 0000 0261 //    check_sim();
; 0000 0262 //    if (!check_signal_with_restart()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
; 0000 0263 //    if (!init_sms()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
; 0000 0264 
; 0000 0265     while (1) {
_0x4F:
; 0000 0266 //        full_check();
; 0000 0267         sim800_restart();
	CALL _sim800_restart
; 0000 0268         check_sim();
	CALL _check_sim
; 0000 0269         check_signal_with_restart();
	CALL _check_signal_with_restart
; 0000 026A         init_sms();
	CALL _init_sms
; 0000 026B 
; 0000 026C         if (init_GPRS()) {
	CALL _init_GPRS
	CPI  R30,0
	BRNE _0x51
; 0000 026D             // «ê— „Ê›ﬁ ‘œ° «“ Õ·ﬁÂ Œ«—Ã »‘Â
; 0000 026E             break;
; 0000 026F         } else {
; 0000 0270             // «ê— ‰«„Ê›ﬁ »Êœ
; 0000 0271             glcd_clear();
	CALL SUBOPT_0x7
; 0000 0272             glcd_outtextxy(0, 0, "GPRS Init Failed!");
	__POINTW2MN _0x4E,15
	CALL SUBOPT_0x1B
; 0000 0273             delay_ms(100);  // ò„Ì ’»— ò‰Â
; 0000 0274             // Ê œÊ»«—Â Õ·ﬁÂ  ò—«— „Ì‘Â
; 0000 0275         }
; 0000 0276     }
	RJMP _0x4F
_0x51:
; 0000 0277 
; 0000 0278 
; 0000 0279 
; 0000 027A     glcd_clear();
	CALL _glcd_clear
; 0000 027B 
; 0000 027C     while (1){
_0x54:
; 0000 027D         static uint8_t processing_sms = 0;
; 0000 027E         draw_bitmap(0, 0, kode_mahsol_payamak_konid, 128, 64);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R30,LOW(_kode_mahsol_payamak_konid*2)
	LDI  R31,HIGH(_kode_mahsol_payamak_konid*2)
	CALL SUBOPT_0x13
; 0000 027F         //test_keypad();
; 0000 0280         process_uart_data();
	RCALL _process_uart_data
; 0000 0281 
; 0000 0282         if (sms_received) {
	SBRS R2,1
	RJMP _0x57
; 0000 0283             processing_sms = 1;   // ‘—Ê⁄ Å—œ«“‘ ÅÌ«„ò
	LDI  R30,LOW(1)
	STS  _processing_sms_S000000A001,R30
; 0000 0284             handle_sms();
	RCALL _handle_sms
; 0000 0285             processing_sms = 0;   // Å«Ì«‰ Å—œ«“‘ ÅÌ«„ò
	LDI  R30,LOW(0)
	STS  _processing_sms_S000000A001,R30
; 0000 0286             uart_buffer_reset();
	RCALL _uart_buffer_reset
; 0000 0287             glcd_clear();
	CALL _glcd_clear
; 0000 0288         }
; 0000 0289 
; 0000 028A         if (!processing_sms && (millis() - last_time > 50000)) {
_0x57:
	LDS  R30,_processing_sms_S000000A001
	CPI  R30,0
	BRNE _0x59
	RCALL _millis
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_last_time
	LDS  R31,_last_time+1
	LDS  R22,_last_time+2
	LDS  R23,_last_time+3
	CALL __SUBD21
	__CPD2N 0xC351
	BRSH _0x5A
_0x59:
	RJMP _0x58
_0x5A:
; 0000 028B             gprs_keep_alive();
	CALL _gprs_keep_alive
; 0000 028C             last_time = millis();
	RCALL _millis
	STS  _last_time,R30
	STS  _last_time+1,R31
	STS  _last_time+2,R22
	STS  _last_time+3,R23
; 0000 028D             uart_buffer_reset();
	RCALL _uart_buffer_reset
; 0000 028E             glcd_clear();
	CALL _glcd_clear
; 0000 028F         }
; 0000 0290 
; 0000 0291     }
_0x58:
	RJMP _0x54
; 0000 0292 }
_0x5B:
	RJMP _0x5B
; .FEND

	.DSEG
_0x4E:
	.BYTE 0x21
;#include "common.h"
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
;#include <string.h>
;#include <delay.h>
;#include <mega64a.h>
;#include <glcd.h>
;
;#define glcd_pixel(x, y, color) glcd_setpixel(x, y)
;#define read_flash_byte(p) (*(p))
;
;// --- «—”«· œ” Ê— AT ---
;void send_at_command(char *command)
; 0001 000C {

	.CSEG
_send_at_command:
; .FSTART _send_at_command
; 0001 000D     printf("%s\r\n", command);
	ST   -Y,R27
	ST   -Y,R26
;	*command -> Y+0
	__POINTW1FN _0x20000,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x14
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0001 000E }
	JMP  _0x212000E
; .FEND
;
;// --- Å«ò ò—œ‰ »«›— USART0 ---
;void uart_flush0(void)
; 0001 0012 {
; 0001 0013     unsigned char dummy;
; 0001 0014 
; 0001 0015     // Å«ò ò—œ‰ —ÃÌ” — ”Œ ù«›“«—Ì
; 0001 0016     while (UCSR0A & (1<<RXC0)) {
;	dummy -> R17
; 0001 0017         dummy = UDR0;
; 0001 0018     }
; 0001 0019 //
; 0001 001A //    // Å«ò ò—œ‰ »«›— ‰—„ù«›“«—Ì
; 0001 001B //    rx_wr_index0 = rx_rd_index0 = 0;
; 0001 001C //    rx_counter0 = 0;
; 0001 001D //    rx_buffer_overflow0 = 0;
; 0001 001E }
;
;
;void uart_buffer_reset(void) {
; 0001 0021 void uart_buffer_reset(void) {
_uart_buffer_reset:
; .FSTART _uart_buffer_reset
; 0001 0022     rx_wr_index0 = rx_rd_index0 = 0;
	LDI  R30,LOW(0)
	STS  _rx_rd_index0,R30
	STS  _rx_wr_index0,R30
; 0001 0023     rx_counter0 = 0;
	STS  _rx_counter0,R30
; 0001 0024     rx_buffer_overflow0 = 0;
	CLT
	BLD  R2,0
; 0001 0025 }
	RET
; .FEND
;
;
;//unsigned char read_serial_timeout_simple(char* buffer, int buffer_size, unsigned long timeout_ms) {
;//    int i = 0;
;//    unsigned long elapsed = 0;
;//
;//    // »«›— „Õ·Ì —« ’›— „Ìùò‰Ì„
;//    memset(buffer, 0, buffer_size);
;//
;//    //  «Ì„ù«Ê   ﬁ—Ì»Ì »— Õ”» Õ·ﬁÂ Ê delay
;//    while (elapsed < timeout_ms && i < buffer_size - 1) {
;//        // «ê— œ«œÂù«Ì œ— UART ¬„œÂ »«‘œ
;//        while (rx_counter0 > 0 && i < buffer_size - 1) {
;//            char c = getchar();  // ŒÊ«‰œ‰ Ìò ò«—«ò — «“ UART
;//            buffer[i++] = c;
;//            buffer[i] = '\0';
;//
;//            // ‰„«Ì‘ “‰œÂ —ÊÌ GLCD
;//            glcd_outtextxy(0, 0, buffer);
;//        }
;//        delay_ms(1);
;//        elapsed++;
;//    }
;//
;//    return (i > 0); // 1 «ê— Õœ«ﬁ· Ìò ò«—«ò — œ—Ì«›  ‘œÂ »«‘œ
;//}
;
;
;
;// »Â —Ì‰  «»⁄ »—«Ì «Ì‰ ò«—
;unsigned char read_until_keyword_keep_all(char* buffer, int buffer_size, unsigned long timeout_ms, const char* keyword)  ...
; 0001 0044 unsigned char read_until_keyword_keep_all(char* buffer, int buffer_size, unsigned long timeout_ms, const char* keyword) {
_read_until_keyword_keep_all:
; .FSTART _read_until_keyword_keep_all
; 0001 0045     int i = 0;
; 0001 0046     unsigned long elapsed = 0;
; 0001 0047     int found = 0;
; 0001 0048     int keyword_len = strlen(keyword);
; 0001 0049 
; 0001 004A     memset(buffer, 0, buffer_size);
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	CALL SUBOPT_0x1
;	*buffer -> Y+18
;	buffer_size -> Y+16
;	timeout_ms -> Y+12
;	*keyword -> Y+10
;	i -> R16,R17
;	elapsed -> Y+6
;	found -> R18,R19
;	keyword_len -> R20,R21
	__GETWRN 18,19,0
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CALL _strlen
	MOVW R20,R30
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _memset
; 0001 004B 
; 0001 004C     while (elapsed < timeout_ms && i < buffer_size - 1) {
_0x20006:
	__GETD1S 12
	__GETD2S 6
	CALL __CPD21
	BRSH _0x20009
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x2000A
_0x20009:
	RJMP _0x20008
_0x2000A:
; 0001 004D         while (rx_counter0 > 0 && i < buffer_size - 1) {
_0x2000B:
	LDS  R26,_rx_counter0
	CPI  R26,LOW(0x1)
	BRLO _0x2000E
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,1
	CP   R16,R30
	CPC  R17,R31
	BRLT _0x2000F
_0x2000E:
	RJMP _0x2000D
_0x2000F:
; 0001 004E             char c = getchar();
; 0001 004F             buffer[i++] = c;
	SBIW R28,1
;	*buffer -> Y+19
;	buffer_size -> Y+17
;	timeout_ms -> Y+13
;	*keyword -> Y+11
;	elapsed -> Y+7
;	c -> Y+0
	CALL _getchar
	ST   Y,R30
	MOVW R30,R16
	__ADDWRN 16,17,1
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	ADD  R30,R26
	ADC  R31,R27
	LD   R26,Y
	STD  Z+0,R26
; 0001 0050             buffer[i] = '\0';
	MOVW R30,R16
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 0051 
; 0001 0052             // »——”Ì ÊÃÊœ keyword
; 0001 0053             if (!found && i >= keyword_len) {
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x20011
	__CPWRR 16,17,20,21
	BRGE _0x20012
_0x20011:
	RJMP _0x20010
_0x20012:
; 0001 0054                 if (strstr(buffer, keyword) != NULL) {
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	CALL _strstr
	SBIW R30,0
	BREQ _0x20013
; 0001 0055                     found = 1;
	__GETWRN 18,19,1
; 0001 0056                     elapsed = 0;   // —Ì”  ò—œ‰  «Ì„— ? «Ã«“Â »œÌ„ «œ«„Â ÃÊ«» Â„ »Ì«œ
	LDI  R30,LOW(0)
	__CLRD1S 7
; 0001 0057                 }
; 0001 0058             }
_0x20013:
; 0001 0059         }
_0x20010:
	ADIW R28,1
	RJMP _0x2000B
_0x2000D:
; 0001 005A 
; 0001 005B         if (found && elapsed > 100) {
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x20015
	__GETD2S 6
	__CPD2N 0x65
	BRSH _0x20016
_0x20015:
	RJMP _0x20014
_0x20016:
; 0001 005C             // ÕœÊœ 100ms »⁄œ «“ œÌœ‰ ò·Ìœ° »Ì—Ê‰ »—Ê
; 0001 005D             break;
	RJMP _0x20008
; 0001 005E         }
; 0001 005F 
; 0001 0060         delay_ms(1);
_0x20014:
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
; 0001 0061         elapsed++;
	__GETD1S 6
	__SUBD1N -1
	__PUTD1S 6
; 0001 0062     }
	RJMP _0x20006
_0x20008:
; 0001 0063 
; 0001 0064     return (i > 0);
	MOVW R26,R16
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __GTW12
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; 0001 0065 }
; .FEND
;
;////  «»⁄ œ—Ì«›  „ﬁ«œÌ— Ã·ÊÌ œ” Ê—« 
;//int extract_value_after_keyword(const char* input, const char* keyword, char* out_value, int out_size) {
;//    const char* p = strstr(input, keyword);
;//    int i = 0;
;//    if (p) {
;//        p += strlen(keyword);  // »—Ê »⁄œ «“ ò·ÌœÊ«éÂ
;//        while (*p == ' ' || *p == '\t') p++;  // —œ ò—œ‰ ›«’·ÂùÂ«
;//
;//        // òÅÌ ò—œ‰ „ﬁœ«—  « «Ê·Ì‰ Ãœ«ò‰‰œÂ (, Ì« «”ÅÌ” Ì« CRLF)
;//        while (*p && *p != ',' && *p != '\r' && *p != '\n' && *p != ' ' && i < out_size - 1) {
;//            out_value[i++] = *p++;
;//        }
;//        out_value[i] = '\0';
;//        return 1;  // „Ê›ﬁ
;//    }
;//    return 0;  // ÅÌœ« ‰‘œ
;//}
;
;
;int extract_field_after_keyword(const char* input, const char* keyword, int field_index, char* out_value, int out_size)
; 0001 007B {
_extract_field_after_keyword:
; .FSTART _extract_field_after_keyword
; 0001 007C     int current_field = 0;
; 0001 007D     int i = 0;
; 0001 007E     const char* p = strstr(input, keyword);
; 0001 007F 
; 0001 0080     if (!p) return 0; // ò·ÌœÊ«éÂ ÅÌœ« ‰‘œ
	ST   -Y,R27
	ST   -Y,R26
	CALL SUBOPT_0x1
;	*input -> Y+14
;	*keyword -> Y+12
;	field_index -> Y+10
;	*out_value -> Y+8
;	out_size -> Y+6
;	current_field -> R16,R17
;	i -> R18,R19
;	*p -> R20,R21
	__GETWRN 18,19,0
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strstr
	MOVW R20,R30
	MOV  R0,R20
	OR   R0,R21
	BRNE _0x20017
	RJMP _0x2120016
; 0001 0081 
; 0001 0082     p += strlen(keyword);      // »—Ê »⁄œ «“ ò·ÌœÊ«éÂ
_0x20017:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL _strlen
	__ADDWRR 20,21,30,31
; 0001 0083 
; 0001 0084     // —œ ò—œ‰ ›«’·ÂùÂ« Ê  »ùÂ« ﬁ»· «“ «Ê·Ì‰ ›Ì·œ
; 0001 0085     while (*p == ' ' || *p == '\t') p++;
_0x20018:
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0x20)
	BREQ _0x2001B
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0x9)
	BRNE _0x2001A
_0x2001B:
	__ADDWRN 20,21,1
	RJMP _0x20018
_0x2001A:
; 0001 0087 while (*p && current_field <= field_index)
_0x2001D:
	MOVW R26,R20
	LD   R30,X
	CPI  R30,0
	BREQ _0x20020
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CP   R30,R16
	CPC  R31,R17
	BRGE _0x20021
_0x20020:
	RJMP _0x2001F
_0x20021:
; 0001 0088     {
; 0001 0089         if (current_field == field_index)
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x20022
; 0001 008A         {
; 0001 008B             // òÅÌ ò—œ‰ „ﬁœ«— ›⁄·Ì  « ò«„«° CR, LF Ì« space
; 0001 008C             while (*p && *p != ',' && *p != '\r' && *p != '\n' && i < out_size - 1)
_0x20023:
	MOVW R26,R20
	LD   R30,X
	CPI  R30,0
	BREQ _0x20026
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x20026
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0xD)
	BREQ _0x20026
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0xA)
	BREQ _0x20026
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	SBIW R30,1
	CP   R18,R30
	CPC  R19,R31
	BRLT _0x20027
_0x20026:
	RJMP _0x20025
_0x20027:
; 0001 008D             {
; 0001 008E                 out_value[i++] = *p++;
	MOVW R30,R18
	__ADDWRN 18,19,1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R26,R20
	__ADDWRN 20,21,1
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0001 008F             }
	RJMP _0x20023
_0x20025:
; 0001 0090             out_value[i] = '\0';
	MOVW R30,R18
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(0)
	ST   X,R30
; 0001 0091             return 1; // „Ê›ﬁ
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x2120015
; 0001 0092         }
; 0001 0093 
; 0001 0094         // —› ‰ »Â ò«„«Ì »⁄œÌ Ê —œ ò—œ‰ ›«’·ÂùÂ«Ì «÷«›Ì
; 0001 0095         while (*p && *p != ',') p++;
_0x20022:
_0x20028:
	MOVW R26,R20
	LD   R30,X
	CPI  R30,0
	BREQ _0x2002B
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BRNE _0x2002C
_0x2002B:
	RJMP _0x2002A
_0x2002C:
	__ADDWRN 20,21,1
	RJMP _0x20028
_0x2002A:
; 0001 0096 if (*p == ',') p++;
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BRNE _0x2002D
	__ADDWRN 20,21,1
; 0001 0097         while (*p == ' ' || *p == '\t') p++; // —œ ò—œ‰ ›«’·Â »⁄œ «“ ò«„«
_0x2002D:
_0x2002E:
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0x20)
	BREQ _0x20031
	MOVW R26,R20
	LD   R26,X
	CPI  R26,LOW(0x9)
	BRNE _0x20030
_0x20031:
	__ADDWRN 20,21,1
	RJMP _0x2002E
_0x20030:
; 0001 0098 current_field++;
	__ADDWRN 16,17,1
; 0001 0099     }
	RJMP _0x2001D
_0x2001F:
; 0001 009A 
; 0001 009B     return 0; // ›Ì·œ „Ê—œ‰Ÿ— ÅÌœ« ‰‘œ
_0x2120016:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x2120015:
	CALL __LOADLOCR6
	ADIW R28,16
	RET
; 0001 009C }
; .FEND
;
;
;//
;//int extract_field_after_keyword(const char* input, const char* keyword, int field_index, char* out_value, int out_size ...
;//{
;//    int current_field = 0;
;//    int i = 0;
;//    const char* p = strstr(input, keyword);
;//
;//    if (!p) return 0; // ò·ÌœÊ«éÂ ÅÌœ« ‰‘œ
;//
;//    p += strlen(keyword);      // »—Ê »⁄œ «“ ò·ÌœÊ«éÂ
;//    while (*p == ' ' || *p == '\t') p++; // —œ ò—œ‰ ›«’·ÂùÂ«
;//
;//    while (*p && current_field <= field_index)
;//    {
;//        if (current_field == field_index)
;//        {
;//            // òÅÌ ò—œ‰ „ﬁœ«— ›⁄·Ì  « ò«„« Ì« CRLF Ì« «”ÅÌ”
;//            while (*p && *p != ',' && *p != '\r' && *p != '\n' && i < out_size - 1)
;//            {
;//                out_value[i++] = *p++;
;//            }
;//            out_value[i] = '\0';
;//            return 1; // „Ê›ﬁ
;//        }
;//
;//        // —› ‰ »Â ò«„«Ì »⁄œÌ
;//        while (*p && *p != ',') p++;
;//        if (*p == ',') p++; // —œ ò—œ‰ ò«„«
;//        current_field++;
;//    }
;//
;//    return 0; // ›Ì·œ „Ê—œ‰Ÿ— ÅÌœ« ‰‘œ
;//}
;
;
;
;//unsigned char read_serial_response(char* buffer, int buffer_size, int timeout_ms, const char* end_pattern) {
;//    int i = 0;
;//    unsigned int elapsed = 0;
;//
;//    memset(buffer, 0, buffer_size);
;//
;//    while (elapsed < (unsigned)timeout_ms) {
;//        while (rx_counter0 > 0 && i < buffer_size - 1) {
;//            buffer[i++] = getchar();
;//        }
;//
;//        // »——”Ì «·êÊÌ Å«Ì«‰ œ«œÂ
;//        if (end_pattern != NULL && strstr(buffer, end_pattern)) {
;//            buffer[i] = '\0';
;//            return 1;
;//        }
;//
;//        if (i >= buffer_size - 1) {
;//            buffer[i] = '\0';
;//            return 1;
;//        }
;//
;//        delay_ms(1);
;//        elapsed++;
;//    }
;//
;//    buffer[i] = '\0';
;//    return (i > 0);
;//}
;
;
;//// --- ŒÊ«‰œ‰ Å«”Œ ”—Ì«· »« timeout ---
;//unsigned char read_serial_response(char* buffer, int buffer_size, int timeout_ms, const char* expected_response) {
;//    int i = 0;
;//    unsigned int elapsed = 0;
;//
;//    // ?C? ??I? EC?? ?C?E?
;//    memset(buffer, 0, buffer_size);
;//
;//    while (elapsed < (unsigned)timeout_ms) {
;//        // ?? EC?? E?C? EC?E??C? I? I?E?? ????? UART ?C EI?C??I
;//        while (rx_counter0 > 0 && i < buffer_size - 1) {
;//            buffer[i++] = getchar();  // getchar C? ????? EC?? ???A?I
;//        }
;//        // C?? C?EUC??C? ?C I?I??? ??I E???I??
;//        if (strstr(buffer, expected_response)) {
;//            return 1;
;//        }
;//        delay_ms(1);
;//        elapsed++;
;//    }
;//    // ?? C? ?C?C? EC???C?E ?? ??EC? I??? ?? ???????
;//    return (strstr(buffer, expected_response) != NULL);
;//}
;
;
;#include "keypad.h"
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
;#include "common.h"
;#include <glcd.h>
;#include <font5x7.h>
;
;
;char get_key(void)
; 0002 0008 {

	.CSEG
_get_key:
; .FSTART _get_key
; 0002 0009     unsigned char row, col;
; 0002 000A     const unsigned char column_pins[3] = {COL1_PIN, COL2_PIN, COL3_PIN};
; 0002 000B     const unsigned char row_pins[4] = {ROW1_PIN, ROW2_PIN, ROW3_PIN, ROW4_PIN};
; 0002 000C 
; 0002 000D //    const char key_map[4][3] = {
; 0002 000E //        {'1', '2', '3'},
; 0002 000F //        {'4', '5', '6'},
; 0002 0010 //        {'7', '8', '9'},
; 0002 0011 //        {'*', '0', '#'}
; 0002 0012 //    };
; 0002 0013 
; 0002 0014     const char key_map[4][3] = {
; 0002 0015         {'#', '0', '*'},  // —œÌ› 1
; 0002 0016         {'9', '8', '7'},  // —œÌ› 2
; 0002 0017         {'6', '5', '4'},  // —œÌ› 3
; 0002 0018         {'3', '2', '1'}   // —œÌ› 4
; 0002 0019     };
; 0002 001A 
; 0002 001B     for (col = 0; col < 3; col++)
	SBIW R28,19
	LDI  R24,19
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x40003*2)
	LDI  R31,HIGH(_0x40003*2)
	CALL __INITLOCB
	ST   -Y,R17
	ST   -Y,R16
;	row -> R17
;	col -> R16
;	column_pins -> Y+18
;	row_pins -> Y+14
;	key_map -> Y+2
	LDI  R16,LOW(0)
_0x40005:
	CPI  R16,3
	BRSH _0x40006
; 0002 001C     {
; 0002 001D         KEYPAD_PORT |= (1 << COL1_PIN) | (1 << COL2_PIN) | (1 << COL3_PIN);
	IN   R30,0x15
	ORI  R30,LOW(0x7)
	OUT  0x15,R30
; 0002 001E         KEYPAD_PORT &= ~(1 << column_pins[col]);
	IN   R1,21
	MOV  R30,R16
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,18
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDI  R26,LOW(1)
	CALL SUBOPT_0x6
	OUT  0x15,R30
; 0002 001F 
; 0002 0020         for (row = 0; row < 4; row++)
	LDI  R17,LOW(0)
_0x40008:
	CPI  R17,4
	BRSH _0x40009
; 0002 0021         {
; 0002 0022             if (!(KEYPAD_PIN & (1 << row_pins[row])))
	CALL SUBOPT_0x1C
	MOV  R26,R1
	CALL SUBOPT_0x3
	BRNE _0x4000A
; 0002 0023             {
; 0002 0024                 delay_ms(10);
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
; 0002 0025                 if (!(KEYPAD_PIN & (1 << row_pins[row])))
	CALL SUBOPT_0x1C
	MOV  R26,R1
	CALL SUBOPT_0x3
	BRNE _0x4000B
; 0002 0026                 {
; 0002 0027                     while (!(KEYPAD_PIN & (1 << row_pins[row])));
_0x4000C:
	CALL SUBOPT_0x1C
	MOV  R26,R1
	CALL SUBOPT_0x3
	BREQ _0x4000C
; 0002 0028                     return key_map[row][col];
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
	RJMP _0x2120014
; 0002 0029                 }
; 0002 002A             }
_0x4000B:
; 0002 002B         }
_0x4000A:
	SUBI R17,-1
	RJMP _0x40008
_0x40009:
; 0002 002C     }
	SUBI R16,-1
	RJMP _0x40005
_0x40006:
; 0002 002D 
; 0002 002E     return 0;
	LDI  R30,LOW(0)
_0x2120014:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,21
	RET
; 0002 002F }
; .FEND
;
;
;
;void test_keypad(void)
; 0002 0034 {
; 0002 0035     char key;
; 0002 0036     char buf[2];
; 0002 0037 
; 0002 0038 
; 0002 0039     glcd_clear();
;	key -> R17
;	buf -> Y+1
; 0002 003A     glcd_outtextxy(0, 0, "Press a key...");
; 0002 003B 
; 0002 003C     while (1)
; 0002 003D     {
; 0002 003E         key = get_key();  //  «»⁄Ì òÂ òÌùÅœ —Ê „ÌùŒÊ‰Â
; 0002 003F         if (key != 0)
; 0002 0040         {
; 0002 0041             glcd_clear();
; 0002 0042             glcd_outtextxy(0, 0, "Key Pressed:");
; 0002 0043 
; 0002 0044             buf[0] = key;  // ò«—«ò — ò·Ìœ
; 0002 0045             buf[1] = '\0';
; 0002 0046 
; 0002 0047             glcd_outtextxy(0, 16, buf);  // ‰„«Ì‘ —ÊÌ GLCD
; 0002 0048             delay_ms(500);               // ò„Ì „òÀ »—«Ì œÌœ‰
; 0002 0049         }
; 0002 004A     }
; 0002 004B }

	.DSEG
_0x4000F:
	.BYTE 0x1C
;#include <stdlib.h>
;#include <stdint.h>
;#include <glcd.h>
;#include <delay.h>
;#include <string.h>
;#include "common.h"
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
;#include "sim800.h"
;
;//#define BUFFER_SIZE 512
;#define MAX_RETRY   3   // Õœ«òÀ—  ⁄œ«œ  ·«‘
;
;
;
;//char value[16];
;
;char at_command[30];
;char sim_number[15];
;
;//char buffer[BUFFER_SIZE];
;uint8_t attempts = 0;
;
;
;
;void sim800_restart(void) {
; 0003 0018 void sim800_restart(void) {

	.CSEG
_sim800_restart:
; .FSTART _sim800_restart
; 0003 0019     glcd_clear();
	CALL SUBOPT_0x7
; 0003 001A     glcd_outtextxy(0, 0, "Restarting SIM800...");
	__POINTW2MN _0x60003,0
	CALL _glcd_outtextxy
; 0003 001B 
; 0003 001C     // --- 1) »” ‰ HTTP («ê— ›⁄«· «” ) ---
; 0003 001D     while (1) {
_0x60004:
; 0003 001E         uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 001F         send_at_command("AT+HTTPTERM");
	__POINTW2MN _0x60003,21
	CALL SUBOPT_0x1D
; 0003 0020         // «ê— OK Ì« ERROR ¬„œ° œÌê— «œ«„Â „ÌùœÂÌ„ («ê— HTTP »” Â ‰»Êœ ERROR „Ìù¬Ìœ)
; 0003 0021         if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) break;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	__POINTW2MN _0x60003,33
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BRNE _0x60006
; 0003 0022         if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 1000, "ERROR")) break;
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1E
	__GETD1N 0x3E8
	CALL __PUTPARD1
	__POINTW2MN _0x60003,36
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BRNE _0x60006
; 0003 0023         glcd_outtextxy(0, 10, "Waiting HTTPTERM...");
	CALL SUBOPT_0x17
	__POINTW2MN _0x60003,42
	CALL SUBOPT_0x1B
; 0003 0024         delay_ms(100);
; 0003 0025     }
	RJMP _0x60004
_0x60006:
; 0003 0026 
; 0003 0027     // --- 2) »” ‰ SAPBR (bearer) ---
; 0003 0028     while (1) {
_0x60009:
; 0003 0029         uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 002A         send_at_command("AT+SAPBR=0,1");   // close bearer
	__POINTW2MN _0x60003,62
	CALL SUBOPT_0x1D
; 0003 002B         if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 3000, "OK")) break;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x20
	__POINTW2MN _0x60003,75
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BRNE _0x6000B
; 0003 002C         glcd_outtextxy(0, 10, "Waiting SAPBR=0,1...");
	CALL SUBOPT_0x17
	__POINTW2MN _0x60003,78
	CALL SUBOPT_0x1B
; 0003 002D         delay_ms(100);
; 0003 002E     }
	RJMP _0x60009
_0x6000B:
; 0003 002F 
; 0003 0030     // --- 3) çò ò‰ òÂ SAPBR »” Â ‘œÂ («Œ Ì«—Ì «„« „›Ìœ) ---
; 0003 0031     {
; 0003 0032         int ok = 0;
; 0003 0033         while (!ok) {
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
;	ok -> Y+0
_0x6000D:
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BRNE _0x6000F
; 0003 0034             uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 0035             send_at_command("AT+SAPBR=2,1"); // query
	__POINTW2MN _0x60003,99
	CALL SUBOPT_0x1D
; 0003 0036             if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "SAPBR")) {
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	__POINTW2MN _0x60003,112
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x60010
; 0003 0037                 // «‰ Ÿ«— œ«—Ì„ ›Ì·œÌ „À· +SAPBR: 1,3,"0.0.0.0" Ì« +SAPBR: 1,0,"0.0.0.0"
; 0003 0038                 // «ê— IP 0.0.0.0 Ì« status != 1 »«‘Â Ì⁄‰Ì »” Â «” 
; 0003 0039                 if (strstr(buffer, "0.0.0.0") || strstr(buffer, ",0,") || strstr(buffer, ",3,")) {
	CALL SUBOPT_0xF
	__POINTW2MN _0x60003,118
	CALL _strstr
	SBIW R30,0
	BRNE _0x60012
	CALL SUBOPT_0xF
	__POINTW2MN _0x60003,126
	CALL _strstr
	SBIW R30,0
	BRNE _0x60012
	CALL SUBOPT_0xF
	__POINTW2MN _0x60003,130
	CALL _strstr
	SBIW R30,0
	BREQ _0x60011
_0x60012:
; 0003 003A                     ok = 1; // œ— ⁄„· »” Â Ì« œ— Õ«·  €Ì— connected «” 
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   Y,R30
	STD  Y+1,R31
; 0003 003B                     break;
	RJMP _0x6000F
; 0003 003C                 }
; 0003 003D             }
_0x60011:
; 0003 003E             // «ê— ÂÌç Å«”ŒÌ ‰ÌÊ„œ Ì« Â‰Ê“ Connected «”  „‰ Ÿ— Ê œÊ»«—Â  ·«‘ ò‰
; 0003 003F             glcd_outtextxy(0, 10, "Checking SAPBR closed...");
_0x60010:
	CALL SUBOPT_0x17
	__POINTW2MN _0x60003,134
	CALL SUBOPT_0x1B
; 0003 0040             delay_ms(100);
; 0003 0041         }
	RJMP _0x6000D
_0x6000F:
; 0003 0042     }
	ADIW R28,2
; 0003 0043 
; 0003 0044     // --- 4) detach «“ GPRS ---
; 0003 0045     while (1) {
_0x60014:
; 0003 0046         uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 0047         send_at_command("AT+CGATT=0");     // detach
	__POINTW2MN _0x60003,159
	CALL SUBOPT_0x1D
; 0003 0048         if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 3000, "OK")) break;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x20
	__POINTW2MN _0x60003,170
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BRNE _0x60016
; 0003 0049         glcd_outtextxy(0, 10, "Waiting CGATT=0...");
	CALL SUBOPT_0x17
	__POINTW2MN _0x60003,173
	CALL SUBOPT_0x1B
; 0003 004A         delay_ms(100);
; 0003 004B     }
	RJMP _0x60014
_0x60016:
; 0003 004C 
; 0003 004D     // --- 5) —Ì”  ò«„· ‰—„ù«›“«—Ì (CFUN=1,1) Ê ”Å” ’»—  « „«éÊ· »«·« »Ì«Ìœ ---
; 0003 004E     // «Ì‰ œ” Ê— „„ò‰ «”  »«⁄À —Ì»Ê  ‘Êœ∫ ¬‰ —« »›—”  Ê ”Å”  « “„«‰Ì òÂ „«éÊ· »Â AT Å«”Œ œÂœ ’»— ò‰.
; 0003 004F     while (1) {
; 0003 0050         uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 0051         send_at_command("AT+CFUN=1,1");
	__POINTW2MN _0x60003,192
	CALL SUBOPT_0x1D
; 0003 0052         // „„ò‰ «”  OK »«“ê—œœ Ì« ‰Â∫ œ— Â— ’Ê—  »⁄œ «“ “œ‰ —Ì” ° „‰ Ÿ— »«·« ¬„œ‰ „«éÊ· „Ìù‘ÊÌ„.
; 0003 0053         // «» œ« «ê— OK ¬„œ «“ ¬‰ ⁄»Ê— ò‰° ”Å” „‰ Ÿ— "AT" Å«”Œ œÂÌ„.
; 0003 0054         read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK"); // (»ÌùŒÿ— «ê— ‰Ì«Ìœ)
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	__POINTW2MN _0x60003,204
	CALL _read_until_keyword_keep_all
; 0003 0055         // «ò‰Ê‰ „‰ Ÿ— ‘Ê  « „œ«Ê„« »Â AT Å«”Œ œÂœ
; 0003 0056         glcd_outtextxy(0, 10, "Rebooting, wait for AT...");
	CALL SUBOPT_0x17
	__POINTW2MN _0x60003,207
	CALL _glcd_outtextxy
; 0003 0057         while (1) {
_0x6001B:
; 0003 0058             uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 0059             send_at_command("AT");
	__POINTW2MN _0x60003,233
	CALL SUBOPT_0x1D
; 0003 005A             if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) {
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	__POINTW2MN _0x60003,236
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BRNE _0x6001F
; 0003 005B                 // „«éÊ· »«·« ¬„œÂ Ê ¬„«œÂ «” 
; 0003 005C                 goto after_reboot;
; 0003 005D             }
; 0003 005E             // «ê— ŒÊ«” Ì „Ì  Ê«‰Ì «Ì‰Ã« ÅÌ«„ Ê÷⁄Ì  Ê delay ÿÊ·«‰Ìù — »–«—Ì
; 0003 005F             delay_ms(100);
	CALL SUBOPT_0x21
; 0003 0060         }
	RJMP _0x6001B
; 0003 0061     }
; 0003 0062 after_reboot:
_0x6001F:
; 0003 0063 
; 0003 0064     // --- 6) Œ«„Ê‘ ò—œ‰ Echo ---
; 0003 0065     while (1) {
_0x60020:
; 0003 0066         uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 0067         send_at_command("ATE0");
	__POINTW2MN _0x60003,239
	CALL SUBOPT_0x1D
; 0003 0068         if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) break;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	__POINTW2MN _0x60003,244
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BRNE _0x60022
; 0003 0069         glcd_outtextxy(0, 10, "Waiting ATE0...");
	CALL SUBOPT_0x17
	__POINTW2MN _0x60003,247
	CALL SUBOPT_0x1B
; 0003 006A         delay_ms(100);
; 0003 006B     }
	RJMP _0x60020
_0x60022:
; 0003 006C 
; 0003 006D     // --- 7)  ”  ‰Â«ÌÌ „«éÊ· ---
; 0003 006E     while (1) {
_0x60024:
; 0003 006F         uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 0070         send_at_command("AT");
	__POINTW2MN _0x60003,263
	CALL SUBOPT_0x1D
; 0003 0071         if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) break;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	__POINTW2MN _0x60003,266
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BRNE _0x60026
; 0003 0072         glcd_outtextxy(0, 10, "Final AT check...");
	CALL SUBOPT_0x17
	__POINTW2MN _0x60003,269
	CALL SUBOPT_0x1B
; 0003 0073         delay_ms(100);
; 0003 0074     }
	RJMP _0x60024
_0x60026:
; 0003 0075 
; 0003 0076     glcd_outtextxy(0, 20, "Restart Done!");
	CALL SUBOPT_0x18
	__POINTW2MN _0x60003,287
	CALL _glcd_outtextxy
; 0003 0077 }
	RET
; .FEND

	.DSEG
_0x60003:
	.BYTE 0x12D
;
;
;
;
;
;
;//void sim800_restart(void) {
;//
;//    glcd_clear();
;//    glcd_outtextxy(0, 0, "Restarting SIM800...");
;//
;//    // --- —Ì”  »«›— UART ---
;//    send_at_command("AT+HTTPTERM");
;//    delay_ms(50);
;//
;//    send_at_command("AT+SAPBR=0,1");   // »” ‰ ò«‰ò‘‰ GPRS
;//    delay_ms(50);
;//
;//    send_at_command("AT+SAPBR=2,1");
;//    delay_ms(50);
;//
;//
;//    send_at_command("AT+CGATT=0");
;//    delay_ms(50);
;//
;////
;////    send_at_command("AT+CGATT=1");
;////    delay_ms(50);
;//
;//    // --- ‰—„ù«›“«— —Ì”  „«éÊ· («Œ Ì«—Ì) ---                      // “„«‰ »—«Ì —Ìù«” «— 
;//
;////    send_at_command("AT+CRESET");
;////    delay_ms(100);
;//
;//    send_at_command("AT+CFUN=0");  // —Ìù«” «—  „«éÊ·
;//    delay_ms(100);                       // “„«‰ »—«Ì —Ìù«” «— 
;//
;//
;//    send_at_command("AT+CFUN=1");  // —Ìù«” «—  „«éÊ·
;//    delay_ms(100);                       // “„«‰ »—«Ì —Ìù«” «— 
;//
;//
;////    send_at_command("AT+CFUN=1,1");  // —Ìù«” «—  „«éÊ·
;////    delay_ms(2000);
;//
;//    // --- Œ«„Ê‘ ò—œ‰ Echo ---
;//    uart_buffer_reset();
;//    send_at_command("ATE0");
;//    delay_ms(50);
;//
;//    // --- »——”Ì ¬„«œÂ »Êœ‰ „«éÊ· ---
;//    uart_buffer_reset();
;//    send_at_command("AT");
;//    if (!read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "OK")) {
;//        glcd_outtextxy(0, 10, "SIM800 not responding!");
;//        return;  // ‘ò”  œ— —«Âù«‰œ«“Ì
;//    }
;//
;//}
;
;
;unsigned char check_sim(void) {
; 0003 00B5 unsigned char check_sim(void) {

	.CSEG
_check_sim:
; .FSTART _check_sim
; 0003 00B6     int stat;
; 0003 00B7     char *comma;
; 0003 00B8 
; 0003 00B9     glcd_clear();
	CALL __SAVELOCR4
;	stat -> R16,R17
;	*comma -> R18,R19
	CALL _glcd_clear
; 0003 00BA     // --- »——”Ì Ê÷⁄Ì  ”Ì„ùò«—  ---
; 0003 00BB     uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 00BC     send_at_command("AT+CPIN?");
	__POINTW2MN _0x60028,0
	CALL SUBOPT_0x1D
; 0003 00BD     if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CPIN")) {
	CALL SUBOPT_0x10
	__POINTW2MN _0x60028,9
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x60029
; 0003 00BE //        glcd_outtextxy(0, 0, buffer);
; 0003 00BF //        delay_ms(5000);
; 0003 00C0         if (extract_field_after_keyword(buffer, "+CPIN:", 0, value, sizeof(value))) {
	CALL SUBOPT_0xF
	__POINTW1MN _0x60028,14
	CALL SUBOPT_0x22
	BREQ _0x6002A
; 0003 00C1             glcd_outtextxy(0, 16, value);  // ›ﬁÿ READY Ì« PIN
	CALL SUBOPT_0x23
; 0003 00C2         }
; 0003 00C3         delay_ms(100);
_0x6002A:
	CALL SUBOPT_0x21
; 0003 00C4     }
; 0003 00C5 
; 0003 00C6 //    uart_buffer_reset();
; 0003 00C7 //    send_at_command("AT+CREG?");
; 0003 00C8 //    if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "+CREG")) {
; 0003 00C9 //        glcd_outtextxy(0, 0, buffer);
; 0003 00CA //        if (extract_value_after_keyword(buffer, "+CREG:", value, sizeof(value))) {
; 0003 00CB //            glcd_outtextxy(0, 16, value);  // ›ﬁÿ READY Ì« PIN
; 0003 00CC //        }
; 0003 00CD //    }
; 0003 00CE 
; 0003 00CF     // --- »——”Ì Ê÷⁄Ì  ‘»òÂ  « “„«‰ « ’«· ---
; 0003 00D0     glcd_clear();
_0x60029:
	RCALL _glcd_clear
; 0003 00D1     do {
_0x6002C:
; 0003 00D2         //glcd_clear();
; 0003 00D3         uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 00D4         send_at_command("AT+CREG?");
	__POINTW2MN _0x60028,21
	CALL SUBOPT_0x1D
; 0003 00D5         if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 2000, "CREG")) {
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	__POINTW2MN _0x60028,30
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x6002E
; 0003 00D6 //            glcd_outtextxy(0, 10, buffer);  // ‰„«Ì‘ Ê÷⁄Ì  ‘»òÂ
; 0003 00D7 
; 0003 00D8 
; 0003 00D9             if (extract_field_after_keyword(buffer, "+CREG:", 1, value, sizeof(value))) {
	CALL SUBOPT_0xF
	__POINTW1MN _0x60028,35
	CALL SUBOPT_0x11
	SBIW R30,0
	BREQ _0x6002F
; 0003 00DA //                glcd_outtextxy(0, 10, value);
; 0003 00DB //                delay_ms(100);
; 0003 00DC //                stat = atoi(value);
; 0003 00DD                 if (atoi(value) == 1) break;
	CALL SUBOPT_0x24
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x6002D
; 0003 00DE             }
; 0003 00DF         }
_0x6002F:
; 0003 00E0         glcd_outtextxy(0, 15, "Waiting for network...");
_0x6002E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	__POINTW2MN _0x60028,42
	CALL _glcd_outtextxy
; 0003 00E1 
; 0003 00E2     } while (1);
	RJMP _0x6002C
_0x6002D:
; 0003 00E3 
; 0003 00E4     glcd_clear();
	RCALL _glcd_clear
; 0003 00E5     glcd_outtextxy(0, 20, "Network OK!");
	CALL SUBOPT_0x18
	__POINTW2MN _0x60028,65
	CALL SUBOPT_0x1B
; 0003 00E6     delay_ms(100);
; 0003 00E7 
; 0003 00E8 //    uart_buffer_reset();
; 0003 00E9 //    send_at_command("AT+CUSD=1,\"*733*2#\"");
; 0003 00EA //    if (read_until_keyword_keep_all(buffer, sizeof(buffer), 3000, "CUSD")) {
; 0003 00EB //        glcd_clear();
; 0003 00EC //        glcd_outtextxy(0, 0, buffer);  // ‘„«—Â —ÊÌ GLCD ‰„«Ì‘ œ«œÂ „Ìù‘Êœ
; 0003 00ED //        delay_ms(1000);        // «” Œ—«Ã ‘„«—Â  ·›‰
; 0003 00EE //
; 0003 00EF //        if (extract_field_after_keyword(buffer, "+CUSD:", 1, sim_number, sizeof(sim_number))){
; 0003 00F0 //            glcd_clear();
; 0003 00F1 //            glcd_outtextxy(0, 0, sim_number);  // ‘„«—Â —ÊÌ GLCD ‰„«Ì‘ œ«œÂ „Ìù‘Êœ
; 0003 00F2 //            delay_ms(1000);
; 0003 00F3 //        }
; 0003 00F4 //    }
; 0003 00F5 
; 0003 00F6     return 1;  // „Ê›ﬁÌ 
	LDI  R30,LOW(1)
	RJMP _0x212000D
; 0003 00F7 
; 0003 00F8 }
; .FEND

	.DSEG
_0x60028:
	.BYTE 0x4D
;
;
;
;unsigned char check_signal_quality(void) {
; 0003 00FC unsigned char check_signal_quality(void) {

	.CSEG
_check_signal_quality:
; .FSTART _check_signal_quality
; 0003 00FD 
; 0003 00FE     uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 00FF     send_at_command("AT+CSQ");
	__POINTW2MN _0x60031,0
	CALL SUBOPT_0x1D
; 0003 0100 
; 0003 0101     if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "CSQ")) {
	CALL SUBOPT_0x10
	__POINTW2MN _0x60031,7
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x60032
; 0003 0102 //        glcd_clear();
; 0003 0103 //        glcd_outtextxy(0, 0, buffer);
; 0003 0104 
; 0003 0105         if (extract_field_after_keyword(buffer, "+CSQ:", 0, value, sizeof(value))) {
	CALL SUBOPT_0xF
	__POINTW1MN _0x60031,11
	CALL SUBOPT_0x22
	BREQ _0x60033
; 0003 0106 //            int csq = atoi(value);  //  »œÌ· —‘ Â »Â ⁄œœ
; 0003 0107             glcd_clear();
	RCALL _glcd_clear
; 0003 0108             glcd_outtextxy(0, 16, value);  // ‰„«Ì‘ „ﬁœ«— ”Ìê‰«·
	CALL SUBOPT_0x23
; 0003 0109             delay_ms(500);
	CALL SUBOPT_0x9
; 0003 010A             //stat = atoi(value);
; 0003 010B             if (atoi(value) < 5) {
	CALL SUBOPT_0x24
	SBIW R30,5
	BRGE _0x60034
; 0003 010C                 // ”Ìê‰«· ÷⁄Ì› => ‰Ì«“ »Â —Ì” 
; 0003 010D                 return 0;
	RJMP _0x2120010
; 0003 010E             } else {
_0x60034:
; 0003 010F                 return 1;
	RJMP _0x2120012
; 0003 0110             }
; 0003 0111         }
; 0003 0112     }
_0x60033:
; 0003 0113     return 0; // «ê— «’·« Å«”ŒÌ ‰ê—› Ì„
_0x60032:
	RJMP _0x2120010
; 0003 0114 }
; .FEND

	.DSEG
_0x60031:
	.BYTE 0x11
;
;
;
;
;unsigned char check_signal_with_restart() {
; 0003 0119 unsigned char check_signal_with_restart() {

	.CSEG
_check_signal_with_restart:
; .FSTART _check_signal_with_restart
; 0003 011A     int i;
; 0003 011B     for (i = 0; i < MAX_RETRY; i++) {
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x60037:
	__CPWRN 16,17,3
	BRGE _0x60038
; 0003 011C         if (check_signal_quality()) {
	RCALL _check_signal_quality
	CPI  R30,0
	BREQ _0x60039
; 0003 011D             // ”Ìê‰«· ŒÊ»Â° «“ Õ·ﬁÂ Œ«—Ã ‘Ê
; 0003 011E             return 1;
	LDI  R30,LOW(1)
	RJMP _0x2120013
; 0003 011F         }
; 0003 0120         // «ê— ”Ìê‰«· ‰»Êœ:
; 0003 0121         sim800_restart();   // —Ìù«” «—  „«éÊ·
_0x60039:
	RCALL _sim800_restart
; 0003 0122         check_sim();
	RCALL _check_sim
; 0003 0123     }
	__ADDWRN 16,17,1
	RJMP _0x60037
_0x60038:
; 0003 0124     // «ê— «Ì‰Ã« —”Ìœ Ì⁄‰Ì »⁄œ «“ 3 »«— Â„ ”Ìê‰«· œ—”  ‰‘œ
; 0003 0125     // „Ì Ê‰Ì ·«ê »êÌ—Ì Ì« Â‰œ· Œÿ« ò‰Ì
; 0003 0126     printf("No signal after %d retries!\n", MAX_RETRY);
	__POINTW1FN _0x60000,370
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x3
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0003 0127 }
_0x2120013:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;
;
;unsigned char init_sms(void)
; 0003 012C {
_init_sms:
; .FSTART _init_sms
; 0003 012D     glcd_clear();
	CALL SUBOPT_0x7
; 0003 012E     glcd_outtextxy(0, 0, "Setting SMS Mode...");
	__POINTW2MN _0x6003A,0
	CALL _glcd_outtextxy
; 0003 012F 
; 0003 0130     send_at_command("AT+CFUN=1");
	__POINTW2MN _0x6003A,20
	CALL SUBOPT_0x25
; 0003 0131     delay_ms(50);
; 0003 0132 
; 0003 0133     send_at_command("AT+CSCLK=0");
	__POINTW2MN _0x6003A,30
	CALL SUBOPT_0x25
; 0003 0134     delay_ms(50);
; 0003 0135 
; 0003 0136     //  ‰ŸÌ„ SMS
; 0003 0137     send_at_command("AT+CMGF=1");
	__POINTW2MN _0x6003A,41
	CALL SUBOPT_0x25
; 0003 0138     delay_ms(50);
; 0003 0139 
; 0003 013A     send_at_command("AT+CNMI=2,2,0,0,0");
	__POINTW2MN _0x6003A,51
	CALL SUBOPT_0x25
; 0003 013B     delay_ms(50);
; 0003 013C 
; 0003 013D     send_at_command("AT+CMGDA=\"DEL ALL\"");
	__POINTW2MN _0x6003A,69
	CALL SUBOPT_0x25
; 0003 013E     delay_ms(50);
; 0003 013F 
; 0003 0140     glcd_outtextxy(0, 10, "SMS Ready.");
	CALL SUBOPT_0x17
	__POINTW2MN _0x6003A,88
	CALL _glcd_outtextxy
; 0003 0141     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	RJMP _0x2120011
; 0003 0142 
; 0003 0143     return 1;
; 0003 0144 }
; .FEND

	.DSEG
_0x6003A:
	.BYTE 0x63
;
;
;
;unsigned char init_GPRS(void)
; 0003 0149 {

	.CSEG
_init_GPRS:
; .FSTART _init_GPRS
; 0003 014A 
; 0003 014B     glcd_clear();
	CALL SUBOPT_0x7
; 0003 014C     glcd_outtextxy(0, 0, "Connecting to GPRS...");
	__POINTW2MN _0x6003B,0
	CALL _glcd_outtextxy
; 0003 014D 
; 0003 014E     send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
	__POINTW2MN _0x6003B,22
	CALL _send_at_command
; 0003 014F     delay_ms(100);
	CALL SUBOPT_0x21
; 0003 0150 
; 0003 0151     sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
	LDI  R30,LOW(_at_command)
	LDI  R31,HIGH(_at_command)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x60000,550
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_APN*2)
	LDI  R31,HIGH(_APN*2)
	CALL SUBOPT_0x14
	CALL SUBOPT_0x5
; 0003 0152     send_at_command(at_command);
	LDI  R26,LOW(_at_command)
	LDI  R27,HIGH(_at_command)
	CALL SUBOPT_0xB
; 0003 0153     delay_ms(100);
; 0003 0154 
; 0003 0155     uart_buffer_reset();
; 0003 0156 
; 0003 0157     send_at_command("AT+SAPBR=1,1");
	__POINTW2MN _0x6003B,52
	CALL SUBOPT_0x1D
; 0003 0158     if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "OK")) {
	CALL SUBOPT_0x10
	__POINTW2MN _0x6003B,65
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x6003C
; 0003 0159         glcd_outtextxy(0, 0, buffer);  // »«Ìœ ò· Œ—ÊÃÌ "+CSQ: 11,0" Ê "OK" ç«Å ‘Êœ
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	CALL SUBOPT_0x1B
; 0003 015A         delay_ms(100);
; 0003 015B     }
; 0003 015C 
; 0003 015D     glcd_clear();
_0x6003C:
	CALL SUBOPT_0x7
; 0003 015E     glcd_outtextxy(0, 0, "Fetching IP...");
	__POINTW2MN _0x6003B,68
	CALL _glcd_outtextxy
; 0003 015F 
; 0003 0160     while (attempts < 3) {
_0x6003D:
	LDI  R30,LOW(3)
	CP   R11,R30
	BRLO PC+2
	RJMP _0x6003F
; 0003 0161         uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 0162         send_at_command("AT+SAPBR=2,1");
	__POINTW2MN _0x6003B,83
	CALL SUBOPT_0x1D
; 0003 0163 
; 0003 0164         if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "SAPBR")) {
	CALL SUBOPT_0x10
	__POINTW2MN _0x6003B,96
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x60040
; 0003 0165             // «” Œ—«Ã status (›Ì·œ œÊ„ »⁄œ «“ +SAPBR:)
; 0003 0166             if (extract_field_after_keyword(buffer, "+SAPBR:", 1, value, sizeof(value))) {
	CALL SUBOPT_0xF
	__POINTW1MN _0x6003B,102
	CALL SUBOPT_0x11
	SBIW R30,0
	BREQ _0x60041
; 0003 0167                 if (atoi(value) == 1) {
	CALL SUBOPT_0x24
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x60042
; 0003 0168                     // «ê— status=1 »Êœ° ›Ì·œ ”Ê„ Â„Ê‰ IP —Ê ‰‘Ê‰ »œÂ
; 0003 0169                     if (extract_field_after_keyword(buffer, "+SAPBR:", 2, value, sizeof(value))) {
	CALL SUBOPT_0xF
	__POINTW1MN _0x6003B,110
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_value)
	LDI  R31,HIGH(_value)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	LDI  R27,0
	CALL _extract_field_after_keyword
	SBIW R30,0
	BREQ _0x60043
; 0003 016A                         glcd_clear();
	CALL SUBOPT_0x7
; 0003 016B                         glcd_outtextxy(0, 0, value);
	LDI  R26,LOW(_value)
	LDI  R27,HIGH(_value)
	CALL _glcd_outtextxy
; 0003 016C                         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
_0x2120011:
	CALL _delay_ms
; 0003 016D                         return 1; // „Ê›ﬁ
_0x2120012:
	LDI  R30,LOW(1)
	RET
; 0003 016E                     }
; 0003 016F                 }
_0x60043:
; 0003 0170             }
_0x60042:
; 0003 0171         }
_0x60041:
; 0003 0172 
; 0003 0173         // «ê— »Â «Ì‰Ã« —”Ìœ Ì⁄‰Ì „Ê›ﬁ ‰»ÊœÂ
; 0003 0174         attempts++;
_0x60040:
	INC  R11
; 0003 0175         delay_ms(100);
	CALL SUBOPT_0x21
; 0003 0176     }
	RJMP _0x6003D
_0x6003F:
; 0003 0177 
; 0003 0178     // »⁄œ «“ 3 »«—  ·«‘ ‰«„Ê›ﬁ
; 0003 0179     glcd_clear();
	CALL SUBOPT_0x7
; 0003 017A     glcd_outtextxy(0, 0, "No IP");
	__POINTW2MN _0x6003B,118
	CALL _glcd_outtextxy
; 0003 017B     return 0; // ‰«„Ê›ﬁ
_0x2120010:
	LDI  R30,LOW(0)
	RET
; 0003 017C }
; .FEND

	.DSEG
_0x6003B:
	.BYTE 0x7C
;
;
;void gprs_keep_alive(void) {
; 0003 017F void gprs_keep_alive(void) {

	.CSEG
_gprs_keep_alive:
; .FSTART _gprs_keep_alive
; 0003 0180 //    glcd_clear();
; 0003 0181 //    glcd_outtextxy(0, 0, "Checking Internet...");
; 0003 0182 
; 0003 0183     uart_buffer_reset();
	CALL _uart_buffer_reset
; 0003 0184     send_at_command("AT+HTTPTERM");
	__POINTW2MN _0x60044,0
	CALL SUBOPT_0xB
; 0003 0185     delay_ms(100);
; 0003 0186 
; 0003 0187     // --- ‘—Ê⁄ HTTP ---
; 0003 0188     uart_buffer_reset();
; 0003 0189     send_at_command("AT+HTTPINIT");
	__POINTW2MN _0x60044,12
	CALL SUBOPT_0xB
; 0003 018A     delay_ms(100);
; 0003 018B 
; 0003 018C     // --- «‰ Œ«» ò«‰ò‘‰ GPRS ---
; 0003 018D     uart_buffer_reset();
; 0003 018E     send_at_command("AT+HTTPPARA=\"CID\",1");
	__POINTW2MN _0x60044,24
	CALL SUBOPT_0xB
; 0003 018F     delay_ms(100);
; 0003 0190 
; 0003 0191     // ---  ‰ŸÌ„ URL ---
; 0003 0192     uart_buffer_reset();
; 0003 0193     send_at_command("AT+HTTPPARA=\"URL\",\"http://www.google.com\"");
	__POINTW2MN _0x60044,44
	CALL SUBOPT_0xB
; 0003 0194     delay_ms(100);
; 0003 0195 
; 0003 0196     // --- «—”«· œ—ŒÊ«”  GET ---
; 0003 0197     uart_buffer_reset();
; 0003 0198     send_at_command("AT+HTTPACTION=0"); // 0=GET
	__POINTW2MN _0x60044,86
	CALL SUBOPT_0xB
; 0003 0199     delay_ms(100); // ’»— »—«Ì Å«”Œ HTTP
; 0003 019A 
; 0003 019B     // --- »——”Ì Å«”Œ ---
; 0003 019C     uart_buffer_reset();
; 0003 019D     if (read_until_keyword_keep_all(buffer, BUFFER_SIZE, 5000, "HTTPACTION")) {
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	__POINTW2MN _0x60044,102
	CALL _read_until_keyword_keep_all
	CPI  R30,0
	BREQ _0x60045
; 0003 019E         // „À«· Œ—ÊÃÌ: +HTTPACTION:0,200,1256
; 0003 019F //        int status = 0;
; 0003 01A0 
; 0003 01A1         // ›Ì·œ œÊ„ »⁄œ «“ +HTTPACTION: Â„«‰ òœ Ê÷⁄Ì  HTTP «” 
; 0003 01A2         if (extract_field_after_keyword(buffer, "+HTTPACTION", 1, value, sizeof(value))) {
	CALL SUBOPT_0xF
	__POINTW1MN _0x60044,113
	CALL SUBOPT_0x11
	SBIW R30,0
	BREQ _0x60046
; 0003 01A3 //            status = atoi(value);  //  »œÌ· —‘ Â »Â ⁄œœ
; 0003 01A4             glcd_outtextxy(0, 16, value);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R26,LOW(_value)
	LDI  R27,HIGH(_value)
	CALL SUBOPT_0x1B
; 0003 01A5             delay_ms(100);
; 0003 01A6 //
; 0003 01A7 //            if (atoi(value) == 200) {
; 0003 01A8 //                glcd_outtextxy(0, 16, "Internet OK");
; 0003 01A9 //            } else {
; 0003 01AA //                glcd_outtextxy(0, 16, "Internet Failed");
; 0003 01AB //            }
; 0003 01AC         }
; 0003 01AD //        else {
; 0003 01AE //            glcd_outtextxy(0, 16, "Parsing Error!");
; 0003 01AF //        }
; 0003 01B0     }
_0x60046:
; 0003 01B1 //    else {
; 0003 01B2 //        glcd_outtextxy(0, 16, "No response!");
; 0003 01B3 //    }
; 0003 01B4 
; 0003 01B5 
; 0003 01B6 
; 0003 01B7     // --- Å«Ì«‰ HTTP ---
; 0003 01B8     uart_buffer_reset();
_0x60045:
	CALL _uart_buffer_reset
; 0003 01B9     send_at_command("AT+HTTPTERM");
	__POINTW2MN _0x60044,125
	CALL _send_at_command
; 0003 01BA     delay_ms(100);
	CALL SUBOPT_0x21
; 0003 01BB }
	RET
; .FEND

	.DSEG
_0x60044:
	.BYTE 0x89
;
;
;//
;//void full_check(void){
;//
;//        sim800_restart();
;//        check_sim();
;//        check_signal_with_restart();
;//        init_sms();
;//
;//        if (init_GPRS()) {
;//            // «ê— „Ê›ﬁ ‘œ° «“ Õ·ﬁÂ Œ«—Ã »‘Â
;//            break;
;//        } else {
;//            // «ê— ‰«„Ê›ﬁ »Êœ
;//            glcd_clear();
;//            glcd_outtextxy(0, 0, "GPRS Init Failed!");
;//            delay_ms(100);  // ò„Ì ’»— ò‰Â
;//            // Ê œÊ»«—Â Õ·ﬁÂ  ò—«— „Ì‘Â
;//        }
;//
;//}
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
	CALL SUBOPT_0x26
	ANDI R30,0xDF
	CALL SUBOPT_0x26
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
_0x212000F:
	LD   R17,Y+
	RET
; .FEND
_ks0108_busy_G100:
; .FSTART _ks0108_busy_G100
	ST   -Y,R26
	ST   -Y,R17
	CALL SUBOPT_0x27
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
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x26
	CALL SUBOPT_0x28
	JMP  _0x2120009
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0x27
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
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x2A
	ORI  R30,8
	CALL SUBOPT_0x2A
	ORI  R30,4
	CALL SUBOPT_0x2A
	ORI  R30,0x80
	STS  97,R30
	LDS  R30,98
	ORI  R30,0x80
	STS  98,R30
	LDS  R30,97
	ORI  R30,0x20
	CALL SUBOPT_0x2A
	ORI  R30,0x40
	STS  97,R30
	RCALL _ks0108_disable_G100
	LDS  R30,98
	ANDI R30,0x7F
	STS  98,R30
	CALL SUBOPT_0x21
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
	CALL SUBOPT_0x1A
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
	CALL SUBOPT_0x1A
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
	CALL SUBOPT_0x2B
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
_0x212000D:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_glcd_putpixel:
; .FSTART _glcd_putpixel
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	CPI  R26,LOW(0x80)
	BRSH _0x200001D
	LDD  R26,Y+3
	CPI  R26,LOW(0x40)
	BRLO _0x200001C
_0x200001D:
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120006
_0x200001C:
	LDD  R30,Y+4
	ST   -Y,R30
	LDD  R26,Y+4
	RCALL _ks0108_rdbyte_G100
	MOV  R17,R30
	RCALL _ks0108_setloc_G100
	LDD  R30,Y+3
	ANDI R30,LOW(0x7)
	LDI  R26,LOW(1)
	CALL __LSLB12
	MOV  R16,R30
	LDD  R30,Y+2
	CPI  R30,0
	BREQ _0x200001F
	OR   R17,R16
	RJMP _0x2000020
_0x200001F:
	MOV  R30,R16
	COM  R30
	AND  R17,R30
_0x2000020:
	MOV  R26,R17
	RCALL _ks0108_wrdata_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	JMP  _0x2120006
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
	CALL SUBOPT_0x2B
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
	RJMP _0x212000C
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
	RJMP _0x212000C
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
	__GETW1MN _glcd_state,27
	SBIW R30,0
	BRNE _0x2000041
	RJMP _0x212000C
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
	CALL SUBOPT_0x2C
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
	CALL SUBOPT_0x2D
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
	CALL SUBOPT_0x2C
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
	CALL SUBOPT_0x2D
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x2C
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
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x2E
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
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2F
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x2B
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x32
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x33
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x2E
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
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x34
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
	CALL SUBOPT_0x32
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x33
	MOV  R30,R18
	MOV  R26,R20
	CALL SUBOPT_0x6
	OR   R21,R30
	CALL SUBOPT_0x2E
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
	CALL SUBOPT_0x30
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
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x34
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
_0x212000C:
	CALL __LOADLOCR6
	ADIW R28,17
	RET
; .FEND

	.CSEG
_glcd_clipx:
; .FSTART _glcd_clipx
	CALL SUBOPT_0x35
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
	CALL SUBOPT_0x35
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
_glcd_setpixel:
; .FSTART _glcd_setpixel
	ST   -Y,R26
	LDD  R30,Y+1
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	LDS  R26,_glcd_state
	RCALL _glcd_putpixel
	JMP  _0x2120003
; .FEND
_glcd_getcharw_G101:
; .FSTART _glcd_getcharw_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,3
	CALL SUBOPT_0x36
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000B
_0x202000B:
	CALL SUBOPT_0x37
	STD  Y+7,R0
	CALL SUBOPT_0x37
	STD  Y+6,R0
	CALL SUBOPT_0x37
	STD  Y+8,R0
	LDD  R30,Y+11
	LDD  R26,Y+8
	CP   R30,R26
	BRSH _0x202000C
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000B
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
	RJMP _0x212000B
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
	RJMP _0x212000B
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
_0x212000B:
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
	CALL SUBOPT_0x38
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
	CALL SUBOPT_0x36
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
	RJMP _0x212000A
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
	CALL SUBOPT_0x38
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
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x38
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x39
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	CP   R30,R16
	CPC  R31,R17
	BRNE _0x2020024
_0x2020021:
	RCALL _glcd_new_line_G101
	RJMP _0x212000A
_0x2020024:
_0x202001F:
	__PUTBMRN _glcd_state,2,16
_0x212000A:
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
_putchar:
; .FSTART _putchar
	ST   -Y,R26
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2120009:
	ADIW R28,1
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
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x3A
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	CALL SUBOPT_0x3A
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
	CALL SUBOPT_0x3B
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x3B
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
	CALL SUBOPT_0x3C
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3D
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3E
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3E
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
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
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
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3F
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
	CALL SUBOPT_0x3B
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
	CALL SUBOPT_0x3B
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
	CALL SUBOPT_0x3D
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x3B
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
	CALL SUBOPT_0x3D
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
	CALL SUBOPT_0x40
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
	CALL SUBOPT_0x40
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	CALL SUBOPT_0x41
	RJMP _0x2120008
; .FEND
_snprintf:
; .FSTART _snprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	__GETWRN 18,19,0
	CALL SUBOPT_0x42
	SBIW R30,0
	BRNE _0x2060073
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2120007
_0x2060073:
	CALL SUBOPT_0x40
	SBIW R30,0
	BREQ _0x2060074
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x42
	STD  Y+6,R30
	STD  Y+6+1,R31
	CALL SUBOPT_0x40
	STD  Y+8,R30
	STD  Y+8+1,R31
	CALL SUBOPT_0x41
_0x2060074:
_0x2120008:
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
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
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
	CALL SUBOPT_0x43
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
	CALL SUBOPT_0x43
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
_rx_counter0:
	.BYTE 0x1
_rx_wr_index0:
	.BYTE 0x1
_rx_rd_index0:
	.BYTE 0x1
_value:
	.BYTE 0x10
_buffer:
	.BYTE 0x100
_millis_counter:
	.BYTE 0x4
_last_time:
	.BYTE 0x4
_header_buffer:
	.BYTE 0x64
_content_buffer:
	.BYTE 0x64
_rx_buffer0:
	.BYTE 0x64
_phase_S0000009000:
	.BYTE 0x1
_h_idx_S0000009000:
	.BYTE 0x1
_c_idx_S0000009000:
	.BYTE 0x1
_processing_sms_S000000A001:
	.BYTE 0x1
_at_command:
	.BYTE 0x1E
_ks0108_coord_G100:
	.BYTE 0x3
_p_S1040026000:
	.BYTE 0x2
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDS  R30,_millis_counter
	LDS  R31,_millis_counter+1
	LDS  R22,_millis_counter+2
	LDS  R23,_millis_counter+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL __SAVELOCR6
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __CWD1
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x7:
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(_mahsol_ra_bardarid*2)
	LDI  R31,HIGH(_mahsol_ra_bardarid*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xA:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,38
	SUBI R29,1
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	CALL __SAVELOCR6
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:87 WORDS
SUBOPT_0xB:
	CALL _send_at_command
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	JMP  _uart_buffer_reset

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	MOVW R30,R28
	ADIW R30,8
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETW1SX 377
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xE:
	MOVW R30,R28
	SUBI R30,LOW(-(263))
	SBCI R31,HIGH(-(263))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,103
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,12
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(_buffer)
	LDI  R31,HIGH(_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	__GETD1N 0x1388
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x11:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_value)
	LDI  R31,HIGH(_value)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	LDI  R27,0
	JMP  _extract_field_after_keyword

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	CALL _send_at_command
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	LDI  R26,LOW(_value)
	LDI  R27,HIGH(_value)
	CALL _atoi
	CPI  R30,LOW(0xC8)
	LDI  R26,HIGH(0xC8)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x13:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	LDI  R26,LOW(64)
	JMP  _draw_bitmap

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	__GETW1SX 371
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x0,124
	CALL _strtok
	STD  Y+38,R30
	STD  Y+38+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(_content_buffer)
	LDI  R31,HIGH(_content_buffer)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1B:
	CALL _glcd_outtextxy
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1C:
	IN   R1,19
	MOV  R30,R17
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,14
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1D:
	CALL _send_at_command
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1F:
	__GETD1N 0x7D0
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	__GETD1N 0xBB8
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x22:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_value)
	LDI  R31,HIGH(_value)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(16)
	LDI  R27,0
	CALL _extract_field_after_keyword
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R26,LOW(_value)
	LDI  R27,HIGH(_value)
	JMP  _glcd_outtextxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(_value)
	LDI  R27,HIGH(_value)
	JMP  _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x25:
	CALL _send_at_command
	LDI  R26,LOW(50)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	STS  98,R30
	LDS  R30,98
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDS  R30,98
	ORI  R30,8
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x28:
	ANDI R30,0XF7
	STS  98,R30
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LD   R30,Y
	OUT  0x1B,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2A:
	STS  97,R30
	LDS  R30,97
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2D:
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
SUBOPT_0x2E:
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
SUBOPT_0x2F:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x31:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x32:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
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
SUBOPT_0x34:
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
	RJMP SUBOPT_0x2F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x38:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(9)
	JMP  _glcd_block

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3B:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3C:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3E:
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
SUBOPT_0x3F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x40:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x41:
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G103)
	LDI  R31,HIGH(_put_buff_G103)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __print_G103
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	MOVW R26,R28
	ADIW R26,14
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
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

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
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

__GTW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRLT __GTW12T
	CLR  R30
__GTW12T:
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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
