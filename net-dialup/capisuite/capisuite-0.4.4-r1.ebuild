# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/capisuite/capisuite-0.4.4-r1.ebuild,v 1.4 2005/02/06 11:11:09 mrness Exp $

inherit eutils

DESCRIPTION="An ISDN telecommunication suite"
HOMEPAGE="http://www.capisuite.de"
SRC_URI="http://www.capisuite.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="dev-lang/python
	virtual/libc
	net-dialup/capi4k-utils"
DEPEND="${RDEPEND}
	media-sound/sox
	media-libs/tiff
	media-gfx/jpeg2ps
	media-gfx/sfftobmp
	virtual/ghostscript
	virtual/mta"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
}

src_compile() {
	econf --localstatedir=/var \
		--with-docdir=/usr/share/doc/${P} || die "econf failed."
	emake || die "parallel make failed."
}

src_install() {
	emake DESTDIR=${D} install || die "install failed."

	exeinto /etc/init.d
	doexe ${FILESDIR}/capisuite

	keepdir /var/spool/capisuite/{done,failed,sendq,users}

	dodoc AUTHORS COPYING INSTALL NEWS README TODO
}
