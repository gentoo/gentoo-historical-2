# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmirage/libmirage-1.2.0.ebuild,v 1.2 2010/01/16 17:37:10 fauli Exp $

EAPI="2"

DESCRIPTION="libMirage is a CD-ROM image access library"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="doc"

RDEPEND="sys-libs/zlib
	>=dev-libs/glib-2.6:2
	>=media-libs/libsndfile-1.0"
DEPEND="${RDEPEND}
	>=sys-devel/flex-2.5.33
	sys-devel/bison
	doc? ( dev-util/gtk-doc )"

src_configure() {
	econf \
		$(use_enable doc gtk-doc)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog README
}
