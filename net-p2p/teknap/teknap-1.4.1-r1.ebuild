# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/teknap/teknap-1.4.1-r1.ebuild,v 1.6 2006/11/13 14:55:42 flameeyes Exp $

inherit eutils

IUSE="gtk ipv6 tcpd"

DESCRIPTION="TekNap is a console Napster/OpenNap client"
SRC_URI="http://www.cactuz.org/jnbek/teknap/TekNap-1.4.orig.tar.gz
	 http://www.cactuz.org/jnbek/teknap/TekNap-1.4-1.diff.gz"
HOMEPAGE="http://www.cactuz.org/jnbek/teknap"

SLOT="0"
KEYWORDS="x86 ~ppc ~amd64 ~sparc"
LICENSE="as-is"

DEPEND="virtual/libc
	>=sys-libs/ncurses-5.2
	gtk? ( =x11-libs/gtk+-1.2* )
	tcpd? ( sys-apps/tcp-wrappers )"

S=${WORKDIR}/${PN}-1.4

src_unpack() {
	unpack TekNap-1.4.orig.tar.gz
	epatch ${DISTDIR}/TekNap-1.4-1.diff.gz
	epatch ${FILESDIR}/teknap-1.4-gcc3.3.patch
	epatch ${FILESDIR}/teknap-1.4-gcc3.4.patch
}

src_compile() {
	econf `use_enable tcpd wrap` \
	      `use_enable ipv6` \
	      `use_enable gtk` \
		  --disable-xmms \
	      --enable-cdrom || die
	make || die
}

src_install () {
	einstall datadir=${D}/usr/share/TekNap install || die
	rm ${D}/usr/bin/TekNap
	dosym TekNap-1.4 /usr/bin/TekNap
	dodoc COPYRIGHT README TODO Changelog doc/*.txt doc/TekNap.faq doc/bugs doc/link-guidelines doc/macosx.notes
	doman TekNap.1
}
