Dim fso, logFSO, winShell, MyTarget, MySource, file ,Dt ,print , logfile , log
'-------------------------------------------------------------------------------
Set logFSO = CreateObject("Scripting.FileSystemObject")
logfile = "C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\sendMail\vbsruntime.log"
Set log = logFSO.OpenTextFile (logfile, logForAppending, True)

'--------------------------------------------------------------------------------------------
Set fso = CreateObject("Scripting.FileSystemObject")
Set Folder = fso.GetFolder("C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\binaryfile\")
counter = 0
For Each File In Folder.Files
    counter = counter + 1
Next
IF counter > 0 THEN

fso.MoveFile "C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\binaryfile\*.*" , "C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\processDirectory\"
ElSE
log.writeline("[" & Now & "] - LogInfo : No Binary files available in source directory ")

END IF
Set fso = Nothing

'---------------------------------------------------------------------------------------------
Const logForAppending = 8
Const logForWriting = 2
Const logForReading = 1

Set fso = CreateObject("Scripting.FileSystemObject")
Set Folder = fso.GetFolder("C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\processDirectory\")
counter = 0
For Each File In Folder.Files
    counter = counter + 1
Next
'print "Total Files " & CStr(counter)
Set fso = Nothing
'-------------------------------------------------------------------------------

IF counter > 0 THEN

log.writeline("[" & Now & "] - LogInfo : Total "&counter&" Binary files available in directory ")
'------------------------------------------------------------------------------
Set fso = CreateObject("Scripting.FileSystemObject")
Set winShell = createObject("shell.application")
Dt =  Month(Date) & "-" & Day(Date) & "-" & Year(Date) 


MyTarget = "C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\TLOG_BINARY_"+CStr(Dt)+".zip"
MySource = "C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\processDirectory\"

Wscript.Echo "Adding " & MySource & " to " & MyTarget

'create a new clean zip archive
Set file = fso.CreateTextFile(MyTarget, True)
file.write("PK" & chr(5) & chr(6) & string(18,chr(0)))
file.close

winShell.NameSpace(MyTarget).CopyHere winShell.NameSpace(MySource).Items

do until winShell.namespace(MyTarget).items.count = winShell.namespace(MySource).items.count
    wscript.sleep 1000 
loop

Set winShell = Nothing
Set fso = Nothing
log.writeline("[" & Now & "] - LogInfo : TLOG_BINARY_"+CStr(Dt)+".zip file created")
'---------------------------------------------------------------------------------


Set fso = CreateObject("Scripting.FileSystemObject")
Set msg=CreateObject("CDO.Message")
Const ForReading=1
'Const cdoBasic=0 'Do not Authenticate
'Const cdoAuth=1 'Basic Authentication
attachment = "C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\TLOG_BINARY_"+CStr(Dt)+".zip"
BodyText = fso.OpenTextFile("C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\sendMail\mailTemplate.html",ForReading).ReadAll

msg.Subject = "TLOG_BINARY|LOCAL SYSTEM"
msg.From  = "SN_IIB_Support@gianteagle.com"
msg.To      = "buddavenkata.sainagarjuna@gianteagle.com"

msg.HtmlBody = BodyText
												
msg.AddAttachment attachment 


msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing")=2

'SMTP Server
msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver")="mail.gianteagle.com"

'SMTP Port
msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport")=25


msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 0


'Use SSL for the connection (False or True)
msg.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = False

msg.Configuration.Fields.Update
msg.Send

Set msg=nothing
log.writeline("[" & Now & "] - LogInfo : eMail sent with attachment TLOG_BINARY_"+CStr(Dt)+".zip")
'-----------------------------------------------------------------------------------------------------------------------------------------
Set fso = CreateObject("Scripting.FileSystemObject")

Const DeleteReadOnly = TRUE
Set fso = CreateObject("Scripting.FileSystemObject")
fso.DeleteFile("C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\processDirectory\*.bin"), DeleteReadOnly
Set fso = Nothing
log.writeline("[" & Now & "] - LogInfo : Binary files deleted from source folder")
'-----------------------------------------------------------------------------------------------------------------------------------------
Set fso = CreateObject("Scripting.FileSystemObject")
fso.MoveFile "C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\TLOG_BINARY_"+CStr(Dt)+".zip" , "C:\Venkat_INBNG233\IIBServices\tlogbinaryparsererrorfiles\mqsiarchive\TLOG_BINARY_"+CStr(Dt)+".zip"
Set fso = Nothing
log.writeline("[" & Now & "] - LogInfo : TLOG_BINARY_"+CStr(Dt)+".zip File moved to archive folder")

ElSE
log.writeline("[" & Now & "] - LogInfo : No Binary files available in process directory ")
END IF
log.close
Set logFSO = Nothing
