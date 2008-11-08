# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/texmaker/texmaker-1.71-r1.ebuild,v 1.4 2008/11/08 13:37:20 nixnut Exp $

EAPI=1

inherit eutils versionator qt4

DESCRIPTION="A nice LaTeX-IDE"

# The upstream version numbering is bad, so we have to remove a dot in the
# minor version number
MAJOR="$(get_major_version)"
MINOR_1="$(($(get_version_component_range 2)/10))"
MINOR_2="$(($(get_version_component_range 2)%10))"
if [ ${MINOR_2} -eq "0" ] ; then
	MY_P="${PN}-${MAJOR}.${MINOR_1}"
else
	MY_P="${PN}-${MAJOR}.${MINOR_1}.${MINOR_2}"
fi

S="${WORKDIR}/${MY_P}"
HOMEPAGE="http://www.xm1math.net/texmaker/"
SRC_URI="http://www.xm1math.net/texmaker/${MY_P}.tar.bz2"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"

IUSE=""

COMMON_DEPEND="x11-libs/libX11
	x11-libs/libXext
	|| ( ( x11-libs/qt-gui x11-libs/qt-core ) =x11-libs/qt-4.3*:4 )
	>=app-text/hunspell-1.2.2"

RDEPEND="${COMMON_DEPEND}
	virtual/latex-base
	app-text/psutils
	virtual/ghostscript
	media-libs/netpbm"

DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-hunspell.patch"
}

src_compile() {
	eqmake4 texmaker.pro || die "qmake failed"
	emake || die "emake failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "make install failed"

	insinto /usr/share/pixmaps/texmaker
	doins utilities/texmaker*.png || die "doins failed."
	doins utilities/texmaker.svg || die "doins failed."

	dodoc utilities/AUTHORS utilities/CHANGELOG.txt || die "dodoc failed"

	make_desktop_entry texmaker Texmaker "/usr/share/pixmaps/texmaker/texmaker48x48.png" Office
}

pkg_postinst() {
	elog "A user manual with many screenshots is available at:"
	elog "/usr/share/${PN}/usermanual_en.html"
	elog
}
