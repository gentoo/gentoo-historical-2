# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/anjuta/anjuta-1.0.0.ebuild,v 1.3 2002/11/09 00:02:51 spider Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A versatile Integrated Development Environment (IDE) for C and C++."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://anjuta.sourceforge.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND=">=gnome-base/ORBit-0.5.0
	media-libs/gdk-pixbuf
	>=gnome-base/gnome-libs-1.4.1.2-r1
	>=dev-libs/libxml-1.4.0
	dev-util/pkgconfig
	>=app-text/scrollkeeper-0.1.4
	>=gnome-base/gnome-print-0.35
	=gnome-base/gnome-vfs-1.0*
	>=gnome-base/bonobo-1.0
	>=sys-devel/bison-1.0"
	
	
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

	econf ${myconf} --enable-final || die
	emake || die
}

src_install () {
	
	einstall \
		anjutadocdir=${D}/usr/share/doc/${PF} || die

	dodoc AUTHORS COPYING ChangeLog FUTURE NEWS README THANKS TODO
}
