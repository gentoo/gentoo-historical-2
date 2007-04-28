# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/icecast/icecast-2.0.1-r1.ebuild,v 1.10 2007/04/28 16:55:28 swegener Exp $

inherit eutils

DESCRIPTION="An opensource alternative to shoutcast that supports mp3 and ogg streaming"
HOMEPAGE="http://www.icecast.org/"
SRC_URI="http://downloads.xiph.org/releases/icecast/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha amd64 ppc64"
IUSE="curl"

DEPEND="virtual/libc
	dev-libs/libxml2
	dev-libs/libxslt
	>=media-libs/libvorbis-1.0
	>=media-libs/libogg-1.0
	curl? ( <net-misc/curl-7.16.0 )"

src_compile() {
	local myconf=""
	use curl || myconf="${myconf} --disable-yp"
	econf \
		--sysconfdir=/etc/icecast2 \
		${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS README TODO HACKING NEWS

	newinitd ${FILESDIR}/init.d.icecast icecast

	rm -rf ${D}usr/share/doc/icecast
}
