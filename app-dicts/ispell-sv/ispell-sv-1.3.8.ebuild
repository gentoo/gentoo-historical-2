# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ispell-sv/ispell-sv-1.3.8.ebuild,v 1.6 2004/05/31 18:17:14 vapier Exp $

DESCRIPTION="The Swedish dictionary for ispell"
HOMEPAGE="http://sv.speling.org"
SRC_URI="http://sv.speling.org/filer/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha hppa"
IUSE=""

DEPEND="app-text/ispell"

src_compile() {
	# It's important that we export the TMPDIR environment variable,
	# so we don't commit sandbox violations
	export TMPDIR=/tmp
	emake || die
	unset TMPDIR
}

src_install() {
	insinto /usr/lib/ispell
	doins svenska.aff svenska.hash
	dodoc README contributors
}
