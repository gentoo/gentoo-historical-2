# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdesdk/kdesdk-3.3.0.ebuild,v 1.2 2004/08/27 22:56:24 weeve Exp $
inherit kde-dist

IUSE=""
DESCRIPTION="KDE SDK: kbabel, ..."
KEYWORDS="~x86 ~amd64 ~sparc"

DEPEND="!dev-util/kcachegrind
	x86? ( >=dev-util/calltree-0.9.1 )
	media-gfx/graphviz
	sys-devel/flex"

RDEPEND="$DEPEND"
