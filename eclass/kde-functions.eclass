# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde-functions.eclass,v 1.80 2005/01/14 13:45:35 danarmak Exp $
#
# Author Dan Armak <danarmak@gentoo.org>
#
# This contains everything except things that modify ebuild variables
# and functions (e.g. $P, src_compile() etc.)

ECLASS=kde-functions
INHERITED="$INHERITED $ECLASS"

# convinience functions for requesting autotools versions
need-automake() {

	debug-print-function $FUNCNAME $*

	unset WANT_AUTOMAKE

	case $1 in
		1.4)	export WANT_AUTOMAKE=1.4;;
		1.5)	export WANT_AUTOMAKE=1.5;;
		1.6)	export WANT_AUTOMAKE=1.6;;
		1.7)	export WANT_AUTOMAKE='1.7';;
		*)		echo "!!! $FUNCNAME: Error: unrecognized automake version $1 requested";;
	esac

}

need-autoconf() {

	debug-print-function $FUNCNAME $*

	unset WANT_AUTOCONF
	case $1 in
		2.1)	export WANT_AUTOCONF=2.1;;
		2.5)	export WANT_AUTOCONF=2.5;;
		*)		echo "!!! $FUNCNAME: Error: unrecognized autoconf version $1 requested";;
	esac

}

