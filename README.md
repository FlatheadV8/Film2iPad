# Film2iPad

Mit diesem Skript kann man einen Film in einen "*.mp4"-Film umwandeln, der vom iPad, iPad2 und iPad mini abgespielt werden kann.
Der hiermit erzeugte Film hat eine maximale Auflösung von 1024x576 Bildpunkten (Pixel).

Es werden folgende Programme von diesem Skript verwendet:
  - mediainfo
  - avconv (libav-tools) oder ffmpeg


Das Skript kann (bei Bedarf) durch Variablen im Kopf angepasst werden.


FreeBSD
-------
mit AACPLUS-, FAAC- und X264-Unterstützung bauen (die anderen Optionen nicht abwählen!):
  cd /usr/ports/multimedia/ffmpeg
  make config
  make clean
  make
  make install
  make clean

mit DVDCSS-Unterstützung bauen:
  cd /usr/ports/multimedia/libdvdread
  make config
  make clean
  make
  make install
  make clean


Linux
-----
Auf den großen Linux-Distributionen (zum Beispiel Ubuntu oder SUSE) muss man sich die libfaac zusammen mit (einem entsprechend angepassten) ffmpeg/avconv erst über ein nicht-Standard-Repository installieren.
An sonsten kann man nur, den experimentellen und freien Encoder "aac" zu verwenden, jedoch nicht die ausgereifte, aber nicht freie, "libfaac".
