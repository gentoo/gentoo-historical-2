# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/rlog/rlog-1.4.ebuild,v 1.2 2010/06/03 09:54:56 ssuominen Exp $

EAPI=2
inherit eutils

DESCRIPTION="A C++ logging library"
HOMEPAGE="http://code.google.com/p/rlog/"
SRC_URI="http://rlog.googlecode.com/files/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3.7-gcc-4.3.patch
}

src_install() {
	emake DESTDIR="${D}" pkgdocdir="/usr/share/doc/${PF}" install || die
	dodoc AUTHORS README
}
