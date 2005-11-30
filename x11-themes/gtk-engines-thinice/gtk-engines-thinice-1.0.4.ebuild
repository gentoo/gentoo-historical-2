# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-thinice/gtk-engines-thinice-1.0.4.ebuild,v 1.1.1.1 2005/11/30 09:51:42 chriswhite Exp $

MY_P="gtk-thinice-theme-${PV}"
DESCRIPTION="Thinice theme engine for GTK+ 1"
SRC_URI="mirror://sourceforge/thinice/${MY_P}.tar.gz"
HOMEPAGE="http://thinice.sourceforge.net/"

KEYWORDS="x86 ppc alpha sparc hppa amd64"
SLOT="1"
LICENSE="GPL-2"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*"

S=${WORKDIR}/${MY_P}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog README TODO
}
