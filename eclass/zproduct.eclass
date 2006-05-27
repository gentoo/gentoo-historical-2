# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/zproduct.eclass,v 1.23 2006/05/27 14:15:26 radek Exp $
# Author: Jason Shoemaker <kutsuya@gentoo.org>

# This eclass is designed to streamline the construction of
# ebuilds for new zope products

EXPORT_FUNCTIONS src_install pkg_prerm pkg_postinst pkg_config

DESCRIPTION="This is a zope product"
#HOMEPAGE=""
#SRC_URI=""

RDEPEND=">=net-zope/zope-2.6.0-r2
	app-admin/zprod-manager"

IUSE=""
SLOT="0"
KEYWORDS="x86 ~ppc"
S=${WORKDIR}

ZI_DIR="${ROOT}/var/lib/zope/"
ZP_DIR="${ROOT}/usr/share/zproduct"
DOT_ZFOLDER_FPATH="${ZP_DIR}/${PF}/.zfolder.lst"

zproduct_src_install() {
	## Assume that folders or files that shouldn't be installed
	#  in the zproduct directory have been already been removed.
	## Assume $S set to the parent directory of the zproduct(s).

	debug-print-function ${FUNCNAME} ${*}
	[ -n "${ZPROD_LIST}" ] || die "ZPROD_LIST isn't defined."
	[ -z "${1}" ] && zproduct_src_install all

	# set defaults
	into ${ZP_DIR}
	dodir ${ZP_DIR}/${PF}

	while [ -n "$1" ] ; do
		case ${1} in
			do_zpfolders)
				## Create .zfolders.lst from $ZPROD_LIST.
				debug-print-section do_zpfolders
				for N in ${ZPROD_LIST} ; do
					echo ${N} >> ${D}/${DOT_ZFOLDER_FPATH}
				done
				;;
			do_docs)
				#*Moves txt docs
				debug-print-section do_docs
				docs_move
				for ZPROD in ${ZPROD_LIST} ; do
					docs_move ${ZPROD}/
				done
				;;
			do_install)
				debug-print-section do_install
				# Copy everything that's left to ${D}${ZP_DIR}
				# modified to not copy ownership (QA)
				cp --recursive --no-dereference --preserve=timestamps,mode,links ${S}/* ${D}/${ZP_DIR}/${PF}
				;;
			all)
				debug-print-section all
				zproduct_src_install do_zpfolders do_docs do_install ;;
		esac
		shift
	done
	debug-print "${FUNCNAME}: result is ${RESULT}"
}

docs_move() {
	# if $1 == "/", then this breaks.
	if [ -n "$1" ] ; then
		docinto $1
	else
		docinto /
	fi
	dodoc $1HISTORY.txt $1README{.txt,} $1INSTALL{.txt,} > /dev/null 2>/dev/null
	dodoc $1AUTHORS $1COPYING $1CREDITS.txt $1TODO{.txt,} > /dev/null 2>/dev/null
	dodoc $1LICENSE{.GPL,.txt,} $1CHANGES{.txt,} > /dev/null 2>/dev/null
	dodoc $1DEPENDENCIES.txt $1FAQ.txt $1UPGRADE.txt > /dev/null 2>/dev/null
	for item in ${MYDOC} ; do
		dodoc ${1}${item} > /dev/null 2>/dev/null
	done
}

zproduct_pkg_postinst() {
	#*check for multiple zinstances, if several display install help msg.

	#*Use zprod-update to install this zproduct to the default zinstance.
	debug-print-function ${FUNCNAME} ${*}

	# this is a shared directory, so root should be owner;
	# zprod-manager or whatever is used to copy products into the
	# instances has to take care of setting the right permissions in
	# the target directory

	chown -R root:root ${ZP_DIR}/${PF}
	# make shure there is nothing writable in the new dir, and all is readable
	chmod -R go-w,a+rX ${ZP_DIR}/${PF}
	einfo ">>> Installing ${PF} into the \"$(zope-config --zidef-get)\" zinstance ..."
	${ROOT}/usr/sbin/zprod-manager add ${ZP_DIR}/${PF}
}

# This function is deprecated! Still used, until a new system developed.

zproduct_pkg_prerm() {
	# remove this zproduct from all zinstances.
	# process zinstance.lst and proceed with zprod-update del
	debug-print-function ${FUNCNAME} ${*}
	ZINST_LST=$(ls /var/lib/zope/)
	if [ "${ZINST_LST}" ] ; then
		# first check and warn on any installed products into instances
		ARE_INSTALLED=0
		for N in ${ZINST_LST} ; do
			if [ -s $DOT_ZFOLDER_FPATH ]
			then
				# check only if installed product has non empty folder lists
				#
				# for every fodler inside product ...
				for PFOLD in `cat $DOT_ZFOLDER_FPATH`
				do
					# ... check if its in instance.
					if [ -d "${ZI_DIR}${N}/Products/${PFOLD}" ]
					then
						ARE_INSTALLED=$[ARE_INSTALLED + 1]
					fi
				done
			fi
		done
		# Info and wait ...
		if [ $ARE_INSTALLED -gt 0 ]
		then
			#TODO: should use ebeep and epause, but i got some inheritance errors on eutils
			#so as for now i use local version. in futuure we should inherit ueilts
			ewarn "Detected at least $ARE_INSTALLED copies of product being removed."
			ewarn "Sleeping 10seconds, please use CTRL+C to abort!"
			echo -ne "\a"
			sleep 10
		fi

		ewarn "Uninstalling from all zinstances ..."
		for N in ${ZINST_LST} ; do
			${ROOT}/usr/sbin/zprod-manager del ${ZP_DIR}/${PF} ${ZI_DIR}${N}
		done
	fi
}

# Add this zproduct to the top zinstance.

zproduct_pkg_config() {
	einfo "To add zproducts to other zinstances execute:"
	einfo "\tzprod-manager add"
}
