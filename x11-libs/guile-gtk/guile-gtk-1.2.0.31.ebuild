# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/guile-gtk/guile-gtk-1.2.0.31.ebuild,v 1.5 2004/06/24 22:03:38 agriffis Exp $

MAJOR_PV=${PV%.[0-9]*.[0-9]*}
MINOR_PV=${PV#[0-9]*.[0-9]*.}
IUSE=""
DESCRIPTION="GTK+ bindings for guile"
SRC_URI="http://savannah.nongnu.org/download/guile-gtk/${PN}-${MAJOR_PV}-${MINOR_PV}.tar.gz"
HOMEPAGE="http://www.ping.de/sites/zagadka/guile-gtk/"

KEYWORDS="~x86 ~ppc"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-util/guile-1.6
	=x11-libs/gtk+-1.2*"

S=${WORKDIR}/${PN}-${MAJOR_PV}-${MINOR_PV}

src_compile() {
	#patch < ${FILESDIR}/${P}-Makefile.in.patch || die "patch failed"
	econf || die "econf failed"
	emake || die
}

src_install() {
	einstall

	dodoc INSTALL README* COPYING AUTHORS ChangeLog NEWS TODO
	insinto /usr/share/guile-gtk/examples
	doins ${S}/examples/*.scm
}
