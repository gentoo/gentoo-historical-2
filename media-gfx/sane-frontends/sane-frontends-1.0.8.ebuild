# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sane-frontends/sane-frontends-1.0.8.ebuild,v 1.9 2002/10/20 18:48:56 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Scanner Access Now Easy"
HOMEPAGE="http://www.mostang.com/sane/"
SRC_URI="ftp://ftp.mostang.com/pub/sane/sane-${PV}/${P}.tar.gz"

DEPEND=">=media-gfx/sane-backends-1.0.8"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc"

src_compile() {
	econf \
		--datadir=/usr/share/misc || die
	emake || die "emake failed"
}

src_install() {
	einstall datadir=${D}/usr/share/misc || die

	dodir /usr/lib/gimp/1.2/plug-ins
	dosym /usr/bin/xscanimage /usr/lib/gimp/1.2/plug-ins/xscanimage
	dodoc AUTHORS COPYING Changelog NEWS PROBLEMS README TODO
}
