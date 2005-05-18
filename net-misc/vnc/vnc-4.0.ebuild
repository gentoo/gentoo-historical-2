# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vnc/vnc-4.0.ebuild,v 1.6 2005/05/18 04:18:29 mr_bones_ Exp $

inherit eutils toolchain-funcs

X_VERSION="6.7.0"

MY_P="${P}-unixsrc"
DESCRIPTION="Remote desktop viewer display system"
HOMEPAGE="http://www.realvnc.com/"
SRC_URI="http://www.realvnc.com/dist/${MY_P}.tar.gz
	 http://freedesktop.org/~xorg/X11R${X_VERSION}/src/X11R${X_VERSION}-src1.tar.gz
	 http://freedesktop.org/~xorg/X11R${X_VERSION}/src/X11R${X_VERSION}-src2.tar.gz
	 http://freedesktop.org/~xorg/X11R${X_VERSION}/src/X11R${X_VERSION}-src3.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc amd64"
IUSE=""

DEPEND="sys-libs/zlib
	!net-misc/tightvnc
	media-libs/freetype
	x11-base/xorg-x11"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	mkdir -p ${S}/xc ; cd ${S}

	unpack X11R${X_VERSION}-src1.tar.gz
	unpack X11R${X_VERSION}-src2.tar.gz
	unpack X11R${X_VERSION}-src3.tar.gz

	cd ${WORKDIR}
	unpack ${MY_P}.tar.gz ; cd ${S}

	# patches from Redhat
	epatch ${FILESDIR}/${P}/vnc-cookie.patch
	epatch ${FILESDIR}/${P}/vnc-def.patch
	epatch ${FILESDIR}/${P}/vnc-fPIC.patch
	epatch ${FILESDIR}/${P}/vnc-gcc34.patch
	epatch ${FILESDIR}/${P}/vnc-idle.patch
	epatch ${FILESDIR}/${P}/vnc-restart.patch
	epatch ${FILESDIR}/${P}/vnc-sparc.patch
	epatch ${FILESDIR}/${P}/vnc-via.patch
	epatch ${FILESDIR}/${P}/vnc-xclients.patch
	epatch ${FILESDIR}/${P}/vnc-xorg-x11-fixes.patch
	epatch ${FILESDIR}/${P}/vnc-xorg.patch

	epatch ${FILESDIR}/xc.patch-cfbglblt8.patch
	epatch xc.patch
}

src_compile() {
	# client
	econf --with-installed-zlib || die
	emake || die

	# server
	cd ${S}/xc
	make CDEBUGFLAGS="${CFLAGS}" CXXDEBUGFLAGS="${CXXFLAGS}" World FAST=1 || die
}

src_install() {
	# client
	dodir /usr/bin /usr/share/man/man1 /usr/X11R6/lib/modules/extensions
	./vncinstall ${D}/usr/bin ${D}/usr/share/man ${D}/usr/X11R6/lib/modules/extensions || die
	dodoc LICENCE.TXT README

	ewarn "Note that the free VNC release is not designed for use on untrusted networks"
}
