# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Dan Armak <danarmak@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/eclass/kde.org.eclass,v 1.11 2002/07/17 20:25:16 danarmak Exp $
# Contains the locations of ftp.kde.org packages and their mirrors
ECLASS=kde.org
INHERITED="$INHERITED $ECLASS"

# kde 3.1 prereleases have tarball versions of 3.0.6 ff
case "$PV" in
    2.2.2)	SRC_PATH="Attic/2.2.2/src/${P}.tar.bz2" ;;
    3.1_alpha1)	SRC_PATH="unstable/kde-3.1-alpha1/src/${P//3.1_alpha1/3.0.6}.tar.bz2" ;;
    3*)		SRC_PATH="stable/$PV/src/${P}.tar.bz2" ;;
    5)		SRC_URI="" # cvs ebuilds, no SRC_URI needed
		debug-print "$ECLASS: finished, cvs detected, SRC_URI=$SRC_URI"
		return 0 ;; 
    *)		die "$ECLASS: Error: unrecognized version $PV, could not set SRC_URI" ;;
esac

SRC_URI="mirror://kde/$SRC_PATH"

debug-print "$ECLASS: finished, SRC_URI=$SRC_URI"
