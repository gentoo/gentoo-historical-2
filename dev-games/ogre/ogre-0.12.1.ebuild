# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/ogre/ogre-0.12.1.ebuild,v 1.1 2003/10/30 21:00:52 vapier Exp $

S=${WORKDIR}/ogrenew
DESCRIPTION="Object-oriented Graphics Rendering Engine"
HOMEPAGE="http://ogre.sourceforge.net/"
SRC_URI="mirror://sourceforge/ogre/${PN}-v${PV//./-}.tar.bz2"

LICENSE="LGPL-2.1"
KEYWORDS="x86"
SLOT="0"

IUSE="doc gtk2"

RDEPEND="virtual/opengl
	media-libs/libsdl
	=media-libs/freetype-2*
	media-libs/devil
	gtk2? (
		=dev-cpp/libglademm-2*
		=dev-cpp/gtkmm-2*
	)
	sys-libs/zlib"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	|| ( dev-libs/STLport >=sys-devel/gcc-3.0 )"

src_compile() {
	local myconf="cli"

	[ `use gtk2` ] && myconf="gtk"

	econf --with-cfgtk=${myconf} || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	if [ `use doc` ] ; then
		dohtml -r Docs/* Docs/Tutorials/* || die "dohtml failed (doc)"
	fi
	insinto /usr/share/OGRE/Media
	doins Samples/Media/* || die "doins failed"
	dodoc AUTHORS BUGS LINUX.DEV README Docs/README.linux || die "dodoc failed"
	dohtml Docs/*.html || die "dohtml failed"
}