# Usage: deprange minver maxver package [...]
# For minver, a -rN part is supported. For both minver and maxver, _alpha/beta/pre/rc suffixes
# are supported, but not _p suffixes or teminating letters (eg 3.3.1a).
# This function echoes a string of the form (for package="kde-base/kdelibs")
# || ( =kde-base/kdelibs-3.3.1-r1 ~kde-base/kdelibs-3.3.2 ~kde-base/kdelibs-3.3.3 )
# This dep means versions of package from maxver through minver will be acceptable.
# Note that only the kde versioning scheme is supported - ie x.y, and we only iterate through y
# (i.e. x can contain more . separators).
deprange() {
	echo -n "|| ( "
	deprange-list $@
	echo -n " )"
}
deprange-list() {

	# Assign, parse params
	local MINVER=$1
	local MAXVER=$2
	shift; shift

	local BASEVER=${MINVER%.*}
	local MINMINOR=${MINVER##*.}
	local MAXMINOR=${MAXVER##*.}

	while [ -n "$1" ]; do
		local PACKAGE=$1
		shift

		# If min version has -rN component, separate it
		if [ "$MINMINOR" != "${MINMINOR/-r}" ]; then
			local MINREV=${MINMINOR##*-r}
			MINMINOR=${MINMINOR%-r*}
		fi

		# If min or max version has a _alpha/beta/pre/rc suffix, separate it.
		# To understand why we initialize MINALPHA etc the way we do, see the loops
		# that use them as bounds.
		local MINALPHA=11
		local MINBETA=11
		local MINPRE=11
		local MINRC=11
		if [ "$MINMINOR" != "${MINMINOR/_}" ]; then
			local MINSUFFIX="${MINMINOR##*_}"
			MINMINOR="${MINMINOR%_*}"
			if [ "$MINSUFFIX" != "${MINSUFFIX/alpha}" ]; then
				MINALPHA="${MINSUFFIX##alpha}"
				MINBETA=1
				MINPRE=1
				MINRC=1
			elif [ "$MINSUFFIX" != "${MINSUFFIX/beta}" ]; then
				MINBETA="${MINSUFFIX##beta}"
				MINPRE=1
				MINRC=1
			elif [ "$MINSUFFIX" != "${MINSUFFIX/pre}" ]; then
				MINPRE="${MINSUFFIX##pre}"
				MINRC=1
			elif [ "$MINSUFFIX" != "${MINSUFFIX/rc}" ]; then
				MINRC="${MINSUFFIX##rc}"
			else
				eerror "deprange(): version suffix $MINSUFFIX (probably _pN) not supported"
				return
			fi
		fi

		local MAXALPHA=0
		local MAXBETA=0
		local MAXPRE=0
		local MAXRC=0
		if [ "$MAXMINOR" != "${MAXMINOR/_}" ]; then
			local MAXSUFFIX="${MAXMINOR##*_}"
			MAXMINOR="${MAXMINOR%_*}"
			if [ "$MAXSUFFIX" != "${MAXSUFFIX/alpha}" ]; then
				MAXALPHA="${MAXSUFFIX##alpha}"
			elif [ "$MAXSUFFIX" != "${MAXSUFFIX/beta}" ]; then
				MAXBETA="${MAXSUFFIX##beta}"
				MAXALPHA=10
			elif [ "$MAXSUFFIX" != "${MAXSUFFIX/pre}" ]; then
				MAXPRE="${MAXSUFFIX##pre}"
				MAXALPHA=10
				MAXBETA=10
			elif [ "$MAXSUFFIX" != "${MAXSUFFIX/rc}" ]; then
				MAXRC="${MAXSUFFIX##rc}"
				MAXALPHA=10
				MAXBETA=10
				MAXPRE=10
			else
				eerror "deprange(): version suffix $MAXSUFFIX (probably _pN) not supported"
				return
			fi
		fi

		# If we stripped a revision number from MINMINOR earlier, increase the main loop's lower bound,
		# as we don't want to include a ~$PACKAGE-$BASEVER.$MINMINOR option.
		# If the lower bound has a suffix, we want to increase the suffix and not MINMINOR itself.
		if [ -n "$MINREV" ]; then
			if [ -z "$MINSUFFIX" ]; then
				let MINMINOR++
			elif [ -n "$MINRC" ]; then
				let MINRC++
			elif [ -n "$MINPRE" ]; then
				let MINPRE++
			elif [ -n "$MINBETA" ]; then
				let MINBETA++
			elif [ -n "$MINALPHA" ]; then
				let MINALPHA++
			fi
		fi

		# If we stripped a suffix from MAXMINOR, decrease it, since MAXMINOR without a suffix
		# is outside the requested range
		if [ -n "$MAXSUFFIX" ]; then
			let MAXMINOR--
		fi

		# Build list of versions in descending order:
		# from upper suffix to highest normal (suffixless) version, then just normal versions,
		# then from lowest normal version to lowest suffix.
		# Cf. the blocks that initialize MAXALPHA, MINBETA etc above to understand why
		# the loops below work.
		local NEWDEP=""
		local i

		# max version's allowed suffixes
		for (( i=$MAXRC ; $i > 0 ; i-- )) ; do
			NEWDEP="$NEWDEP =$PACKAGE-$BASEVER.${MAXMINOR}_rc$i"
		done
		for (( i=$MAXPRE ; $i > 0 ; i-- )) ; do
			NEWDEP="$NEWDEP =$PACKAGE-$BASEVER.${MAXMINOR}_pre$i"
		done
		for (( i=$MAXBETA ; $i > 0 ; i-- )) ; do
			NEWDEP="$NEWDEP =$PACKAGE-$BASEVER.${MAXMINOR}_beta$i"
		done
		for (( i=$MAXALPHA ; $i > 0 ; i-- )) ; do
			NEWDEP="$NEWDEP =$PACKAGE-$BASEVER.${MAXMINOR}_alpha$i"
		done

		# allowed normal versions
		for (( i=$MAXMINOR ; $i >= $MINMINOR ; i-- )) ; do
			NEWDEP="$NEWDEP ~$PACKAGE-$BASEVER.$i"
		done

		# min version's allowed suffixes
		for (( i=10 ; $i >= $MINRC ; i-- )) ; do
			NEWDEP="$NEWDEP =$PACKAGE-$BASEVER.${MINMINOR}_rc$i"
		done
		for (( i=10 ; $i >= $MINPRE ; i-- )) ; do
			NEWDEP="$NEWDEP =$PACKAGE-$BASEVER.${MINMINOR}_pre$i"
		done
		for (( i=10 ; $i >= $MINBETA ; i-- )) ; do
			NEWDEP="$NEWDEP =$PACKAGE-$BASEVER.${MINMINOR}_beta$i"
		done
		for (( i=10 ; $i >= $MINALPHA ; i-- )) ; do
			NEWDEP="$NEWDEP =$PACKAGE-$BASEVER.${MINMINOR}_alpha$i"
		done

		# If min verson had -rN component, add all revisions from r99 to it in descending order
		if [ -n "$MINREV" ]; then
			let MINMINOR--
			if [ -n "$MINSUFFIX" ]; then
				BASEMINVER="$PACKAGE-$BASEVER.${MINMINOR}_$MINSUFFIX"
			else
				BASEMINVER="$PACKAGE-$BASEVER.${MINMINOR}"
			fi
			for (( i=99 ; $i >= $MINREV ; i-- )) ; do
				NEWDEP="$NEWDEP =$BASEMINVER-r$i"
			done
		fi

		echo -n $NEWDEP
	done
}

# ---------------------------------------------------------------
# kde/qt directory management etc. functions, was kde-dirs.ebuild
# ---------------------------------------------------------------

need-kde() {

	debug-print-function $FUNCNAME $*
	KDEVER="$1"

	# determine install locations
	set-kdedir $KDEVER

	# ask for autotools
	case "$KDEVER" in
		3.1.[234])	# Newer 3.1.x versions are built with automake 1.7, and have errors when using 1.6
			need-automake 1.7
			need-autoconf 2.5
			;;
		3.1*)	# actually, newer 3.0.x stuff uses this too, but i want to make a clean switch
			need-automake 1.6
			need-autoconf 2.5
			;;
		3.2*)
			need-autoconf 2.5
			need-automake 1.7
			;;
		3*)	# a generic call for need-kde 3 - automake 1.4 works most often
			need-autoconf 2.5
			need-automake 1.4
			;;
		5*)
			need-autoconf 2.5
			need-automake 1.7
			;;
	esac

	# Things that need more special handling can just set NEED_KDE_DONT_ADD_KDELIBS_DEP
	# and add one of their own manually.
	if [ -n "$NEED_KDE_DONT_ADD_KDELIBS_DEP" ]; then
		# do nothing
		debug-print "$FUNCNAME: NEED_KDE_DONT_ADD_KDELIBS_DEP set, complying with request"
	elif [ -n "$KDEBASE" ]; then
		# If we're a kde-base package, we need at least our own version of kdelibs.
		# Also, split kde-base ebuilds are not updated with every KDE release, and so
		# can require support of different versions of kdelibs.
		# KM_DEPRANGE should contain 2nd and 3rd parameter to deprange:
		# max and min KDE versions. E.g. KM_DEPRANGE="$PV $MAXKDEVER".
		if [ -n "$KM_DEPRANGE" ]; then
			DEPEND="$DEPEND $(deprange $KM_DEPRANGE kde-base/kdelibs)"
			RDEPEND="$RDEPEND $(deprange $KM_DEPRANGE kde-base/kdelibs)"
		else
			DEPEND="${DEPEND} ~kde-base/kdelibs-$PV"
			RDEPEND="${RDEPEND} ~kde-base/kdelibs-$PV"
		fi
	else
		# Things outside kde-base only need a minimum version
		min-kde-ver $KDEVER
		RDEPEND="${RDEPEND} >=kde-base/kdelibs-${selected_version}"
		DEPEND="${DEPEND} >=kde-base/kdelibs-${selected_version}"
	fi

	qtver-from-kdever $KDEVER
	need-qt $selected_version

	if [ -n "$KDEBASE" ]; then
		SLOT="$KDEMAJORVER.$KDEMINORVER"
	else
		SLOT="0"
	fi
}

