# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-flat/gtk-engines-flat-0.1-r1.ebuild,v 1.1 2005/08/02 09:31:06 leonardop Exp $

MY_PN="gtk-flat-theme"
MY_P=${MY_PN}-${PV}
DESCRIPTION="Flat theme engine for GTK+ 1"
HOMEPAGE="http://themes.freshmeat.net/projects/flat/"
SRC_URI="http://download.freshmeat.net/themes/flat/flat-1.2.x.tar.gz"

KEYWORDS="~x86 ~ppc ~alpha ~sparc ~hppa ~amd64"
SLOT="1"
LICENSE="GPL-2"
IUSE="static"

DEPEND="=x11-libs/gtk+-1.2*"
S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf="$(use_enable static)"

	econf $myconf || die "Configuration failed"
	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS README
}
