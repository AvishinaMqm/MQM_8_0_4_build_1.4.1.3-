PATH=%PATH%;C:\Program Files\Borland\InterBase\bin

gbak -b  -user SYSDBA -password masterkey MQM_Main.gdb MQM_MAIN%DATE%.gbk

gbak -r -user SYSDBA -password masterkey MQM_MAIN.gbk MQM_Main.gdb