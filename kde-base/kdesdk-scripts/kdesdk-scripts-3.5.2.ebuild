# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk-scripts/kdesdk-scripts-3.5.2.ebuild,v 1.9 2007/02/03 09:31:59 mr_bones_ Exp $

KMNAME=kdesdk
KMMODULE="scripts"
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="Kdesdk Scripts - Some useful scripts for the development of applications"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""
