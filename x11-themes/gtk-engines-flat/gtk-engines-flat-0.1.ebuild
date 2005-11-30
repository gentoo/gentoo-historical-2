# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-flat/gtk-engines-flat-0.1.ebuild,v 1.1.1.1 2005/11/30 09:51:34 chriswhite Exp $

MY_PN="gtk-flat-theme"
MY_P=${MY_PN}-${PV}
DESCRIPTION="Flat theme engine for GTK+ 1"
HOMEPAGE="http://themes.freshmeat.net/projects/flat/"
SRC_URI="http://download.freshmeat.net/themes/flat/flat-1.2.x.tar.gz"

KEYWORDS="x86 ppc alpha sparc hppa amd64"
SLOT="1"
LICENSE="GPL-2"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*"
S=${WORKDIR}/${MY_P}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS README
}
