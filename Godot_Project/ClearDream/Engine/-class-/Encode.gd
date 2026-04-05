class_name Ra2md
extends Node

#### Ra2 标题语法 ####
func Title(label,startype:String="B"):
	var star:String
	match startype:
		"B":star =  " ******* "
		"C":star =  " *** "
		"A":star =  "; **************************************************************************\n; **************************** %s ************************************\n; **************************************************************************\n"%label
	var cmd = ";"+star+label.replace(";","")+star+"\n"
	if label.contains("["):cmd=label
	if startype=="A":cmd=star
	return cmd

func Split_Type(content:String):
	var cmd = "******* %s *******"%content
	return cmd

func eco(a,b,c=""):
	var con = a+"="+b
	if !c.is_empty():con+="			"+c
	return con

const HardColor="[ColorAdd]
;NameRGB			values			bit vales		color#
None=				0,0,0		;00000,000000,00000		0
StrongRed=			31,0,0		;11111,000000,00000		1
StrongGreen=		0,63,0		;00000,111111,00000		2
StrongBlue=			0,0,31		;00000,000000,11111		3
HighRed=			24,0,0		;11000,000000,00000		4
HighGreen=			0,56,0		;00000,111000,00000		5
HighBlue=			0,0,24		;00000,000000,11000		6
BrightWhite=		31,63,31	;11111,111111,11111		7
LowWhite=			7,7,7		;00111,000111,00111		8
HighWhite=			24,56,24	;11000,111000,11000		9
MidWhite=			14,28,14	;01110,011100,01110		10
Purple=				15,0,15		;01111,000000,01111		11
HighYellow=			24,56,0		;11000,111000,00000		12
TopYellow=			16,32,0		;10000,100000,00000		13
"
