# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/genkernel/genkernel-3.0.2a.ebuild,v 1.4 2004/07/12 22:00:46 plasmaroo Exp $

IUSE=""

DESCRIPTION="Gentoo autokernel script"
HOMEPAGE="http://www.gentoo.org"
SRC_URI="http://dev.gentoo.org/~plasmaroo/patches/kernel/genkernel/3.0.2/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86 sparc hppa alpha ppc"

DEPEND="amd64? ( media-gfx/bootsplash )
	x86? ( media-gfx/bootsplash )"

src_install() {
	dodir /etc
	cp ${S}/genkernel.conf ${D}/etc

	dodir /usr/share/genkernel
	cp -Rp ${S}/* ${D}/usr/share/genkernel

	dodir /usr/bin
	dosym ${D}/usr/share/genkernel/genkernel /usr/bin/genkernel

	rm ${D}/usr/share/genkernel/genkernel.conf
	dodoc README
}
