# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/nautilus-gtkhtml/nautilus-gtkhtml-0.3.2.ebuild,v 1.9 2003/02/13 12:23:41 vapier Exp $

inherit debug

S=${WORKDIR}/${P}
DESCRIPTION="libgtkhtml addons for Nautilus in gnome2"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc "

RDEPEND=">=gnome-base/nautilus-1.1.10
	>=gnome-extra/libgtkhtml-1.99.7"

DEPEND=">=dev-util/pkgconfig-0.12.0
	${RDEPEND}"


src_compile() {
	local myconf

	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--enable-platform-gnome-2 \
		--enable-debug=yes || die "configure failure"

	emake || die "compile failure"
}

src_install() {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		install || die
    
	dodoc ABOUT-NLS  AUTHORS COPYING  ChangeLog  INSTALL NEWS  README TODO
}





