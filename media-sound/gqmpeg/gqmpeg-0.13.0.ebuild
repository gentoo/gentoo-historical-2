# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-sound/gqmpeg/gqmpeg-0.13.0.ebuild,v 1.7 2002/08/01 11:59:02 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="front end to various audio players, including mpg123"
SRC_URI="mirror://sourceforge/gqmpeg/${P}.tar.gz"
HOMEPAGE="http://gqmpeg.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND="=x11-libs/gtk+-1.2*
	>=media-libs/gdk-pixbuf-0.13.0"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myconf
	use nls || myconf="--disable-nls"

	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc [A-KN-Z]*

	use gnome && ( \
		insinto /usr/share/gnome/apps/Multimedia
		doins ${FILESDIR}/gqmpeg.desktop
	)
}
