# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/dia/dia-0.90-r2.ebuild,v 1.1 2002/10/22 12:06:52 foser Exp $

IUSE="nls gnome bonobo truetype png"

S=${WORKDIR}/${P}
DESCRIPTION="Diagram Creation Program"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/gnome-office/dia.shtml"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

RDEPEND=">=dev-libs/libxml-1.8.14
	>=media-libs/gdk-pixbuf-0.7
	dev-libs/popt
	dev-libs/libunicode
	bonobo? ( gnome-base/bonobo )
	truetype? ( >=media-libs/freetype-2.0.5 )
	png? ( media-libs/libpng )" 

# Python module needs some work
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
#	python? ( dev-lang/python-2.0 )"

src_compile() {
	local myconf

	use gnome && myconf="--enable-gnome" \
		|| myconf="--disable-gnome"

	use bonobo && myconf="${myconf} --enable-bonobo" \
		|| myconf="${myconf} --disable-bonobo"

#	use python && myconf="${myconf} --with-python"

	use truetype && myconf="${myconf} --enable-freetype" \
		|| myconf="${myconf} --enable-freetype"

	use nls || myconf="${myconf} --disable-nls"
 
    # enable-gnome-print not recoomended

	econf ${myconf} || die
	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog README NEWS TODO KNOWN_BUGS
}
