# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krossjava/krossjava-4.6.5.ebuild,v 1.1 2011/07/09 15:14:09 alexxy Exp $

EAPI=4

KMNAME="kdebindings"
KMMODULE="java/krossjava"
inherit java-pkg-2 java-ant-2 kde4-meta eutils

DESCRIPTION="Java plugin for the kdelibs/kross scripting framework."
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

DEPEND="
	>=virtual/jdk-1.5
"
RDEPEND="
	>=virtual/jre-1.5
"

RESTRICT="test"

PATCHES=( "${FILESDIR}/${PN}-4.2.3_includes.patch" )

pkg_setup() {
	kde4-meta_pkg_setup
	java-pkg-2_pkg_setup
}

src_prepare() {
	find "${S}" -iname '*.jar' | xargs rm -v
	kde4-meta_src_prepare
	java-pkg-2_src_prepare
}

src_configure() {
	mycmakeargs=(-DENABLE_KROSSJAVA=ON)
	kde4-meta_src_configure
	java-ant-2_src_configure
}

src_compile() {
	kde4-meta_src_compile
	cd "${S}/java/${PN}/${PN}/java/" || die
	eant makejar
}

src_install() {
	kde4-meta_src_install
	java-pkg_dojar "${ED}/usr/$(get_libdir)/kde4/kross/kross.jar"

	dosym ../../../share/${PN}-${SLOT}/lib/kross.jar \
		/usr/$(get_libdir)/kde4/kross/kross.jar
	java-pkg_regso "${ED}/usr/$(get_libdir)/kde4/libkrossjava.so"
}

pkg_preinst() {
	kde4-meta_pkg_preinst
	java-pkg-2_pkg_preinst
}
