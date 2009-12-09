# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/gprolog/gprolog-1.3.1.ebuild,v 1.4 2009/12/09 19:34:01 nixnut Exp $

inherit eutils flag-o-matic

DESCRIPTION="GNU Prolog is a native Prolog compiler with constraint solving over finite domains (FD)"
HOMEPAGE="http://www.gprolog.org/"
SRC_URI="ftp://ftp.gnu.org/gnu/gprolog/${P}.tar.gz"
S="${WORKDIR}"/${P}/src

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug doc examples"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-CFLAGS_MACHINE.patch
	epatch "${FILESDIR}"/${P}-TXT_FILES.patch
}

src_compile() {
	CFLAGS_MACHINE="`get-flag -march` `get-flag -mcpu` `get-flag -mtune`"

	append-flags -fno-strict-aliasing
	use debug && append-flags -DDEBUG

	econf \
		CFLAGS_MACHINE="${CFLAGS_MACHINE}" \
		--with-c-flags="${CFLAGS}" \
		--with-install-dir="${D}"/usr \
		--with-doc-dir="${D}"/usr/share/doc/${PF} \
		--with-html-dir="${D}"/usr/share/doc/${PF}/html \
		--with-examples-dir="${D}"/usr/share/doc/${PF}/examples \
		|| die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make install-system || die "make install-system failed"

	if use doc; then
		make install-html || die "make install-html failed"
	fi
	if use examples; then
		make install-examples || die "make install-examples failed"
	fi

	cd "${S}"/..
	dodoc ChangeLog NEWS PROBLEMS README VERSION
}
