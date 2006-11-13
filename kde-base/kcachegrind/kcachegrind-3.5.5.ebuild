# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcachegrind/kcachegrind-3.5.5.ebuild,v 1.3 2006/11/13 10:11:52 opfer Exp $

KMNAME=kdesdk
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE Frontend for Cachegrind"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="x86? ( >=dev-util/valgrind-3.2.0 )"

RDEPEND="${DEPEND}
	media-gfx/graphviz"
