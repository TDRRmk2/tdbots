#!/bin/sh
echo Compiling main ACS module...
zt-bcc BCS/TDBots.bcs ../acs/TDBots.o
echo Verifying header file...
zt-bcc headers/TDBots.h.bcs headers/TDBots.o
echo Compiling Doom support module...
zt-bcc -I headers/ BCS/IWADSupport/TDB_Doom.bcs ../acs/TDB_Doom.o
rm headers/TDBots.o
echo Preprocessing DECOM4...
m4 DECOM4.dec > ../DECORATE.tdb
cd BotC
echo Compiling BotScript...
./botc tdbot.botc ../../tdbot
cd ../..
cp tdbot crashbot.lump
cp tdbot dfultbot.lump
cp tdbot fatbot.lump
cp tdbot humanbot.lump
cp tdbot sausgbot.lump
