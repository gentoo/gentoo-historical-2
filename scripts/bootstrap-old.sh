#!/bin/bash
# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/scripts/bootstrap-old.sh,v 1.1 2005/03/28 01:03:31 wolf31o2 Exp $

# people who were here:
# (drobbins, 06 Jun 2003)
# (solar, Jul 2004)
# (vapier, Aug 2004)
# (compnerd, Nov 2004)

if [ -e /etc/init.d/functions.sh ] ; then
	source /etc/init.d/functions.sh

	# Use our own custom script, else logger cause things to
	# 'freeze' if we do not have a system logger running
	esyslog() {
		echo &> /dev/null
	}
else
	eerror() { echo "!!! $*"; }
	einfo() { echo "* $*"; }
fi
show_status() {
	local num=$1
	shift
	echo "  [[ ($num/6) $* ]]"
}

# Track progress of the bootstrap process to allow for
# semi-transparent resuming
progressfile=/var/run/bootstrap-progress
[[ -e ${progressfile} ]] && source ${progressfile}
export BOOTSTRAP_STAGE=${BOOTSTRAP_STAGE:-1}
set_bootstrap_stage() {
	[[ -z ${STRAP_RUN} ]] && return 0
	export BOOTSTRAP_STAGE=$1
	echo "BOOTSTRAP_STAGE=$1" > ${progressfile}
}

v_echo() {
	einfo "Executing: $*"
	env "$@"
}

usage() {
	echo -e "Usage: ${HILITE}${0##*/}${NORMAL} ${GOOD}[options]${NORMAL}"
	echo -e "  ${GOOD}--debug (-d)${NORMAL}     Run with debug information turned on"
	echo -e "  ${GOOD}--fetchonly (-f)${NORMAL} Just download all the source files"
	echo -e "  ${GOOD}--info (-i)${NORMAL}      Show system related information"
	echo -e "  ${GOOD}--pretend (-p)${NORMAL}   Display the packages that will be merged"
	echo -e "  ${GOOD}--tree (-t)${NORMAL}      Display the dependency tree, forces -p"
	echo -e "  ${GOOD}--resume (-r)${NORMAL}    Build/use binary packages"
}

unset STRAP_EMERGE_OPTS
STRAP_RUN=1
V_ECHO=env
DEBUG=0
GENTOO_VERS=2005.0 # Mostly for fluff ;)

for opt in "$@" ; do
	case ${opt} in
		--fetchonly|-f)
			echo "Running in fetch-only mode ..."
			STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -f"
			unset STRAP_RUN;;
		--help|-h)
			usage
			exit 0;;
		--debug|-d)   STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} --debug"; DEBUG=1;;
		--info|-i)    STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} --info"   ; unset STRAP_RUN ;;
		--pretend|-p) STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -p" ; unset STRAP_RUN ;;
		--tree|-t)    STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -p -t"; unset STRAP_RUN ;;
		--resume|-r)  STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} --usepkg --buildpkg";;
		--verbose|-v) STRAP_EMERGE_OPTS="${STRAP_EMERGE_OPTS} -v"; V_ECHO=v_echo;;
		--version)
			cvsver="$Header: /var/cvsroot/gentoo-x86/scripts/bootstrap-old.sh,v 1.1 2005/03/28 01:03:31 wolf31o2 Exp $"
			cvsver=${cvsver##*,v }
			einfo "Gentoo ${GENTOO_VERS} bootstrap ${cvsver%%Exp*}"
			exit 0
			;;
		*)
			eerror "Unknown option '${opt}'"
			usage
			exit 1;;
	esac
done

if [[ -n ${STRAP_RUN} ]]  ; then
	if [ ${BOOTSTRAP_STAGE} -ge 6 ] ; then
		echo
		einfo "System has been bootstrapped already!"
		einfo "If you re-bootstrap the system, you must complete the entire bootstrap process"
		einfo "otherwise you will have a broken system."
		einfo "Press enter to continue or CTRL+C to abort ..."
		read
		set_bootstrap_stage 1
	elif [ ${BOOTSTRAP_STAGE} -gt 1 ] ; then
		einfo "Resuming bootstrap at internal stage #${BOOTSTRAP_STAGE} ..."
	fi
