# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkscan/libkscan-3.5.8.ebuild,v 1.4 2008/01/30 11:31:25 opfer Exp $

KMNAME=kdegraphics
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE scanner library"
KEYWORDS="alpha amd64 ia64 ~ppc ~ppc64 sparc x86"
IUSE=""
DEPEND="media-gfx/sane-backends"
RDEPEND="${DEPEND}"
