# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/icecast/icecast-2.0_pre20030929.ebuild,v 1.1 2003/09/30 11:25:47 jje Exp $

IUSE="oggvorbis curl"

inherit eutils

DESCRIPTION="An opensource alternative to shoutcast that supports mp3 and ogg streaming"
HOMEPAGE="http://www.icecast.org/"
SRC_URI="mirror://gentoo/icecast-2.0-alpha-2-20030929.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND="virtual/glibc
	dev-libs/libxml2
	dev-libs/libxslt
	oggvorbis? ( >=media-libs/libvorbis-1.0
		>=media-libs/libogg-1.0 )
	curl? ( net-ftp/curl )"

S=${WORKDIR}/icecast-2.0-alpha-2

src_compile() {
	local myconf="--with-gnu-ld"

	use oggvorbis || myconf="${myconf} --without-ogg --without-vorbis"

	use curl || myconf="${myconf} --disable-yp"

	econf \
		--sysconfdir=/etc/icecast2 \
		${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"

	dodoc AUTHORS README TODO HACKING NEWS

	rm -rf ${D}usr/share/doc/icecast
}
