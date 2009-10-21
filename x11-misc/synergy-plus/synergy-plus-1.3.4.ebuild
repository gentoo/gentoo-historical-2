# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/synergy-plus/synergy-plus-1.3.4.ebuild,v 1.1 2009/10/21 16:15:37 cardoe Exp $

EAPI="2"

DESCRIPTION="Lets you easily share a single mouse and keyboard between multiple
computers. An active fork of synergy"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"
#SRC_URI="mirror://google/files/${PN}/${P}.tar.gz"
HOMEPAGE="http://code.google.com/p/synergy-plus/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

CDEPEND="x11-libs/libXtst
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama"
RDEPEND="${CDEPEND}
	!x11-misc/synergy"
DEPEND="${CDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
	x11-proto/kbproto
	x11-proto/xineramaproto
	x11-libs/libXt"

src_install () {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
	insinto /etc
	doins examples/synergy.conf || die "doins failed"
}

pkg_postinst() {
	elog
	elog "${PN} can also be used to connect to computers running Windows or Mac OS X."
	elog "Visit ${HOMEPAGE} to find the Windows client and Mac OS X client."
	elog
}
