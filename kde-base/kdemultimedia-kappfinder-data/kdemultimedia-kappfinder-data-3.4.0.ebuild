# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdemultimedia-kappfinder-data/kdemultimedia-kappfinder-data-3.4.0.ebuild,v 1.5 2005/04/27 20:02:55 corsair Exp $

KMNAME=kdemultimedia
KMMODULE=kappfinder-data
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="kappfinder data from kdemultimedia"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc ~ppc64"
IUSE=""
