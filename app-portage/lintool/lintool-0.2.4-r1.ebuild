# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/lintool/lintool-0.2.4-r1.ebuild,v 1.7 2004/06/24 21:50:20 agriffis Exp $

inherit python eutils

DESCRIPTION="Gentoo Linux \"lint\" utility"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~hppa ~alpha ~amd64"

DEPEND=">=dev-lang/python-2.2"

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/lintool-0.2.4-fixyear.diff
	EPATCH_OPTS="-d ${S}" epatch ${FILESDIR}/lintool-0.2.4-python.diff
}

src_compile() {
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README ChangeLog AUTHORS
}
