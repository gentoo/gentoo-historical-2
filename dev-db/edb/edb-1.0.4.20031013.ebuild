# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/edb/edb-1.0.4.20031013.ebuild,v 1.1 2003/10/14 02:58:26 vapier Exp $

inherit enlightenment flag-o-matic

DESCRIPTION="Enlightment Data Base"
HOMEPAGE="http://www.enlightenment.org/pages/edb.html"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha"
IUSE="${IUSE} ncurses gtk"

DEPEND="${DEPEND}
	gtk? ( =x11-libs/gtk+-1* )
	ncurses? ( sys-libs/ncurses )"
RDEPEND="virtual/glibc"

S=${WORKDIR}/${PN}

src_compile() {
	cp autogen.sh{,.old}
	sed -e 's:.*configure.*::' autogen.sh.old > autogen.sh
	env WANT_AUTOCONF_2_5=1 ./autogen.sh || die "could not autogen"

	use alpha && append-flags -fPIC

	econf \
		--enable-compat185 \
		--enable-dump185 \
		--enable-cxx \
		--with-gnu-ld \
		|| die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc AUTHORS README
}
