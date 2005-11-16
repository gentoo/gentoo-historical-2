# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde.eclass,v 1.139 2005/11/16 12:50:02 flameeyes Exp $
#
# Author Dan Armak <danarmak@gentoo.org>
#
# Revisions Caleb Tennis <caleb@gentoo.org>
# The kde eclass is inherited by all kde-* eclasses. Few ebuilds inherit straight from here.

inherit base eutils kde-functions flag-o-matic
DESCRIPTION="Based on the $ECLASS eclass"
HOMEPAGE="http://www.kde.org/"
IUSE="debug arts xinerama kdeenablefinal"

DEPEND=">=sys-devel/automake-1.7.0
	sys-devel/autoconf
	sys-devel/make
	dev-util/pkgconfig
	dev-lang/perl
	~kde-base/kde-env-3"

RDEPEND="~kde-base/kde-env-3"

# overridden in other places like kde-dist, kde-source and some individual ebuilds
SLOT="0"

kde_pkg_setup() {
	if [ "${PN}" != "arts" ] && [ "${PN}" != "kdelibs" ] ; then
		use arts && if ! built_with_use kde-base/kdelibs arts ; then
			eerror "You are trying to compile ${CATEGORY}/${P} with the \"arts\" USE flag enabled."
			eerror "However, $(best_version kde-base/kdelibs) was compiled with this flag disabled."
			eerror
			eerror "You must either disable this use flag, or recompile"
			eerror "$(best_version kde-base/kdelibs) with this use flag enabled."
			die
		fi
	fi

	# Let filter visibility flags that will *really* hurt your KDE
	filter-flags -fvisibility=hidden -fvisibility-inlines-hidden
}

kde_src_unpack() {
	debug-print-function $FUNCNAME $*

	# call base_src_unpack, which implements most of the functionality and has sections,
	# unlike this function. The change from base_src_unpack to kde_src_unpack is thus
	# wholly transparent for ebuilds.
	base_src_unpack $*

	# kde-specific stuff stars here

	# fix the 'languageChange undeclared' bug group: touch all .ui files, so that the
	# makefile regenerate any .cpp and .h files depending on them.
	cd $S
	debug-print "$FUNCNAME: Searching for .ui files in $PWD"
	UIFILES="`find . -name '*.ui' -print`"
	debug-print "$FUNCNAME: .ui files found:"
	debug-print "$UIFILES"
	# done in two stages, because touch doens't have a silent/force mode
	if [ -n "$UIFILES" ]; then
		debug-print "$FUNCNAME: touching .ui files..."
		touch $UIFILES
	fi
}

kde_src_compile() {

	debug-print-function $FUNCNAME $*
	[ -z "$1" ] && kde_src_compile all

	cd ${S}
	export kde_widgetdir="$KDEDIR/$(get_libdir)/kde3/plugins/designer"

	# fix the sandbox errors "can't writ to .kde or .qt" problems.
	# this is a fake homedir that is writeable under the sandbox, so that the build process
	# can do anything it wants with it.
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	# Fix bug 96177: if KDEROOTHOME is defined, the ebuild accesses the real homedir via it, and not our exported $HOME
	unset KDEHOME
	unset KDEROOTHOME

	# things that should access the real homedir
	[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"
	[ -n "$UNSERMAKE" ] && addwrite "/usr/kde/unsermake"

	while [ "$1" ]; do

		case $1 in
			myconf)
				debug-print-section myconf
				myconf="$myconf --with-x --enable-mitshm $(use_with xinerama) --with-qt-dir=${QTDIR} --enable-mt --with-qt-libraries=${QTDIR}/$(get_libdir)"
				# calculate dependencies separately from compiling, enables ccache to work on kde compiles
				[ -z "$UNSERMAKE" ] && myconf="$myconf --disable-dependency-tracking"
				if use debug ; then
					myconf="$myconf --enable-debug=full --with-debug"
				else
					myconf="$myconf --disable-debug --without-debug"
				fi
				if useq kdeenablefinal && [ -n "$KDEBASE" ]; then
					myconf="$myconf --enable-final"
				else
					myconf="$myconf --disable-final"
				fi
				[ -z "$KDEBASE" ] && myconf="$myconf $(use_with arts)"
				[ -n "$KDEBASE" -a "$KDEMINORVER" -ge 3 ] && myconf="$myconf $(use_with arts)"
				debug-print "$FUNCNAME: myconf: set to ${myconf}"
				;;
			configure)
				debug-print-section configure
				debug-print "$FUNCNAME::configure: myconf=$myconf"

				# rebuild configure script, etc
				# This can happen with e.g. a cvs snapshot
				if [ ! -f "./configure" ] || [ -n "$UNSERMAKE" ]; then
					for x in Makefile.cvs admin/Makefile.common; do
						if [ -f "$x" ] && [ -z "$makefile" ]; then makefile="$x"; fi
					done
					if [ -f "$makefile" ]; then
						debug-print "$FUNCNAME: configure: generating configure script, running make -f $makefile"
						make -f $makefile
					fi
					[ -f "./configure" ] || die "no configure script found, generation unsuccessful"
				fi

				export PATH="${KDEDIR}/bin:${PATH}"

				# configure doesn't need to know about the other KDEs installed.
				# in fact, if it does, it sometimes tries to use the wrong dcopidl, etc.
				# due to the messed up way configure searches for things
				export KDEDIRS="${PREFIX}:${KDEDIR}"

				cd $S

				# Visiblity stuff is broken. Just disable it when it's present.
				export kde_cv_prog_cxx_fvisibility_hidden=no

				# If we're in a kde-base ebuild, set the prefixed directories to
				# override the ones set by econf.
				if [[ ${PREFIX} != "/usr" ]]; then
					myconf="${myconf} --prefix=${PREFIX}
						--mandir=${PREFIX}/share/man
						--infodir=${PREFIX}/share/info
						--datadir=${PREFIX}/share
						--sysconfdir=${PREFIX}/etc"
				fi

				# Use libsuffix to keep KDE happy, the --libdir parameter get
				# still honored.
				if [[ $(get_libdir) != "lib" ]] ; then
					myconf="${myconf} --enable-libsuffix=$(get_libdir | sed s/lib//)"
				fi

				econf \
					${myconf} \
					|| die "died running ./configure, $FUNCNAME:configure"

				# Seems ./configure add -O2 by default but hppa don't want that but we need -ffunction-sections
				if [[ "${ARCH}" = "hppa" ]]
				then
					einfo Fixating Makefiles
					find ${S} -name Makefile | while read a; do sed -e s/-O2/-ffunction-sections/ -i "${a}" ; done
				fi
				;;
			make)
				export PATH="${KDEDIR}/bin:${PATH}"
				debug-print-section make
				emake || die "died running emake, $FUNCNAME:make"
				;;
			all)
				debug-print-section all
				kde_src_compile myconf configure make
				;;
		esac

	shift
	done

}

