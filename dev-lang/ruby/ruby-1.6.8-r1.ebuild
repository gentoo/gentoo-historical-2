# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/ruby/ruby-1.6.8-r1.ebuild,v 1.3 2003/08/01 03:23:26 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="An object-oriented scripting language"
SRC_URI="mirror://ruby/${PV%.*}/${P/_pre/-preview}.tar.gz"
HOMEPAGE="http://www.ruby-lang.org/"
LICENSE="Ruby"
KEYWORDS="x86 alpha ppc sparc hppa amd64"
SLOT="0"

inherit flag-o-matic
filter-flags -fomit-frame-pointer

DEPEND=">=sys-libs/glibc-2.1.3
	>=sys-libs/gdbm-1.8.0
	>=sys-libs/readline-4.1
	>=sys-libs/ncurses-5.2"

src_unpack() {
	unpack ${A}

	cd ${S}
	use amd64 && epatch ${FILESDIR}/ruby-1.6.8-fix-x86_64.patch
}

src_compile() {
	econf --enable-shared
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc COPYING* ChangeLog MANIFEST README* ToDo
}
