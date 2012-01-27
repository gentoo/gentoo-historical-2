# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libjpeg-turbo/libjpeg-turbo-1.1.90_p20120128.ebuild,v 1.2 2012/01/27 23:06:18 ssuominen Exp $

EAPI=4
JPEG_ABI=8
inherit autotools java-pkg-opt-2 libtool toolchain-funcs

DESCRIPTION="MMX, SSE, and SSE2 SIMD accelerated JPEG library"
HOMEPAGE="http://libjpeg-turbo.virtualgl.org/ http://sourceforge.net/projects/libjpeg-turbo/"

if [[ ${PV} == *_p20* ]]; then
	SRC_URI="http://dev.gentoo.org/~ssuominen/${P}.tar.xz"
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
fi
SRC_URI="${SRC_URI}
	mirror://debian/pool/main/libj/libjpeg${JPEG_ABI}/libjpeg${JPEG_ABI}_${JPEG_ABI}c-2.debian.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86 ~amd64-linux ~x86-linux"
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

DOCS="*.txt change.log example.c README"

src_prepare() {
	eautoreconf
	#elibtoolize # note: for fbsd and prefix
	java-pkg-opt-2_src_prepare
}

src_configure() {
	if use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		export JNI_CFLAGS="$(java-pkg_get-jni-cflags)"
	fi

	econf \
		$(use_enable static-libs static) \
		--with-jpeg${JPEG_ABI} \
		$(use_with java)
}

src_compile() {
	local _java_makeopts
	use java && _java_makeopts="-j1"
	emake ${_java_makeopts}

	ebegin "Building exifautotran and jpegexiforient extra tools"
	pushd ../debian/extra >/dev/null
	emake CC="$(tc-getCC)" CFLAGS="${LDFLAGS} ${CFLAGS}"
	popd >/dev/null
	eend $?
}

src_test() {
	emake test
}

src_install() {
	default
	find "${ED}"usr -name '*.la' -exec rm -f {} +

	insinto /usr/share/doc/${PF}/html
	doins -r doc/html/*

	if use java; then
		insinto /usr/share/doc/${PF}/html/java
		doins -r java/doc/*
		newdoc java/README README.java

		rm -rf "${ED}"usr/classes
		java-pkg_dojar java/turbojpeg.jar
	fi

	ebegin "Installing exifautotran and jpegexiforient extra tools"
	pushd ../debian/extra >/dev/null
	newdoc ../changelog changelog.debian

	emake \
		DESTDIR="${D}" prefix="${EPREFIX}"/usr \
		INSTALL="install -m755" INSTALLDIR="install -d -m755" \
		install
	popd >/dev/null
	eend $?
}
