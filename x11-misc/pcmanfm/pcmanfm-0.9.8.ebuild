# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/pcmanfm/pcmanfm-0.9.8.ebuild,v 1.3 2010/12/26 04:59:43 ssuominen Exp $

EAPI=2

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="git://pcmanfm.git.sourceforge.net/gitroot/pcmanfm/${PN}"
	inherit autotools git
	SRC_URI=""
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~ppc ~x86"
fi

inherit fdo-mime

DESCRIPTION="Fast lightweight tabbed filemanager"
HOMEPAGE="http://pcmanfm.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug"

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	>=x11-libs/gtk+-2.16:2
	>=lxde-base/menu-cache-0.3.2
	>=x11-libs/libfm-0.1.10"
RDEPEND="${COMMON_DEPEND}
	virtual/eject"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.40
	dev-util/pkgconfig
	sys-devel/gettext"

src_prepare() {
	if [[ ${PV} == 9999 ]]; then
		intltoolize --force --copy --automake || die
		eautoreconf
	fi
}

src_configure() {
	econf \
		--sysconfdir=/etc \
		$(use_enable debug)
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS
}

pkg_postinst() {
	fdo-mime_desktop_database_update

	elog 'PCmanFM can optionally support the menu://applications/ location.'
	elog 'You should install lxde-base/lxmenu-data for that	functionality.'
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
