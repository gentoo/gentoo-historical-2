# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-dwerg/gtk-engines-dwerg-0.8.ebuild,v 1.1 2005/08/02 07:34:11 leonardop Exp $

DESCRIPTION="GTK+2 Dwerg Theme Engine"
SRC_URI="http://download.freshmeat.net/themes/dwerg/dwerg-default-${PV}.tar.gz"
HOMEPAGE="http://themes.freshmeat.net/projects/dwerg/"

KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"
IUSE="static"
LICENSE="GPL-2"
SLOT="2"

DEPEND=">=x11-libs/gtk+-1.3.15"
RDEPEND="${DEPEND}"

src_compile() {
	local myconf="$(use_enable static)"

	econf $myconf || die "Configuration failed"
	emake || die "Compilation failed"
}

src_install() {
	make DESTDIR="${D}" install || die "Installation failed"

	dodoc AUTHORS ChangeLog NEWS README
}
