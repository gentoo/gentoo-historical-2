# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/amarok/amarok-1.4.1-r2.ebuild,v 1.2 2006/07/20 17:59:01 corsair Exp $

LANGS="az bg br ca cs cy da de el en_GB es et fi fr ga gl he hi hu is it ja ka
km ko lt ms nb nl nn pa pl pt pt_BR ro ru rw sl sr sr@Latn sv ta tg th tr uk uz
zh_CN zh_TW"
LANGS_DOC="da de es et fr it nl pt pt_BR ru sv"

USE_KEG_PACKAGING=1

inherit kde eutils flag-o-matic

PKG_SUFFIX=""

MY_PV="${PV/_rc/_RC}"
MY_PV="${MY_PV/_beta/-beta}${PKG_SUFFIX}"
MY_BASE_PV="${MY_PV/_RC*/}"
MY_BASE_PV="${MY_BASE_PV/-beta*/}"
S="${WORKDIR}/${PN}-${MY_PV}"

DESCRIPTION="Advanced audio player based on KDE framework."
HOMEPAGE="http://amarok.kde.org/"

SRC_URI="mirror://sourceforge/amarok/${PN}-${MY_PV}.tar.bz2"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="aac kde mysql noamazon opengl postgres
xmms visualization musicbrainz ipod ifp real njb"
# kde: enables compilation of the konqueror sidebar plugin

DEPEND="kde? ( || ( kde-base/konqueror kde-base/kdebase ) )
	>=media-libs/xine-lib-1.1.2_pre20060328-r8
	musicbrainz? ( >=media-libs/tunepimp-0.3 )
	>=media-libs/taglib-1.4
	mysql? ( >=dev-db/mysql-4.0.16 )
	postgres? ( dev-db/postgresql )
	opengl? ( virtual/opengl )
	xmms? ( >=media-sound/xmms-1.2 )
	visualization? ( media-libs/libsdl
					 =media-plugins/libvisual-plugins-0.4* )
	ipod? ( media-libs/libgpod )
	aac? ( media-libs/libmp4v2 )
	ifp? ( media-libs/libifp )
	real? ( media-video/realplayer )
	njb? ( >=media-libs/libnjb-2.2.4 )"

RDEPEND="${DEPEND}
	dev-lang/ruby"

DEPEND="${DEPEND}
	>=dev-util/pkgconfig-0.9.0"

need-kde 3.3

src_compile() {
	export WANT_AUTOMAKE="1.9" # Force usage of automake 1.9 for safety
	append-flags -fno-inline

	# Extra, unsupported engines are forcefully disabled.
	local myconf="$(use_enable mysql) $(use_enable postgres postgresql)
				  $(use_with opengl) $(use_with xmms)
				  $(use_with visualization libvisual)
				  $(use_enable !noamazon amazon)
				  $(use_with musicbrainz)
				  $(use_with ipod libgpod)
				  $(use_with aac mp4v2)
				  $(use_with ifp)
				  $(use_with real helix)
				  $(use_with njb libnjb)
				  --with-xine
				  --without-mas
				  --without-nmm"

	kde_src_compile
}

src_install() {
	kde_src_install

	mv "${D}/usr/share/services/lastfm.protocol" \
		"${D}/usr/share/services/amaroklastfm.protocol"
}