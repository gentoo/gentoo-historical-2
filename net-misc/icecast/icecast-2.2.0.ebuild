# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/icecast/icecast-2.2.0.ebuild,v 1.2 2005/01/23 15:08:36 luckyduck Exp $

IUSE="doc yp"

inherit eutils

DESCRIPTION="An opensource alternative to shoutcast that supports mp3 and ogg streaming"
HOMEPAGE="http://www.icecast.org/"
SRC_URI="http://svn.xiph.org/releases/icecast/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/libxslt
	media-libs/libogg
	media-libs/libvorbis
	yp? ( net-misc/curl )"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${PV}-gentoo.patch || die "Patch failed!"
}

src_compile() {

	econf \
		--sysconfdir=/etc/icecast2 \
		$(use_enable yp) \
		${myconf} || die "configure failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README TODO HACKING NEWS conf/icecast.xml.dist
	use doc && dohtml -A chm,hhc,hhp doc/*

	exeinto /etc/init.d
	newexe ${FILESDIR}/init.d.icecast icecast

	fperms 600 /etc/icecast2/icecast.xml

	rm -rf ${D}/usr/share/doc/icecast
}
