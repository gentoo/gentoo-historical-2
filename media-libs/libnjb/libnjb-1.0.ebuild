# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libnjb/libnjb-1.0.ebuild,v 1.6 2004/06/24 23:12:56 agriffis Exp $

inherit eutils

IUSE=""

DESCRIPTION="libnjb is a C library and API for communicating with the Creative Nomad JukeBox digital audio player under BSD and Linux."
HOMEPAGE="http://libnjb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~amd64"
DEPEND=">=dev-libs/libusb-0.1.7"
S="${WORKDIR}/${PN}"

src_compile() {

	unpack ${A}; cd ${S}
	epatch ${FILESDIR}/libnjb-errno.patch

	sed -i "s:all\: lib samples filemodes:all\: lib filemodes:g" Makefile.in
	econf || die "econf failed"
	emake || die
}

src_install() {
	einstall || die
	prepalldocs
	dodoc FAQ LICENSE INSTALL CHANGES README
}
