# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/aiksaurus/aiksaurus-1.0.1-r1.ebuild,v 1.1 2004/04/24 09:05:27 robbat2 Exp $

inherit flag-o-matic eutils

DESCRIPTION="A thesaurus lib, tool and database"
HOMEPAGE="http://sourceforge.net/projects/aiksaurus"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="sys-devel/gcc"

src_unpack() {
	unpack ${A}

	# fix -DGTK_DEPRECATED
	sed -e 's/-DGTK_DISABLE_DEPRECATED//g' -i ${S}/configure

	cd ${S}/base
	epatch ${FILESDIR}/${PN}-0.15-gentoo.patch || die
}

src_compile() {
	filter-flags -fno-exceptions

	local myconf
	myconf="${myconf} `use_with gtk`"
	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS README* ChangeLog
}
