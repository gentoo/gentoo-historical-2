# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde-dist.eclass,v 1.46 2003/12/03 22:16:04 caleb Exp $
#
# Author Dan Armak <danarmak@gentoo.org>
#
# This is the kde-dist eclass for >=2.2.1 kde base packages.  Don't use for kdelibs though :-)
# Don't use it for e.g. kdevelop, koffice because of their separate versioning schemes.

inherit kde
ECLASS=kde-dist
INHERITED="$INHERITED $ECLASS"

# kde 3.1 prereleases have tarball versions of 3.0.6 ff
unset SRC_URI
case "$PV" in
	1*)				SRC_PATH="stable/3.0.2/src/${P}.tar.bz2";; # backward compatibility for unmerging ebuilds
	2.2.2a)			SRC_PATH="Attic/2.2.2/src/${PN}-${PV/a/}.tar.bz2" ;;
	2.2.2*)			SRC_PATH="Attic/2.2.2/src/${P}.tar.bz2" ;;
	3.2.0_beta1)		SRC_PATH="unstable/3.1.93/src/${P//3.2.0_beta1/3.1.93}.tar.bz2" ;;
	3.2.0_beta2)		SRC_PATH="unstable/3.1.94/src/${P//3.2.0_beta2/3.1.94}.tar.bz2" ;;
	3.1.1a)			SRC_PATH="stable/$PV/src/${PN}-3.1.1.tar.bz2"
				SRC_URI="$SRC_URI mirror://gentoo/${PN}-${PVR}.diff.bz2" ;;
	3*)			SRC_PATH="stable/$PV/src/${P}.tar.bz2" ;;
	5)					SRC_URI="" # cvs ebuilds, no SRC_URI needed
		debug-print "$ECLASS: cvs detected" ;;
	*)		debug-print "$ECLASS: Error: unrecognized version $PV, could not set SRC_URI" ;;
esac
[ -n "$SRC_PATH" ] && SRC_URI="$SRC_URI mirror://kde/$SRC_PATH"
debug-print "$ECLASS: finished, SRC_URI=$SRC_URI"

need-kde $PV

# 3.2 prereleases
[ "$PV" == "3.2.0_beta1" ] && S=${WORKDIR}/${PN}-3.1.93
[ "$PV" == "3.2.0_beta2" ] && S=${WORKDIR}/${PN}-3.1.94
[ "$PV" == "3.1_rc1" ] && S=${WORKDIR}/${PN}-3.0.9
[ "$PV" == "3.1_rc2" ] && S=${WORKDIR}/${PN}-3.0.98
[ "$PV" == "3.1_rc3" ] && S=${WORKDIR}/${PN}-3.0.99
[ "$PV" == "3.1_rc5" ] && S=${WORKDIR}/${PN}-3.1rc5
[ "$PV" == "3.1_rc6" ] && S=${WORKDIR}/${PN}-3.1rc6

# these use incrememntal patches so as to avoid downloadnig a lot of stuff all over
if [ "$PV" == "3.1.1a" ]; then
    PATCHES1="${WORKDIR}/${PN}-${PVR}.diff"
    export S="${WORKDIR}/${PN}-3.1.1"
fi

DESCRIPTION="KDE ${PV} - "
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"

SLOT="$KDEMAJORVER.$KDEMINORVER"

debug-print "----------- $ECLASS finished -----------------"
