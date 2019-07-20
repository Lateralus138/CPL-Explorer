;┌────────────────────────────────────────┐
;│ CPL Explorer - Control Panel Explorer  │
;│ © 2019 Ian Pride - New Pride Software  │
;│ ::Gnu GPL V3::                         │
;│ View and run .cpl files located in the │
;│ Windows system directory.              │
;└────────────────────────────────────────┘
;┌─────────────┐
;│ #Directives │
;└─────────────┘
#SingleInstance,force ;
SetWorkingDir,%A_ScriptDir% ;
SetBatchLines,-1 ;
SetWinDelay, 0 ;
;┌──────────┐
;│ Pre Init │
;└──────────┘
noFilesErr =
(join
No .cpl files
 found in your
 system directory
 or the directory
 was not found.
 Cpl Explorer will
 now exit.
)
getFullList()
;┌───────┐
;│ #Vars │
;└───────┘
title := "CPL Explorer" ;
helpText=
(join%A_Space%
%title% allows you to view
detailed information about
and/or run .cpl files found
in %A_WinDir%\System32.
)
cplFilesNfo=
(join%A_Space%
CPL (.cpl) files are direct links to
Control Panel settings sections that
allow you to go straight to that
setting without starting it from the
Control Panel main screen. 
)
cantStart =
(
Cannot start cpl file:
<<REPLACE>>
has it been moved or deleted
since last refresh?
)
hotkeys :=  {   "alt"   :   {   "a"     :   {   "name"  :   "Alt+a"
                                            ,   "desc"  :   "Administrator Mode"}
                            ,   "h"     :   {   "name"  :   "Alt+h"
                                            ,   "desc"  :   "Help Window"}
                            ,   "r"     :   {   "name"  :   "Alt+r"
                                            ,   "desc"  :   "Refresh List"}
                            ,   "s"     :   {   "name"  :   "Alt+s"
                                            ,   "desc"  :   "Start selected file"}}
            ,   "shift" :   {   "enter" :   {   "name"  :   "Shift+Enter"
                                            ,   "desc"  :   "Start selected file as admin"}}
            ,   "enter" :   {   "name"  :   "Enter"
                            ,   "desc"  :   "Start selected file"}}
hKeys   :=  {   hotkeys.alt.a.name          :   hotkeys.alt.a.desc
            ,   hotkeys.alt.h.name          :   hotkeys.alt.h.desc
            ,   hotkeys.alt.r.name          :   hotkeys.alt.r.desc
            ,   hotkeys.alt.s.name          :   hotkeys.alt.s.desc
            ,   hotkeys.shift.enter.name    :   hotkeys.shift.enter.desc
            ,   hotkeys.enter.name          :   hotkeys.enter.desc  }                        
hkaa    := hotkeys.alt.a,hkaan   := hkaa.name,hkaad   := hkaa.desc
hkah    := hotkeys.alt.h,hkahn   := hkah.name,hkahd   := hkah.desc
hkar    := hotkeys.alt.r,hkarn   := hkar.name,hkard   := hkar.desc
hkas    := hotkeys.alt.s,hkasn   := hkas.name,hkasd   := hkas.desc
hkse    := hotkeys.shift.enter, hksen   := hkse.name,hksed   := hkse.desc
hke     := hotkeys.enter,hken   := hke.name,hked   := hke.desc
hotkeyString=
(
Hotkey List
[Name]%A_Tab%%A_Tab%[Description]
%hkaan%%A_Tab%%A_Tab%%hkaad%
%hkahn%%A_Tab%%A_Tab%%hkahd%
%hkarn%%A_Tab%%A_Tab%%hkard%
%hkasn%%A_Tab%%A_Tab%%hkasd%
%hksen%%A_Tab%%hksed%
%hken%%A_Tab%%A_Tab%%hked%
)
hkaa := hkaan := hkaad := hkah := hkahn := hkahd := ""
hkar := hkarn := hkard := hkas := hkasn := hkasd := ""
hkse := hksen := hksed := hke := hken := hked := ""
loadMsgFuncsA := Func("OnMessageBulk").Bind(    {   0x201:"WM_LBUTTONDOWN"
                                                ,   0x200:"WM_MOUSEMOVE"
                                                ,   0x100:"WM_KEYDOWN"
                                                ,   0x101:"WM_KEYUP"
                                                ,   0x231:"WM_ENTERSIZEMOVE"
                                                ,   0x232:"WM_EXITSIZEMOVE"
                                                ,   0x104:"WM_SYSKEYDOWN"})
                                                ; WM_ENTERSIZEMOVE = 0x231
