# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-util/anjuta/anjuta-0.9.99.ebuild,v 1.1 2002/08/19 01:23:14 stroke Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A versatile Integrated Development Environment (IDE) for C and C++."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://anjuta.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"

DEPEND=">=gnome-base/gnome-libs-1.4.1.2-r1
	=x11-libs/gtk+-1.2*
	media-libs/audiofile
	dev-libs/libxml
	dev-util/pkgconfig
	gnome-extra/libglademm
	app-text/scrollkeeper"
	
RDEPEND="dev-util/glade
	 media-gfx/gnome-iconedit
	 app-text/scrollkeeper
	 =x11-libs/gtk+-1.2*
	 media-libs/audiofile
	 media-sound/esound
	 dev-util/ctags
	 sys-devel/gdb
	 sys-apps/grep
	 >=sys-libs/db-3.2.3
	 dev-util/indent"


src_compile() {
        
	local myconf
	use nls || myconf="--disable-nls"

	econf ${myconf} || die
	emake || die
}

src_install () {
	
	einstall \
		anjutadocdir=${D}/usr/share/doc/${PF} || die

	dodoc AUTHORS COPYING ChangeLog FUTURE NEWS README THANKS TODO
}
