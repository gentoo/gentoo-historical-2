# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp-freetype/gimp-freetype-0.2-r3.ebuild,v 1.2 2003/01/16 23:54:45 leonardop Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="GIMP freetype text plugin"
SRC_URI="http://freetype.gimp.org/gimp-freetype-0.2.tar.gz"
HOMEPAGE="http://freetype.gimp.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=media-gfx/gimp-1.2.3-r1 
	>=media-libs/freetype-2.0.1"
RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf=""
	
	use nls || myconf="--disable-nls"

	econf \
		--sysconfdir=/etc/gimp/1.2/ \
		--with-gimp-exec-prefix=/usr \
		${myconf}

	emake || die
}

src_install() {
	local GIMP_PLUGIN_DIR=`gimptool --gimpplugindir`

	einstall bindir=${D}/${GIMP_PLUGIN_DIR}/plug-ins || die

	dodoc AUTHORS ChangeLog COPYING NEWS README* TODO
}
