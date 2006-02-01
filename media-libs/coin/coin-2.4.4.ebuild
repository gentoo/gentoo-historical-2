# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/coin/coin-2.4.4.ebuild,v 1.4 2006/02/01 17:49:55 dertobi123 Exp $

inherit eutils

MY_P=${P/c/C}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Coin3D is a high-level 3D graphics toolkit, fully compatible with SGI Open Inventor 2.1."
HOMEPAGE="http://www.coin3d.org/"
SRC_URI="ftp://ftp.coin3d.org/pub/coin/src/all/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 PEL )"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="bzip2 debug doc fontconfig openal opengl X zlib" # java javascript

RDEPEND="media-libs/freetype
	bzip2?	( app-arch/bzip2 )
	fontconfig? ( media-libs/fontconfig )
	openal?	( media-libs/openal )
	opengl? ( virtual/opengl virtual/glu )
	X?      ( || ( ( x11-libs/libXt x11-libs/libXext ) virtual/x11 ) )
	zlib? 	( sys-libs/zlib )"
	# java?	( virtual/jdk )
	# javascript? ( dev-lang/spidermonkey )
DEPEND="${RDEPEND}
	app-doc/doxygen"

src_compile() {
	# "waiting" for someone needing mesa, instead opengl
	# simage currently not in the repository
	# java and javascript support fails for differnt reasons
	# otherwise hopefully sensible defaults and enough use flags
	local myconf="--enable-optimization \
			--enable-3ds-import \
			--enable-vrml97 \
			--enable-man  \
			--disable-html-help \
			--without-mesa \
			--without-simage \
			--with-doxygen \
			--with-freetype \
			$(use_enable debug) \
			$(use_enable debug symbols) \
			$(use_enable doc html) \
			$(use_with bzip2) \
			$(use_with fontconfig) \
			$(use_with openal) \
			$(use_with opengl) \
			$(use_with opengl glu) \
			$(use_with X x) \
			$(use_with zlib ) \
			--disable-java-wrapper \
			--disable-javascript-api \
			--without-spidermokey"
			# $(use_enable java java-wrapper) \
			# $(use_enable javascript javascript-api) \
			# $(use_with javascript spidermonkey) \

	econf ${myconf} htmldir=${ROOT}usr/share/doc/${PF}/html || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install
	dodoc AUTHORS COPYING NEWS README* RELEASE RELNOTES THANKS

	# Waiting for a maintainer to fix, see #117756.
	rm -f ${D}/usr/share/man/man3/_var_tmp* ${D}/usr/sharedoc/coin-2.4.4/html/dir__*
}
