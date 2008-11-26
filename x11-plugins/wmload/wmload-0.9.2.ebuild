# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmload/wmload-0.9.2.ebuild,v 1.10 2008/11/26 00:01:43 tcunha Exp $

inherit eutils

IUSE=""

DESCRIPTION="yet another dock application showing a system load gauge"
SRC_URI="http://www.cs.mun.ca/~gstarkes/wmaker/dockapps/files/${P}.tgz"
HOMEPAGE="http://www.cs.mun.ca/~gstarkes/wmaker/dockapps/sys.html#wmload"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-misc/imake
	x11-proto/xproto
	x11-proto/xextproto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc sparc x86"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-ComplexProgramTargetNoMan.patch
}

src_compile() {
	xmkmf || die "xmkmf failed."
	emake CDEBUGFLAGS="${CFLAGS}" || die "emake failed."
}

src_install() {
	einstall DESTDIR="${D}" BINDIR=/usr/bin || die "einstall failed."

	dodoc README

	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop
}
