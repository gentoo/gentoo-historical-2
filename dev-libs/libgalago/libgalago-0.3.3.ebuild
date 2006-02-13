# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgalago/libgalago-0.3.3.ebuild,v 1.2 2006/02/13 20:07:36 metalgod Exp $

inherit eutils autotools

DESCRIPTION="Galago - desktop presence framework"
HOMEPAGE="http://www.galago-project.org/"
SRC_URI="http://www.galago-project.org/files/releases/source/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="sys-devel/gettext
		 >=dev-libs/glib-2.2.2
		 >=sys-apps/dbus-0.23"
DEPEND="${RDEPEND}
		>=dev-util/pkgconfig-0.9
		test? ( dev-libs/check )"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Hard enable/disable tests
	epatch ${FILESDIR}/${PN}-0.3.3-test-option.patch

	eautoreconf
}

src_compile() {
	econf $(use_enable test tests) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS
}
