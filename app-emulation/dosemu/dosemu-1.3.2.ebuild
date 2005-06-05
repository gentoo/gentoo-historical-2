# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/dosemu/dosemu-1.3.2.ebuild,v 1.1 2005/06/05 22:35:33 hanno Exp $

inherit flag-o-matic eutils

P_FD=dosemu-freedos-b9r5-bin
DESCRIPTION="DOS Emulator"
HOMEPAGE="http://www.dosemu.org/"
SRC_URI="mirror://sourceforge/dosemu/${P_FD}.tgz
	mirror://sourceforge/dosemu/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="X svga gpm debug"

RDEPEND="X? ( virtual/x11 )
	svga? ( media-libs/svgalib )
	gpm? ( sys-libs/gpm )
	sys-libs/slang"

DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.57"

src_unpack() {
	unpack ${P}.tgz
	cd ${S}
	epatch ${FILESDIR}/${PN}-broken-links.diff
	epatch ${FILESDIR}/dosemu-1.2.2-cflags.patch

	WANT_AUTOCONF=2.5
	autoconf || die "autoconf failed"
}

src_compile() {
	local myflags="--sysconfdir=/etc/dosemu/ \
	--with-mandir=/usr/share/man/"

	unset KERNEL
	use X || myflags="${myflags} --with-x=no"
	use svga && myflags="${myflags} --enable-use-svgalib"
	use gpm || myflags="${myflags} --without-gpm"
	use debug && myflags="${myflags} --enable-debug"

	# Has problems with -O3 on some systems
	replace-flags -O[3-9] -O2

	# Fix compilation on hardened
	append-flags -fno-pic

	econf ${myflags} || die "DOSemu Base Configuration Failed"

	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc doc/*
	rm -rf ${D}/usr/share/doc/dosemu

	# freedos tarball is needed in /usr/share/dosemu
	cp ${DISTDIR}/${P_FD}.tgz ${D}/usr/share/dosemu/dosemu-freedos-bin.tgz
}
