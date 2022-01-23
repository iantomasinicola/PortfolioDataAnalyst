import pyodbc #per connettermi a sql server
import win32com.client #per lavorare con excel
import time #per fare uno sleep di 5 secondi
import datetime #per creare il timestamp con data e ora attuali

path = "C:\\Users\\ianto\\Desktop\\Corsi\\CorsoDataScientist\\ProgettoDataManagement\\Python-SqlServer-Excel\\"


#Creo la connessione al database Sql Server
connessione = pyodbc.connect('Driver={SQL Server};'
                      'Server=LAPTOP-UDP6N0UL\SQLEXPRESS;'
                      'Database=CorsoSQL;'
                      'Trusted_Connection=yes;')

cursor = connessione.cursor()

#eseguo stored procedure
cursor.execute('exec [dbo].[CaricaEsperimenti]')
cursor.commit()

cursor.close()


#aggiorno excel     
File = win32com.client.DispatchEx("Excel.Application")

File.Visible = 1

Workbook  = File.Workbooks.Open(path + "Report.xlsx")

Workbook.RefreshAll()

time.sleep(5)

#salvo pdf
timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')

File.Worksheets("ReportEsperimenti").ExportAsFixedFormat(0,
           path + "Report" + timestamp + ".pdf")    


#chiudo excel
Workbook.Save()

Workbook.Close() 

File.Quit()
