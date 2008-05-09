# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/arj/arj-3.10.22-r2.ebuild,v 1.2 2008/05/09 12:14:41 drac Exp $

inherit autotools eutils toolchain-funcs

PATCH_LEVEL=4

DESCRIPTION="Utility for opening arj archives"
HOMEPAGE="http://arj.sourceforge.net"
SRC_URI="mirror://debian/pool/main/a/arj/${P/-/_}.orig.tar.gz
	mirror://debian/pool/main/a/arj/${P/-/_}-${PATCH_LEVEL}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${WORKDIR}"/${P/-/_}-${PATCH_LEVEL}.diff
	EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" \
		epatch debian/patches

	cd gnu
	eautoconf
}

src_compile() {
	cd gnu
	CFLAGS="${CFLAGS}" econf

	cd "${S}"
	sed -i -e '/stripgcc/d' GNUmakefile || die "sed failed."

	ARJLIBDIR="/usr/$(get_libdir)"

	emake CC=$(tc-getCC) libdir="${ARJLIBDIR}" \
		pkglibdir="${ARJLIBDIR}" all || die "emake failed."
}

src_install() {
	emake pkglibdir="${ARJLIBDIR}" \
		DESTDIR="${D}" install || die "emake install failed."

	dodoc doc/rev_hist.txt
}
