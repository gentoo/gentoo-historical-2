# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kcachegrind/kcachegrind-0.4.4.ebuild,v 1.1 2003/11/05 21:03:25 caleb Exp $
inherit kde-base

need-kde 3

IUSE=""
DESCRIPTION="A kde frontend for the cachegrind profiling tool, which is part of valgrind"
SRC_URI="http://kcachegrind.sourceforge.net/${P}.tar.gz"
HOMEPAGE="http://kcachegrind.sourceforge.net"

LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND=">=dev-util/calltree-0.9.1
	media-gfx/graphviz"
