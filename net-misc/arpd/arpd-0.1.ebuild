# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/arpd/arpd-0.1.ebuild,v 1.2 2003/01/08 05:36:12 jrray Exp $

DESCRIPTION="ARP reply daemon enables a single host to claim all unassigned addresses on a LAN for network monitoring or simulation"
HOMEPAGE="http://www.citi.umich.edu/u/provos/honeyd/"
SRC_URI="http://www.citi.umich.edu/u/provos/honeyd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"

IUSE=""
DEPEND=">=libdnet-1.4
	>=libevent-0.6
	>=libpcap-0.7.1"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd ${S}

	mv configure configure.orig || die
	sed -e 's|$withval/lib/libevent.a; then||' \
		-e 's|if test -f $withval/include/event.h -a -f|if test -f $withval/include/event.h -a -f $withval/lib/libevent.a; then|' \
		configure.orig > configure || die
	chmod +x configure
}

src_compile() {
	econf --with-libdnet=/usr --with-libevent=/usr || die "configure failed"
	emake || die
}

src_install() {
	dosbin arpd
	doman arpd.8
}
