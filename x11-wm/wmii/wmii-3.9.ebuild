# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/wmii/wmii-3.9.ebuild,v 1.1 2010/06/07 10:32:19 ssuominen Exp $

EAPI=2
inherit flag-o-matic multilib

MY_P=wmii+ixp-${PV}
PVER=4

DESCRIPTION="A dynamic window manager for X11"
HOMEPAGE="http://wmii.suckless.org/"
SRC_URI="http://dl.suckless.org/wmii/${MY_P}-${PVER}.tbz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

COMMON_DEPEND="x11-libs/libXft
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libX11
	x11-libs/libXinerama
	>=media-libs/freetype-2"
RDEPEND="${COMMON_DEPEND}
	x11-apps/xmessage
	x11-apps/xsetroot
	x11-misc/dmenu
	media-fonts/font-misc-misc"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	mywmiiconf=(
		"PREFIX=/usr"
		"DOC=/usr/share/doc/${PF}"
		"ETC=/etc"
		"LIBDIR=/usr/$(get_libdir)"
		"DESTDIR=${D}"
		)
}

src_compile() {
	append-flags -I/usr/include/freetype2
	emake "${mywmiiconf[@]}" || die
}

src_install() {
	emake "${mywmiiconf[@]}" install || die
	dodoc NEWS NOTES README TODO

	echo wmii > "${T}"/wmii
	exeinto /etc/X11/Sessions
	doexe "${T}"/wmii || die

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop || die
}
