# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdvi/kdvi-3.5.6.ebuild,v 1.1 2007/01/16 20:30:17 flameeyes Exp $

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE DVI viewer"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="tetex"

DEPEND="
$(deprange $PV $MAXKDEVER kde-base/kviewshell)
>=media-libs/freetype-2"
RDEPEND="${DEPEND}
	tetex? ( virtual/tetex )"

KMCOMPILEONLY="kviewshell/"
