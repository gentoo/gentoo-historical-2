# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/directvnc/directvnc-0.7.ebuild,v 1.10 2004/06/24 23:41:50 agriffis Exp $

inherit eutils

DESCRIPTION="Very thin VNC client for unix framebuffer systems"
HOMEPAGE="http://adam-lilienthal.de/directvnc"
SRC_URI="http://savannah.gnu.org/download/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc -sparc"

DEPEND="dev-libs/DirectFB
	sys-devel/automake
	sys-devel/autoconf
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd ${S}/src

	# fix src/dfb.c to handle the new API changes in DirectFB
	epatch ${FILESDIR}/${P}-api-fix.patch

	#fix broken Makefile.am
	mv Makefile.am Makefile.am.orig
	sed -e 's/-$(DIRECTFB_LIBS)/$(DIRECTFB_LIBS)/' \
		Makefile.am.orig > Makefile.am
	cd ..
	aclocal || die "aclocal failed"
	autoconf || die "autoconf failed"
	automake || die "automake failed"
}

src_install() {
	make \
		DESTDIR=${D} \
		docsdir=/usr/share/doc/${PF} \
		install || die
}
