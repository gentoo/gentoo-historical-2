# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glew/glew-1.5.3.ebuild,v 1.1 2010/04/21 09:09:35 ssuominen Exp $

EAPI=2
inherit multilib toolchain-funcs

DESCRIPTION="The OpenGL Extension Wrangler Library"
HOMEPAGE="http://glew.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="x11-libs/libXmu
	x11-libs/libXi
	virtual/glu
	virtual/opengl
	x11-libs/libXext
	x11-libs/libX11"

src_prepare() {
	sed -i \
		-e '/INSTALL/s:-s::' \
		-e '/$(CC) $(CFLAGS) -o/s:$(CFLAGS):$(CFLAGS) $(LDFLAGS):' \
		Makefile || die
}

src_compile(){
	emake AR="$(tc-getAR)" STRIP=true CC="$(tc-getCC)" \
		LD="$(tc-getCC) ${LDFLAGS}" POPT="${CFLAGS}" M_ARCH="" || die
}

src_install() {
	dodir /usr/$(get_libdir)/pkgconfig

	emake STRIP=true GLEW_DEST="${D}/usr" LIBDIR="${D}/usr/$(get_libdir)" \
		M_ARCH="" install || die

	dodoc doc/*.txt README.txt TODO.txt || die
	dohtml doc/*.{css,html,jpg,png} || die
}