unloadMsgFuncsA := Func("OnMessageBulk").Bind( {0x201:"",0x200:""})
loadMsgFuncsB := Func("OnMessageBulk").Bind([0x102,0x121],"KillToolTip")
unloadMsgFuncsB := Func("OnMessageBulk").Bind([0x100,0x101,0x102,0x121],"")
%loadMsgFuncsA%()
%loadMsgFuncsB%()
;┌───────────┐
;│ Tray Menu │
;└───────────┘
Menu,Tray,NoStandard
Menu,Tray,Icon,control.exe,1
Menu,Tray,Add,%title% &Help,helpGui
Menu,Tray,Icon,%title% &Help,shell32.dll,24
Menu,Tray,Add
Menu,Tray,Add,E&xit %title%,GuiClose
Menu,Tray,Icon,E&xit %title%,shell32.dll,220
;┌────────────┐
;│ #Interface │
;└────────────┘
Gui,New ;
Gui,+LastFound -Caption +Border ;
Gui,Color,0xE0E0E0,0xEFEFEF
Gui,Margin,0,0 ;
Gui,Font,s15 q2,Segoe UI
Gui,Add,Progress,x0 y0 w480 h40 Background0x1B4787 C0x2B5797 HwndtitleBar,100 ;
Gui,Add,Text,xp yp w480 h40 +Center +0x200 C0xEFEFEF +BackgroundTrans,%title% ;
Gui,Add,Progress,x398 y0 w40 h40 Background0x1B4787 C0x2B5797 HwndminWin,100 ;
Gui,Add,Text,xp yp w40 h40 +Center +0x200 C0xEFEFEF +BackgroundTrans,_
Gui,Add,Progress,x439 y0 w40 h40 Background0x1B4787 C0x2B5797 HwndmaxWin,100 ;
Gui,Add,Text,xp yp w40 h40 +Center +0x200 C0xEFEFEF +BackgroundTrans,X
Gui,Font,s14
Gui,Add,Text,x8 y+8 C0x2B5797 w464 +Center C0xFF2F2F HwndcpeHwnd,.CPL (Control Panel) Explorer
Gui,Add,Picture,x8 yp w25 h25 Icon6 HwndhelpHoverHwnd,main.cpl
Gui,Add,Picture,x439 yp w25 h25 Icon24 ghelpFunc HwndhelpHwnd,shell32.dll
Gui,Font,s12,Consolas
Gui,Add,ListBox,Section x8 y+8 w464 r10 vselectedCpl glistFunc,%listboxList%
Gui,Font,s10
Gui,Add,ListView,xs y+8 w464 r10 vinfoBox +ReadOnly,Category|Value
Gui,Font,s12,Segoe UI
Gui,Add,Progress,xs y+8 w112 h32 Background0x1B4787 C0x2B5797 HwndrefreshButton +Border,100
Gui,Add,Text,xp yp w112 h32 +Center +0x200 C0xEFEFEF +BackgroundTrans HwndrefreshText,&Refresh
Gui,Add,Progress,x+8 yp w168 h32 Background0x1B4787 C0x2B5797 HwndrunButton +Border,100
Gui,Add,Text,xp yp w168 h32 +Center +0x200 C0xEFEFEF +BackgroundTrans HwndrunText,&Start Cpl
Gui,Font,,Consolas
Gui,Add,Checkbox,x+8 yp w168 h32 +0xC00 +0x300 +0x1000 visAdmin gcheckAdmin ,&Admin Mode: Off
Gui,Add,Text,x0 y+0 w480 h8
Gui,Show,Hide AutoSize,%title% ;
DetectHiddenWindows,On
mainGuiId := WinExist() ;
AnimateWindowEx(mainGuiId,"SlideDown")
Gui,Show,AutoSize,%title%
DetectHiddenWindows,Off
Gui,Default
Gui,Submit,NoHide
listFunc()
SetTimer,CleanToolTips,-3000
return ;
;┌────────────┐
;│ #Functions │
;└────────────┘
#Include,C:\Users\FluxApex\Documents\AutoHotkey\Projects\CPL Explorer\cpl-explorer_funcs.ahk ;
;┌──────┐
;│ Subs │
;└──────┘
HelpGuiGuiEscape:
HelpGuiGuiClose:
    editTog := ""
    AnimateWindowEx(WinExist(title " Help"),"Hide|SlideDown")
    Gui,HelpGui:Destroy
    WinSet,Enable,,ahk_id %mainGuiId%
    WinActivate,ahk_id %mainGuiId%
return
ShowLicense:
    WinSet,Redraw,,ahk_id %buttonHwnd%
    if (editTog:=!editTog)
    {   GuiControl,Text,%buttonHwnd%,Hide &License
        WinShow,ahk_id %editHwnd%
        WinShow,ahk_id %textHwnd%
        WinShow,ahk_id %hideMarg%
        GuiControlGet,Edit1,%h%:Pos
        GuiControl,%h%:Move,bottomMargin,% "y" (Edit1Y+Edit1H)
        GuiControl,Hide,%buttonHwnd%
        AnimateWindowEx(buttonHwnd,"SlideDown",50)
        GuiControl,Hide,%textHwnd%
        AnimateWindowEx(textHwnd,"SlideDown",50)          
        WinSet,Redraw,,ahk_id %buttonHwnd%
        SendInput,{Ctrl Down}{Home}{Ctrl Up}
        WinSet,Redraw,,ahk_id %editHwnd%
    }
    else
    {   GuiControl,Text,%buttonHwnd%,Show &License
        WinHide,ahk_id %editHwnd%
        WinHide,ahk_id %textHwnd%
        GuiControlGet,Button1,%h%:Pos
        GuiControl,%h%:Move,bottomMargin,% "y" (Button1Y+Button1H)
        GuiControl,Hide,%buttonHwnd%
        AnimateWindowEx(buttonHwnd,"SlideDown",100)
        WinSet,Redraw,,ahk_id %buttonHwnd%
    }
    WinSet,Redraw,,ahk_id %buttonHwnd% ; Not redundant
    Gui,%h%:Show,AutoSize,%title% Help
return
CleanToolTips:
    IfWinNotActive,%title%
        KillToolTip()
    SetTimer, ,,-3000
return
GuiClose:
GuiEscape:
    ExitApp