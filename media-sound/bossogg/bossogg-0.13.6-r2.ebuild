# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/bossogg/bossogg-0.13.6-r2.ebuild,v 1.8 2007/04/28 15:18:16 tove Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit eutils autotools

IUSE="vorbis mad flac"

DESCRIPTION="Bossogg Music Server"
HOMEPAGE="http://bossogg.wishy.org"
SRC_URI="mirror://sourceforge/bossogg/${P}.tar.gz"

KEYWORDS="x86 sparc amd64"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=media-libs/libao-0.8.3
	media-libs/libshout
	flac? ( ~media-libs/flac-1.1.2 )
	vorbis? ( media-libs/libvorbis )
	mad? ( media-sound/madplay media-libs/id3lib )"

RDEPEND="${DEPEND}
	 dev-python/pysqlite"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}-Makefile.patch
	eautoreconf
}

src_compile() {
	econf --enable-shout \
	      `use_enable vorbis` \
	      `use_enable flac` \
	      `use_enable mad mp3` \
	      `use_enable mad id3` || die "could not configure"

	emake -j1 || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README TODO API

	newinitd "${FILESDIR}"/bossogg.initd bossogg
}

pkg_postinst() {
	enewgroup bossogg
	enewuser bossogg -1 /bin/bash /var/bossogg bossogg -G audio

	if ! [ -d /var/bossogg ]; then
		mkdir /var/bossogg
		chown bossogg:bossogg /var/bossogg
	fi

	elog "After running the /etc/init.d/bossogg service for the first"
	elog "time, /var/bossogg/.bossogg/bossogg.conf will be created."
	elog "Please edit this file and restart the service to setup."
	elog "the server."
}
