# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/flac/flac-1.2.1-r5.ebuild,v 1.1 2013/05/01 21:40:00 mgorny Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
WANT_AUTOMAKE=1.12
inherit autotools-multilib

DESCRIPTION="free lossless audio encoder and decoder"
HOMEPAGE="http://flac.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://gentoo/${P}-embedded-m4.tar.bz2"

LICENSE="BSD FDL-1.2 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="3dnow altivec +cxx debug doc ogg sse static-libs"

RDEPEND="ogg? ( >=media-libs/libogg-1.1.3[${MULTILIB_USEDEP}] )
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-soundlibs-20130224 )"
DEPEND="${RDEPEND}
	abi_x86_32? ( dev-lang/nasm )
	!elibc_uclibc? ( sys-devel/gettext )
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-asneeded.patch
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-asm.patch
	"${FILESDIR}"/${P}-dontbuild-tests.patch
	"${FILESDIR}"/${P}-dontbuild-examples.patch
	"${FILESDIR}"/${P}-gcc-4.3-includes.patch
	"${FILESDIR}"/${P}-ogg-m4.patch
)

src_prepare() {
	cp "${WORKDIR}"/*.m4 m4 || die

	# html docgen seems to cause trouble
	sed -i -e '/SUBDIRS/s:html::' doc/Makefile.am || die

	AT_M4DIR="m4" \
	autotools-multilib_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable sse)
		$(use_enable 3dnow)
		$(use_enable altivec)
		--disable-doxygen-docs
		--disable-xmms-plugin
		$(use_enable cxx cpplibs)
		$(use_enable ogg)
		--disable-examples
	)
	autotools-multilib_src_configure
}

src_test() {
	if [[ ${UID} != 0 ]]; then
		autotools-multilib_src_test
	else
		ewarn "Tests will fail if ran as root, skipping."
	fi
}

src_install() {
	use doc && local HTML_DOCS=( doc/html/. )

	autotools-multilib_src_install

	rm -rf "${D}"/usr/share/doc/${P}
}
