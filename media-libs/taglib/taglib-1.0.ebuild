# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/taglib/taglib-1.0.ebuild,v 1.1 2004/02/17 13:37:34 caleb Exp $

inherit flag-o-matic

DESCRIPTION="A library for reading and editing audio meta data"
HOMEPAGE="http://ktown.kde.org/~wheeler/taglib/"
SRC_URI="http://ktown.kde.org/~wheeler/taglib/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~hppa ~amd64"

DEPEND=">=sys-devel/autoconf-2.58"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	rm -rf autom4te.cache
	export WANT_AUTOCONF=2.5
	export WANT_AUTOMAKE=1.7
	aclocal && autoconf && automake || die "autotools failed"
}

src_compile() {
	replace-flags -O3 -O2
	econf || die
	emake || die
}

src_install() {
	make install DESTDIR=${D} destdir=${D} || die
}
