#!/bin/bash

TOKEN="817564505:AAFKGE0jEfdJXcOZCb0Eq62g0zp9Rdewprk"
## el TOKEN se obtiene creando un nuevo bot mediante el bot de telegram 
## @BotFather y el comando /newbot
ID="1557097"
## el ID se obtiene mediante el bot de telegram
## @userinfobot y el comando /start
MENSAJE="Esto es un Mensaje de Prueba"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

curl -s -X POST $URL -d chat_id=$ID -d text="$MENSAJE"

