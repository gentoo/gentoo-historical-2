# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/coinor-mp/coinor-mp-1.7.6.ebuild,v 1.1 2014/01/14 22:02:05 bicatali Exp $

EAPI=5

inherit autotools-utils multilib

MYPN=CoinMP

DESCRIPTION="COIN-OR lightweight API for COIN-OR libraries CLP, CBC, and CGL"
HOMEPAGE="https://projects.coin-or.org/CoinMP/"
SRC_URI="http://www.coin-or.org/download/source/${MYPN}/${MYPN}-${PV}.tgz"

LICENSE="EPL-1.0"
SLOT="0/1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples static-libs"

RDEPEND="sci-libs/coinor-cbc:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${MYPN}-${PV}/${MYPN}"

src_prepare() {
	# as-needed fix
	# hack to avoid eautoreconf (coinor has its own weird autotools)
	sed -i \
		-e 's:\(libCoinMP_la_LIBADD.*=.*\)$:\1 @COINMP_LIBS@:' \
		src/Makefile.in || die
	sed -i \
		-e '/addlibsdir/s/$(DESTDIR)//' \
		Makefile.in || die
}

src_configure() {
	PKG_CONFIG_PATH+="${ED}"/usr/$(get_libdir)/pkgconfig \
		autotools-utils_src_configure
}

src_test() {
	pushd "${BUILD_DIR}" > /dev/null || die
	emake test
	popd > /dev/null || die
}

src_install() {
	autotools-utils_src_install
	# already installed
	rm "${ED}"/usr/share/coin/doc/${MYPN}/{README,AUTHORS,LICENSE} || die
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
