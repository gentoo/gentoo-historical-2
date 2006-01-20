# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/yaz/yaz-2.1.10.ebuild,v 1.2 2006/01/20 05:04:57 vapier Exp $

inherit eutils

DESCRIPTION="C/C++ programmer's toolkit supporting the development of Z39.50v3 clients and servers"
HOMEPAGE="http://www.indexdata.dk/yaz"
SRC_URI="http://ftp.indexdata.dk/pub/${PN}/${P}.tar.gz"

LICENSE="YAZ"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="tcpd"

RDEPEND="dev-libs/libxml2
	dev-libs/openssl
	tcpd? ( sys-apps/tcp-wrappers )"
DEPEND="${RDEPEND}
		app-text/docbook-xml-dtd
		app-text/docbook-dsssl-stylesheets
		app-text/docbook-xsl-stylesheets
		dev-util/pkgconfig
		sys-devel/autoconf"

src_unpack() {
	unpack ${A}
	cd ${S}
	autoconf || die "autoconf failed"
}

src_compile() {
	local myopts
	myopts="${myopts} `use_enable tcpd tcpd /usr`"

	econf ${myopts} --enable-shared || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	docdir="/usr/share/doc/${PF}"
	make DESTDIR="${D}" docdir="${docdir}" install || die "einstall failed"
	docinto html
	mv -f ${D}${docdir}/*.{html,css,png} ${D}${docdir}/html/ || die "Failed to move HTML docs"
}
