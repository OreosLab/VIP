;~ #NoTrayIcon
#Region ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#AccAu3Wrapper_Icon=C:\Windows\xsbao.ico
#AccAu3Wrapper_Outfile_x64=Unlock163music一键部署_x64.exe
#AccAu3Wrapper_Res_Fileversion=1.0
#AccAu3Wrapper_Res_Fileversion_AutoIncrement=p
#AccAu3Wrapper_Res_Language=2052
#AccAu3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AccAu3Wrapper_Run_AU3Check=n
#EndRegion ;**** 由 AccAu3Wrapper_GUI 创建指令 ****
#include <MsgBoxConstants.au3>
#include <InetConstants.au3>
#include <WinAPIFiles.au3>
#include <Array.au3> ; Only required to display the arrays
#include <File.au3>


$dlport='2333'
$show=@SW_HIDE
$node_exe=@ScriptDir&"\UnblockNeteaseMusic-master\node.exe"
$app_js=@ScriptDir&"\UnblockNeteaseMusic-master\app.js"
$app_js_folder=@ScriptDir&"\UnblockNeteaseMusic-master\src"
$music_exe=RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\cloudmusic.exe","")
FileInstall("7z.exe",@ScriptDir&"\7z.exe",1)
FileInstall("7z.dll",@ScriptDir&"\7z.dll",1)

FileCreateShortcut(@ScriptFullPath,@DesktopDir&"\网易云音乐(解锁版).lnk",@ScriptDir,"","解锁灰色歌曲",$music_exe,"",0)

If Not FileExists($app_js) Or Not FileExists($app_js_folder) Then
	TraySetToolTip("正在下载nondanee的脚本包")
Local $sFilePath =@ScriptDir&"\nondanee.zip"
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("https://github.com/nondanee/UnblockNeteaseMusic/archive/master.zip", $sFilePath, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

    ; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
    Do
        Sleep(250)
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)

    ; Display details about the total number of bytes read and the filesize.
    MsgBox($MB_SYSTEMMODAL, "UnblockNeteaseMusic 已经下载", "UnblockNeteaseMusic 已经下载。"&@crlf&"下载文件: " & $iBytesSize & @CRLF & _
            "远程文件: " & $iFileSize,2)

    ; Delete the file.
	TraySetToolTip("正在解压nondanee的脚本包")
	$sFilePath=FileGetShortName($sFilePath)
;~ 	MsgBox(0,"","7z.exe  x "&$sFilePath&" -y -o"&'"'&@WorkingDir&'\"')
	RunWait("7z.exe  x "&$sFilePath&" -y -o"&'"'&@WorkingDir&'\"','',$show)
	FileDelete($sFilePath)
EndIf

If Not FileExists($node_exe) Then
Local $sFilePath2 =@ScriptDir&"\node.zip"
TraySetToolTip("正在下载 node")
    ; Download the file in the background with the selected option of 'force a reload from the remote site.'
    Local $hDownload = InetGet("https://npm.taobao.org/mirrors/node/v14.15.5/node-v14.15.5-win-x64.zip", $sFilePath2, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)

    ; Wait for the download to complete by monitoring when the 2nd index value of InetGetInfo returns True.
    Do
        Sleep(250)
    Until InetGetInfo($hDownload, $INET_DOWNLOADCOMPLETE)

    ; Retrieve the number of total bytes received and the filesize.
    Local $iBytesSize = InetGetInfo($hDownload, $INET_DOWNLOADREAD)
    Local $iFileSize = FileGetSize($sFilePath2)

    ; Close the handle returned by InetGet.
    InetClose($hDownload)

    ; Display details about the total number of bytes read and the filesize.
    MsgBox($MB_SYSTEMMODAL, "Node 已经下载  ", "Node 已经下载。"&@crlf&"下载文件: " & $iBytesSize & @CRLF & _
            "远程文件: " & $iFileSize,2)
				TraySetToolTip("正在提取 node.exe")