kde_src_install() {

	debug-print-function $FUNCNAME $*
	[[ -z "$1" ]] && kde_src_install all

	cd ${S}

	while [[ "$1" ]]; do

		case $1 in
			make)
				debug-print-section make
				make install DESTDIR=${D} destdir=${D} || die "died running make install, $FUNCNAME:make"
				;;
	    	dodoc)
				debug-print-section dodoc
				for doc in AUTHORS ChangeLog* README* NEWS TODO; do
					[ -s "$doc" ] && dodoc $doc
				done
				;;
	    	all)
				debug-print-section all
				kde_src_install make dodoc
				;;
		esac

	shift
	done

}

# slot rebuild function, thanks to Carsten Lohrke in bug 98425.
slot_rebuild() {
	local VDB_PATH="$(portageq vdb_path)"
	local KDE_PREFIX="$(kde-config --prefix)"
	local REBUILD_LIST=""
	local BROKEN_PKGS=""

	echo
	einfo "Scan for possible needed slot related rebuilds.\n"
	echo
	for i in ${*} ; do
		local temp="$(ls -1d ${VDB_PATH}/${i}*)"
		for j in ${temp} ; do
			if ! [[ -f ${j}/CONTENTS ]] ; then
				eerror "The package db entry for ${j/${VDB_PATH}\//} is broken."
				BROKEN_PKGS="${BROKEN_PKGS} ${j/${VDB_PATH}\//}"
				continue
			fi

			k="$(grep -o /.*/lib.*\.la ${j}/CONTENTS)"
			m=""
			for l in ${k} ; do [[ -e ${l} ]] && m="${m} ${l}"; done
			l="$(echo ${k} ${m} | fmt -w 1 | sort | uniq -u)"

			if [[ ${l} != "" ]] || [[ ${m} == "" ]] ; then
				eerror "Installation of ${j/${VDB_PATH}\//} is broken."
				BROKEN_PKGS="${BROKEN_PKGS} ${j/${VDB_PATH}\//}"
			else
				if [[ $(cat ${m}  | grep -co "${KDE_PREFIX}") = 0 ]] ; then
					REBUILD_LIST="${REBUILD_LIST} =${j/${VDB_PATH}\//}"
				fi
			fi
		done
	done
	echo
	if [[ -n "${BROKEN_PKGS}" ]] ; then
		eerror "Anomalies were found. Please do \"emerge ${BROKEN_PKGS}\"."
		return 1
	fi


	if [[ -n "${REBUILD_LIST}" ]] ; then
		local temp=""
		cd ${VDB_PATH}
		for i in ${REBUILD_LIST} ; do
			i="$(echo ${i%-*} | cut -d= -f2)"
			temp="${temp} $(find .  -iname "DEPEND" -exec grep -H ${i} '{}' \; | cut -f2-3 -d/ | grep -v ${CATEGORY}/${PN})"
		done
		temp="$(echo ${temp} | fmt -w 1 | sort -u)"
		for i in ${temp} ; do
			REBUILD_LIST="${REBUILD_LIST} =${i}"
		done
	fi

	if [[ -n "${REBUILD_LIST}" ]] ; then
		einfo "Please run \"emerge --oneshot ${REBUILD_LIST}\" before continuing.\n"
	else
		einfo "Done :), continuing...\n"
		return 1
	fi
	echo
}

EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install
