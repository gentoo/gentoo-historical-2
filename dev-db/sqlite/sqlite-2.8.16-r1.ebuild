# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqlite/sqlite-2.8.16-r1.ebuild,v 1.2 2005/04/04 13:34:43 gustavoz Exp $

inherit eutils toolchain-funcs

IUSE="nls"

DESCRIPTION="SQLite: An SQL Database Engine in a C Library."
SRC_URI="http://www.sqlite.org/${P}.tar.gz"
HOMEPAGE="http://www.sqlite.org"
DEPEND="virtual/libc
	dev-lang/tcl"
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 ~ppc sparc ~alpha ~arm ~mips ~hppa ~ppc64 amd64 ~ppc-macos"

src_unpack() {
	unpack ${A}

	use hppa && epatch ${FILESDIR}/${PN}-2.8.15-alignement-fix.patch

	epatch ${FILESDIR}/${P}-multilib.patch

	if use nls; then
		ENCODING=${ENCODING-"UTF8"}
	else
		ENCODING="ISO8859"
	fi

	sed -i -e "s:@@S@@:${S}:g" \
	       -e "s:@@CC@@:$(tc-getCC):g" \
	       -e "s:@@CFLAGS@@:${CFLAGS}:g" \
	       -e "s:@@AR@@:$(tc-getAR):g" \
	       -e "s:@@RANLIB@@:$(tc-getRANLIB):g" \
	       -e "s:@@ENCODING@@:${ENCODING}:g" \
	       ${S}/Makefile.linux-gcc
}

src_compile() {
	local myconf
	myconf="--enable-incore-db --enable-tempdb-in-ram"
	myconf="${myconf} `use_enable nls utf8`"
	econf ${myconf} || die
	emake all doc || die

	cp -P ${FILESDIR}/maketcllib.sh ${S}
	chmod +x ./maketcllib.sh
	./maketcllib.sh
}

src_install () {
	dodir /usr/{bin,include,$(get_libdir)}

	make DESTDIR="${D}" install || die

	dobin lemon
	dodoc README VERSION
	doman sqlite.1
	docinto html
	dohtml doc/*.html doc/*.txt doc/*.png

	mkdir ${D}/usr/lib/tclsqlite${PV}
	cp ${S}/tclsqlite.so ${D}/usr/lib/tclsqlite${PV}/
	cp ${S}/pkgIndex.tcl ${D}/usr/lib/tclsqlite${PV}/
}
