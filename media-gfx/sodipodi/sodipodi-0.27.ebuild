# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/sodipodi/sodipodi-0.27.ebuild,v 1.2 2002/10/24 21:56:07 foser Exp $

IUSE="xml2 nls bonobo wmf"

S=${WORKDIR}/${P}
DESCRIPTION="Vector illustration application for GNOME"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://sodipodi.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

# add wmf USE when in use.desc
RDEPEND=">=gnome-base/gnome-print-0.35
	>=gnome-extra/gal-0.13
	media-libs/gdk-pixbuf
	bonobo? ( gnome-base/bonobo )
	xml2? ( dev-libs/libxml2 )
	wmf? ( >=media-libs/libwmf-0.2.1 )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use bonobo \
		&& myconf="${myconf} --with-bonobo" \
		|| myconf="${myconf} --without-bonobo"

	use xml2 \
		&& myconf="${myconf} --with-gnome-xml2" \
		|| myconf="${myconf} --without-gnome-xml2"

	use wmf \
		&& myconf="${myconf} --with-libwmf" \
		|| myconf="${myconf} --without-libwmf"

	use nls || myconf="${myconf} --disable-nls"

	CFLAGS="${CFLAGS} `gnome-config --cflags gdk_pixbuf`"

	econf \
		--enable-gnome \
		--enable-gnome-print \
		${myconf} || die

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die

	dodoc AUTHORS COPYING ChangeLog README NEWS TODO
}
