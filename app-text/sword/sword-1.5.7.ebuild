# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/sword/sword-1.5.7.ebuild,v 1.8 2004/06/24 22:52:21 agriffis Exp $

inherit eutils

DESCRIPTION="library for bible reading software"
HOMEPAGE="http://www.crosswire.org/sword/"
SRC_URI="ftp://ftp.crosswire.org/pub/sword/source/v1.5/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
# do not mark stable- problems when compiling (bug #48523)
KEYWORDS="~x86 ~ppc ~amd64"

IUSE="icu curl"
DEPEND="virtual/glibc
	sys-libs/zlib
	curl? ( >=net-misc/curl-7.10.8 )
	icu? ( dev-libs/icu )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-installmgr-gentoo.patch
	epatch ${FILESDIR}/${PN}-gcc34-gentoo.patch
}

src_compile() {
	econf --without-clucene --without-lucene `use_with icu` `use_with curl` || die "configure failed"
	emake || die "compile failed"
}

src_install() {
	einstall || die "install failed"
	dodir /etc
	doins ${FILESDIR}/sword.conf

	dodoc AUTHORS CODINGSTYLE INSTALL ChangeLog README
	cp -R samples examples ${D}/usr/share/doc/${PF}
	dohtml doc/api-documentation/html/*
}

pkg_postinst() {
	einfo ""
	einfo "To install modules for SWORD, you can emerge:"
	einfo "  app-text/sword-modules"
	einfo "or check out http://www.crosswire.org/sword/modules/"
	einfo "to download modules manually that you would like to"
	einfo "use the library with.  Follow module installation"
	einfo "instructions found on the web or in INSTALL.gz found"
	einfo "in /usr/share/doc/${PF}"
	einfo ""
}
