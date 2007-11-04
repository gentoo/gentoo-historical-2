# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glew/glew-1.4.0.ebuild,v 1.1 2007/11/04 16:57:50 drac Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="The OpenGL Extension Wrangler Library"
HOMEPAGE="http://glew.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tgz"

LICENSE="BSD GLX SGI-B GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

RDEPEND="virtual/opengl
	virtual/glu"
DEPEND="${RDEPEND}
	sys-apps/sed"

S="${WORKDIR}"/${PN}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:-s\b::g' Makefile
}

src_compile(){
	emake LD="$(tc-getCC) ${LDFLAGS}" CC="$(tc-getCC)" \
		POPT="${CFLAGS}" M_ARCH="" || die "emake failed."
}

src_install() {
	emake GLEW_DEST="${D}/usr" LIBDIR="${D}/usr/$(get_libdir)" \
		M_ARCH="" install || die "emake install failed."

	dodoc README.txt
	dohtml doc/*.{html,css,png,jpg}
}
