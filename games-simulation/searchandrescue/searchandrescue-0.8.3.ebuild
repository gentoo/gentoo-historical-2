# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-simulation/searchandrescue/searchandrescue-0.8.3.ebuild,v 1.1 2010/03/10 00:58:58 mr_bones_ Exp $

EAPI=2
inherit eutils games

MY_PN=SearchAndRescue
DESCRIPTION="Helicopter based air rescue flight simulator"
HOMEPAGE="http://searchandrescue.sourceforge.net/"
SRC_URI="mirror://sourceforge/searchandrescue/${MY_PN}-${PV}.tar.gz
	mirror://sourceforge/searchandrescue/${MY_PN}-data-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="joystick"

RDEPEND="x11-libs/libXxf86vm
	x11-libs/libXmu
	x11-libs/libXi
	x11-libs/libXpm
	virtual/opengl
	virtual/glu
	media-libs/yiff
	joystick? ( media-libs/libjsw )"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xf86vidmodeproto"

S=${WORKDIR}/${PN}_${PV}

src_unpack() {
	unpack ${MY_PN}-${PV}.tar.gz
	mkdir data ; cd data
	unpack ${MY_PN}-data-${PV}.tgz
}

src_prepare() {
	sed -i \
		-e 's/make /$(MAKE) /' \
		Makefile \
		|| die "sed failed"
	bunzip2 sar/man/${MY_PN}.6.bz2
}

src_configure() {
	local myconf

	use joystick \
		&& myconf="--enable=libjsw" \
		|| myconf="--disable=libjsw"

	# NOTE: not an autoconf script
	./configure Linux \
		--prefix="${GAMES_PREFIX}" \
		${myconf} \
		|| die
}

src_install() {
	dogamesbin sar/${MY_PN} || die "dogamesbin failed"
	doman sar/man/${MY_PN}.6
	insinto /usr/share/icons/
	doins sar/icons/*.{ico,xpm}
	dodoc AUTHORS HACKING README
	newicon sar/icons/SearchAndRescue.xpm ${PN}.xpm
	cd "${WORKDIR}/data"
	dodir "${GAMES_DATADIR}/${PN}"
	cp -r * "${D}/${GAMES_DATADIR}/${PN}/" || die "cp failed"
	make_desktop_entry SearchAndRescue "SearchAndRescue" \
		/usr/share/pixmaps/${PN}.xpm
	prepgamesdirs
}
