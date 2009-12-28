# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/pixie/pixie-2.2.6.ebuild,v 1.1 2009/12/28 20:58:08 flameeyes Exp $

EAPI="2"
inherit eutils multilib autotools

MY_PN="Pixie"
S="${WORKDIR}/${MY_PN}"

DESCRIPTION="RenderMan like photorealistic renderer."
HOMEPAGE="http://pixie.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_PN}-src-${PV}.tgz"

LICENSE="GPL-2"
IUSE="X static-libs"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="!mail-client/nmh
	media-libs/jpeg
	media-libs/tiff
	media-libs/libpng
	x11-libs/fltk:1.1[opengl]
	media-libs/openexr
	virtual/opengl
	sys-libs/zlib
	X? (
		x11-libs/libXext
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdmcp
		x11-libs/libXi
		x11-libs/libXmu
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison"

src_prepare() {
	# FIX: missing @includedir@
	epatch "${FILESDIR}/${P}-autotools.patch"
	eautoreconf
}

src_configure() {
	econf \
		$(use_with X x) \
		$(use_enable static-libs static) \
		--includedir=/usr/include/pixie \
		--libdir=/usr/$(get_libdir)/pixie \
		--with-docdir=/usr/share/doc/${PF}/html \
		--with-shaderdir=/usr/share/Pixie/shaders \
		--with-ribdir=/usr/share/Pixie/ribs \
		--with-texturedir=/usr/share/Pixie/textures \
		--with-displaysdir=/usr/$(get_libdir)/pixie/displays \
		--with-modulesdir=/usr/$(get_libdir)/pixie/modules \
		--enable-openexr-threads \
		--mandir=/usr/share/man \
		--bindir=/usr/bin
}

src_compile() {
	emake || die "emake failed"

	# regenerating Pixie shaders
	einfo "Re-building Pixie Shaders for v${PV} format"
	emake -f "${FILESDIR}/Makefile.shaders" -C "${S}/shaders"
}

src_install() {
	emake DESTDIR="${D}" install || die "installation failed."

	# remove useless .la files
	find "${D}" -name '*.la' -delete || die

	dodoc README AUTHORS ChangeLog || die
}
