# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/astyle/astyle-1.15.3-r1.ebuild,v 1.4 2004/06/25 02:19:41 agriffis Exp $

inherit eutils

DESCRIPTION="Artistic Style is a reindenter and reformatter of C++, C and Java source code"
HOMEPAGE="http://astyle.sourceforge.net/"
SRC_URI="mirror://sourceforge/astyle/astyle_${PV}.zip"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc"
IUSE=""

DEPEND=">=app-arch/unzip-5.42"

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/cmd-line-fix.diff
}

src_compile() {
	emake || die
}

src_install() {
	dobin astyle
	dohtml astyle.html astyle_release_notes.html license.html
	dodoc INSTALL.TXT
}
