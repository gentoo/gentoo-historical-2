# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/zthread/zthread-2.3.1-r1.ebuild,v 1.1 2005/12/24 00:48:27 ka0ttic Exp $

inherit eutils flag-o-matic

MY_P="ZThread-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="a platform-independent object-oriented threading architecture"
HOMEPAGE="http://www.cs.buffalo.edu/~crahen/projects/zthread/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="debug"

DEPEND="virtual/libc"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-fix-underquoted-m4-defs.diff
	epatch ${FILESDIR}/${P}-fix-ac-arg-enable-debug.diff
	epatch ${FILESDIR}/${P}-respect-DESTDIR.diff
}

src_compile() {
	einfo "Regenerating autoconf/automake files"
	libtoolize --copy --force || die "libtoolize failed"
	aclocal -I share || die "aclocal failed"
	autoheader || die "autoheader failed"
	automake --add-missing --copy || die "automake failed"
	autoconf || die "autoconf failed"


	local myconf
	use debug \
		&& myconf="--enable-debug=yes" \
		|| myconf="--enable-debug=no"

	append-flags -fpermissive

	econf ${myconf} || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS TODO THANK.YOU
}
