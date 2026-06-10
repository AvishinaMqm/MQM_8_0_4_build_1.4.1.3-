PATH=%PATH%;C:\Program Files\Borland\InterBase\bin

for /f %%i in ('realdate.com /d') do (set current_date=%%i)


gbak -b  -user SYSDBA -password masterkey MQM_Main.gdb MQM_MAIN_%current_date%.gbk

gbak -r -user SYSDBA -password masterkey MQM_MAIN_%current_date%.gbk MQM_Main.gdb