# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Paul Fleischer <proguy@proguy.dk>
# /space/gentoo/cvsroot/gentoo-x86/skel.ebuild,v 1.4 2002/03/12 16:05:09 tod Exp

S="${WORKDIR}/Epplets-${PV}"

DESCRIPTION="Base files for Enlightenment epplets and some epplets"
SRC_URI="http://prdownloads.sourceforge.net/enlightenment/${P}.tar.gz"

HOMEPAGE="http://sourceforge.net/projects/enlightenment"

DEPEND=">=x11-base/xfree-4.2.0
	>=media-libs/imlib-1.9.10
	>=x11-wm/enlightenment-0.16.5-r4"

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man || die "./configure failed"

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog
}
