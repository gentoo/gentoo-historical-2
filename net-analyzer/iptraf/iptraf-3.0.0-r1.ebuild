# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/iptraf/iptraf-3.0.0-r1.ebuild,v 1.1 2006/01/29 13:47:36 jokey Exp $

inherit eutils

DESCRIPTION="IPTraf is an ncurses-based IP LAN monitor"
HOMEPAGE="http://iptraf.seul.org/"
SRC_URI="ftp://iptraf.seul.org/pub/iptraf/${P}.tar.gz
	mirror://gentoo/${P}-ipv6.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="ipv6"

DEPEND=">=sys-libs/ncurses-5.2-r1"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	epatch ${FILESDIR}/${P}-atheros.patch
	epatch ${FILESDIR}/${P}-build.patch
	epatch ${FILESDIR}/${P}-linux-headers.patch
	epatch ${FILESDIR}/${P}-bnep.patch
	epatch ${FILESDIR}/${P}-Makefile.patch
	sed -i \
		-e 's:/var/local/iptraf:/var/lib/iptraf:g' \
		-e "s:Documentation/:/usr/share/doc/${PF}:g" \
		Documentation/*.* || die "sed doc paths"
	if use ipv6 ; then
	    epatch ${DISTDIR}/${P}-ipv6.patch.bz2
	fi
}

src_compile() {
	emake -C src || die
}

src_install() {
	dosbin src/{iptraf,rawtime,rvnamed} || die
	dodoc FAQ README* CHANGES RELEASE-NOTES
	doman Documentation/*.8
	dohtml -r Documentation/*
	keepdir /var/{lib,run,log}/iptraf
}
