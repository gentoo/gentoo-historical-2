# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/kde-dist.eclass,v 1.65 2005/07/06 20:20:03 agriffis Exp $
#
# Author Dan Armak <danarmak@gentoo.org>
#
# This is the kde-dist eclass for >=2.2.1 kde base packages.  Don't use for kdelibs though :-)
# Don't use it for e.g. kdevelop, koffice because of their separate versioning schemes.

inherit kde
INHERITED="$INHERITED $ECLASS"

# kde 3.1 prereleases have tarball versions of 3.0.6 ff
unset SRC_URI
case "$PV" in
	1*)			SRC_PATH="stable/3.0.2/src/${P}.tar.bz2";; # backward compatibility for unmerging ebuilds
	2.2.2a)			SRC_PATH="Attic/2.2.2/src/${PN}-${PV/a/}.tar.bz2" ;;
	2.2.2*)			SRC_PATH="Attic/2.2.2/src/${P}.tar.bz2" ;;
	3.2.0)			SRC_PATH="stable/3.2/src/${P}.tar.bz2" ;;
	3.3.0)			SRC_PATH="stable/3.3/src/${P}.tar.bz2" ;;
	3.4.0_beta1)		SRC_PATH="unstable/3.3.91/src/${PN}-3.3.91.tar.bz2" ;;
	3.4.0_beta2)		SRC_PATH="unstable/3.3.92/src/${PN}-3.3.92.tar.bz2" ;;
	3.4.0_rc1)		SRC_PATH="unstable/3.4.0-rc1/src/${PN}-3.4.0-rc1.tar.bz2" ;;
	3.4.0)			SRC_PATH="stable/3.4/src/${P}.tar.bz2" ;;
	3*)			SRC_PATH="stable/${PV}/src/${P}.tar.bz2" ;;
	5)			SRC_URI="" # cvs ebuilds, no SRC_URI needed
				debug-print "$ECLASS: cvs detected" ;;
	*)			debug-print "$ECLASS: Error: unrecognized version $PV, could not set SRC_URI" ;;
esac
[ -n "$SRC_PATH" ] && SRC_URI="$SRC_URI mirror://kde/$SRC_PATH"
debug-print "$ECLASS: finished, SRC_URI=$SRC_URI"

need-kde ${PV}

# 3.4 prereleases
[ "${PV}" == "3.4.0_beta1" ] && S=${WORKDIR}/${PN}-3.3.91
[ "${PV}" == "3.4.0_beta2" ] && S=${WORKDIR}/${PN}-3.3.92
[ "${PV}" == "3.4.0_rc1" ] && S=${WORKDIR}/${PN}-3.4.0

DESCRIPTION="KDE ${PV} - "
HOMEPAGE="http://www.kde.org/"
LICENSE="GPL-2"
SLOT="$KDEMAJORVER.$KDEMINORVER"

# add blockers on split packages derived from this one
for x in $(get-child-packages ${CATEGORY}/${PN}); do
	DEPEND="${DEPEND} !=${x}-${SLOT}*"
	RDEPEND="${RDEPEND} !=${x}-${SLOT}*"
done
