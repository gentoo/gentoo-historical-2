# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/XWine/XWine-0.3.1.ebuild,v 1.6 2004/08/21 15:22:50 foser Exp $

DESCRIPTION="GTK+ frontend for Wine"
HOMEPAGE="http://darken33.free.fr/"
SRC_URI="http://darken33.free.fr/logiciels/${P}_en.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE="nls"

DEPEND="=x11-libs/gtk+-1*
	sys-devel/bison
	>=gnome-base/gnome-libs-1.4.2
	=gnome-base/orbit-0*
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${P}_en

src_compile() {
	econf `use_enable nls` || die
	emake || die
}

src_install() {
	einstall || die
	# Don't need to install docs twice
	rm -rf ${D}/usr/share/doc/xwine
	dodoc doc/Manual* FAQ* BUGS AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	einfo "${PN} requires a setup Wine to start....It is recommended"
	einfo "that you run winesetuptk prior to running ${PN} to setup"
	einfo "a base Wine install"
	einfo ""
	einfo "You should also emerge wine or winex at this point"
}