$sFilePath2=FileGetShortName($sFilePath2)
;~ MsgBox(0,"",@ScriptDir&"\7z.exe  e "&$sFilePath2&" node.ex?  -r0 -y -o"&@WorkingDir&"\UnblockNeteaseMusic-master\")
	RunWait("7z.exe  e "&$sFilePath2&" node.ex?  -r0 -y -o"&'"'&@WorkingDir&'\UnblockNeteaseMusic-master\"','',$show)
	FileDelete($sFilePath2)
EndIf
;Local $sFilePath ="temp.zip"
;Local $sFilePath2 ="node.zip"
;MsgBox(0,"",@ScriptDir&"\7z.exe  x "&$sFilePath&" -y -o"&@WorkingDir&"\Music\")
;MsgBox(0,"",@ScriptDir&"\7z.exe  e "&$sFilePath2&" node.ex?  -r0 -o"&@WorkingDir&"\Music\")





;~ 
;~ 
;~ ;FileDelete("7z.exe")
;~ ;FileDelete("7z.dll")






;~ $filelist=_FileListToArrayRec ( @ScriptDir ,  "node.exe" ,1 ,1, 2, 2 )
;~ _ArrayDisplay($filelist)
If FileExists($app_js) And FileExists($node_exe) Then

FileDelete(@ScriptDir&"\7z.exe")
FileDelete(@scriptdir&"\7z.dll")

TCPStartup()
$sIP = TCPNameToIP("music.163.com")
TCPShutdown()

;~ MsgBox(0,$sIP,$sIP)
;~ MsgBox(0,"",$node_exe &' '& "app.js" &" -p 2333 -f "&$sIP&@CRLF&@WorkingDir&"\UnblockNeteaseMusic-master\")
$pid=Run($node_exe &' '& "app.js" &" -p "&$dlport&" -f "&$sIP,@WorkingDir&"\UnblockNeteaseMusic-master\",$show)
config()
$pid2=Run($music_exe)
Opt("TrayAutoPause",0)
Opt("TrayMenuMode",1)
TraySetState(4)
TraySetToolTip("网易云音乐解锁服务运行中...(退出网易云音乐,服务自动停止。)")
;~ TrayTip("服务运行中...","退出“网易云音乐”,服务自动停止。",2,1)
Do
	
	Sleep(100)
Until Not ProcessExists($pid2)
ProcessClose($pid)
ProcessClose("node.exe")
EndIf

Func config()
  Local $proxy[11],$temparray,$proxyc[9]
	$proxy[0]= '{'
	$proxy[1]='     "Proxy": {'
	$proxy[2]='      "Type": "http",'
	$proxy[3]='   		 "http": {'
	$proxy[4]='		     "Host": "127.0.0.1",'
	$proxy[5]='			 "Password": "",'
	$proxy[6]='     	 "Port": "'&$dlport&'",'
	$proxy[7]='      	 "UserName": ""'
	$proxy[8]='    				}'
	$proxy[9]='  			}'
	$proxy[10]='}'
  

	$proxyc[0]='     "Proxy": {'
	$proxyc[1]='      "Type": "http",'
	$proxyc[2]='    "http": {'
	$proxyc[3]='       "Host": "127.0.0.1",'
	$proxyc[4]='      "Password": "",'
	$proxyc[5]='     "Port": "'&$dlport&'",'
	$proxyc[6]='      "UserName": ""'
	$proxyc[7]='    }'
	$proxyc[8]='  },'

  
  

;~   _ArrayDisplay($proxy)
Local  $file=@LocalAppDataDir&"\Netease\CloudMusic\config"

  If Not FileExists($file) Then
	  $sfile=FileOpen($file,256+1)
	  _FileWriteFromArray($sfile,$proxy,0)
	  FileClose($sfile)
  Else
	  _FileReadToArray($file,$temparray,0)
;~ 	  _ArrayDisplay($temparray)
	  _ArraySearch ($temparray,StringStripWS($proxy[2],8))
	  If @error Then
	  _ArrayInsert($temparray, "1;1;1;1;1;1;1;1;1",$proxyc)
	  EndIf
;~ 	  _ArrayDisplay($temparray)
	  $sfile=FileOpen($file,256+2)
	  _FileWriteFromArray($sfile,$temparray,0)
	  FileClose($sfile)
  EndIf
  
EndFunc
