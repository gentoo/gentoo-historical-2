# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-dwerg/gtk-engines-dwerg-0.6.ebuild,v 1.1.1.1 2005/11/30 09:51:35 chriswhite Exp $

DESCRIPTION="GTK+2 Dwerg Theme Engine"
SRC_URI="http://download.freshmeat.net/themes/dwerg/dwerg-default-${PV}.tar.gz"
HOMEPAGE="http://themes.freshmeat.net/projects/dwerg/"

KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""
LICENSE="GPL-2"
SLOT="2"

DEPEND=">=x11-libs/gtk+-1.3.15"
RDEPEND="${DEPEND}"

src_unpack() {
	# Weird. The file is in bz2 but named gz ??
	cd ${WORKDIR}
	bzcat ${DISTDIR}/${A} | tar xvf -
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog NEWS README TODO
}
