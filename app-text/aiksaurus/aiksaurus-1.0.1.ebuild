# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/aiksaurus/aiksaurus-1.0.1.ebuild,v 1.3 2004/03/12 08:45:39 mr_bones_ Exp $

inherit flag-o-matic

DESCRIPTION="A thesaurus lib, tool and database"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://sf.net/projects/aiksaurus"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="sys-devel/gcc"

src_unpack() {
	unpack ${A}
	cd ${S}/base
	epatch ${FILESDIR}/${PN}-0.15-gentoo.patch || die
}

src_compile() {

	filter-flags -fno-exceptions

	cd ${S}
	econf || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING README* ChangeLog
}
