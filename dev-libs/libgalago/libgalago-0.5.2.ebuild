# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libgalago/libgalago-0.5.2.ebuild,v 1.8 2007/08/02 05:09:02 mr_bones_ Exp $

inherit eutils autotools

DESCRIPTION="Galago - desktop presence framework"
HOMEPAGE="http://www.galago-project.org/"
SRC_URI="http://www.galago-project.org/files/releases/source/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE="test"

RDEPEND=">=dev-libs/glib-2.8
	>=dev-libs/dbus-glib-0.71"
DEPEND="${RDEPEND}
		>=sys-devel/gettext-0.10.40
		>=dev-util/pkgconfig-0.9
		test? ( dev-libs/check )"
PDEPEND=">=sys-apps/galago-daemon-0.5.1"

src_compile() {
	econf $(use_enable test tests) || die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS
}
