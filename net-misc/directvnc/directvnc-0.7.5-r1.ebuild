# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/directvnc/directvnc-0.7.5-r1.ebuild,v 1.2 2007/11/16 17:07:20 s4t4n Exp $

inherit eutils

DESCRIPTION="Very thin VNC client for unix framebuffer systems"
HOMEPAGE="http://adam-lilienthal.de/directvnc/"
SRC_URI="http://www.adam-lilienthal.de/directvnc/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~amd64"
IUSE="mouse"

RDEPEND="dev-libs/DirectFB
	>=media-libs/jpeg-6b-r7"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-apps/sed-4
	x11-proto/xproto"

src_unpack() {
	unpack "${A}"

	# Make mouse support optional
	cd "${S}/src"
	use mouse || epatch "${FILESDIR}/${PN}-mouse.patch"
}

src_compile() {
	econf || die

	# Fix bug #116148, DFBGraphicsDeviceDescription is no longer present in
	# newer DirectFB version, but the application never uses it :-/
	local comment_out="DFBCardCapabilities caps;"
	sed -i -e "s:${comment_out}://${comment_out}:" src/dfb.c

	emake DEBUGFLAGS="${CFLAGS}" || die
}

src_install() {
	make install DESTDIR=${D} || die
	rm -rf ${D}/usr/doc
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO
}
