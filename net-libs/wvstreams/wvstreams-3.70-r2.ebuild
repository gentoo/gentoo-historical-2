# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/wvstreams/wvstreams-3.70-r2.ebuild,v 1.16 2003/11/04 00:49:01 vapier Exp $

inherit flag-o-matic

DESCRIPTION="A network programming library in C++"
HOMEPAGE="http://open.nit.ca/wiki/?page=WvStreams"
SRC_URI="http://open.nit.ca/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc alpha amd64 hppa"

DEPEND="virtual/glibc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-gcc3.patch
	if has_version '>=dev-libs/openssl-0.9.7' ; then
		epatch ${FILESDIR}/${PV}-openssl.patch
	fi
}

src_compile() {
	[ "${ARCH}" = "alpha" -o "${ARCH}" = "hppa" ] && append-flags -fPIC
	append-flags -Wno-deprecated
	emake -j1 || die
}

src_install() {
	make PREFIX=${D}/usr install || die
}