else
	export BOOTSTRAP_STAGE=0
fi

MYPROFILEDIR=$(readlink -f /etc/make.profile)
if [[ ! -d ${MYPROFILEDIR} ]] ; then
	eerror "Error:  '${MYPROFILEDIR}' does not exist.  Exiting."
	exit 1
fi

[[ -e /etc/profile ]] && source /etc/profile

echo -e "\n${GOOD}Gentoo Linux ${GENTOO_VERS}; ${BRACKET}http://www.gentoo.org/${NORMAL}"
echo -e "Copyright 1999-2005 Gentoo Foundation; Distributed under the GPLv2"
if [[ ${STRAP_EMERGE_OPTS:0:2} = "-f" ]] ; then
	echo "Fetching all bootstrap-related archives ..."
elif [[ -n ${STRAP_RUN} ]] ; then
	if [ ${BOOTSTRAP_STAGE} -gt 2 ] ; then
		echo "Resuming Bootstrap of base system ..."
	else
		echo "Starting Bootstrap of base system ..."
	fi
fi
echo -------------------------------------------------------------------------------
show_status 0 Locating packages

# This should not be set to get glibc to build properly. See bug #7652.
unset LD_LIBRARY_PATH

# We do not want stray $TMP, $TMPDIR or $TEMP settings
unset TMP TMPDIR TEMP

cleanup() {
	if [[ -n ${STRAP_RUN} ]] ; then
		if [[ -f /etc/make.conf.build ]] ; then
			mv -f /etc/make.conf.build /etc/make.conf
		fi
	fi
	exit $1
}

pycmd() {
	[[ ${DEBUG} = "1" ]] && echo /usr/bin/python -c "$@" > /dev/stderr
	/usr/bin/python -c "$@"
}

# Trap ctrl-c and stuff.  This should fix the users make.conf
# not being restored.
[[ -n ${STRAP_RUN} ]] && cp -f /etc/make.conf /etc/make.conf.build

#TSTP messes ^Z of bootstrap up, so we don't trap it anymore.
trap "cleanup" TERM KILL INT QUIT ABRT

# USE may be set from the environment so we back it up for later.
export ORIGUSE=$(portageq envvar USE)

# Check for 'build' or 'bootstrap' in USE ...
INVALID_USE="`gawk -v ORIGUSE="${ORIGUSE}" '
	BEGIN { 
		if (ORIGUSE ~ /[[:space:]]*(build|bootstrap)[[:space:]]*/)
			print "yes"
	}'`"

# Do not do the check for stage build scripts ...
if [[ ${INVALID_USE} = "yes" ]] ; then
	echo
	eerror "You have 'build' or 'bootstrap' in your USE flags. Please"
	eerror "remove it before trying to continue, since these USE flags"
	eerror "are used for internal purposes and shouldn't be specified"
	eerror "by you."
	echo
	cleanup 1
fi

# bug #50158 (don't use `which` in a bootstrap).
if ! type -path portageq &>/dev/null ; then
	echo
	eerror "Your portage version is too old.  Please use a newer stage1 image."
	echo
	cleanup 1
fi

# gettext should only be needed when used with nls
for opt in ${ORIGUSE} ; do
	case "${opt}" in
		nls) myGETTEXT="gettext";;
		nptl)
			if [[ -z $(portageq best_visible / '>=sys-kernel/linux26-headers-2.6.0') ]] ; then
				eerror "You need to have >=sys-kernel/linux26-headers-2.6.0 unmasked!"
				eerror "Please edit the latest >=sys-kernel/linux26-headers-2.6.0 package,"
				eerror "and add your ARCH to KEYWORDS."
				echo
				cleanup 1
			fi
			if [[ -n $(portageq best_version / sys-kernel/linux-headers) ]] ; then
				emerge -C sys-kernel/linux-headers
				emerge --nodeps --oneshot sys-kernel/linux26-headers
			fi
			USE_NPTL=1
		;;
	esac
