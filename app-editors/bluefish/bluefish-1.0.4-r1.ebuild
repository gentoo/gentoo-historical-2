# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/bluefish/bluefish-1.0.4-r1.ebuild,v 1.1 2005/12/20 22:34:51 hanno Exp $

inherit eutils fdo-mime

IUSE="nls spell gnome"

DESCRIPTION="A GTK HTML editor for the experienced web designer or programmer."
SRC_URI="http://pkedu.fbt.eitn.wau.nl/~olivier/downloads/${P}.tar.bz2"
HOMEPAGE="http://bluefish.openoffice.nl/"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"

RDEPEND=">=x11-libs/gtk+-2
	dev-libs/libpcre
	spell? ( app-text/aspell )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )
	gnome? ( gnome-base/libgnomeui )"

src_compile() {
	econf --disable-update-databases \
		`use_enable nls` \
		`use_with gnome libgnomeui` || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}

pkg_postinst() {
	update-mime-database /usr/share/mime
}
