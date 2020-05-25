# Aktywny firewall 
# Spis treści
- [Opis projektu](#opis-projektu)
  + [Narzędznia i architektura](#narzędzia-i-architektura)
- [Instalacja konfiguracja i uruchomienie programu](#instalacja-konfiguracja-i-uruchomienie-programu)
  + [Instalacja](#instalacja)
  + [Konfiguracja](#konfiguracja)
  + [Uruchomienie](#uruchomienie)
- [Algorytm działania skryptu broniącego hosta](#algorytm-działania-skryptu-broniącego-hosta)
  + [Tabela priorytetów ataków](#tabela-priorytetów-ataków) 
- [Zestaw testów](#zestaw-testów)
  + [TCP Port Scanning](#tcp-port-scanning)
  + [UDP Port Scanning](#udp-port-scanning)
  + [LAND Attack](#land-attack)
  + [UDP Flood](#udp-flood)
  + [ICMP Flood](#icmp-flood)
  + [Ping of Death](#ping-of-death)
- [Scenariusz testowy](#scenariusz-testowy)
- [Dodatek A Snort](#dodatek-a-snort)
  + [Pliki konfiguracyjne dla Snort](#pliki-konfiguracyjne-dla-snort)
  + [Wyłączenie domyślnych reguł](#wyłączenie-domyślnych-reguł)
  + [Utworzenie własnych reguł](#utworzenie-własnych-reguł)
  + [Testowanie konfiguracji](#testowanie-konfiguracji)
  + [Testowanie snort na dwóch hostach](#testowanie-snort-na-dwóch-hostach)
- [Dodatek B iptables](#dodatek-b-iptables)



# Opis projektu
Celem tego projektu jest opracowanie adaptacyjnego firewalla typu host-based broniącego hosta w sieci przed typowymi atakami. Program ma analizować przychodzące pakiety i na ich podstawie wykrywać i klasyfikować atak. Po wykryciu ataku, zadaniem programu jest uruchomienie odpowiednich skryptów (odpowiadających wykrytemu atakowi), które pozwolą na obronę hosta przed wykrytym atakiem. 

## Narzędzia i architektura
Architektura projektowa składa się z 4 głównych komponentów:
+ Atakowy host - Ubuntu 16.04 LTS (VirtualBox)
+ Firewall - w projekcie tą funkcję pełni program linuksowy iptables 
+ Intrusion Detection System - dla projektu wybrano Snort
+ Skrypty bash/python - odpowiadają za obronę przed atakami poprzez adaptacyjne konfigurowanie iptables

Poniższy diagram przedstawia relacje pomiędzy opisanymi powyżej komponentami:
![01](https://user-images.githubusercontent.com/39568472/82142339-e6268d00-983b-11ea-959e-c44d22582778.PNG)

## Instalacja konfiguracja i uruchomienie programu

### Instalacja
Aby zainstalować program w środowisku Linux należy pobrać i uruchomić skrytpy z folderu 01_skrypty_instalacyjne:
```console
./python_install.sh
./snort_install.sh
```
Poprawność instalacji można sprawdzić komendą:
```console
snort -V
# Powinna zostać wyświetlona zainstalowana wersja SNORT
```
### Konfiguracja
Przed uruchomieniem należy skonfigurować SNORT - usuwamy wszystkie reguły domyśle i dodajemy własne. Aby skonfigurować snort należy pobrać pliki z folderu 02_konfiguracja snorta i uruchomić skrypt:
```console
./snort_setup.sh
```

### Uruchomienie
Abu uruchomić program należy pobrać folder 03_skrypty_uruchomieniowe i uruchomić skrypt:
```console
./firewall_start.sh
```
## Algorytm działania skryptu broniącego hosta
![10](https://user-images.githubusercontent.com/39568472/82753492-58f8b080-9dc6-11ea-842f-3e82f2a83a80.PNG)

### Tabela priorytetów ataków 
![08](https://user-images.githubusercontent.com/39568472/82753503-6d3cad80-9dc6-11ea-82d1-eab99540bedd.PNG)


## Zestaw testów
### TCP Port Scanning
+ Opis ataku

Atak polegający na sprawdzeniu dostępnych portów i działających serwisów w protokole TCP na atakowanym hoście.
+ Przeprowadzenie ataku i reguła wykrywająca SNORT

![02](https://user-images.githubusercontent.com/39568472/82147991-c732f580-9851-11ea-9f7f-90d2a02a2be8.PNG)

### UDP Port Scanning
+ Opis ataku

Atak polegający na sprawdzeniu dostępnych portów i działających serwisów w protokole UDP na atakowanym hoście.
+ Przeprowadzenie ataku i reguła wykrywająca SNORT

![03](https://user-images.githubusercontent.com/39568472/82159768-02a0e480-9891-11ea-8e7c-2065d3494301.PNG)

### LAND Attack
+ Opis ataku

Atak polegający na wysłaniu na otwarty port hosta złośliwego pakietu. Pakiet zawiera adres docelowy i adres do odpowiedzi ustawiony na ten sam adres, który jest adresem hosta-ofiary. W efekcie host odpowiada w nieskończoność sam do siebie.  
+ Przeprowadzenie ataku i reguła wykrywająca SNORT

![04](https://user-images.githubusercontent.com/39568472/82159774-0a608900-9891-11ea-8c34-11934a1f932c.PNG)

### UDP Flood
+ Opis ataku

Atak polegający na wysłaniu na otwarty port UDP ogromnej liczby pakietów. System ofiary będzie zmuszony odpowiadać wieloma pakietami ICMP, stając się w końcu nieosiągalnym dla innych klientów. 
+ Przeprowadzenie ataku i reguła wykrywająca SNORT

![05](https://user-images.githubusercontent.com/39568472/82159780-15b3b480-9891-11ea-9283-35c2eb0f2fc9.PNG)


### ICMP Flood
+ Opis ataku

Atak polegający na wysłaniu do systemu ofiary ogromnej liczby pakietów ICMP. System ofiary będzie zmuszony odpowiadać wieloma pakietami ICMP, stając się w końcu nieosiągalnym dla innych klientów
+ Przeprowadzenie ataku i reguła wykrywająca SNORT

![06](https://user-images.githubusercontent.com/39568472/82159804-4398f900-9891-11ea-9084-6254fb8ff8f6.PNG)

### Ping of Death
+ Opis ataku

Atak na system polegający na wysłaniu zapytania ping (ICMP Echo Request) w pakiecie o rozmiarze większym niż 65 535 bajtów. Może to spowodować awarię atakowanego systemu lub zawieszenie działającej na nim aplikacji.
+ Przeprowadzenie ataku i reguła wykrywająca SNORT

![07](https://user-images.githubusercontent.com/39568472/82159810-4c89ca80-9891-11ea-83f5-34432231d3dc.PNG)

# Scenariusz testowy
![09](https://user-images.githubusercontent.com/39568472/82753497-60b85500-9dc6-11ea-8521-faf0780a5468.PNG)

# Dodatek A Snort
Po instalacji SNORT możemy przejrzeć i skonfigurować pliki odpowiadające za działanie SNORT.
## Pliki konfiguracyjne dla Snort
```console
cd /etc/snort
ls
# Najwazniejsze z plikow:
# konfiguracja snort:
snort.conf  
# folder z regułami dopasowania do żądań:
rules 
```
## Wyłączenie domyślnych reguł
Najpierw należy nadać dla pliku odpowiednie prawa:
```console
sudo chmod 777 snort.conf
```
Plik snort.conf najlepiej otworzyć w edytorze gedit przez interfejs graficzny (otwórz za pomocą -> gedit).
W pliku snort.conf należy wykomentować wszystkie 'include' znajdujące się w kroku 7 jak na screenie poniżej.
Dzięki temu unikniemy analizowania nieistotnych z punktu widzenia projektu zdarzeń.

![01](https://user-images.githubusercontent.com/39568472/79751141-61b31e00-8312-11ea-89d4-e6d2f3bfa71c.PNG)

## Utworzenie własnych reguł
Własne reguły umieszczamy w pliku /etc/snort/rules/local.rules

Najpierw nadejmy mu prawa:
```console
sudo chmod 777 local.rules
```
Następnie możemy wpisać do niego testową regułę np. przy użyciu edytora gedit:
```console
alert icmp any any -> any any (msg:"ICMP connection attempt"; sid:1000004; rev:1;)

alert tcp any any -> any any (msg:"TCP connection attempt"; sid:1000001; rev:1;)
```
Powyższe reguły to reguły testowe, które powodują wypisanie alarmu przy dowolnym połączeniu TCP lub ICMP.

## Testowanie konfiguracji
Sprawdzamy poprawność konfiguracji:
```console
sudo snort -T -c /etc/snort/snort.conf
```
W wyniku powinniśmy dostać komunikat 'Snort successfully validated the configuration'. Jeśli wszystko jest ok to możemy teraz uruchomić Snort:

```console
snort -d -l /var/log/snort/ -h {YOUR_HOST_IP}/24 -A console -c /etc/snort/snort.conf
# -d  -> dumps application layer data
# -l dir -> logging directory
# -h home_net 
# -A console -> log to console
# -c file -> configuration file
```
YOUR_HOST_IP to adres ip, który możemy sprawdzić korzystając z komendy ifconfig. Jeśli wejdziemy na dowolną stronę w przeglądarce to powinniśmy przy tej konfiguracji dostać alert tcp w konsoli. 

Aby uruchomić alert icmp możemy wysłać ping na ip naszej domyślnej bramy, którą możemy sprawdzić komendą ip route.  

## Testowanie snort na dwóch hostach

Jeśli sprawdziliśmy już, że działają alerty na jednym hoście, możemy teraz przejść do próby przeprowadzenia bardziej rzeczywistego testu. Spróbujemy wysłać ping z jednego hosta na drugi i uzyskać alert na jednym z hostów. Aby to zrobić najpierw potrzebujemy mieć dwie maszyny wirtualne, np. Linux Ubuntu oraz Linux Kali (obraz Kali do pobrania: https://www.offensive-security.com/kali-linux-vm-vmware-virtualbox-image-download/#1572305786534-030ce714-cc3b)

Link do całego filmiku z instalacją Kali: https://www.youtube.com/watch?v=TGOiAsSdADs

![image](https://user-images.githubusercontent.com/39568472/79867365-896fb800-83de-11ea-9725-b315b862ed35.png)

Następnie musimy utworzyć sieć dla naszych wirtualnych maszyn, wszystko pokazane jest w tym filmiku:

https://www.youtube.com/watch?v=vReAkOq-59I

Teraz uruchamiamy obie maszyny naraz, na tej na której mamy Snorta uruchamiany go. Sprawdzamy też IP komendą ifconfig. Na drugim hoście też sprawdzamy tą komendą IP, powinny być z tej samej sieci, ale różne. Z hosta atakującego wysyłamy ping do tego na którym działa Snort. Powinien się wyświetlić Alert. 
 
# Dodatek B iptables

Sprawdzenie instalacji i wyświetlenie wszystkich reguł:
```console
sudo iptables -L -v
# Powinno wyświetlić 3 defaultowe CHAIN (INPUT, OUTPUT, FORWARD)
```

Dodawanie reguł do iptablesl (ogólna forma reguły):
```console
sudo iptables -A <chain> -i <interface> -p <protocol> -s <source> --dport <port no.>  -j <target>

<chain> - INPUT (przychodzące), OUTPUT (wychodzące) lub FORWARD (przechodzące przez localhost)
<interface> - np.  eth0, lo, ppp0
<protocol> - np. tcp, udp, udplite, icmp
<source> - adres IP źródła
<port no.> - port protokołu np. 22 (SSH), 443 (https)
<target> - co zrobić z pakietem - ACCEPT, DROP lub RETURN
```

Usunięcie wszystkich reguł z iptables:
```console
sudo iptables -F
```

Zapis to iptables z poziomu skryptu python:
```python
def addRule(allert, sourceIp, rule):
	print('Adding rule: ' + rule)
	os.system(f"/sbin/iptables {rule}")
```

Ustwienie reguły na określony czas (UWAGA: Czas UTC !)
```console
sudo iptables -A INPUT -s 10.0.2.4 -m time --timestart 10:00 --timestop 10:01 -j DROP
```
Powyższa komenda ustawia działanie reguły pomiędzy 10:00 i 10:01 czasu UTC.





