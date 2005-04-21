# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ladspa-sdk/ladspa-sdk-1.12-r2.ebuild,v 1.14 2005/04/21 19:19:42 hansmi Exp $

inherit eutils

MY_PN=${PN/-/_}
MY_P=${MY_PN}_${PV}

DESCRIPTION="The Linux Audio Developer's Simple Plugin API"
HOMEPAGE="http://www.ladspa.org/"
SRC_URI="http://www.ladspa.org/download/${MY_P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 ppc-macos sparc x86"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

S=${WORKDIR}/${MY_PN}/src

src_unpack() {
	unpack ${A}
	sed -i \
		-e "/^CFLAGS/ s:-O3:${CFLAGS}:" \
		${S}/makefile || die "sed makefile failed (CFLAGS)"
	sed -i \
		-e 's:-mkdirhier:mkdir\ -p:g' \
		${S}/makefile || die "sed makefile failed (mkdirhier)"
	epatch ${FILESDIR}/${P}-test.patch
	use ppc-macos && epatch ${FILESDIR}/${P}-ppc-macos.patch
}

src_compile() {
	emake -j1 targets || die
}

src_test() {
	# needed for sox to allow playback of the test sounds
	addwrite /dev/dsp

	emake test || die
}

src_install() {
	make \
		INSTALL_PLUGINS_DIR=${D}/usr/$(get_libdir)/ladspa \
		INSTALL_INCLUDE_DIR=${D}/usr/include \
		INSTALL_BINARY_DIR=${D}/usr/bin \
		install || die "make install failed"

	cd ../doc && \
		dohtml *.html || die "dohtml failed"

	# Needed for apps like rezound
	dodir /etc/env.d
	echo "LADSPA_PATH=/usr/$(get_libdir)/ladspa" > ${D}/etc/env.d/60ladspa
}
