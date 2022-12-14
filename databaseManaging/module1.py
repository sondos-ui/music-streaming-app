import mysql.connector

dp=mysql.connector.connect(
    host="localhost",user="root",passwd="moaz2008",database="musicplayer");
 
mycursor=dp.cursor()




