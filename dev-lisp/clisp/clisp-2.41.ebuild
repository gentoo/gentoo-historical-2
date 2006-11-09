# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/clisp/clisp-2.41.ebuild,v 1.1 2006/11/09 04:06:32 mkennedy Exp $

inherit flag-o-matic eutils toolchain-funcs

DESCRIPTION="A portable, bytecode-compiled implementation of Common Lisp"
HOMEPAGE="http://clisp.sourceforge.net/"
SRC_URI="mirror://sourceforge/clisp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~amd64 ~ppc ~ppc-macos -sparc ~x86"
IUSE="X new-clx fastcgi pcre postgres readline zlib"

RDEPEND=">=dev-libs/libsigsegv-2.4
	>=dev-lisp/common-lisp-controller-4.27
	sys-devel/gettext
	virtual/tetex
	fastcgi? ( dev-libs/fcgi )
	postgres? ( >=dev-db/postgresql-8.0 )
	readline? ( sys-libs/readline )
	pcre? ( dev-libs/libpcre )
	zlib? ( sys-libs/zlib )
	X? ( new-clx? ( || ( x11-libs/libXpm virtual/x11 ) ) )"

DEPEND="${RDEPEND}
	X? ( new-clx? ( || ( ( x11-misc/imake x11-proto/xextproto ) virtual/x11 ) ) )"

PROVIDE="virtual/commonlisp"

pkg_setup() {
	if use X; then
		if use new-clx; then
			einfo "CLISP will be built with NEW-CLX support which is a C binding to Xorg libraries."
		else
			einfo "CLISP will be built with MIT-CLX support."
		fi
	fi
}

src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/2.41-fastcgi-Makefile-gentoo.patch
}

src_compile() {
	CC="$(tc-getCC)"
	local myconf="--with-dynamic-ffi
		--with-module=wildcard
		--with-module=rawsock"
	use ppc-macos || myconf="${myconf} --with-module=bindings/glibc"
	use readline || myconf="${myconf} --with-noreadline"
	if use X; then
		if use new-clx; then
			myconf="${myconf} --with-module=clx/new-clx"
		else
			myconf="${myconf} --with-module=clx/mit-clx"
		fi
	fi
	if use postgres; then
		myconf="${myconf} --with-module=postgresql"
		CC="${CC} -I $(pg_config --includedir)"
	fi
	use fastcgi && myconf="${myconf} --with-module=fastcgi"
	use pcre && myconf="${myconf} --with-module=pcre"
	use zlib && myconf="${myconf} --with-module=zlib"
	einfo "Configuring with ${myconf}"
	./configure --prefix=/usr ${myconf} build || die "./configure failed"
	cd build
	./makemake ${myconf} >Makefile
	emake -j1 config.lisp
	sed -i 's,"vi","nano",g' config.lisp
	sed -i 's,http://www.lisp.org/HyperSpec/,http://www.lispworks.com/reference/HyperSpec/,g' config.lisp
	emake -j1 || die
}

src_install() {
	pushd build
	make DESTDIR=${D} prefix=/usr install-bin || die
	doman clisp.1
	dodoc SUMMARY README* NEWS MAGIC.add GNU-GPL COPYRIGHT \
		ANNOUNCE clisp.dvi clisp.html
	chmod a+x ${D}/usr/lib/clisp/clisp-link
	popd
	dohtml doc/impnotes.{css,html}
	dohtml build/clisp.html
	dohtml doc/clisp.png
	dodoc build/clisp.ps
	dodoc doc/{editors,CLOS-guide,LISP-tutorial}.txt
}
