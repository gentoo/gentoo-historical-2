# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/ftgl/ftgl-2.1.2-r2.ebuild,v 1.2 2009/08/21 21:02:05 ssuominen Exp $

inherit eutils flag-o-matic autotools

DESCRIPTION="library to use arbitrary fonts in OpenGL applications"
HOMEPAGE="http://homepages.paradise.net.nz/henryj/code/#FTGL"
SRC_URI="http://opengl.geek.nz/ftgl/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=media-libs/freetype-2.0.9
	virtual/opengl
	virtual/glut"
RDEPEND="${DEPEND}"

S=${WORKDIR}/FTGL/unix

src_unpack() {
	unpack ${A}

	# Use the correct includedir for pkg-config
	epatch \
		"${FILESDIR}"/${P}-ftgl.pc.in.patch \
		"${FILESDIR}"/${P}-gcc41.patch \
		"${FILESDIR}"/${P}-configure.ac.patch
	if ! has_version app-doc/doxygen ; then
		cd FTGL/docs
		tar xzf html.tar.gz || die "unpack html.tar.gz"
		ln -fs ../../docs/html "${S}/docs"
	fi
	sed -i \
		-e "s:\((PACKAGE_NAME)\):\1-${PVR}:g" "${S}"/docs/Makefile \
		|| die "sed failed"
	sed -i \
		-e "s:    \\$:\t\\$:g" "${S}"/src/Makefile \
		|| die "sed failed"

	cd "${S}"
	AT_M4DIR=m4 eautoreconf
}

src_compile() {
	strip-flags # ftgl is sensitive - bug #112820
	econf \
		--enable-shared \
		|| die
	emake || die
}

src_install() {
	einstall || die
	dodoc README.txt
}
