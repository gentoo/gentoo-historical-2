# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/ode/ode-0.5-r2.ebuild,v 1.7 2005/10/22 05:54:55 vapier Exp $

inherit eutils

DESCRIPTION="Open Dynamics Engine SDK"
HOMEPAGE="http://ode.org/"
SRC_URI="mirror://sourceforge/opende/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc debug double-precision"

DEPEND="virtual/x11
	virtual/glu
	virtual/opengl"

config_use() {
	use $1 && echo $2 || echo $3
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	echo 'C_FLAGS+=$(E_CFLAGS) -fPIC' >> config/makefile.unix-gcc
	epatch "${FILESDIR}"/${PV}-PIC.patch
	sed -i -e "s/..\/..\/drawstuff\/textures/\/usr\/share\/${P}\/examples/" ode/test/*.c*
	sed -i -e "s/fn.path_to_textures = 0/fn.path_to_textures = \"\/usr\/share\/${P}\/examples\"/" drawstuff/dstest/dstest.cpp
	sed -i \
		-e "s/#OPCODE_DIRECTORY/OPCODE_DIRECTORY/" \
		-e "/^BUILD=/s:=.*:=$(config_use debug debug release):" \
		-e "/^PRECISION=/s:=.*:=$(config_use double-precision DOUBLE SINGLE):" \
		"${S}"/config/user-settings
}

src_compile() {
	emake \
		-j1 \
		E_CFLAGS="${CFLAGS}" \
		PLATFORM=unix-gcc \
		|| die "emake failed"
}

src_install() {
	insinto /usr/include/ode
	doins include/ode/*.h || die "doins failed"
	dolib lib/libode.a lib/libdrawstuff.a || die "dolib failed"
	dodir /usr/share/${P}/config
	insinto /usr/share/${P}/config
	doins config/user-settings
	if use doc; then
		dodoc README CHANGELOG ode/doc/ode.pdf
		dohtml ode/doc/ode.html
		dodir /usr/share/doc/${PF}/html/pix/
		insinto /usr/share/doc/${PF}/html/pix/
		doins ode/doc/pix/*.jpg
		# install examples
		dodir /usr/share/${PF}/examples
		exeinto /usr/share/${PF}/examples
		doexe ode/test/*.exe
		doexe drawstuff/dstest/dstest.exe
		insinto /usr/share/${PF}/examples
		doins ode/test/*.c ode/test/*.cpp
		doins drawstuff/textures/*.ppm
		doins drawstuff/dstest/dstest.cpp
	fi
}
