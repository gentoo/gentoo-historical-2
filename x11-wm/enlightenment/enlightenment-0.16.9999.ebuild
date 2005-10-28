# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/enlightenment/enlightenment-0.16.9999.ebuild,v 1.11 2005/10/28 00:14:16 vapier Exp $

ECVS_SERVER="cvs.sourceforge.net:/cvsroot/enlightenment"
ECVS_MODULE="e16/e"
inherit cvs

DESCRIPTION="Enlightenment Window Manager"
HOMEPAGE="http://www.enlightenment.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-*"
IUSE="esd nls xrandr doc"

RDEPEND="esd? ( >=media-sound/esound-0.2.19 )
	=media-libs/freetype-2*
	media-libs/imlib2
	virtual/x11"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
PDEPEND="doc? ( app-doc/edox-data )"

S=${WORKDIR}/e16/e

src_unpack() {
	cvs_src_unpack
	cd ${S}
	NOCONFIGURE=blah ./autogen.sh
}

src_compile() {
	econf \
		$(use_enable nls) \
		$(use_enable esd sound) \
		$(use_enable xrandr) \
		--enable-upgrade \
		--enable-hints-ewmh \
		--enable-fsstd \
		--enable-zoom \
		--with-imlib2 \
		|| die
	emake || die
}

src_install() {
	make install DESTDIR="${D}" || die
	mv "${D}"/usr/bin/{,e}dox
	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}"/enlightenment

	dodoc AUTHORS ChangeLog FAQ INSTALL NEWS README*

	# fix default xcursor support
	cd "${D}"/usr/share/enlightenment/themes
	local deftheme=`readlink DEFAULT`
	cp -rf ${deftheme} ${deftheme}-xcursors
	rm DEFAULT
	ln -s ${deftheme}-xcursors DEFAULT
	rm -rf ${deftheme}-xcursors/cursors*
	cp "${FILESDIR}"/cursors.cfg ${deftheme}-xcursors/
}