done

# With cascading profiles, the packages profile at the leaf is not a
# complete system, just the restrictions to it for the specific profile.
# The complete profile consists of an aggregate of the leaf and all its
# parents.  So we now call portage to read the aggregate profile and store
# that into a variable.

eval $(pycmd 'import portage; print portage.settings.packages;' |
sed 's/[][,]//g; s/ /\n/g; s/\*//g' | while read p; do n=${p##*/}; n=${n%\'};
n=${n%%-[0-9]*}; echo "my$(tr a-z- A-Z_ <<<$n)=$p; "; done)

# this stuff should never fail but will if not enough is installed.
#[[ -z ${myBASELAYOUT} ]] && myBASELAYOUT="$(portageq best_version / virtual/baselayout)"
[[ -z ${myBASELAYOUT} ]] && myBASELAYOUT="baselayout"
[[ -z ${myPORTAGE}    ]] && myPORTAGE="portage"
[[ -z ${myBINUTILS}   ]] && myBINUTILS="binutils"
[[ -z ${myGCC}        ]] && myGCC="gcc"
[[ -z ${myLIBC}       ]] && myLIBC="virtual/libc"
[[ -z ${myTEXINFO}    ]] && myTEXINFO="sys-apps/texinfo"
[[ -z ${myZLIB}       ]] && myZLIB="zlib"
[[ -z ${myNCURSES}    ]] && myNCURSES="ncurses"

# Do we really have no 2.4.x nptl kernels in portage?
if [[ ${USE_NPTL} = "1" ]] ; then
	myOS_HEADERS="$(portageq best_visible / '>=sys-kernel/linux26-headers-2.6.0')"
	[[ -n ${myOS_HEADERS} ]] && myOS_HEADERS=">=${myOS_HEADERS}"
fi
[[ -z ${myOS_HEADERS} ]] && myOS_HEADERS="virtual/os-headers"

einfo "Using baselayout : ${myBASELAYOUT}"
einfo "Using portage    : ${myPORTAGE}"
einfo "Using os-headers : ${myOS_HEADERS}"
einfo "Using binutils   : ${myBINUTILS}"
einfo "Using gcc        : ${myGCC}"
[[ -n ${myGETTEXT} ]] && einfo "Using gettext    : ${myGETTEXT}"
einfo "Using libc       : ${myLIBC}"
einfo "Using texinfo    : ${myTEXINFO}"
einfo "Using zlib       : ${myZLIB}"
einfo "Using ncurses    : ${myNCURSES}"
echo -------------------------------------------------------------------------------
show_status 1 Configuring environment

# Get correct CFLAGS, CHOST, CXXFLAGS, MAKEOPTS since make.conf will be
# overwritten.

ENV_EXPORTS="GENTOO_MIRRORS PORTDIR DISTDIR PKGDIR PORTAGE_TMPDIR
	CFLAGS CHOST CXXFLAGS MAKEOPTS ACCEPT_KEYWORDS PROXY HTTP_PROXY
	FTP_PROXY FEATURES STAGE1_USE"

for opt in ${ENV_EXPORTS} ; do
	val=$(portageq envvar "${opt}")
	if [[ -n ${val} ]] ; then
		einfo "${opt}='${val}'"
		export ${opt}="${val}"
	fi
done
echo -------------------------------------------------------------------------------

[[ -x /usr/sbin/gcc-config ]] && GCC_CONFIG="/usr/sbin/gcc-config"
[[ -x /usr/bin/gcc-config  ]] && GCC_CONFIG="/usr/bin/gcc-config"

# Disable autoclean, or it b0rks
export AUTOCLEAN="no"

# Allow portage to overwrite stuff
export CONFIG_PROTECT="-*"

# disable collision-protection
export FEATURES="${FEATURES} -collision-protect"

if [ ${BOOTSTRAP_STAGE} -le 1 ] ; then
	show_status 2 Updating portage
	${V_ECHO} USE="-* build bootstrap ${STAGE1_USE}" emerge ${STRAP_EMERGE_OPTS} ${myPORTAGE} || cleanup 1
	echo -------------------------------------------------------------------------------
	set_bootstrap_stage 2
fi
export USE="${ORIGUSE} bootstrap ${STAGE1_USE}"

# We can't unmerge headers which may or may not exist yet. If your
# trying to use nptl, it may be needed to flush out any old headers
# before fully bootstrapping. 
if [ ${BOOTSTRAP_STAGE} -le 2 ] ; then
	show_status 3 Emerging headers/binutils
	#emerge ${STRAP_EMERGE_OPTS} -C virtual/os-headers || cleanup 1
	${V_ECHO} emerge ${STRAP_EMERGE_OPTS} ${myOS_HEADERS} ${myTEXINFO} ${myGETTEXT} ${myBINUTILS} || cleanup 1
	echo -------------------------------------------------------------------------------
	set_bootstrap_stage 3
fi

# If say both gcc and binutils were built for i486, and we then merge
# binutils for i686 without removing the i486 version (Note that this is
# _only_ when its exactly the same version of binutils ... if we have say
# 2.14.90.0.6 build for i486, and bootstrap then merge 2.14.90.0.7 for i686,
# we will not have issues.  More below ...), gcc's search path will
# still have
#
#   /usr/lib/gcc-lib/i486-pc-linux-gnu/<gcc_version>/../../../../i486-pc-linux-gnu/bin/
#
# before /usr/bin, and thus it will use the i486 versions of binutils binaries
# which causes issues.  The reason for this issues is that when bootstrap merge
# exactly the same version for i686, both will have installed the same files to
# /usr/lib, and thus also USE the same libraries, cause as/ld to fail with
# unresolved symbols during compiling/linking.
#
# More info on this can be found by looking at bug #32140:
#
#   http://bugs.gentoo.org/show_bug.cgi?id=32140
#
# We now thus run an 'emerge clean' just after merging binutils ...
#
# NB: thanks to <rac@gentoo.org> for bringing me on the right track
#     (http://forums.gentoo.org/viewtopic.php?t=100263)
#
# <azarah@gentoo.org> (1 Nov 2003)
if [[ -n ${STRAP_RUN} ]] ; then
    emerge clean || cleanup 1
fi

if [ ${BOOTSTRAP_STAGE} -le 3 ] ; then
	show_status 4 Emerging gcc
	${V_ECHO} emerge ${STRAP_EMERGE_OPTS} ${myGCC} || cleanup 1
	echo -------------------------------------------------------------------------------
	set_bootstrap_stage 4
fi

# Basic support for gcc multi version/arch scheme ...
if [[ -n ${STRAP_RUN} ]] ; then
	if [[ -x ${GCC_CONFIG} ]] && ${GCC_CONFIG} --get-current-profile &>/dev/null
	then
		# Make sure we get the old gcc unmerged ...
		emerge clean || cleanup 1
		# Make sure the profile and /lib/cpp and /usr/bin/cc are valid ...
		${GCC_CONFIG} "$(${GCC_CONFIG} --get-current-profile)" &>/dev/null
	fi
fi

if [ ${BOOTSTRAP_STAGE} -le 4 ] ; then
	show_status 5 Emerging libc/baselayout
	${V_ECHO} emerge ${STRAP_EMERGE_OPTS} ${myLIBC} ${myBASELAYOUT} ${myZLIB} || cleanup 1
	echo -------------------------------------------------------------------------------
	set_bootstrap_stage 5
fi

# ncurses-5.3 and up also build c++ bindings, so we need to rebuild it
export USE="${ORIGUSE}"
if [ ${BOOTSTRAP_STAGE} -le 5 ] ; then
	show_status 6 Re-Emerging C++ apps
	${V_ECHO} emerge ${STRAP_EMERGE_OPTS} ${myNCURSES} || cleanup 1
	echo -------------------------------------------------------------------------------
	set_bootstrap_stage 6
fi

# Restore original make.conf
cleanup 0
