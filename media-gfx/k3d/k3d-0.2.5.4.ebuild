# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/k3d/k3d-0.2.5.4.ebuild,v 1.8 2005/09/17 01:19:39 vanquirius Exp $

inherit python eutils

IUSE="truetype doc python ruby"

DESCRIPTION="K-3D is a free 3D modeling, animation, and rendering system."
HOMEPAGE="http://k3d.sourceforge.net"
SRC_URI="mirror://sourceforge/k3d/${P}-src.tar.bz2
	mirror://gentoo/${P}-gentoo.patch.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~sparc"

DEPEND="virtual/x11
	virtual/opengl
	virtual/glu
	>=dev-libs/glib-2.2.1
	=x11-libs/gtk+-1.2*
	=dev-libs/libsigc++-1.0*
	media-libs/plib
	truetype? ( >=media-libs/freetype-2 )
	doc? ( app-text/xmlto )
	python? ( >=dev-lang/python-2.2 )
	ruby? ( virtual/ruby )"

src_unpack() {
	unpack ${A}; cd ${S}
	epatch "${WORKDIR}/${P}-gentoo.patch"

	# fix python compilation
	python_version
	sed -i -e "s:python2.2:python${PYVER}:g" configure
}

src_compile() {
	local myconf="--with-plib --without-graphviz"

	use truetype \
		&& myconf="${myconf} --with-freetype" \
		|| myconf="${myconf} --without-freetype"

	use doc \
		&& myconf="${myconf} --with-docbook" \
		|| myconf="${myconf} --without-docbook"

	use python \
		&& myconf="${myconf} --with-python" \
		|| myconf="${myconf} --without-python"

	use ruby \
		&& myconf="${myconf} --with-ruby=`ruby -rrbconfig -e 'puts Config::CONFIG["archdir"]'`" \
		|| myconf="${myconf} --without-ruby"

	econf ${myconf} || die
	emake "CXXFLAGS=${CXXFLAGS}" || die
}

src_install() {
	einstall || die
	dodoc AUTHORS NEWS README TODO
}