set-kdedir() {

	debug-print-function $FUNCNAME $*


	# set install location:
	# - 3rd party apps go into /usr, and have SLOT="0".
	# - kde-base category ebuilds go into /usr/kde/$MAJORVER.$MINORVER,
	# and have SLOT="$MAJORVER.$MINORVER".
	# - kde-base category cvs ebuilds have major version 5 and go into
	# /usr/kde/cvs; they have SLOT="cvs".
	# - Backward-compatibility exceptions: all kde2 packages (kde-base or otherwise)
	# go into /usr/kde/2. kde 3.0.x goes into /usr/kde/3 (and not 3.0).
	# - kde-base category ebuilds always depend on their exact matching version of
	# kdelibs and link against it. Other ebuilds link aginst the latest one found.
	# - This function exports $PREFIX (location to install to) and $KDEDIR
	# (location of kdelibs to link against) for all ebuilds.
	#
	# -- Overrides - deprecated but working for now: --
	# - If $KDEPREFIX is defined (in the profile or env), it overrides everything
	# and both base and 3rd party kde stuff goes in there.
	# - If $KDELIBSDIR is defined, the kdelibs installed in that location will be
	# used, even by kde-base packages.

	# get version elements
	IFSBACKUP="$IFS"
	IFS=".-_"
	for x in $1; do
		if [ -z "$KDEMAJORVER" ]; then KDEMAJORVER=$x
		else if [ -z "$KDEMINORVER" ]; then KDEMINORVER=$x
		else if [ -z "$KDEREVISION" ]; then KDEREVISION=$x
		fi; fi; fi
	done
	[ -z "$KDEMINORVER" ] && KDEMINORVER="0"
	[ -z "$KDEREVISION" ] && KDEREVISION="0"
	IFS="$IFSBACKUP"
	debug-print "$FUNCNAME: version breakup: KDEMAJORVER=$KDEMAJORVER KDEMINORVER=$KDEMINORVER KDEREVISION=$KDEREVISION"

	# install prefix
	if [ -n "$KDEPREFIX" ]; then
		export PREFIX="$KDEPREFIX"
	elif [ "$KDEMAJORVER" == "2" ]; then
		export PREFIX="/usr/kde/2"
	else
		if [ -z "$KDEBASE" ]; then
			export PREFIX="/usr"
		else
			case $KDEMAJORVER.$KDEMINORVER in
				3.0) export PREFIX="/usr/kde/3";;
				3.1) export PREFIX="/usr/kde/3.1";;
				3.2) export PREFIX="/usr/kde/3.2";;
				3.3) export PREFIX="/usr/kde/3.3";;
				3.4) export PREFIX="/usr/kde/3.4";;
				5.0) export PREFIX="/usr/kde/cvs";;
			esac
		fi
	fi

	# kdelibs location
	if [ -n "$KDELIBSDIR" ]; then
		export KDEDIR="$KDELIBSDIR"
	elif [ "$KDEMAJORVER" == "2" ]; then
		export KDEDIR="/usr/kde/2"
	else
		if [ -z "$KDEBASE" ]; then
			# find the latest kdelibs installed
			for x in /usr/kde/{cvs,3.4,3.3,3.2,3.1,3.0,3} $PREFIX $KDE3LIBSDIR $KDELIBSDIR $KDE3DIR $KDEDIR /usr/kde/*; do
				if [ -f "${x}/include/kwin.h" ]; then
					debug-print found
					export KDEDIR="$x"
					break
				fi
			done
		else
			# kde-base ebuilds must always use the exact version of kdelibs they came with
			case $KDEMAJORVER.$KDEMINORVER in
				3.0) export KDEDIR="/usr/kde/3";;
				3.1) export KDEDIR="/usr/kde/3.1";;
				3.2) export KDEDIR="/usr/kde/3.2";;
				3.3) export KDEDIR="/usr/kde/3.3";;
				3.4) export KDEDIR="/usr/kde/3.4";;
				5.0) export KDEDIR="/usr/kde/cvs";;
			esac
		fi
	fi


	# check that we've set everything
	[ -z "$PREFIX" ] && debug-print "$FUNCNAME: ERROR: could not set install prefix"
	[ -z "$KDEDIR" ] && debug-print "$FUNCNAME: ERROR: couldn't set kdelibs location"

	debug-print "$FUNCNAME: Will use the kdelibs installed in $KDEDIR, and install into $PREFIX."

}

need-qt() {

	debug-print-function $FUNCNAME $*
	QTVER="$1"

	QT=qt

	case $QTVER in
	    2*)
			RDEPEND="${RDEPEND} =x11-libs/${QT}-2.3*"
			DEPEND="${DEPEND} =x11-libs/${QT}-2.3*"
			;;
	    3*)
			RDEPEND="${RDEPEND} >=x11-libs/${QT}-${QTVER}"
			DEPEND="${DEPEND} >=x11-libs/${QT}-${QTVER}"
			;;
	    *)	echo "!!! error: $FUNCNAME() called with invalid parameter: \"$QTVER\", please report bug" && exit 1;;
	esac

	set-qtdir $QTVER

}

set-qtdir() {

	debug-print-function $FUNCNAME $*


	# select 1st element in dot-separated string
	IFSBACKUP=$IFS
	IFS="."
	QTMAJORVER=""
	for x in $1; do
		[ -z "$QTMAJORVER" ] && QTMAJORVER=$x
	done
	IFS=$IFSBACKUP

	# Don't se the QTDIR if it's already set
	# See bug #61967
	if [ ! $QTDIR ]; then
		export QTDIR="/usr/qt/$QTMAJORVER"
	fi

	# i'm putting this here so that the maximum amount of qt/kde apps gets it -- danarmak
	# if $QTDIR/etc/settings/qtrc file exists, the qt build tools try to create
	# a .qtrc.lock file in that directory. It's easiest to allow them to do so.
	[ -d "$QTDIR/etc/settings" ] && addwrite "$QTDIR/etc/settings"
	addpredict "$QTDIR/etc/settings"
}

# returns minimal qt version needed for specified kde version
qtver-from-kdever() {

	debug-print-function $FUNCNAME $*

	local ver

	case $1 in
		2*)	ver=2.3.1;;
		3.1*)	ver=3.1;;
		3.2*)	ver=3.2;;
		3.3*)	ver=3.3;;
		3.4*)	ver=3.3;;
		3*)	ver=3.0.5;;
		5)	ver=3.3;; # cvs version
		*)	echo "!!! error: $FUNCNAME called with invalid parameter: \"$1\", please report bug" && exit 1;;
	esac

	selected_version="$ver"

}

# compat - not used anymore, but old ebuilds that once used this fail if it's not present
# when they are unmerged
need-kdelibs() {
	echo "WARNING: need-kdelibs() called, where need-kde() is correct.
If this happens at the unmerging of an old ebuild, disregard; otherwise report."
	need-kde $*
}

min-kde-ver() {

	debug-print-function $FUNCNAME $*

	case $1 in
		2*)			selected_version="2.2.2";;
		3.0*)			selected_version="3.0";;
		3.1*)			selected_version="3.1";;
		3.2*)			selected_version="3.2";;
		3.3*)			selected_version="3.3";;
		3.4*)			selected_version="3.4";;
		3*)			selected_version="3.0";;
		5)			selected_version="5";;
		*)			echo "!!! error: $FUNCNAME() called with invalid parameter: \"$1\", please report bug" && exit 1;;
	esac

}

# This function should fix the broken automake detection in the detect-autoconf file
# This is only in use in arts-1.1.5.
kde_fix_autodetect() {
	cd ${S}/admin
	patch -p0 <<EOF
--- arts-1.1.3/admin/detect-autoconf.sh	2003-05-07 13:50:14.000000000 +0200
+++ detect-autoconf.sh	2003-07-29 12:21:39.000000000 +0200
@@ -52,7 +52,10 @@
 checkAutomakeAclocal ()
 {
   if test -z "\$UNSERMAKE"; then
-    if test -x "\`\$WHICH automake-1.5\`" ; then
+    if test -x "\`\$WHICH automake\`" ; then
+      AUTOMAKE="\`\$WHICH automake\`"
+      ACLOCAL="\`\$WHICH aclocal\`"
+    elif test -x "\`\$WHICH automake-1.5\`" ; then
       AUTOMAKE="\`\$WHICH automake-1.5\`"
       ACLOCAL="\`\$WHICH aclocal-1.5\`"
     elif test -x "\`\$WHICH automake-1.6\`" ; then
EOF
	cd -
}

# generic makefile sed for sandbox compatibility. for some reason when the kde makefiles (of many packages
# and versions) try to chown root and chmod 4755 some binaries (after installing, target isntall-exec-local),
# they do it to the files in $(bindir), not $(DESTDIR)/$(bindir). Most of these have been fixed in latest cvs
# but a few remain here and there.
# Pass a list of dirs to sed, Makefile.{am,in} in these dirs will be sed'ed.
# This should be harmless if the makefile doesn't need fixing.
kde_sandbox_patch() {

	debug-print-function $FUNCNAME $*

	while [ -n "$1" ]; do
	# can't use dosed, because it only works for things in ${D}, not ${S}
	cd $1
	for x in Makefile.am Makefile.in Makefile
	do
		if [ -f "$x" ]; then
			echo Running sed on $x
			cp $x ${x}.orig
			sed -e 's: $(bindir): $(DESTDIR)/$(bindir):g' -e 's: $(kde_datadir): $(DESTDIR)/$(kde_datadir):g' -e 's: $(TIMID_DIR): $(DESTDIR)/$(TIMID_DIR):g' ${x}.orig > ${x}
			rm ${x}.orig
		fi
	done
	shift
	done

}

# remove an optimization flag from a specific subdirectory's makefiles.
# currently kdebase and koffice use it to compile certain subdirs without
# -fomit-frame-pointer which breaks some things.
# Parameters:
# $1: subdirectory
# $2: flag to remove
kde_remove_flag() {

	debug-print-function $FUNCNAME $*

	cd ${S}/${1} || die
	[ -n "$2" ] || die

	cp Makefile Makefile.orig
	sed -e "/CFLAGS/ s/${2}//g
/CXXFLAGS/ s/${2}//g" Makefile.orig > Makefile

	cd $OLDPWD

}

# disable a subdir of a module from building.
# used by kdemultimedia et al
# autorun from kde_src_compile:configure if $KDE_REMOVE_DIR is set;
# $KDE_REMOVE_DIR is then passed as parameter
kde_remove_dir() {

	debug-print-function $FUNCNAME $*

	cd ${S}

	while [ -n "$1" ]; do
		for dir in $1; do

			debug-print "$FUNCNAME: removing subdirectory $dir"

			rm -rf $dir

			if [ -f subdirs ]; then
				mv subdirs subdirs.orig
				grep -v $dir subdirs.orig > subdirs
			fi

			rm -f configure configure.in

			export DO_NOT_COMPILE="$DO_NOT_COMPILE $dir"

		done
	shift
	done

}

# is this a kde-base ebuid?
case $PN in kde-i18n|arts|kdeaccessibility|kdeaddons|kdeadmin|kdeartwork|kdebase|kdebindings|kdeedu|kdegames|kdegraphics|kdelibs|kdemultimedia|kdenetwork|kdepim|kdesdk|kdetoys|kdeutils|kdewebdev|kdelibs-apidocs)
		debug-print "$ECLASS: KDEBASE ebuild recognized"
		export KDEBASE="true"
		;;
esac
