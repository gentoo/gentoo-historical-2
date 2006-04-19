# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/apr/apr-1.2.7.ebuild,v 1.2 2006/04/19 00:55:06 vericgar Exp $

inherit libtool

DESCRIPTION="Apache Portable Runtime Library"
HOMEPAGE="http://apr.apache.org/"
SRC_URI="mirror://apache/apr/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="ipv6 urandom"
RESTRICT="test"

DEPEND=""

src_compile() {
	elibtoolize || die "elibtoolize failed"

	myconf="--datadir=/usr/share/apr-1"

	myconf="${myconf} $(use_enable ipv6)"
	myconf="${myconf} --enable-threads"
	myconf="${myconf} --enable-nonportable-atomics"
	if use urandom; then
		einfo "Using /dev/urandom as random device"
		myconf="${myconf} --with-devrandom=/dev/urandom"
	else
		einfo "Using /dev/random as random device"
		myconf="${myconf} --with-devrandom=/dev/random"
	fi

	econf ${myconf} || die "Configure failed"
	emake || die "Make failed"
}

src_install() {

	make DESTDIR="${D}" install || die "make install failed"

	dodoc CHANGES NOTICE LICENSE
}
