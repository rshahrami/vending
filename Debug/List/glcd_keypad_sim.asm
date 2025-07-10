
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

_0x17:
	.DB  0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38
	.DB  0x39,0x2A,0x30,0x23,0x7,0x5,0x6,0x4
	.DB  0x0,0x1,0x2
_0x0:
	.DB  0x25,0x73,0xD,0xA,0x0,0x41,0x54,0x2B
	.DB  0x48,0x54,0x54,0x50,0x49,0x4E,0x49,0x54
	.DB  0x0,0x4F,0x4B,0x0,0x6C,0x65,0x76,0x20
	.DB  0x31,0x0,0x41,0x54,0x2B,0x48,0x54,0x54
	.DB  0x50,0x50,0x41,0x52,0x41,0x3D,0x22,0x43
	.DB  0x49,0x44,0x22,0x2C,0x31,0x0,0x6C,0x65
	.DB  0x76,0x20,0x32,0x0,0x41,0x54,0x2B,0x48
	.DB  0x54,0x54,0x50,0x50,0x41,0x52,0x41,0x3D
	.DB  0x22,0x55,0x52,0x4C,0x22,0x2C,0x22,0x25
	.DB  0x73,0x22,0x0,0x6C,0x65,0x76,0x20,0x33
	.DB  0x0,0x41,0x54,0x2B,0x48,0x54,0x54,0x50
	.DB  0x50,0x41,0x52,0x41,0x3D,0x22,0x43,0x4F
	.DB  0x4E,0x54,0x45,0x4E,0x54,0x22,0x2C,0x22
	.DB  0x61,0x70,0x70,0x6C,0x69,0x63,0x61,0x74
	.DB  0x69,0x6F,0x6E,0x2F,0x6A,0x73,0x6F,0x6E
	.DB  0x22,0x0,0x6C,0x65,0x76,0x20,0x34,0x0
	.DB  0x7B,0x22,0x70,0x68,0x6F,0x6E,0x65,0x5F
	.DB  0x6E,0x75,0x6D,0x62,0x65,0x72,0x22,0x3A
	.DB  0x22,0x25,0x73,0x22,0x7D,0x0,0x6C,0x65
	.DB  0x76,0x20,0x35,0x0,0x41,0x54,0x2B,0x48
	.DB  0x54,0x54,0x50,0x44,0x41,0x54,0x41,0x3D
	.DB  0x25,0x75,0x2C,0x25,0x64,0x0,0x44,0x4F
	.DB  0x57,0x4E,0x4C,0x4F,0x41,0x44,0x0,0x6C
	.DB  0x65,0x76,0x20,0x36,0x0,0x6C,0x65,0x76
	.DB  0x20,0x37,0x0,0x41,0x54,0x2B,0x48,0x54
	.DB  0x54,0x50,0x41,0x43,0x54,0x49,0x4F,0x4E
	.DB  0x3D,0x31,0x0,0x2B,0x48,0x54,0x54,0x50
	.DB  0x41,0x43,0x54,0x49,0x4F,0x4E,0x3A,0x0
	.DB  0x6C,0x65,0x76,0x20,0x38,0x0,0x41,0x54
	.DB  0x2B,0x48,0x54,0x54,0x50,0x52,0x45,0x41
	.DB  0x44,0x0,0x52,0x65,0x73,0x70,0x6F,0x6E
	.DB  0x73,0x65,0x3A,0x0,0x6C,0x65,0x76,0x20
	.DB  0x39,0x0,0x41,0x54,0x2B,0x48,0x54,0x54
	.DB  0x50,0x54,0x45,0x52,0x4D,0x0,0x6C,0x65
	.DB  0x76,0x20,0x31,0x30,0x0,0x53,0x65,0x74
	.DB  0x74,0x69,0x6E,0x67,0x20,0x53,0x4D,0x53
	.DB  0x20,0x4D,0x6F,0x64,0x65,0x2E,0x2E,0x2E
	.DB  0x0,0x41,0x54,0x2B,0x43,0x4D,0x47,0x46
	.DB  0x3D,0x31,0x0,0x41,0x54,0x2B,0x43,0x4E
	.DB  0x4D,0x49,0x3D,0x32,0x2C,0x32,0x2C,0x30
	.DB  0x2C,0x30,0x2C,0x30,0x0,0x41,0x54,0x2B
	.DB  0x43,0x4D,0x47,0x44,0x41,0x3D,0x22,0x44
	.DB  0x45,0x4C,0x20,0x41,0x4C,0x4C,0x22,0x0
	.DB  0x53,0x4D,0x53,0x20,0x52,0x65,0x61,0x64
	.DB  0x79,0x2E,0x0,0x43,0x6F,0x6E,0x6E,0x65
	.DB  0x63,0x74,0x69,0x6E,0x67,0x20,0x74,0x6F
	.DB  0x20,0x47,0x50,0x52,0x53,0x2E,0x2E,0x2E
	.DB  0x0,0x41,0x54,0x2B,0x53,0x41,0x50,0x42
	.DB  0x52,0x3D,0x33,0x2C,0x31,0x2C,0x22,0x43
	.DB  0x6F,0x6E,0x74,0x79,0x70,0x65,0x22,0x2C
	.DB  0x22,0x47,0x50,0x52,0x53,0x22,0x0,0x41
	.DB  0x54,0x2B,0x53,0x41,0x50,0x42,0x52,0x3D
	.DB  0x33,0x2C,0x31,0x2C,0x22,0x41,0x50,0x4E
	.DB  0x22,0x2C,0x22,0x25,0x73,0x22,0x0,0x6D
	.DB  0x63,0x69,0x6E,0x65,0x74,0x0,0x41,0x54
	.DB  0x2B,0x53,0x41,0x50,0x42,0x52,0x3D,0x31
	.DB  0x2C,0x31,0x0,0x46,0x65,0x74,0x63,0x68
	.DB  0x69,0x6E,0x67,0x20,0x49,0x50,0x2E,0x2E
	.DB  0x2E,0x0,0x41,0x54,0x2B,0x53,0x41,0x50
	.DB  0x42,0x52,0x3D,0x32,0x2C,0x31,0x0,0x2B
	.DB  0x53,0x41,0x50,0x42,0x52,0x3A,0x0,0x52
	.DB  0x65,0x73,0x70,0x3A,0x0,0x2B,0x53,0x41
	.DB  0x50,0x42,0x52,0x3A,0x20,0x31,0x2C,0x31
	.DB  0x2C,0x0,0x4D,0x4F,0x54,0x4F,0x52,0x20
	.DB  0x25,0x64,0x20,0x4F,0x4E,0x21,0x0,0x4D
	.DB  0x4F,0x54,0x4F,0x52,0x20,0x25,0x64,0x20
	.DB  0x4F,0x46,0x46,0x21,0x0,0x68,0x74,0x74
	.DB  0x70,0x3A,0x2F,0x2F,0x31,0x39,0x33,0x2E
	.DB  0x35,0x2E,0x34,0x34,0x2E,0x31,0x39,0x31
	.DB  0x2F,0x68,0x6F,0x6D,0x65,0x2F,0x70,0x6F
	.DB  0x73,0x74,0x2F,0x0,0x2B,0x39,0x38,0x39
	.DB  0x31,0x32,0x32,0x36,0x30,0x38,0x35,0x38
	.DB  0x32,0x0,0x4D,0x6F,0x64,0x75,0x6C,0x65
	.DB  0x20,0x49,0x6E,0x69,0x74,0x2E,0x2E,0x2E
	.DB  0x0,0x41,0x54,0x45,0x30,0x0,0x41,0x54
	.DB  0x0,0x53,0x4D,0x53,0x20,0x49,0x6E,0x69
	.DB  0x74,0x20,0x46,0x61,0x69,0x6C,0x65,0x64
	.DB  0x21,0x0,0x47,0x50,0x52,0x53,0x20,0x49
	.DB  0x6E,0x69,0x74,0x20,0x46,0x61,0x69,0x6C
	.DB  0x65,0x64,0x21,0x0,0x53,0x79,0x73,0x74
	.DB  0x65,0x6D,0x20,0x52,0x65,0x61,0x64,0x79
	.DB  0x2E,0x0,0x57,0x61,0x69,0x74,0x69,0x6E
	.DB  0x67,0x20,0x66,0x6F,0x72,0x20,0x53,0x4D
	.DB  0x53,0x2E,0x2E,0x2E,0x0,0x53,0x65,0x6E
	.DB  0x64,0x69,0x6E,0x67,0x20,0x50,0x4F,0x53
	.DB  0x54,0x2E,0x2E,0x2E,0x0,0x50,0x4F,0x53
	.DB  0x54,0x20,0x4F,0x4B,0x0,0x50,0x4F,0x53
	.DB  0x54,0x20,0x46,0x61,0x69,0x6C,0x0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  _0xA
	.DW  _0x0*2+5

	.DW  0x03
	.DW  _0xA+12
	.DW  _0x0*2+17

	.DW  0x06
	.DW  _0xA+15
	.DW  _0x0*2+20

	.DW  0x14
	.DW  _0xA+21
	.DW  _0x0*2+26

	.DW  0x03
	.DW  _0xA+41
	.DW  _0x0*2+17

	.DW  0x06
	.DW  _0xA+44
	.DW  _0x0*2+46

	.DW  0x03
	.DW  _0xA+50
	.DW  _0x0*2+17

	.DW  0x06
	.DW  _0xA+53
	.DW  _0x0*2+75

	.DW  0x29
	.DW  _0xA+59
	.DW  _0x0*2+81

	.DW  0x03
	.DW  _0xA+100
	.DW  _0x0*2+17

	.DW  0x06
	.DW  _0xA+103
	.DW  _0x0*2+122

	.DW  0x06
	.DW  _0xA+109
	.DW  _0x0*2+150

	.DW  0x09
	.DW  _0xA+115
	.DW  _0x0*2+174

	.DW  0x06
	.DW  _0xA+124
	.DW  _0x0*2+183

	.DW  0x06
	.DW  _0xA+130
	.DW  _0x0*2+189

	.DW  0x10
	.DW  _0xA+136
	.DW  _0x0*2+195

	.DW  0x0D
	.DW  _0xA+152
	.DW  _0x0*2+211

	.DW  0x06
	.DW  _0xA+165
	.DW  _0x0*2+224

	.DW  0x0C
	.DW  _0xA+171
	.DW  _0x0*2+230

	.DW  0x03
	.DW  _0xA+183
	.DW  _0x0*2+17

	.DW  0x0A
	.DW  _0xA+186
	.DW  _0x0*2+242

	.DW  0x06
	.DW  _0xA+196
	.DW  _0x0*2+252

	.DW  0x0C
	.DW  _0xA+202
	.DW  _0x0*2+258

	.DW  0x03
	.DW  _0xA+214
	.DW  _0x0*2+17

	.DW  0x07
	.DW  _0xA+217
	.DW  _0x0*2+270

	.DW  0x14
	.DW  _0x12
	.DW  _0x0*2+277

	.DW  0x0A
	.DW  _0x12+20
	.DW  _0x0*2+297

	.DW  0x12
	.DW  _0x12+30
	.DW  _0x0*2+307

	.DW  0x13
	.DW  _0x12+48
	.DW  _0x0*2+325

	.DW  0x0B
	.DW  _0x12+67
	.DW  _0x0*2+344

	.DW  0x16
	.DW  _0x13
	.DW  _0x0*2+355

	.DW  0x1E
	.DW  _0x13+22
	.DW  _0x0*2+377

	.DW  0x0D
	.DW  _0x13+52
	.DW  _0x0*2+438

	.DW  0x0F
	.DW  _0x13+65
	.DW  _0x0*2+451

	.DW  0x0D
	.DW  _0x13+80
	.DW  _0x0*2+466

	.DW  0x08
	.DW  _0x13+93
	.DW  _0x0*2+479

	.DW  0x06
	.DW  _0x13+101
	.DW  _0x0*2+487

	.DW  0x0D
	.DW  _0x13+107
	.DW  _0x0*2+493

	.DW  0x1F
	.DW  _0x2A
	.DW  _0x0*2+533

	.DW  0x0E
	.DW  _0x2A+31
	.DW  _0x0*2+564

	.DW  0x0F
	.DW  _0x2A+45
	.DW  _0x0*2+578

	.DW  0x05
	.DW  _0x2A+60
	.DW  _0x0*2+593

	.DW  0x03
	.DW  _0x2A+65
	.DW  _0x0*2+598

	.DW  0x11
	.DW  _0x2A+68
	.DW  _0x0*2+601

	.DW  0x12
	.DW  _0x2A+85
	.DW  _0x0*2+618

	.DW  0x0E
	.DW  _0x2A+103
	.DW  _0x0*2+636

	.DW  0x13
	.DW  _0x2A+117
	.DW  _0x0*2+650

	.DW  0x10
	.DW  _0x2A+136
	.DW  _0x0*2+669

	.DW  0x08
	.DW  _0x2A+152
	.DW  _0x0*2+685

	.DW  0x0A
	.DW  _0x2A+160
	.DW  _0x0*2+693

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
;#include <stdlib.h> // ÈÑÇí ÇÓÊÝÇÏå ÇÒ ÊÇÈÚ atoi
;
;// #define F_CPU 8000000UL
;#include <delay.h>
;
;// --- ÊäÙíãÇÊ ÇÕáí ---
;#define APN "mcinet" // APN ÇÑÇÊæÑ ÎæÏ ÑÇ æÇÑÏ ˜äíÏ
;//#define SERVER_URL "http://google.com/api/authorize" // ÂÏÑÓ ˜Çãá ÓÑæÑ ÎæÏ ÑÇ ÇíäÌÇ ÞÑÇÑ ÏåíÏ
;#define SERVER_URL_POST "http://193.5.44.191/home/post/"
;
;#define HTTP_TIMEOUT_MS 30000
;
;// --- ÈÇÝÑåÇí ÓÑÇÓÑí ---
;char header_buffer[100];
;char content_buffer[100];
;char ip_address_buffer[16];
;char phone_number[16];
;char response_buffer[256]; // ÇÝÒÇíÔ ÓÇíÒ ÈÇÝÑ ÈÑÇí ÏÑíÇÝÊ ÇÓÎåÇí HTTP
;
;// --- ÊÚÑíÝ íäåÇí ãæÊæÑ ---
;#define MOTOR_DDR DDRE
;#define MOTOR_PORT PORTE
;#define MOTOR_PIN_1 2
;#define MOTOR_PIN_2 3
;#define MOTOR_PIN_3 4
;
;// --- ÊÚÑíÝ íäåÇí ˜íÏ ---
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
;// ÊÇÈÚ ÇÑÓÇá ÏÓÊæÑ AT Èå ãÇŽæá
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
	JMP  _0x212000C
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
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
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
	RJMP _0x212000F
