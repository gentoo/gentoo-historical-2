# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmirage/libmirage-1.0.0.ebuild,v 1.5 2008/08/22 22:06:05 maekke Exp $

DESCRIPTION="libMirage is a CD-ROM image access library"
HOMEPAGE="http://cdemu.org"
SRC_URI="mirror://sourceforge/cdemu/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND=">=dev-libs/glib-2.6
	>=media-libs/libsndfile-1.0
	>=sys-devel/flex-2.5.33
	sys-devel/bison
	doc? ( dev-util/gtk-doc )"

src_compile() {
	local myconf

	if use doc ; then
		myconf="--enable-gtk-doc"
	fi

	econf ${myconf} || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die "install failed"
	dodoc AUTHORS ChangeLog README TODO
}
