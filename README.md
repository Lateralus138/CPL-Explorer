
# CPLExplorer
View and/or run CPL files in the Windows\System32 folder for the Microsoft Control Panel (control.exe)

## Current Release
[CPL Explorer 32 Bit](https://github.com/Lateralus138/CPL-Explorer/releases/download/1.7.20.19/cpl.explorer.32bit.exe)<br />
[CPL Explorer 64 Bit](https://github.com/Lateralus138/CPL-Explorer/releases/download/1.7.20.19/cpl.explorer.64bit.exe)<br />
[Release Page - Source Files](https://github.com/Lateralus138/CPL-Explorer/releases/latest)

## Example Code - ControlPanelObj() - ShowCase
### Get an object with info for each cpl file
```
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
```
## Motivation

I wanted a better way to view and run CPL files.

## Installation

Portable program (Plans for installer and portable option).


## Test
I have tested on Windows 10 64 Bit

## Contributors

Ian Pride @ faithnomoread@yahoo.com - [Lateralus138] @ New Pride Services 

## License

	This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

	License provided in the License folder on the source page