; 0000 004E     }
; 0000 004F 
; 0000 0050     return 0; // Failed to find the response
_0x9:
	LDI  R30,LOW(0)
_0x212000F:
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; 0000 0051 }
; .FEND
;
;
;// ÊÇÈÚ ÈÑÑÓí ãÌæÒ ÔãÇÑå ÊáÝä ÇÒ ØÑíÞ ÓÑæÑ
;
;unsigned char send_json_post(const char* url, const char* phone_number) {
; 0000 0056 unsigned char send_json_post(const char* url, const char* phone_number) {
_send_json_post:
; .FSTART _send_json_post
; 0000 0057     char cmd[128];
; 0000 0058     char response[256];
; 0000 0059     char json[64];
; 0000 005A     unsigned int json_len;
; 0000 005B 
; 0000 005C     // 1. Initialize HTTP service
; 0000 005D     send_at_command("AT+HTTPINIT");
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,63
	SBIW R28,63
	SBIW R28,3
	SUBI R29,1
	ST   -Y,R17
	ST   -Y,R16
;	*url -> Y+452
;	*phone_number -> Y+450
;	cmd -> Y+322
;	response -> Y+66
;	json -> Y+2
;	json_len -> R16,R17
	__POINTW2MN _0xA,0
	CALL SUBOPT_0x1
; 0000 005E     if (!read_serial_response(response, sizeof(response), 2000, "OK")) return 0;
	__POINTW2MN _0xA,12
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0xB
	LDI  R30,LOW(0)
	RJMP _0x212000E
; 0000 005F 
; 0000 0060     glcd_outtextxy(0,20,"lev 1");
_0xB:
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,15
	CALL _glcd_outtextxy
; 0000 0061 
; 0000 0062     // 2. Set CID to bearer profile 1
; 0000 0063     send_at_command("AT+HTTPPARA=\"CID\",1");
	__POINTW2MN _0xA,21
	CALL SUBOPT_0x1
; 0000 0064     if (!read_serial_response(response, sizeof(response), 2000, "OK")) return 0;
	__POINTW2MN _0xA,41
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0xC
	LDI  R30,LOW(0)
	RJMP _0x212000E
; 0000 0065 
; 0000 0066     glcd_outtextxy(0,20,"lev 2");
_0xC:
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,44
	CALL SUBOPT_0x3
; 0000 0067 
; 0000 0068     // 3. Set the target URL
; 0000 0069     sprintf(cmd, "AT+HTTPPARA=\"URL\",\"%s\"", url);
	__POINTW1FN _0x0,52
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 456
	CALL SUBOPT_0x0
	CALL _sprintf
	ADIW R28,8
; 0000 006A     send_at_command(cmd);
	MOVW R26,R28
	SUBI R26,LOW(-(322))
	SBCI R27,HIGH(-(322))
	CALL SUBOPT_0x1
; 0000 006B     if (!read_serial_response(response, sizeof(response), 2000, "OK")) return 0;
	__POINTW2MN _0xA,50
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0xD
	LDI  R30,LOW(0)
	RJMP _0x212000E
; 0000 006C 
; 0000 006D     glcd_outtextxy(0,20,"lev 3");
_0xD:
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,53
	CALL _glcd_outtextxy
; 0000 006E 
; 0000 006F     // 4. Tell the module we’ll send JSON
; 0000 0070     send_at_command("AT+HTTPPARA=\"CONTENT\",\"application/json\"");
	__POINTW2MN _0xA,59
	CALL SUBOPT_0x1
; 0000 0071     if (!read_serial_response(response, sizeof(response), 2000, "OK")) return 0;
	__POINTW2MN _0xA,100
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0xE
	LDI  R30,LOW(0)
	RJMP _0x212000E
; 0000 0072 
; 0000 0073     glcd_outtextxy(0,20,"lev 4");
_0xE:
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,103
	CALL _glcd_outtextxy
; 0000 0074 
; 0000 0075     // 5. Build the JSON payload
; 0000 0076     sprintf(json, "{\"phone_number\":\"%s\"}", phone_number);
	MOVW R30,R28
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,128
	ST   -Y,R31
	ST   -Y,R30
	__GETW1SX 454
	CALL SUBOPT_0x0
	CALL _sprintf
	ADIW R28,8
; 0000 0077     json_len = strlen(json);
	MOVW R26,R28
	ADIW R26,2
	CALL _strlen
	MOVW R16,R30
; 0000 0078 
; 0000 0079     glcd_outtextxy(0,20,"lev 5");
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,109
	CALL SUBOPT_0x3
; 0000 007A //    delay_ms(3000);
; 0000 007B 
; 0000 007C     // 6. Notify module about payload size and wait for “DOWNLOAD”
; 0000 007D     sprintf(cmd, "AT+HTTPDATA=%u,%d", json_len, HTTP_TIMEOUT_MS);
	__POINTW1FN _0x0,156
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	__GETD1N 0x7530
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 007E     send_at_command(cmd);
	MOVW R26,R28
	SUBI R26,LOW(-(322))
	SBCI R27,HIGH(-(322))
	CALL SUBOPT_0x4
; 0000 007F     if (!read_serial_response(response, sizeof(response), 7000, "DOWNLOAD")) return 0;
	LDI  R30,LOW(7000)
	LDI  R31,HIGH(7000)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0xA,115
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0xF
	LDI  R30,LOW(0)
	RJMP _0x212000E
; 0000 0080 
; 0000 0081     glcd_outtextxy(0,20,"lev 6");
_0xF:
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,124
	CALL _glcd_outtextxy
; 0000 0082 
; 0000 0083     // 7. Send the actual JSON data
; 0000 0084     send_at_command((char*)json);  // send_at_command appends \r\n
	MOVW R26,R28
	ADIW R26,2
	CALL SUBOPT_0x5
; 0000 0085     // ˜ãí ÕÈÑ ˜äíÏ ÊÇ ÏÇÏå ˜Çãá ÈÑæÏ
; 0000 0086     delay_ms(500);
; 0000 0087 
; 0000 0088     glcd_outtextxy(0,20,"lev 7");
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,130
	CALL _glcd_outtextxy
; 0000 0089 //    glcd_outtextxy(0,20,"level 2");
; 0000 008A //    delay_ms(3000);
; 0000 008B 
; 0000 008C     // 8. Execute the POST (1 = POST method)
; 0000 008D     send_at_command("AT+HTTPACTION=1");
	__POINTW2MN _0xA,136
	CALL SUBOPT_0x4
; 0000 008E     if (!read_serial_response(response, sizeof(response), HTTP_TIMEOUT_MS, "+HTTPACTION:")) return 0;
	LDI  R30,LOW(30000)
	LDI  R31,HIGH(30000)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0xA,152
	RCALL _read_serial_response
	CPI  R30,0
	BRNE _0x10
	LDI  R30,LOW(0)
	RJMP _0x212000E
; 0000 008F 
; 0000 0090     glcd_outtextxy(0,20,"lev 8");
_0x10:
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,165
	CALL _glcd_outtextxy
; 0000 0091 
; 0000 0092     // 9. (ÇÎÊíÇÑí) ÎæÇäÏä ÇÓÎ ÓÑæÑ
; 0000 0093     send_at_command("AT+HTTPREAD");
	__POINTW2MN _0xA,171
	CALL SUBOPT_0x4
; 0000 0094     if (read_serial_response(response, sizeof(response), 7000, "OK")) {
	LDI  R30,LOW(7000)
	LDI  R31,HIGH(7000)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0xA,183
	RCALL _read_serial_response
	CPI  R30,0
	BREQ _0x11
; 0000 0095         // ÇÓÎ ÓÑæÑ ÏÑ response ÇÓÊ¡ ãíÊæÇäíÏ ÈÑÇí ÏíÈÇ Ç ˜äíÏ:
; 0000 0096         glcd_clear();
	CALL SUBOPT_0x6
; 0000 0097         glcd_outtextxy(0,0,"Response:");
	__POINTW2MN _0xA,186
	CALL SUBOPT_0x7
; 0000 0098         glcd_outtextxy(0,10,response);
	MOVW R26,R28
	SUBI R26,LOW(-(68))
	SBCI R27,HIGH(-(68))
	CALL _glcd_outtextxy
; 0000 0099     }
; 0000 009A 
; 0000 009B     glcd_outtextxy(0,20,"lev 9");
_0x11:
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,196
	CALL _glcd_outtextxy
; 0000 009C 
; 0000 009D     // 10. Terminate HTTP service
; 0000 009E     send_at_command("AT+HTTPTERM");
	__POINTW2MN _0xA,202
	CALL SUBOPT_0x1
; 0000 009F     read_serial_response(response, sizeof(response), 2000, "OK");
	__POINTW2MN _0xA,214
	RCALL _read_serial_response
; 0000 00A0 
; 0000 00A1     glcd_outtextxy(0,20,"lev 10");
	CALL SUBOPT_0x2
	__POINTW2MN _0xA,217
	CALL _glcd_outtextxy
; 0000 00A2     return 1;
	LDI  R30,LOW(1)
_0x212000E:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,63
	ADIW R28,63
	ADIW R28,63
	ADIW R28,9
	SUBI R29,-1
	RET
; 0000 00A3 }
; .FEND

	.DSEG
_0xA:
	.BYTE 0xE0
;
;///////////////////////////////////////////////////////////////////////////////////////////
;
;unsigned char init_sms(void)
; 0000 00A8 {

	.CSEG
_init_sms:
; .FSTART _init_sms
; 0000 00A9     glcd_clear();
	CALL SUBOPT_0x6
; 0000 00AA     glcd_outtextxy(0, 0, "Setting SMS Mode...");
	__POINTW2MN _0x12,0
	CALL _glcd_outtextxy
; 0000 00AB     send_at_command("AT+CMGF=1");
	__POINTW2MN _0x12,20
	CALL SUBOPT_0x5
; 0000 00AC     delay_ms(500);
; 0000 00AD 
; 0000 00AE     send_at_command("AT+CNMI=2,2,0,0,0");
	__POINTW2MN _0x12,30
	CALL SUBOPT_0x5
; 0000 00AF     delay_ms(500);
; 0000 00B0 
; 0000 00B1     send_at_command("AT+CMGDA=\"DEL ALL\"");
	__POINTW2MN _0x12,48
	RCALL _send_at_command
; 0000 00B2     delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 00B3 
; 0000 00B4     glcd_outtextxy(0, 10, "SMS Ready.");
	CALL SUBOPT_0x8
	__POINTW2MN _0x12,67
	CALL _glcd_outtextxy
; 0000 00B5     delay_ms(1000);
	CALL SUBOPT_0x9
; 0000 00B6     return 1;
	LDI  R30,LOW(1)
	RET
; 0000 00B7 }
; .FEND

	.DSEG
_0x12:
	.BYTE 0x4E
;
;unsigned char init_GPRS(void)
; 0000 00BA {

	.CSEG
_init_GPRS:
; .FSTART _init_GPRS
; 0000 00BB     char at_command[50];
; 0000 00BC     char response[100]; // Local buffer for the response
; 0000 00BD 
; 0000 00BE     glcd_clear();
	SBIW R28,63
	SBIW R28,63
	SBIW R28,24
;	at_command -> Y+100
;	response -> Y+0
	CALL SUBOPT_0x6
; 0000 00BF     glcd_outtextxy(0, 0, "Connecting to GPRS...");
	__POINTW2MN _0x13,0
	CALL _glcd_outtextxy
; 0000 00C0 
; 0000 00C1     send_at_command("AT+SAPBR=3,1,\"Contype\",\"GPRS\"");
	__POINTW2MN _0x13,22
	CALL SUBOPT_0xA
; 0000 00C2     delay_ms(1500);
; 0000 00C3 
; 0000 00C4     sprintf(at_command, "AT+SAPBR=3,1,\"APN\",\"%s\"", APN);
	MOVW R30,R28
	SUBI R30,LOW(-(100))
	SBCI R31,HIGH(-(100))
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,407
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,431
	CALL SUBOPT_0x0
	CALL _sprintf
	ADIW R28,8
; 0000 00C5     send_at_command(at_command);
	MOVW R26,R28
	SUBI R26,LOW(-(100))
	SBCI R27,HIGH(-(100))
	CALL SUBOPT_0xA
; 0000 00C6     delay_ms(1500);
; 0000 00C7 
; 0000 00C8     send_at_command("AT+SAPBR=1,1");
	__POINTW2MN _0x13,52
	RCALL _send_at_command
; 0000 00C9     delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00CA 
; 0000 00CB     glcd_clear();
	CALL SUBOPT_0x6
; 0000 00CC     glcd_outtextxy(0, 0, "Fetching IP...");
	__POINTW2MN _0x13,65
	CALL _glcd_outtextxy
; 0000 00CD     send_at_command("AT+SAPBR=2,1"); // Request IP
	__POINTW2MN _0x13,80
	RCALL _send_at_command
; 0000 00CE     // delay_ms(5000);
; 0000 00CF 
; 0000 00D0     // Attempt to read the response for 5 seconds, looking for "+SAPBR:"
; 0000 00D1     // FIX: Added the 4th argument, "+SAPBR:", to the function call.
; 0000 00D2     if (read_serial_response(response, sizeof(response), 5000, "+SAPBR:")) {
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x13,93
	RCALL _read_serial_response
	CPI  R30,0
	BREQ _0x14
; 0000 00D3         glcd_outtextxy(0, 10, "Resp:");
	CALL SUBOPT_0x8
	__POINTW2MN _0x13,101
	CALL _glcd_outtextxy
; 0000 00D4         glcd_outtextxy(0, 20, response); // Display the received response for debugging
	CALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,2
	CALL _glcd_outtextxy
; 0000 00D5         delay_ms(3000);
	LDI  R26,LOW(3000)
	LDI  R27,HIGH(3000)
	CALL _delay_ms
; 0000 00D6 
; 0000 00D7         // Check if the response contains the IP address part
; 0000 00D8         if (strstr(response, "+SAPBR: 1,1,") != NULL) {
	MOVW R30,R28
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2MN _0x13,107
	CALL _strstr
	SBIW R30,0
	BREQ _0x15
; 0000 00D9             char* token = strtok(response, "\"");
; 0000 00DA             token = strtok(NULL, "\"");
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
; 0000 00DB 
; 0000 00DC             if (token) {
	LD   R30,Y
	LDD  R31,Y+1
	SBIW R30,0
	BREQ _0x16
; 0000 00DD                 strcpy(ip_address_buffer, token);
	LDI  R30,LOW(_ip_address_buffer)
	LDI  R31,HIGH(_ip_address_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL _strcpy
; 0000 00DE                 return 1; // Success
	LDI  R30,LOW(1)
	ADIW R28,2
	RJMP _0x212000D
; 0000 00DF             }
; 0000 00E0         }
_0x16:
	ADIW R28,2
; 0000 00E1     }
_0x15:
; 0000 00E2 
; 0000 00E3     // If we reach here, it means getting the IP address failed
; 0000 00E4     return 0; // Failure
_0x14:
	LDI  R30,LOW(0)
_0x212000D:
	ADIW R28,63
	ADIW R28,63
	ADIW R28,24
	RET
; 0000 00E5 }
; .FEND

	.DSEG
_0x13:
	.BYTE 0x78
;
;
;
;
;char get_key(void)
; 0000 00EB {

	.CSEG
; 0000 00EC     unsigned char row, col;
; 0000 00ED     const unsigned char column_pins[3] = {COL1_PIN, COL2_PIN, COL3_PIN};
; 0000 00EE     const unsigned char row_pins[4] = {ROW1_PIN, ROW2_PIN, ROW3_PIN, ROW4_PIN};
; 0000 00EF 
; 0000 00F0     const char key_map[4][3] = {
; 0000 00F1         {'1', '2', '3'},
; 0000 00F2         {'4', '5', '6'},
; 0000 00F3         {'7', '8', '9'},
; 0000 00F4         {'*', '0', '#'}
; 0000 00F5     };
; 0000 00F6 
; 0000 00F7     for (col = 0; col < 3; col++)
;	row -> R17
;	col -> R16
;	column_pins -> Y+18
;	row_pins -> Y+14
;	key_map -> Y+2
; 0000 00F8     {
; 0000 00F9         KEYPAD_PORT |= (1 << COL1_PIN) | (1 << COL2_PIN) | (1 << COL3_PIN);
; 0000 00FA         KEYPAD_PORT &= ~(1 << column_pins[col]);
; 0000 00FB 
; 0000 00FC         for (row = 0; row < 4; row++)
; 0000 00FD         {
; 0000 00FE             if (!(KEYPAD_PIN & (1 << row_pins[row])))
; 0000 00FF             {
; 0000 0100                 delay_ms(10);
; 0000 0101 
; 0000 0102                 if (!(KEYPAD_PIN & (1 << row_pins[row])))
; 0000 0103                 {
; 0000 0104                     while (!(KEYPAD_PIN & (1 << row_pins[row])));
; 0000 0105                     return key_map[row][col];
; 0000 0106                 }
; 0000 0107             }
; 0000 0108         }
; 0000 0109     }
; 0000 010A 
; 0000 010B     // C?? ??? ???I? ?O?I? ?OI? E?I? ??IC? ??? (NULL) ?C E???IC?
; 0000 010C     return 0;
; 0000 010D }
;
;
;
;
;void activate_motor(int product_id)
; 0000 0113 {
; 0000 0114     unsigned char motor_pin;
; 0000 0115     char motor_msg[20];
; 0000 0116 
; 0000 0117     switch (product_id)
;	product_id -> Y+21
;	motor_pin -> R17
;	motor_msg -> Y+1
; 0000 0118     {
; 0000 0119         case 1: motor_pin = MOTOR_PIN_1; break;
; 0000 011A         case 2: motor_pin = MOTOR_PIN_2; break;
; 0000 011B         case 3: motor_pin = MOTOR_PIN_3; break;
; 0000 011C         default: return;
; 0000 011D     }
; 0000 011E 
; 0000 011F     sprintf(motor_msg, "MOTOR %d ON!", product_id);
; 0000 0120     glcd_clear();
; 0000 0121     glcd_outtextxy(10, 20, motor_msg);
; 0000 0122     MOTOR_PORT |= (1 << motor_pin);
; 0000 0123     delay_ms(10000);
; 0000 0124     MOTOR_PORT &= ~(1 << motor_pin);
; 0000 0125 
; 0000 0126     sprintf(motor_msg, "MOTOR %d OFF!", product_id);
; 0000 0127     glcd_outtextxy(10, 40, motor_msg);
; 0000 0128     delay_ms(2000);
; 0000 0129 }
;
;///////////////////////////////////////////////////////////////////////////////////
;
;void main(void)
; 0000 012E {
_main:
; .FSTART _main
; 0000 012F     const char* server_url = "http://193.5.44.191/home/post/";
; 0000 0130     const char* my_phone    = "+989122608582";
; 0000 0131 
; 0000 0132     GLCDINIT_t glcd_init_data;
; 0000 0133 
; 0000 0134     // --- C?? EIO ??IC?I?? C???? ???E??C ? USART C?E ?? C? ?I I?IEC? ??? OI? ---
; 0000 0135     // --- ? ???? C?E. ??C?? E? EU??? A? ???E.                             ---
; 0000 0136     DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
	SBIW R28,6
;	*server_url -> R16,R17
;	*my_phone -> R18,R19
;	glcd_init_data -> Y+0
	__POINTWRMN 16,17,_0x2A,0
	__POINTWRMN 18,19,_0x2A,31
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0137     PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	OUT  0x1B,R30
; 0000 0138     DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
	OUT  0x17,R30
; 0000 0139     PORTB=(1<<PORTB7) | (1<<PORTB6) | (1<<PORTB5) | (1<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(240)
	OUT  0x18,R30
; 0000 013A     DDRC=(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(7)
	OUT  0x14,R30
; 0000 013B     PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);
	LDI  R30,LOW(240)
	OUT  0x15,R30
; 0000 013C     DDRE=(0<<DDE7) | (0<<DDE6) | (1<<DDE5) | (1<<DDE4) | (1<<DDE3) | (1<<DDE2) | (0<<DDE1) | (0<<DDE0);
	LDI  R30,LOW(60)
	OUT  0x2,R30
; 0000 013D     PORTE=(0<<PORTE7) | (0<<PORTE6) | (0<<PORTE5) | (0<<PORTE4) | (0<<PORTE3) | (0<<PORTE2) | (0<<PORTE1) | (0<<PORTE0);
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 013E     DDRF=(0<<DDF7) | (0<<DDF6) | (0<<DDF5) | (0<<DDF4) | (0<<DDF3) | (0<<DDF2) | (0<<DDF1) | (0<<DDF0);
	STS  97,R30
; 0000 013F     PORTF=(0<<PORTF7) | (0<<PORTF6) | (0<<PORTF5) | (0<<PORTF4) | (0<<PORTF3) | (0<<PORTF2) | (0<<PORTF1) | (0<<PORTF0);
	STS  98,R30
; 0000 0140     UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
	OUT  0xB,R30
; 0000 0141     UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0142     UCSR0C=(0<<UMSEL0) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0143     UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0144     UBRR0L=0x33; // 9600 Baud Rate for 8MHz clock
	LDI  R30,LOW(51)
	OUT  0x9,R30
; 0000 0145     MCUCSR = (1 << JTD);
	LDI  R30,LOW(128)
	OUT  0x34,R30
; 0000 0146     MCUCSR = (1 << JTD);
	OUT  0x34,R30
; 0000 0147     glcd_init_data.font=font5x7;
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0148     glcd_init_data.readxmem=NULL;
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+2+1,R30
; 0000 0149     glcd_init_data.writexmem=NULL;
	STD  Y+4,R30
	STD  Y+4+1,R30
; 0000 014A     glcd_init(&glcd_init_data);
	MOVW R26,R28
	RCALL _glcd_init
; 0000 014B     glcd_setfont(font5x7);
	LDI  R30,LOW(_font5x7*2)
	LDI  R31,HIGH(_font5x7*2)
	CALL SUBOPT_0xC
; 0000 014C     // --- ?C?C? EIO ??IC?I?? C???? ---
; 0000 014D 
; 0000 014E     glcd_clear();
	CALL SUBOPT_0x6
; 0000 014F     glcd_outtextxy(0, 0, "Module Init...");
	__POINTW2MN _0x2A,45
	CALL _glcd_outtextxy
; 0000 0150     delay_ms(5000);
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	CALL _delay_ms
; 0000 0151 
; 0000 0152     send_at_command("ATE0");
	__POINTW2MN _0x2A,60
	RCALL _send_at_command
; 0000 0153     delay_ms(1000);
	CALL SUBOPT_0x9
; 0000 0154     send_at_command("AT");
	__POINTW2MN _0x2A,65
	RCALL _send_at_command
; 0000 0155     delay_ms(1000);
	CALL SUBOPT_0x9
; 0000 0156 
; 0000 0157     if (!init_sms()) { glcd_outtextxy(0, 10, "SMS Init Failed!"); while(1); }
	RCALL _init_sms
	CPI  R30,0
	BRNE _0x2B
	CALL SUBOPT_0x8
	__POINTW2MN _0x2A,68
	CALL _glcd_outtextxy
_0x2C:
	RJMP _0x2C
; 0000 0158     if (!init_GPRS()) { glcd_outtextxy(0, 10, "GPRS Init Failed!"); while(1); }
_0x2B:
	RCALL _init_GPRS
	CPI  R30,0
	BRNE _0x2F
	CALL SUBOPT_0x8
	__POINTW2MN _0x2A,85
	CALL _glcd_outtextxy
_0x30:
	RJMP _0x30
; 0000 0159 
; 0000 015A     glcd_clear();
_0x2F:
	CALL SUBOPT_0x6
; 0000 015B     glcd_outtextxy(0, 0, "System Ready.");
	__POINTW2MN _0x2A,103
	CALL SUBOPT_0x7
; 0000 015C     glcd_outtextxy(0, 10, "Waiting for SMS...");
	__POINTW2MN _0x2A,117
	CALL _glcd_outtextxy
; 0000 015D 
; 0000 015E 
; 0000 015F     glcd_clear();
	CALL SUBOPT_0x6
; 0000 0160     glcd_outtextxy(0,0,"Sending POST...");
	__POINTW2MN _0x2A,136
	CALL _glcd_outtextxy
; 0000 0161     if (send_json_post(server_url, my_phone)) {
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R18
	RCALL _send_json_post
	CPI  R30,0
	BREQ _0x33
; 0000 0162         glcd_outtextxy(0,10,"POST OK");
	CALL SUBOPT_0x8
	__POINTW2MN _0x2A,152
	RJMP _0x39
; 0000 0163     } else {
_0x33:
; 0000 0164         glcd_outtextxy(0,10,"POST Fail");
	CALL SUBOPT_0x8
	__POINTW2MN _0x2A,160
_0x39:
	CALL _glcd_outtextxy
; 0000 0165     }
; 0000 0166 
; 0000 0167     while (1)
_0x35:
; 0000 0168     {
; 0000 0169 //        char sms_char;
; 0000 016A //        char key_pressed;
; 0000 016B //        char display_buffer[2] = {0};
; 0000 016C //        int product_id = 0;
; 0000 016D //
; 0000 016E //        memset(header_buffer, 0, sizeof(header_buffer));
; 0000 016F //
; 0000 0170 //        if (gets(header_buffer, sizeof(header_buffer)))
; 0000 0171 //        {
; 0000 0172 //            if (strstr(header_buffer, "+CMT:") != NULL)
; 0000 0173 //            {
; 0000 0174 //                char* token;
; 0000 0175 //                token = strtok(header_buffer, "\"");
; 0000 0176 //                if (token != NULL) {
; 0000 0177 //                    token = strtok(NULL, "\"");
; 0000 0178 //                    if (token != NULL) {
; 0000 0179 //                        strcpy(phone_number, token);
; 0000 017A //
; 0000 017B //                        // ===== ÈÎÔ ÇÕáí: ÈÑÑÓí ãÌæÒ =====
; 0000 017C //                        if (check_authorization_post(phone_number))
; 0000 017D //                        {
; 0000 017E //                            // ˜ÇÑÈÑ ãÌÇÒ ÇÓÊ¡ ÇÏÇãå ÝÑÇíäÏ...
; 0000 017F //                            memset(content_buffer, 0, sizeof(content_buffer));
; 0000 0180 //                            gets(content_buffer, sizeof(content_buffer)); // ÎæÇäÏä ãÊä íÇã˜
; 0000 0181 //
; 0000 0182 //                            if (strlen(content_buffer) > 0)
; 0000 0183 //                            {
; 0000 0184 //                                sms_char = content_buffer[0];
; 0000 0185 //
; 0000 0186 //                                if (sms_char == '1' || sms_char == '2' || sms_char == '3')
; 0000 0187 //                                {
; 0000 0188 //                                    int timeout_counter = 0;
; 0000 0189 //                                    glcd_clear();
; 0000 018A //                                    glcd_outtextxy(0, 5, "SMS Code:");
; 0000 018B //                                    display_buffer[0] = sms_char;
; 0000 018C //                                    glcd_outtextxy(70, 5, display_buffer);
; 0000 018D //                                    glcd_outtextxy(0, 25, "Enter code on keypad:");
; 0000 018E //
; 0000 018F //                                    for(timeout_counter = 0; timeout_counter < 200; timeout_counter++)
; 0000 0190 //                                    {
; 0000 0191 //                                       key_pressed = get_key();
; 0000 0192 //                                       if(key_pressed != 0) break; // C?? ???I? ?O?I? OI? C? ???? IC?? O?
; 0000 0193 //                                       delay_ms(10);
; 0000 0194 //                                    }
; 0000 0195 //
; 0000 0196 //                                    // C?? ?? C? ? EC??? ???I? ?O?I? ?OI
; 0000 0197 //                                    if(key_pressed == 0) {
; 0000 0198 //                                        glcd_clear();
; 0000 0199 //                                        glcd_outtextxy(10, 25, "Timeout! Try again.");
; 0000 019A //                                        delay_ms(1000);
; 0000 019B //                                        glcd_clear();
; 0000 019C //                                        glcd_outtextxy(0, 0, "System Ready.");
; 0000 019D //                                        glcd_outtextxy(0, 10, "Waiting for SMS...");
; 0000 019E //                                        continue; // E??C?? ?C E? CEEIC? ???? while(1) E???IC?
; 0000 019F //                                    }
; 0000 01A0 //
; 0000 01A1 //                                    glcd_outtextxy(0, 45, "You pressed:");
; 0000 01A2 //                                    display_buffer[0] = key_pressed;
; 0000 01A3 //                                    glcd_outtextxy(90, 45, display_buffer);
; 0000 01A4 //                                    delay_ms(1000);
; 0000 01A5 //
; 0000 01A6 //                                    if (key_pressed == sms_char)
; 0000 01A7 //                                    {
; 0000 01A8 //                                        glcd_clear();
; 0000 01A9 //                                        glcd_outtextxy(10, 25, "Code is CORRECT!");
; 0000 01AA //                                        delay_ms(1500);
; 0000 01AB //                                        product_id = sms_char - '0';
; 0000 01AC //                                        activate_motor(product_id);
; 0000 01AD //                                    }
; 0000 01AE //                                    else
; 0000 01AF //                                    {
; 0000 01B0 //                                        glcd_clear();
; 0000 01B1 //                                        glcd_outtextxy(5, 25, "Error in entry!");
; 0000 01B2 //                                        delay_ms(2000);
; 0000 01B3 //                                    }
; 0000 01B4 //                                }
; 0000 01B5 //                                else {
; 0000 01B6 //                                     glcd_clear();
; 0000 01B7 //                                     glcd_outtextxy(5, 25, "Invalid SMS Code!");
; 0000 01B8 //                                     delay_ms(2000);
; 0000 01B9 //                                }
; 0000 01BA //                            }
; 0000 01BB //                        }
; 0000 01BC //                        else
; 0000 01BD //                        {
; 0000 01BE //                             // ÇÑ ÊÇÈÚ check_authorization ãÞÏÇÑ 0 ÈÑÑÏÇäÏ
; 0000 01BF //                             glcd_clear();
; 0000 01C0 //                             glcd_outtextxy(0, 25, "You are not authorized!");
; 0000 01C1 //                             delay_ms(2500);
; 0000 01C2 //                        }
; 0000 01C3 //                    }
; 0000 01C4 //                }
; 0000 01C5 //
; 0000 01C6 //                glcd_clear();
; 0000 01C7 //                glcd_outtextxy(0, 0, "System Ready.");
; 0000 01C8 //                glcd_outtextxy(0, 10, "Waiting for SMS...");
; 0000 01C9 //            }
; 0000 01CA //        }
; 0000 01CB     }
	RJMP _0x35
; 0000 01CC }
_0x38:
	RJMP _0x38
; .FEND

	.DSEG
_0x2A:
	.BYTE 0xAA
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
	CALL SUBOPT_0xD
	ANDI R30,0xDF
	CALL SUBOPT_0xD
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
	CALL SUBOPT_0xE
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
	CALL SUBOPT_0xF
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
	CALL SUBOPT_0xD
	CALL SUBOPT_0xF
	JMP  _0x2120008
; .FEND
_ks0108_rddata_G100:
; .FSTART _ks0108_rddata_G100
	__GETB2MN _ks0108_coord_G100,1
	RCALL _ks0108_busy_G100
	CALL SUBOPT_0xE
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
	CALL SUBOPT_0x10
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
	CALL SUBOPT_0x11
	ORI  R30,8
	CALL SUBOPT_0x11
	ORI  R30,4
	CALL SUBOPT_0x11
	ORI  R30,0x80
	STS  97,R30
	LDS  R30,98
	ORI  R30,0x80
	STS  98,R30
	LDS  R30,97
	ORI  R30,0x20
	CALL SUBOPT_0x11
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
	CALL SUBOPT_0xC
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
	CALL SUBOPT_0xC
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
	CALL SUBOPT_0x12
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
	CALL SUBOPT_0x12
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
	CALL SUBOPT_0x13
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
	CALL SUBOPT_0x14
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
	CALL SUBOPT_0x13
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
	CALL SUBOPT_0x14
	RJMP _0x2000051
_0x2000053:
	LDD  R30,Y+14
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R31,0
	CALL SUBOPT_0x13
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
	CALL SUBOPT_0x10
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
	CALL SUBOPT_0x15
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
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	MOV  R21,R30
	LDD  R30,Y+9
	CPI  R30,LOW(0x7)
	BREQ _0x2000079
	CPI  R30,LOW(0x8)
	BRNE _0x200007A
_0x2000079:
_0x2000072:
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x12
	RJMP _0x2000077
_0x2000080:
	CALL SUBOPT_0x18
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
	CALL SUBOPT_0x19
	MOV  R26,R30
	MOV  R30,R19
	CALL __LSRB12
	CALL SUBOPT_0x1A
	MOV  R30,R19
	MOV  R26,R20
	CALL __LSRB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x15
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
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x18
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
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x19
	MOV  R26,R30
	MOV  R30,R18
	CALL __LSLB12
	CALL SUBOPT_0x1A
	MOV  R30,R18
	MOV  R26,R20
	CALL __LSLB12
	COM  R30
	AND  R30,R1
	OR   R21,R30
	CALL SUBOPT_0x15
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
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x18
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
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x1C
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
	CALL SUBOPT_0x1C
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
	CALL SUBOPT_0x1D
	MOVW R16,R30
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x202000B
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x212000A
_0x202000B:
	CALL SUBOPT_0x1E
	STD  Y+7,R0
	CALL SUBOPT_0x1E
	STD  Y+6,R0
	CALL SUBOPT_0x1E
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
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x1D
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
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	__GETB1MN _glcd_state,2
	ST   -Y,R30
	__GETB2MN _glcd_state,3
	CALL SUBOPT_0x1F
	ADD  R30,R26
	ST   -Y,R30
	ST   -Y,R19
	__GETB1MN _glcd_state,7
	CALL SUBOPT_0x20
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
_put_usart_G103:
; .FSTART _put_usart_G103
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	CALL SUBOPT_0x21
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
	CALL SUBOPT_0x21
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2060013:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2060014
	CALL SUBOPT_0x21
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
	CALL SUBOPT_0x22
_0x206001E:
	RJMP _0x206001B
_0x206001C:
	CPI  R30,LOW(0x1)
	BRNE _0x206001F
	CPI  R18,37
	BRNE _0x2060020
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x23
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x24
	RJMP _0x2060030
_0x206002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2060032
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2060033
_0x2060032:
	CPI  R30,LOW(0x70)
	BRNE _0x2060035
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
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
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
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
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
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
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x24
	CPI  R21,0
	BREQ _0x206006B
	SUBI R21,LOW(1)
_0x206006B:
_0x206006A:
_0x2060069:
_0x2060061:
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x24
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
	CALL SUBOPT_0x27
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
	CALL SUBOPT_0x27
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x29
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

	.DSEG
_glcd_state:
	.BYTE 0x1D
_ip_address_buffer:
	.BYTE 0x10
_ks0108_coord_G100:
	.BYTE 0x3
_p_S1040026000:
	.BYTE 0x2
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x1:
	CALL _send_at_command
	MOVW R30,R28
	SUBI R30,LOW(-(66))
	SBCI R31,HIGH(-(66))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(20)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	CALL _glcd_outtextxy
	MOVW R30,R28
	SUBI R30,LOW(-(322))
	SBCI R31,HIGH(-(322))
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4:
	CALL _send_at_command
	MOVW R30,R28
	SUBI R30,LOW(-(66))
	SBCI R31,HIGH(-(66))
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5:
	CALL _send_at_command
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	CALL _glcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL _glcd_outtextxy
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CALL _send_at_command
	LDI  R26,LOW(1500)
	LDI  R27,HIGH(1500)
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x0,73
	CALL _strtok
	ST   Y,R30
	STD  Y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__PUTW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	STS  98,R30
	LDS  R30,98
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	OUT  0x1A,R30
	LDS  R30,98
	ORI  R30,8
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	ANDI R30,0XF7
	STS  98,R30
	LDI  R30,LOW(255)
	OUT  0x1A,R30
	LD   R30,Y
	OUT  0x1B,R30
	CALL _ks0108_enable_G100
	JMP  _ks0108_disable_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LSR  R30
	LSR  R30
	LSR  R30
	MOV  R26,R30
	JMP  _ks0108_gotoxp_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	STS  97,R30
	LDS  R30,97
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL _ks0108_wrdata_G100
	JMP  _ks0108_nextx_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
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
SUBOPT_0x15:
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
SUBOPT_0x16:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	JMP  _glcd_readmem

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	ST   -Y,R21
	LDD  R26,Y+10
	JMP  _glcd_mappixcolor1bit

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+16
	ST   -Y,R30
	ST   -Y,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ST   -Y,R16
	INC  R16
	LDD  R26,Y+16
	CALL _ks0108_rdbyte_G100
	AND  R30,R20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
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
SUBOPT_0x1B:
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
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	ST   -Y,R27
	ST   -Y,R26
	LD   R26,Y
	LDD  R27,Y+1
	CALL __CPW02
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	CALL __SAVELOCR6
	__GETW1MN _glcd_state,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	MOVW R30,R16
	__ADDWRN 16,17,1
	LPM  R0,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	__GETW1MN _glcd_state,4
	ADIW R30,1
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
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
SUBOPT_0x21:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x22:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x25:
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
SUBOPT_0x26:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
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

;END OF CODE MARKER
__END_OF_CODE:
