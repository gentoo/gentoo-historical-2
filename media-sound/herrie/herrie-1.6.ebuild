# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/herrie/herrie-1.6.ebuild,v 1.2 2007/04/17 21:21:02 rbu Exp $

inherit eutils toolchain-funcs

DESCRIPTION="Herrie is a command line music player."
HOMEPAGE="http://herrie.info/"
SRC_URI="http://herrie.info/distfiles/${P}.tar.bz2"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ao http modplug mp3 scrobbler sdl sndfile vorbis xspf linguas_nl linguas_tr linguas_de"

DEPEND="sys-libs/ncurses
	>=dev-libs/glib-2.0
	ao? ( media-libs/libao )
	http? ( net-misc/curl )
	modplug? ( media-libs/libmodplug )
	mp3? ( media-libs/libmad
		media-libs/libid3tag )
	scrobbler? ( net-misc/curl
		dev-libs/openssl )
	sdl? ( media-libs/libsdl )
	sndfile? ( media-libs/libsndfile )
	vorbis? ( media-libs/libvorbis )
	xspf? ( >=media-libs/libspiff-0.6.5 )"
RDEPEND="${DEPEND}"
DEPEND="sys-devel/gettext
	dev-util/pkgconfig"

pkg_setup() {
	if use sdl && ! use ao ; then
		ewarn "Please be aware that SDL support in Herrie is highly experimental. Use it at your own risk."
	fi
	if use sdl && use ao ; then
		ewarn "You cannot use SDL and ao at the same time, using ao."
	fi
}

src_unpack() {
	unpack "${A}"
	cd "${S}"

	epatch "${FILESDIR}/${PN}-1.5.1-chost.patch"
}

src_compile() {
	local EXTRA_CONF="verbose"
	use ao && EXTRA_CONF="${EXTRA_CONF} ao"
	use http || EXTRA_CONF="${EXTRA_CONF} no_http"
	use mp3 || EXTRA_CONF="${EXTRA_CONF} no_mp3"
	use modplug || EXTRA_CONF="${EXTRA_CONF} no_modplug"
	use scrobbler || EXTRA_CONF="${EXTRA_CONF} no_scrobbler"
	use sdl && ! use ao && EXTRA_CONF="${EXTRA_CONF} sdl"
	use sndfile || EXTRA_CONF="${EXTRA_CONF} no_sndfile"
	use vorbis || EXTRA_CONF="${EXTRA_CONF} no_vorbis"
	use xspf || EXTRA_CONF="${EXTRA_CONF} no_xspf"

	CC="$(tc-getCC)" PREFIX=/usr MANDIR=/usr/share/man ./configure ${EXTRA_CONF} || die "configure failed"
	emake || die "make failed"
}

src_install() {
	dobin herrie
	doman herrie.1

	dodoc README ChangeLog

	insinto /etc
	newins herrie.conf.sample herrie.conf

	use linguas_nl && domo nl.mo
	use linguas_tr && domo tr.mo
	use linguas_de && domo de.mo
}
