# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/libnasl/libnasl-2.3.0.ebuild,v 1.5 2005/02/16 00:51:04 ka0ttic Exp $

inherit toolchain-funcs

DESCRIPTION="A remote security scanner for Linux (libnasl)"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="ftp://ftp.nessus.org/pub/nessus/nessus-${PV}/src/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64 ~ppc64"
IUSE="doc"

RDEPEND="=net-analyzer/nessus-libraries-${PV}"
DEPEND="${RDEPEND}
	doc? ( virtual/tetex )"

S=${WORKDIR}/${PN}

src_compile() {
	export CC=$(tc-getCC)
	econf || die "configuration failed"
	# emake fails for >= -j2. bug #16471.
	emake -C nasl cflags
	emake || die "make failed"
	if use doc; then
		cd doc
		pdflatex nasl_guide.tex
	fi
}

src_install() {
	emake DESTDIR=${D} install || die "Install failed libnasl"
	dodoc COPYING
	if use doc; then
		dodoc doc/nasl_guide.pdf
	fi
}
