#!/usr/bin/env bash

#------------------------------------------------------------------------------#
#
# Mit diesem Skript kann man einen Film in einen "*.mp4"-Film umwandeln,
# der vom iPad, iPad2 und iPad mini abgespielt werden kann.
# Der hiermit erzeugte Film hat eine maximale Auflösung von 1024x576 Bildpunkten (Pixel).
#
#
# Es werden folgende Programme von diesem Skript verwendet:
#  - mediainfo
#  - avconv (libav-tools) oder ffmpeg
#
#
### iPad2
# http://walter.bislins.ch/blog/index.asp?page=Videos+konvertieren+f%FCr+iPad#H_Empfohlenes_iPad_Format
#
#------------------------------------------------------------------------------#

VERSION="v2015012701"

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
VIDEOCODEC="libx264"

if [ "FreeBSD" = "$(uname -s)" ] ; then
	AUDIOCODEC="libfaac"	# "non-free"-Lizenz; funktioniert aber
	#AUDIOCODEC="aac"	# free-Lizenz; ist noch experimentell
	#AUDIOCODEC="aac -strict experimental"
elif [ "Linux" = "$(uname -s)" ] ; then
	#AUDIOCODEC="libfaac"	# "non-free"-Lizenz; funktioniert aber
	#AUDIOCODEC="aac"	# free-Lizenz; ist noch experimentell
	AUDIOCODEC="aac -strict experimental" # das geht ohne www.medibuntu.org
fi

#------------------------------------------------------------------------------#

FILMDATEI="${1}"
MP4DATEI="${2}"

#------------------------------------------------------------------------------#

hilfe()
{
	echo "
	# Video- und Audio-Spur in ein iPad-kompatibles Format transkodieren
	${0} Film.mkv Film.mp4
	${0} Film.mkv Film.m4v

	Es duerfen in den Dateinamen keine Leerzeichen, Sonderzeichen
	oder Klammern enthalten sein!
	"

	exit 1
}

if [ -z "${MP4DATEI}" ] ; then
	hilfe
fi

#==============================================================================#

case "${2}" in
       	[a-zA-Z0-9\_\-\+][a-zA-Z0-9\_\-\+]*[.][Mm][Pp4][Vv4])
		ENDUNG="richtig"
		shift
		;;
       	*)
		ENDUNG="falsch"
		shift
		;;
esac

if [ -z "${MP4DATEI}" ] ; then
	echo "
	Die Endung der Zieldatei ist falsch!

	${0} Film.mkv Film.mp4
	${0} Film.mkv Film.m4v

	Es duerfen in den Dateinamen keine Leerzeichen, Sonderzeichen
	oder Klammern enthalten sein!
	"
	exit 1
fi

#------------------------------------------------------------------------------#

if [ -z "${FILMDATEI}" ] ; then
	hilfe
fi
if [ -z "${MP4DATEI}" ] ; then
	hilfe
fi


PROGRAMM="$(which avconv)"
if [ -z "${PROGRAMM}" ] ; then
	PROGRAMM="$(which ffmpeg)"
fi

if [ -z "${PROGRAMM}" ] ; then
	echo "Weder avconv noch ffmpeg konnten gefunden werden. Abbruch!"
	exit 1
fi


### es wird die passende Bildhöhe für eine Bildbreite von 1024 Pixel ermittelt
if [ -r $(which mediainfo) ] ; then
	BILDHOEHE="$(mediainfo ${FILMDATEI} | awk '/Display aspect ratio/{print $NF}' | awk '{gsub("[/:]"," ");printf "%.0f\n", 1024 * $2 / $1 / 2}' | awk '{print $1 * 2}')"
else
	### wenn mediainfo nicht installiert ist, dann gehen wir von einem Bildformat von 16/9 aus
	BILDHOEHE="576"
fi

if [ "${VIDEOCODEC}" != "copy" ] ; then
	VIDEOOPTION="-vf scale=1024:${BILDHOEHE}"
fi
if [ "${AUDIOCODEC}" != "copy" ] ; then
	AUDIOOPTION="-b:a 128k -ar 44100"
fi

#==============================================================================#
echo "${PROGRAMM} -i ${FILMDATEI} -c:v ${VIDEOCODEC} ${VIDEOOPTION} -c:a ${AUDIOCODEC} ${AUDIOOPTION} -y ${MP4DATEI}"

${PROGRAMM} -i ${FILMDATEI} -c:v ${VIDEOCODEC} ${VIDEOOPTION} -c:a ${AUDIOCODEC} ${AUDIOOPTION} -y ${MP4DATEI}

echo "${PROGRAMM} -i ${FILMDATEI} -c:v ${VIDEOCODEC} ${VIDEOOPTION} -c:a ${AUDIOCODEC} ${AUDIOOPTION} -y ${MP4DATEI}"
#------------------------------------------------------------------------------#

exit
