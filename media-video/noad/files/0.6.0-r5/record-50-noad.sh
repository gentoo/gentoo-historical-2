# $Header: /var/cvsroot/gentoo-x86/media-video/noad/files/0.6.0-r5/record-50-noad.sh,v 1.1 2006/10/07 11:19:01 zzam Exp $
#
# Joerg Bornkessel <hd_brummy@gentoo.org>
# Mathias Schwarzott <zzam@gentoo.org>
#

source /etc/conf.d/vdraddon.noad

CMD="/usr/bin/noad"

# Parameter to start NoAd
# parameter are "no | yes"


ALLOW_ONLINE=yes

if [[ ${VDR_RECORD_STATE} == reccmd ]]; then
	# script started from reccmd
	VDR_USE_NOAD=yes
	VDR_RECORD_STATE=after
	ALLOW_ONLINE=no
	NOAD_ONLY_SCAN_IF_NO_PTSMARKS=no
fi

[[ ${VDR_USE_NOAD} == "yes" ]] || return


case "${VDR_RECORD_STATE}" in
after)	: ;;

before)	[[ "${NOAD_ONLINE}" == "no" ]] && return ;;

*)	return ;;
esac

if [[ ${ALLOW_ONLINE} == yes ]]; then
	case "${NOAD_ONLINE}" in
		live|yes)
			CMD="${CMD} --online=1"
			;;
		all)
			CMD="${CMD} --online=2"
			;;
	esac
fi

if [[ ${NOAD_ONLY_SCAN_IF_NO_PTSMARKS} == yes ]]; then
	[[ -f ${VDR_RECORD_NAME}/ptsmarks.vdr ]] && return
fi

[[ "${NOAD_AC3}" == "yes" ]] && CMD="${CMD} -a"
[[ "${NOAD_JUMP}" == "yes" ]] && CMD="${CMD} -j"
[[ "${NOAD_OVERLAP}" == "yes" ]] && CMD="${CMD} -o"
[[ "${NOAD_MESSAGES}" == "yes" ]] && CMD="${CMD} -O"

if [[ ${NOAD_NICE} == yes ]]; then
	CMD="nice ${CMD}"
fi

CMD="${CMD} ${NOAD_PARAMETER}"
${CMD} "${VDR_RECORD_STATE}" "${VDR_RECORD_NAME}" 

