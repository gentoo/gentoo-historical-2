# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/fortune-mod-bofh-excuses/fortune-mod-bofh-excuses-1.2.ebuild,v 1.3 2003/10/15 20:20:57 vapier Exp $

DESCRIPTION="Excuses from Bastard Operator from Hell"
HOMEPAGE="http://www.stlim.net/staticpages/index.php?page=20020814005536450"
SRC_URI="http://www.stlim.net/downloads/fortune-bofh-excuses-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips"

RDEPEND="games-misc/fortune-mod"

S=${WORKDIR}/${PN/mod-/}

src_install() {
	insinto /usr/share/fortune
	doins bofh-excuses.dat bofh-excuses
}
