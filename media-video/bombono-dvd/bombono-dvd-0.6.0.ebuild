# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/bombono-dvd/bombono-dvd-0.6.0.ebuild,v 1.2 2010/09/17 23:32:52 dilfridge Exp $

EAPI=2

inherit base toolchain-funcs

DESCRIPTION="GUI DVD authoring program"
HOMEPAGE="http://www.bombono.org/"
SRC_URI="mirror://sourceforge/bombono/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=x11-libs/gtk+-2.8
	>=dev-cpp/gtkmm-2.4
	>=media-gfx/graphicsmagick-1.1.7
	>=media-video/mjpegtools-1.8.0
	media-libs/libdvdread
	media-video/dvdauthor
	app-cdr/dvd+rw-tools
	media-sound/twolame
	dev-cpp/libxmlpp:2.6"

DEPEND=">=dev-util/scons-0.96.1
	${RDEPEND}"

src_compile() {
	# scons options differ from make options -> remove everything except "-jX" and "-j X"
	local sconsopts=$(echo "${MAKEOPTS}" | sed -ne "/-j/ { s/.*\(-j[[:space:]]*[0-9]\+\).*/\1/; p }")

	scons CC="$(tc-getCC)" CXX="$(tc-getCXX)" CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}" ${sconsopts} DESTDIR="${D}" PREFIX="/usr" \
		|| die 'Please add "${S}/config.opts" when filing bugs reports!'
}

src_install() {
	scons install || die 'Please add "${S}/config.opts" when filing bugs reports!'
}
