#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

FileRead, Loginname, id.txt
FileRead, Password, pw.txt
Loginname := Trim(Loginname)
Password := Trim(Password)




if (!Loginname || !Password) {
	RunGUI()
}else{
	RunProcess()
}


guiClose(){
	;MsgBox, CLSOED!
	Close()
}

RunGUI(){
	global id, pw, time
	Gui, add, text, y+10 Section, ID:
	Gui, add, text, xs y+12, Password:		
	Gui, add, edit, vid ys Section ; The ym option starts a new column of controls.	
	Gui, add, edit, vpw xs Password
	Gui, add, button, default ys Section gSave, Save  ; The label ButtonOK (if it exists) will be run when the button is pressed.
	Gui, add, button, default ys gHelp, Help
	Gui, add, button, default xs Section gRun, Run  ; The label ButtonOK (if it exists) will be run when the button is pressed.
	Gui, Add, DDL, vhour w50 xm Section, 00|01|02|03|04|05|06|07|08||09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24
	Gui, add, text, ys , H		
	Gui, add, button, default ys gSetSchedule, Set Schedule
	Gui, add, button, default ys gDeleteSchedule, Delete Schedule
	Gui, add, button, default ys gClose, Close	
	Gui, show,, Get Free E-Book
}

Help(){
	msg = 
	(
https://www.packtpub.com/packt/offers/free-learning# 에 접속해서 
등록된 계정에 로그인하여 무료 책을 신청하는 버튼을 클릭하는 프로그램입니다.
최초 exe 파일을 실행한 후 ID, PW 를 입력 후 Save 버튼을 클릭하면 txt 파일이 저장됩니다.
이 후 exe 파일을 실행하면, id.txt, pw.txt 에 저장된 내용을 읽어서 GUI 화면 없이 실행됩니다. 
스케쥴 등록을 원할 경우에는, 시간을 선택한 후에 SetSchedule 버튼을 클릭합니다. 
스케쥴 제거 시에는 Delete Schedule 버튼을 클릭합니다. 

					문의: http://surpassing.tistory.com/664
	)
	;Gui, 1: +Disabled
	;Gui, 2: Default
	;Gui, +Owner1
	Gui, help: add, text, xm y+10, %msg%
	Gui, help: Show,, HELP
}

2GuiClose(){
	MsgBox, 2 called?
	Gui, 1: -Disabled
	Gui, 2: Destroy
}

helpGuiClose(){
	;MsgBox, help closed
}


Run(){
	global
	if CheckValue() == false
		return
	Loginname = id
	Password = pw
	RunProcess()
}

schName = get_packtpub_free_e_book_daily

SetSchedule(){
	global	
	Gui,Submit,nohide	
	addScript = schtasks /create /tn %schName% /tr %A_ScriptFullPath% /sc DAILY /st %hour%:00:00 /f
	Run %comspec% /c %addScript%
}

DeleteSchedule(){
	global
	deleteScript = schtasks /delete /tn %schName% /f
	Run %comspec% /c %deleteScript%
}

CheckValue(){
	global
	if (!id) {
		MsgBox, Insert ID
		return false
	} 
	if (!pw) {
		MsgBox, Insert Password
		return false
	}

	return true
}


Save(){	
	global
	Gui,Submit,nohide	
	if !CheckValue() 
		return
	
	idFile = %A_ScriptDir%\id.txt
	FileDelete %idFile%
	FileAppend, %id%, %idFile%
	
	pwFile = %A_ScriptDir%\pw.txt
	FileDelete %pwFile%
	FileAppend, %pw%, %pwFile%
}

Close(){
	ExitApp
}


RunProcess(){	
	global
	URL = https://www.packtpub.com/packt/offers/free-learning#

	WB := ComObjCreate("InternetExplorer.Application")
	WB.Visible := True
	WB.Navigate(URL)

	While wb.readyState != 4 || wb.document.readyState != "complete" || wb.busy ; wait for the page to load
	   Sleep, 10
	wb.document.querySelector("input[value^=""Claim Your Free eBook""]").click()

	While wb.readyState != 4 || wb.document.readyState != "complete" || wb.busy ; wait for the page to load
	   Sleep, 10

	wb.document.getElementById("email").value := Loginname
	wb.document.getElementById("password").value := Password
	wb.document.getElementById("edit-submit-1").click()

	While wb.readyState != 4 || wb.document.readyState != "complete" || wb.busy ; wait for the page to load
	   Sleep, 10
	wb.document.querySelector("input[value^=""Claim Your Free eBook""]").click()	

	Close()
}
