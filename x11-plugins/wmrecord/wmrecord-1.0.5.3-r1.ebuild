# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmrecord/wmrecord-1.0.5.3-r1.ebuild,v 1.5 2008/06/29 13:28:39 drac Exp $

IUSE=""

DESCRIPTION="A Dockable General Purpose Recording Utility"
SRC_URI="http://ret009t0.eresmas.net/other_software/wmrecord/${PN}-1.0.5_20040218_0029.tgz"
HOMEPAGE="http://ret009t0.eresmas.net/other_software/wmrecord/"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xextproto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc"

S=${WORKDIR}/${PN}-1.0.5

src_compile() {
	emake CFLAGS="${CFLAGS} -Wall" || die "make failed"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	einstall BINDIR="${D}/usr/bin" MANDIR="${D}/usr/share/man/man1" || die "make install failed"

	dodoc Changelog README TODO

	insinto /usr/share/applications
	doins "${FILESDIR}"/${PN}.desktop
}
