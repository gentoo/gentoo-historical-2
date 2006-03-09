# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/konsole/konsole-3.5.1-r1.ebuild,v 1.2 2006/03/09 10:49:34 flameeyes Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="X terminal for use with KDE."
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

PATCHES="${FILESDIR}/${P}-detach-send2all.patch"

RDEPEND="
	|| ( (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXrender
			x11-libs/libXtst
		) virtual/x11 )"

DEPEND="${RDEPEND}
	|| ( x11-apps/bdftopcf virtual/x11 )"

