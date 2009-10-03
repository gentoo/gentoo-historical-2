# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/djview4/djview4-4.5.ebuild,v 1.7 2009/10/03 17:15:31 maekke Exp $

EAPI=2

inherit eutils versionator qt4 toolchain-funcs fdo-mime

MY_P=${PN}-$(replace_version_separator 2 '-')

DESCRIPTION="Portable DjVu viewer using Qt4"
HOMEPAGE="http://djvu.sourceforge.net/djview4.html"
SRC_URI="mirror://sourceforge/djvu/${MY_P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc64 x86"
SLOT="0"
IUSE="debug"
RDEPEND="
	>=app-text/djvu-3.5.19
	x11-libs/qt-gui:4
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

S="${WORKDIR}/${PN}-$(get_version_component_range 1-2)"

src_configure() {
	# QTDIR is needed because of kde3
	QTDIR=/usr \
	econf \
		$(use_enable debug) \
		--with-x \
		--disable-nsdejavu \
		--disable-desktopfiles
}

src_compile() {
	emake CC=$(tc-getCC) CXX=$(tc-getCXX) || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	#remove conflicting symlinks
	rm -f "${D}/usr/bin/djview" "${D}/usr/share/man/man1/djview.1"

	dodoc README TODO NEWS || die "dodoc failed"

	cd desktopfiles
	insinto /usr/share/icons/hicolor/32x32/apps
	newins hi32-djview4.png djvulibre-djview4.png
	insinto /usr/share/icons/hicolor/scalable/apps
	newins djview.svg djvulibre-djview4.svg
	domenu djvulibre-djview4.desktop
}

pkg_postinst() {
	fdo-mime_desktop_database_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
}
