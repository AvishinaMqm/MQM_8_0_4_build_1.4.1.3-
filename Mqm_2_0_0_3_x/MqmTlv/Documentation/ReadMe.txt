Following is a short installation guide for MQM .If anything is unclear please contact me.


Part I : Downloading

1. connect to our FTP server at 212.179.77.241
   user :mqm
   password : mqmrelease

2. go to folder MQM full CD
    there download the zip file named : 1.*.*.*  MQM.zip (it's about 50 MB).


Part II : Prerequisites

1. For Demo purposes you need the files downloaded above plus demo DB files 
    ( which are available upon request).

2. For live data you will need also the MQM files on the As400 and Client
   Access version 5 in order to download and upload data to/from  the As400.

3. The recommended OS is Windows XP  , although it may run also on Win 98 it
    is not recommended.


Part III : Installing

1.  Unzip  the zip file containing the MQM CD you have downloaded.
     Inside the unzipped folder you will find a file named CD-start.exe - 
     run it and you will get a menu

2. Installing the Interbase database:
    In the menu choose Install Interbase Database .
    When installing please leave all the defaults of the installation as is.
    
Please verify that Interbase is running :
    Go to Control Panel -> Interbase Manager
    Verify that :
     a. The startup mode is Automatic
     b. The status of the Interbase server should be running (green)
     c. It is recommended that the check box will be checked - run as Service 
    

3. Installing MQM:
    return to the main/first screen , now choose Install MQM .

4. You should have now an icons of MQM on your desktop and also in your
   programs menu you should have Datatex -> MQM -> 3 programs

5. License :
   When trying to work with MQM you shall get some strange errors - till you
   get a license.
   Once the license is installed these errors should go away.
   
   How to get a license :
   Run MQM Config ( some errors and messages about demo mode etc ).
   
   a. In menu 'Create' select 'Database' , click on  'Create Cfg database'
       When it has been created a small message will appear - close the Database window 
   b.  In the menu 'Licensing' choose 'create lock'.
        Save the file and then send it to us so that we can issue you a license.
   
  Once we send you your license you will have run the MQM Config again
   In the menu 'Licensing' choose 'View Lisence'.
   click on 'Load' ( point to the file you have received ) click 'Install'.
   That's it now you are done .

6. Please verify that the MqmUDF.dll is located in C:\Program files \Borland\Interbase\UDF  

7. Create the ODBC connection:  -  (This is ONLY in order to work with the AS400 - NOT the Demo alone)
    goto the control panel -> Administrative tools -> Data sources ( ODBC ) -> System DSN tab
    a. click 'Add ', choose 'Client Access Driver ', click 'finish'
    b. General Tab :  Data source name : MQM_AS400_DB
        Server Tab :    Naming Convention : System naming convention (*SYS)
        Library List :   The Library list where you have MQM on the AS400 - 
                              (eg : Tesmqm, Tesmqmd and your data library) 
                               Please note that the library where you have the stored procedures of MQM should be 
                               on this list.                         
       

Part IV running in Demo mode - (only If you have the Demo DB )

1. There are 3 programs that are part of MQM.
    Since you are not going to download data from AS400  you don't need 2 of
    them (MQM_config and MQM_srvLoad).
    You only need to run MQM.exe .
    You will have 3 optional workstations to work with , the password
    therefore will be one of the following : ws1, ws2, ws3 .

2. You will get a blank background , click on the third icon from the left
   'edit tabs' press ok and you will get the Gantt
   Do the same on the lower part of the screen - Bin - that is a right
   click on it .


Part V: Running in live mode

If you want to work with your own data then you will need to run
MQM_config and MQM_srvload.

1. MQM_config :
    a.  In menu 'Create' select 'Database' , click on  'Create Main database'
         When it has been created a small message will appear - close the Database window.
         Now click on 'Create Cfg database' - when completed a message shall appear.
    b.  In menu 'Create' select 'stored procedures'

2. MQM_srvload:
    a.  In menu 'Configure' select 'Stored Procedure' Tab , fill in the name of the library you wish to create
         the stores procedure on the AS400  - The default is TesMQM .
         click on  'Create '.
         Please be sure  to include this library in the ODBC connection library list.
    b.  Load the calendar/s.-go to menu Calendars -> load 
    c.  Make download. - go to  menu 'service' -> 'download'


Important Notice :

Interbase database is a shareware product.
Therefore there is a need to buy it separately . The version distributed with MQM will expire after 90 days.
This version will support a maximum of 2 concurent useres connected to the server.
 

If you have any problems please contact.

Regards
 Yitzhak Zinner
 Datatex  Textile Information Systems
       Phone : 03- 9234101 ext  214
        E-Mail   :zinner@datatx.com
        URL     :Http://www.datatx-tim.com
