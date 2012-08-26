# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/icecast/icecast-2.3.3.ebuild,v 1.7 2012/08/26 14:12:48 armin76 Exp $

EAPI=4
inherit eutils autotools

DESCRIPTION="An opensource alternative to shoutcast that supports mp3, ogg (vorbis/theora) and aac streaming"
HOMEPAGE="http://www.icecast.org/"
SRC_URI="http://downloads.xiph.org/releases/icecast/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~x86-fbsd"
IUSE="kate +speex +ssl +theora +yp"

#Although there is a --with-ogg and --with-orbis configure option, they're
#only useful for specifying paths, not for disabling.
DEPEND="dev-libs/libxslt
	dev-libs/libxml2
	media-libs/libogg
	media-libs/libvorbis
	kate? ( media-libs/libkate )
	speex? ( media-libs/speex )
	theora? ( media-libs/libtheora )
	yp? ( net-misc/curl )
	ssl? ( dev-libs/openssl )"

pkg_setup() {
	enewuser icecast -1 -1 -1 nogroup
}

src_prepare() {
	# bug #368539
	epatch "${FILESDIR}"/${P}-libkate.patch
	# bug #430434
	epatch "${FILESDIR}"/${P}-fix-xiph_openssl.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--sysconfdir=/etc/icecast2 \
		$(use_enable kate) \
		$(use_with theora) \
		$(use_with speex) \
		$(use_with yp curl) \
		$(use_with ssl openssl) \
		$(use_enable yp)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README TODO HACKING NEWS conf/icecast.xml.dist
	dohtml -A chm,hhc,hhp doc/*
	doman debian/icecast2.1

	newinitd "${FILESDIR}"/init.d.icecast icecast

	insinto /etc/icecast2
	doins "${FILESDIR}"/icecast.xml
	fperms 600 /etc/icecast2/icecast.xml

	diropts -m0764 -o icecast -g nogroup
	dodir /var/log/icecast
	keepdir /var/log/icecast
	rm -rf "${D}"/usr/share/doc/icecast
}

pkg_postinst() {
	touch "${ROOT}"var/log/icecast/{access,error}.log
	chown icecast:nogroup "${ROOT}"var/log/icecast/{access,error}.log
}
