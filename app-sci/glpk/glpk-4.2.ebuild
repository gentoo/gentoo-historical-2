# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/glpk/glpk-4.2.ebuild,v 1.4 2004/06/24 22:01:12 agriffis Exp $

DESCRIPTION="GNU Linear Programming Kit"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/${PN}/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE="java doc"

RDEPEND="java? ( >=virtual/jdk-1.4* )
		 sys-libs/glibc"
DEPEND=">=sys-devel/gcc-3.2* ${RDEPEND}
		 doc? ( virtual/ghostscript )"

src_unpack() {
	unpack ${A}
	cd ${S}
	sed -e "s:/usr/local/lib:${S}/src:g" -i contrib/jni/c/Makefile \
		|| die "sed failed correcting library path"
}

src_compile() {
	LIBS="${LIBS} -lm" econf --enable-shared || die
	emake || die "emake failed"
	if use java; then
		cd ${S}/contrib/jni
		local extrainclude="-I ${S}/contrib/jni/java -I ${S}/include"
		emake CFLAGS="${CFLAGS} ${extrainclude}"  || die "emake java failed"
	fi
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	# base docs
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
	#examples
	docinto examples

	dodoc ${S}/examples/*
	#docs
	if use doc; then
		cd ${S}/doc
		for i in *.ps; do
			ps2pdf14 ${i}
		done
	fi
	dodoc ${S}/doc/*
	#java
	if use java; then
		cd ${S}/contrib/jni
		dolib c/libglpk_jni.so
		dojar java/glpk.jar
		docinto java
		mv contrib/java/sample/README contrib/java/sample/README.sample
		dodoc contrib/java/README contrib/java/sample/*
	fi
}
