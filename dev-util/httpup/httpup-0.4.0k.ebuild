# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/httpup/httpup-0.4.0k.ebuild,v 1.1 2010/05/21 20:41:47 ssuominen Exp $

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="synchronisation tool for http file repositories"
HOMEPAGE="http://jw.tks6.net/files/crux/httpup_manual.html"
SRC_URI="http://jw.tks6.net/files/crux/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="net-misc/curl"

src_prepare() {
	epatch "${FILESDIR}"/${P}-Makefile.patch
}

src_compile() {
	tc-export CC CXX
	emake || die
}

src_install() {
	emake DESTDIR="${D}" mandir="/usr/share/man" prefix="/usr" install || die
	dodoc AUTHORS ChangeLog httpup.conf.example README TODO
}
