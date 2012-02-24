# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcdio/libcdio-0.83.ebuild,v 1.7 2012/02/24 14:30:17 phajdan.jr Exp $

EAPI=4

inherit autotools-utils

DESCRIPTION="A library to encapsulate CD-ROM reading and control"
HOMEPAGE="http://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE="cddb +cxx minimal static-libs"

RDEPEND="cddb? ( >=media-libs/libcddb-1.0.1 )
	>=sys-libs/ncurses-5.7-r7
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/pkgconfig"

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

src_configure() {
	local myeconfargs=(
		$(use_enable cddb)
		$(use_enable cxx)
		$(use_with !minimal cd-drive)
		$(use_with !minimal cd-info)
		$(use_with !minimal cd-paranoia)
		$(use_with !minimal cdda-player)
		$(use_with !minimal cd-read)
		$(use_with !minimal iso-info)
		$(use_with !minimal iso-read)
		--disable-example-progs
		--disable-cpp-progs
		--with-cd-paranoia-name=libcdio-paranoia
		--disable-vcd-info
		--disable-maintainer-mode
	)
	autotools-utils_src_configure
}

pkg_postinst() {
	ewarn "If you've upgraded from a previous version of ${PN}, you may need to re-emerge"
	ewarn "packages that linked against ${PN} (vlc, vcdimager and more) by running:"
	ewarn "\trevdep-rebuild"
}
