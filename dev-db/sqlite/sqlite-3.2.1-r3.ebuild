# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqlite/sqlite-3.2.1-r3.ebuild,v 1.5 2005/05/21 08:17:44 corsair Exp $

inherit eutils

DESCRIPTION="SQLite: An SQL Database Engine in a C Library"
HOMEPAGE="http://www.sqlite.org/"
SRC_URI="http://www.sqlite.org/${P}.tar.gz"

LICENSE="as-is"
SLOT="3"
KEYWORDS="~alpha amd64 arm ia64 ~ppc ppc64 ~ppc-macos sparc x86"
IUSE="nothreadsafe doc"

DEPEND="virtual/libc
	doc? ( dev-lang/tcl )"

src_unpack() {
	unpack ${A}

	epatch ${FILESDIR}/${P}-data-corruption.patch
	epatch ${FILESDIR}/${P}-tcl-fix.patch
}

src_compile() {
	local myconf
	myconf="--enable-incore-db --enable-tempdb-in-ram"
	# Yes, this is ridiculous, but I'm not the maintainer for this ebuild,
	#   and yet it's broken w/o thread support, so this has to do for now
	#   - 20041203, Armando Di Cianno <fafhrd@gentoo.org>
	if ! use nothreadsafe; then
		myconf="${myconf} --enable-threadsafe"
	else
		myconf="${myconf} --disable-threadsafe"
	fi
	econf ${myconf} || die
	emake all || die

	if use doc; then
	emake doc
	fi
}

# In case we ever want testing support; note: this needs more work, as
#   as it causes some sandbox issues.
#   - 20041203, Armando Di Cianno <fafhrd@gentoo.org>
#src_test() {
#	cd ${S}
#	emake fulltest || die "some test failed"
#}

src_install () {
	make DESTDIR="${D}" install || die

	dobin lemon
	dodoc README VERSION
	doman sqlite3.1

	if use doc; then
	docinto html
	dohtml doc/*.html doc/*.txt doc/*.png
	fi
}
