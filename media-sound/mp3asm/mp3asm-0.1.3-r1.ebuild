# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mp3asm/mp3asm-0.1.3-r1.ebuild,v 1.3 2003/08/07 04:10:18 vapier Exp $

MY_P=${PN}-${PV}-${PR/r/}
DESCRIPTION="A command line tool to clean and edit mp3 files."
HOMEPAGE="http://sourceforge.net/projects/mp3asm/"
SRC_URI="mirror://sourceforge/mp3asm/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"

DEPEND=""
RDEPEND=""

# the author uses weird numbering...
S=${WORKDIR}/mp3asm-0.1

src_compile() {
        econf || die
        emake || die
}

src_install() {
	dodoc README
	dobin src/mp3asm
}
