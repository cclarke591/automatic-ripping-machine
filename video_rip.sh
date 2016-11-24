#!/bin/bash
#
# Rip video using MakeMKV then eject and call transcode script

source /opt/arm/config

VIDEO_TITLE=$1
HAS_NICE_TITLE=$2

{

	echo "Video Title is ${VIDEO_TITLE}"
    echo "Ripping video ${ID_FS_LABEL} from ${DEVNAME}" >> $LOG
	TIMESTAMP=`date '+%Y%m%d_%H%M%S'`;
    DEST=${RAWPATH}/${VIDEO_TITLE}_${TIMESTAMP}
	RIPSTART=$(date +%s);

	echo /opt/arm/video_transcode.sh \"$DEST\" \"$VIDEO_TITLE\" $TIMESTAMP >> $LOG
	if [ $RIPMETHOD = "backup" ] && [ $ID_CDROM_MEDIA_BD = "1" ]; then
		echo "Using backup method of ripping." >> $LOG
		DISC="${DEVNAME: -1}"
		echo "Sending command: "makemkvcon backup --decrypt -r disc:$DISC $DEST/""
		makemkvcon backup --decrypt -r disc:$DISC $DEST/
		eject $DEVNAME
	elif [ $MAINFEATURE = true ] && [ $ID_CDROM_MEDIA_DVD = "1" ] && [ -z $ID_CDROM_MEDIA_BD ]; then
		echo "Media is DVD and Main Feature parameter in config file is true.  Bypassing MakeMKV." >> $LOG

	echo "DEST is ${DEST}"
	else
		echo "Using mkv method of ripping." >> $LOG
		makemkvcon mkv dev:$DEVNAME all $DEST --minlength=$MINLENGTH -r
		eject $DEVNAME
	fi

    mkdir "$DEST"

	if [ $RIPMETHOD = "backup" ] && [ $ID_CDROM_MEDIA_BD = "1" ]; then
		echo "Using backup method of ripping." >> $LOG
		DISC="${DEVNAME: -1}"
		echo "Sending command: "makemkvcon backup --decrypt -r disc:$DISC $DEST/""
		makemkvcon backup --decrypt -r disc:$DISC $DEST/
		eject $DEVNAME
	elif [ $MAINFEATURE = true ] && [ $ID_CDROM_MEDIA_DVD = "1" ] && [ -z $ID_CDROM_MEDIA_BD ]; then
		echo "Media is DVD and Main Feature parameter in config file is true.  Bypassing MakeMKV." >> $LOG

	else
		echo "Using mkv method of ripping." >> $LOG
		makemkvcon mkv dev:$DEVNAME all "$DEST" --minlength=$MINLENGTH -r
		eject $DEVNAME
	fi

	RIPEND=$(date +%s);
	RIPSEC=$(($RIPEND-$RIPSTART));
	RIPTIME="$(($RIPSEC / 3600)) hours, $((($RIPSEC / 60) % 60)) minutes and $(($RIPSEC % 60)) seconds."

	#eject $DEVNAME

	echo /opt/arm/notify.sh "\"Ripped: ${ID_FS_LABEL} completed from ${DEVNAME} in ${RIPTIME}\"" |at now

	echo "STAT: ${ID_FS_LABEL} ripped in ${RIPTIME}" >> $LOG

	echo /opt/arm/video_transcode.sh \"$DEST\" \"$VIDEO_TITLE\" \"$HAS_NICE_TITLE\" $TIMESTAMP >> $LOG
	echo /opt/arm/video_transcode.sh \"$DEST\" \"$VIDEO_TITLE\" \"$HAS_NICE_TITLE\" $TIMESTAMP | batch

	echo "${ID_FS_LABEL} sent to transcoding queue..." >> $LOG



} >> $LOG
