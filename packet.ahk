#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance force

FileRead, Loginname, id.txt
FileRead, Password, pw.txt
Loginname := Trim(Loginname)
Password := Trim(Password)
;Loginname = Your Name
;Password = Your Password
URL = https://www.packtpub.com/packt/offers/free-learning#

WB := ComObjCreate("InternetExplorer.Application")
WB.Visible := True
WB.Navigate(URL)
While wb.readyState != 4 || wb.document.readyState != "complete" || wb.busy ; wait for the page to load
   Sleep, 10
wb.document.getElementById("email").value := Loginname
wb.document.getElementById("password").value := Password
wb.document.getElementById("edit-submit-1").click()
While wb.readyState != 4 || wb.document.readyState != "complete" || wb.busy ; wait for the page to load
   Sleep, 10
;wb.document.querySelector("input[value^=Claim Your Free eBook]").click()
;wb.document.IDocumentSelector_querySelectorAll("input[value^=""Claim Your Free eBook""]").click()
wb.document.querySelector("input[value^=""Claim Your Free eBook""]").click()
;msgbox % wb.document.documentElement.innerText

;Msgbox, Now, Claimed Free eBook From packtpub.com!