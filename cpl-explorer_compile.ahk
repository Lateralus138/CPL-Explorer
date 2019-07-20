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
WM_LBUTTONDOWN(args*)
{   global
    local lbPos,lbModifiers,lbWin,mods,tb,aid,thisControl
    Gui,Submit,NoHide
    tooltip
    mods := (args[1]-1)
    if (WinActive(title " Help"))
    {   MouseGetPos,,,,thisControl
        if (thisControl="Static1")
        {   PostMessage,0xA1,2,,,%title% Help
            return
        }
        if (thisControl="Static2")
        {   Gosub,HelpGuiGuiClose
        }
    }
    if (args[4]=runButton)
    {   AnimateButton(runButton,runText,"SlideDown",33)
        runCpl(isAdmin)
        return
    }
    if (args[4]=refreshButton)
    {   AnimateButton(refreshButton,refreshText,"SlideDown",33)
        refreshList()
        return
    }
    lbModifiers :=  {    "ctrl" :   (mods=8)
                    ,   "shift" :   (mods=4)
                    ,   "ctrl_shift":(mods=12)}
    lbPos := {   "x":(args[2]&0xffff)
                ,   "y":(args[2]>>16)&0xffff}
    aid :=  "ahk_id " args[4]
    WinGetTitle,winTitle,%aid%
    WinGetClass,winClass,%aid%
    lbWin :=    {   "id":args[4]
                ,   "title":winTitle
                ,   "class":winClass}
    aid := ""
    tb := (lbWin.Id = titlebar)
    if overTitleBar := (tb And (lbPos.x<398)) 
    {
        PostMessage,0xA1,2,,,% "ahk_id " mainGuiId
        return
    }
    if overMinWin := (tb And ((lbPos.x>=398) And (lbPos.x<=438)))
    {
        WinMinimize,ahk_id %mainGuiId%
        return
    }
    if overClose := (tb And ((lbPos.x>=399) And (lbPos.x<=479)))
    {   AnimateWindowEx(mainGuiId,"Hide|SlideDown",333)
        ExitApp
    }


}
;┌──────────────────────────────────────────────────────┐
;│ mouseBounds Function:                                │
;│ Test if mouse is in bounds of 2                      │
;│ pairs of diagonal x,y coordinates                    │
;│ E.g.:                                                │
;│ mouseBounds(x1,y1,x2,y2)                             │
;│ mouseBounds(0,0,64,64)                               │
;│ mouseBounds(ctrlX,ctrlY,(ctrlX+ctrlW),(ctrlY+ctrlH)) │
;│ will all return true or false                        │
;└──────────────────────────────────────────────────────┘
mouseBounds(bounds*)
{   if (bounds.MaxIndex()=4) ; must supply all 4 coords
    {   MouseGetPos,x,y
        return  (   (   (x>=bounds[1]) And (x<=bounds[3]))
                And (   (y>=bounds[2]) And (y<=bounds[4])))
    }
}
ttx()
{   return WinExist("ahk_class tooltips_class32")
}
WM_MOUSEMOVE(args*)
{
    global
    local       lbPos,aid,winTitle,winClass,lbWin,activeWinId
            ,   picAX,picAY,pixAW,picAH,thisControl
    lbPos :=    {   "x":(args[2]&0xffff)
                ,   "y":(args[2]>>16)&0xffff}
    aid :=  "ahk_id " args[4]
    activeWinId := WinExist("A")
    if (WinActive(title " Help"))
    {   MouseGetPos,,,,thisControl
        if (thisControl="Static2")
        {   if ! (s2tog)
            {   s2tog := true
                GuiControl,+C0xFF2F2F,msctls_progress322,%title% Help
                GuiControl,+Redraw,Static2,%title% Help
            }
            return
        }
        else
        {   if (s2tog)
            {   s2tog := false
                GuiControl,+C0x2B5797,msctls_progress322,%title% Help
                GuiControl,+Redraw,Static2,%title% Help
            }
            return
        }
    }
    if (WinActive("ahk_id " mainGuiId))
    {   ControlGetPos,picAX,picAY,picAW,picAH,Static5,%title%
        if mouseBounds(picAX,pixAY,(picAX+picAW),(picAY+picAH))
        {   if ! ttx()
            {   tooltip % hotkeyString
            }
        }
        else
        {   if ttx()
            {   KillToolTip()
            }
        }
    }
    WinGetTitle,winTitle,%aid%
    WinGetClass,winClass,%aid%
    lbWin :=    {   "id":args[4]
                ,   "title":winTitle
                ,   "class":winClass}
    aid := ""
    tb := (lbWin.Id = titlebar)
    if maxWinReset
    {
        maxWinReset := false
        GuiControl,+C2b5797,msctls_progress323,ahk_id %mainGuiId%
        GuiControl,+Redraw,Static3,ahk_id %mainGuiId%
    }
    if minWinReset
    {
        minWinReset := false
        GuiControl,+C0x2B5797,msctls_progress322,ahk_id %mainGuiId%
        GuiControl,+Redraw,Static2,ahk_id %mainGuiId%
    }
    if overMinWin := (tb And ((lbPos.x>=398) And (lbPos.x<=438)))
    {   
        minWinReset := true
        GuiControl,+C0x3B67A7,msctls_progress322,ahk_id %mainGuiId%
        GuiControl,+Redraw,Static2,ahk_id %mainGuiId%
        return
    }
    if overClose := (tb And ((lbPos.x>=399) And (lbPos.x<=479)))
    {   
        maxWinReset := true
        GuiControl,+C0xFF2F2F,msctls_progress323,ahk_id %mainGuiId%
        GuiControl,+Redraw,Static2,ahk_id %mainGuiId%
        return
    }
}
KillToolTip()
{   if WinExist("ahk_class tooltips_class32")
    {   tooltip
    }
}
OnMessageBulk(objOrArray :=  "",funcName := "")
{   if IsObject(objOrArray)
    {   for idx, item in objOrArray
        {   OnMessage(  (funcName?item:idx)
                    ,   (funcName?funcName:item))
        }
    }
}
ControlPanelObj()
{   A_SysDir := A_WinDir "\System32\"
    if InStr(FileExist(A_SysDir),"D")
    {   tmpObj := {}
        loop,files,%A_SysDir%*.cpl
        {   thisFile := A_LoopFileFullPath
            SplitPath,thisFile,thisFileName,thisDir,thisExt,thisNoExt,thisDrive
            tmpObj[thisNoExt]   :=  {   "full"  :   thisFile
                                    ,   "path"  :   {   "filename"  :   thisFileName
                                                    ,   "directory" :   thisDir
                                                    ,   "extension" :   thisExt
                                                    ,   "noextension":  thisNoExt
                                                    ,   "drive"     :   thisDrive}
                                    ,   "info"  :   FileInfo(thisFile)}
        }
        return tmpObj
    }
}
FileInfo(file := "",select := "")
{	data := 0
	if dataSz := DllCall("Version\GetFileVersionInfoSizeW","WStr",file,"Int",0)
	{	if DllCall("Version\GetFileVersionInfoW","WStr",file,"Int",0,"UInt",VarSetCapacity(ret,dataSz),"Str",ret)
		{	if select
			{	if DllCall("Version\VerQueryValueW","Str",ret,"WStr","\StringFileInfo\040904B0\" select,"PtrP",data,"Int",0)
					return StrGet(data,"UTF-16")
			}else
			{	retArray := {}
				for idx, type in	[	"FileDescription"	,	"FileVersion"
									,	"InternalName"		,	"LegalCopyright"
									,	"OriginalFilename"	,	"ProductName"
									,	"ProductVersion"	]
				{	DllCall("Version\VerQueryValueW","Str",ret,"WStr","\StringFileInfo\040904B0\" type,"PtrP",data,"Int",0)
					retArray[type] := StrGet(data,"UTF-16")
				}
				return retArray
			}
		}
	}
}
listFunc(display := true)
{
    global
    static obj
    if display
    {   LV_Delete()
    }
    Gui,Submit,NoHide
    currentFileObj := obj := cplObj[selectedCpl]
    if display
    {   GuiControl,-Redraw,ListView1
        LV_Insert(1,,"Name:",obj.path.noextension)
        LV_Insert(2,,"File Name:",obj.path.filename)
        LV_Insert(3,,"Path:",obj.full)
        LV_Insert(4,,"Settings for:",obj.info.ProductName)
        LV_Insert(5,,"Original filename:",obj.info.OriginalFilename)
        LV_Insert(6,,"Product version:",obj.info.ProductVersion)
        LV_Insert(7,,"File version:",obj.info.FileVersion)
        LV_Insert(8,,"Description:",obj.info.FileDescription)
        LV_Insert(9,,"Copyright:",obj.info.LegalCopyright)
        if IsObject(obj)
            LV_ModifyCol()
        else
            LV_ModifyCol(1)
        GuiControl,+Redraw,ListView1
    }
}
refreshList()
{   global
    Gui,Submit,NoHide
    GuiControl,-Redraw,ListBox1
    GuiControl,,ListBox1,% "|" getFullList()
    GuiControl,+Redraw,ListBox1
    listFunc()
}
getFullList(exitv := true)
{
    global
    cplObj := ControlPanelObj()
    if ! IsObject(cplObj)
    {   MsgBox,32,CPL Explorer Information,%noFilesErr%
        if exitv
            ExitApp
        else
            return
    }
    listboxList := ""
    for cpl in cplObj
    {
        listboxList .= cpl "|"
    }
    listboxList := SubStr(listboxList,1,StrLen(listboxList)-1)
    return listboxList
}
WM_KEYDOWN(args*)
{   global
    Gui,Submit,NoHide
    if (WinActive("ahk_id " mainGuiId))
    {   if  (   GetKeyState("Shift","P")
            And GetKeyState("Enter","P"))
        {   AnimateButton(runButton,runText,"SlideDown",33)
            runCpl(true)
            return 
        }
        if GetKeyState("Enter","P")
        {   AnimateButton(runButton,runText,"SlideDown",33)
            runCpl(isAdmin)
            return
        }
    }
}
runCpl(admin := false)
{   global
    Gui,Submit,NoHide
    local f,msg,runErr
    if FileExist(currentFileObj.full)
    {
        f := currentFileObj.full?currentFileObj.full:"File not found"
        if admin
        {   try,run *runas %f%
            catch runErr
            {   msg :=  (runErr.Extra~="The system cannot find the file specified.")
                    ?   StrReplace(cantStart,"<<REPLACE>>",f)
                    :   (runErr.Extra~=".*canceled by the user.")
                    ?   runErr.Extra
                    :   "There was an unkown error."
                MsgBox,32,CPL Explorer Information,%msg%
                return
            }
            return true
        }
        try,run,%f%
        catch runErrb
        {   msg :=  (runErrb.Extra~="The system cannot find the file specified.")
                ?   StrReplace(cantStart,"<<REPLACE>>",f)
                :   "There was an unkown error."
            MsgBox,32,CPL Explorer Information,%msg%
            return
        }
        return true
    }
}
checkAdmin()
{   global
    local text
    Gui,Submit,NoHide
    ControlGetText,text,Button1,ahk_id %mainGuiId%
    if isAdmin
    {
        if (SubStr(text,StrLen(text)-2)="Off")
            GuiControl,Text,Button1,&Admin Mode: On
        return
    }
    if (SubStr(text,StrLen(text)-1)="On")
        GuiControl,Text,Button1,&Admin Mode: Off
}
WM_SYSKEYDOWN(args*)
{   global
    Gui,Submit,NoHide
    if (WinActive("ahk_id " mainGuiId))
    {   if GetKeyState("s","P")
        {   AnimateButton(runButton,runText,"SlideDown",33)
            runCpl(isAdmin)
            return
        }
        if GetKeyState("r","P")
        {   AnimateButton(refreshButton,refreshText,"SlideDown",33)
            refreshList()
            return
        }
        if GetKeyState("h","P")
        {   helpFunc()
        }
    }
}
WM_ENTERSIZEMOVE(args*)
{   global
    WinSet,Trans,191,% "ahk_id " args[4]
}
WM_EXITSIZEMOVE(args*)
{   global
    WinSet,Trans,255,% "ahk_id " args[4]
    WinSet,Trans,Off,% "ahk_id " args[4]
    if (args[4]=helpGuiId)
    {   WinSet,Redraw,,% "ahk_id " editHwnd
        WinSet,Redraw,,% "ahk_id " buttonHwnd
    }
}
helpFunc()
{   global
    AnimateButton(helpHwnd,,"SlideDown")
    helpGui()
}
helpGui()
{   global
    local GNULIC
    WinSet,Disable,,ahk_id %mainGuiId%
    h := "HelpGui"
    Gui,%h%:New,+HwndhelpGuiHwnd -Caption +Border
    Gui,%h%:Font,s15 q2 c0x1F1F1F,Segoe UI
    Gui,%h%:Color,0xE0E0E0,0xEFEFEF
    Gui,%h%:Margin,0,0
    Gui,%h%:Add,Progress,x0 y0 w496 h40 Background0x1B4787 C0x2B5797 HwndhelpTitleBar,100 ;
    Gui,%h%:Add,Text,xp yp w496 h40 +Center +0x200 C0xEFEFEF +BackgroundTrans,%title% Help ;
    Gui,%h%:Add,Progress,x455 y0 w40 h40 Background0x1B4787 C0x2B5797 HwndmaxWinB,100 ;
    Gui,%h%:Add,Text,xp yp w40 h40 +Center +0x200 C0xEFEFEF +BackgroundTrans HwndmaxTextWinB,X
    helpHeader("About: " title,,"x8 y+8")
    Gui,%h%:Font,s10 w500 c0x1B4787
    Gui,%h%:Add,Text,Section x8 y+0 w480 HwndhTextId,%helpText%
    helpHeader("What is a cpl file?",,"x8 y+8 HwndtestHwnd")
    Gui,%h%:Font,s10 w500 c0x1B4787
    Gui,%h%:Add,Text,xs y+0 w480,%cplFilesNfo%
    helpHeader("Hotkeys",,"y+8 +Center w480")
    Gui,Font,w500 s10 c0x1B4787
    Gui,%h%:Add,ListView,xs y+8 w480 R6,Name|Description
    for keyName, keyDesc in hKeys
    {   LV_Add(,keyName,keyDesc)
    }
    LV_ModifyCol()
    Gui,%h%:Font,s10,Segoe UI
    if (GNULIC := getLic()) ; add ! to test no lic file
    {   Gui,%h%:Add,Button,xs y+8 gShowLicense HwndbuttonHwnd,Show &License
        helpHeader( "Gnu Public License V3",,"Hidden xs yp +Center +0x200 w480 c0xFF2F2F HwndtextHwnd ","s12")
        Gui,%h%:Add,Text,Hidden xs y+0 w480 h8 vbottomMargin HwndhideMarg
        Gui,%h%:Font,S8 c0x1F1F1F w500,Consolas
        Gui,%h%:Color,0xE0E0E0
        Gui,%h%:Add,Edit,xs y+8 Hidden w480 r20 +0x800 +0x4 +0x80 v%h%EditVar HwndeditHwnd,%GNULIC%
    }
    else
    {   Gui,%h%:Font,s12 w600
        Gui,%h%:Add,Link,xs y+8 w480 C0xFF2F2F,  %    "This software is licensed under the GNU Public License V3: "
                                                .   "`n<a href=`""https://www.gnu.org/licenses/gpl-3.0.txt`"">"
                                                .   "https://www.gnu.org/licenses/gpl-3.0.txt</a>"
    }
    ; GNULIC := ""  ; uncomment to test no lic file 
    if (! GNULIC)
    {   Gui,%h%:Add,Text,x0 y+0 w496 h8 vbottomMargin
    }
    else
    {   GuiControl,%h%:Show,bottomMargin
        GuiControlGet,Button1,%h%:Pos
        GuiControl,%h%:Move,bottomMargin,% "y" (Button1Y+Button1H)
    }
    Gui,%h%:Show,Hide AutoSize,%title% Help
    DetectHiddenWindows,On
    helpWinId := WinExist(title " Help")
    AnimateWindowEx(helpWinId,"SlideDown")
    Gui,%h%:+LastFound
    helpGuiId := WinExist()
    Gui,%h%:Show,AutoSize,%title% Help
    Gui,%h%:Submit,NoHide
    WinActivate,%title% Help
}
helpHeader(string,fntFace := "Segoe UI",txtOpts := "",fntOpts := "",opts*)
{   global
    local idx,item
    if (opts.MaxIndex())
        for idx, item in opts
            options .= item A_Space
    Gui,%h%:Font,q2 s12 w600 c0xFF2F2F %fntOpts% %options%,%fntFace%
    Gui,%h%:Add,Text,xp y+0 %txtOpts%,%string%
}
getLic(del := false)
{   gpl := A_WorkingDir "\gplv3.lic"
    if ! FileExist(gpl)
        UrlDownloadToFile,https://www.gnu.org/licenses/gpl-3.0.txt,%gpl%
    if ErrorLevel
        return
    loop,read,%gpl%
        text .= A_LoopReadLine "`n"
    if del
        FileDelete,%gpl%
    return text
}
arrayFromStr(string,delim := "`n")
{   array := []
    loop,parse,string,%delim%
        array.Push(A_LoopField)
    return array
}
getEditLines()
{   global
    return arrayFromStr(%h%EditVar)
}
AnimateWindowEx(hwnd,opts,time:=200)
{	DetectHiddenWindows,On
	if WinExist("ahk_id " hwnd)
	{	DetectHiddenWindows,Off
		options := 0
		optList :=	{	"Activate" 	: 0x00020000,	"Blend" 	: 0x00080000
					,	"Center"   	: 0x00000010,	"Hide" 		: 0x00010000
					,	"RollRight"	: 0x00000001,	"RollLeft"  : 0x00000002
					,	"RollDown" 	: 0x00000004,	"RollUp"   	: 0x00000008
					,	"SlideRight": 0x00040001,	"SlideLeft"	: 0x00040002
					,	"SlideDown"	: 0x00040004,	"SlideUp"	: 0x00040008	}
		loop,parse,opts,|
			options |= optList[A_LoopField]
		return DllCall("AnimateWindow","UInt",hwnd,"Int",time,"UInt",options)
	}
	DetectHiddenWindows,Off
}
AnimateButton(id,hideId := "",mode := "Center",speed := 50)
{   if (id := WinExist("ahk_id " id))
    {   AnimateWindowEx(id,"Hide|" mode,speed)
        if (hideId := WinExist("ahk_id " hideId))
        {   WinHide,ahk_id %hideId% 
        }
        AnimateWindowEx(id,mode,speed)
        if (hideId := WinExist("ahk_id " hideId))
        {   WinShow,ahk_id %hideId% 
        }
    }
}
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