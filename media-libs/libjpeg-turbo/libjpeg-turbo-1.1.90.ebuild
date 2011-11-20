# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libjpeg-turbo/libjpeg-turbo-1.1.90.ebuild,v 1.1 2011/11/20 06:57:15 ssuominen Exp $

EAPI=4
inherit flag-o-matic java-pkg-opt-2 libtool toolchain-funcs

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="http://libjpeg-turbo.virtualgl.org/ http://sourceforge.net/projects/libjpeg-turbo/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://debian/pool/main/libj/libjpeg8/libjpeg8_8c-2.debian.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="java static-libs"

ASM_DEPEND="|| ( dev-lang/nasm dev-lang/yasm )"
COMMON_DEPEND="!media-libs/jpeg:0"
RDEPEND="${COMMON_DEPEND}
	java? ( >=virtual/jre-1.5 )"
DEPEND="${COMMON_DEPEND}
	amd64? ( ${ASM_DEPEND} )
	x86? ( ${ASM_DEPEND} )
	amd64-linux? ( ${ASM_DEPEND} )
	x86-linux? ( ${ASM_DEPEND} )
	java? ( >=virtual/jdk-1.5 )"

src_prepare() {
	elibtoolize

	java-pkg-opt-2_src_prepare
}

src_configure() {
	if use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	econf \
		$(use_enable static-libs static) \
		--with-jpeg8 \
		$(use_with java)
}

src_compile() {
	local _java_makeopts
	use java && _java_makeopts="-j1"
	emake ${_java_makeopts}

	cd ../debian/extra || die
	emake CC="$(tc-getCC)" CFLAGS="${LDFLAGS} ${CFLAGS}"
}

src_test() {
	emake test
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -exec rm -f {} +

	dodoc ChangeLog.txt example.c README-turbo.txt

	if use java; then
		docinto java
		dodoc java/README
		rm -rf "${ED}"usr/classes
		java-pkg_dojar java/turbojpeg.jar
	fi

	cd ../debian/extra || die
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" \
		INSTALL="install -m755" INSTALLDIR="install -d -m755" \
		install
}
