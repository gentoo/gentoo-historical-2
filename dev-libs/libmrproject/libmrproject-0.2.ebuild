# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmrproject/libmrproject-0.2.ebuild,v 1.1 2002/05/23 00:18:33 spider Exp $


# Do _NOT_ strip symbols in the build! Need both lines for Portage 1.8.9+
DEBUG="yes"
RESTRICT="nostrip"
# force debug information
CFLAGS="${CFLAGS} -g"
CXXFLAGS="${CXXFLAGS} -g"


S=${WORKDIR}/${P}
DESCRIPTION="Project manager for Gnome2"
SRC_URI="ftp://ftp.codefactory.se/pub/software/mrproject/unstable/${P}.tar.gz"
HOMEPAGE="http://mrproject.codefactory.se/"
SLOT="0"


#libglade
RDEPEND=">=dev-util/pkgconfig-0.12.0
		>=dev-libs/glib-2.0.0
		>=dev-libs/libxml2-2.4.19	
		nls? ( sys-devel/gettext )"


DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0'
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"
	

src_compile() {
	local myconf
	use doc && myconf="--enable-gtk-doc" || myconf="--disable-gtk-doc" 	use nls && myconf="${myconf} --enable-nls" || myconf="${myconf} --disable-nls"
	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--localstatedir=/var/lib \
		${myconf} --disable-maintainer-mode \
		--enable-debug || die
	emake || die
}

src_install() {
	make DESTDIR=${D} prefix=/usr \
		sysconfdir=/etc \
		infodir=/usr/share/info \
		mandir=/usr/share/man \
		localstatedir=/var/lib \
		install || die
    
	dodoc AUTHORS COPYING ChangeL* INSTALL NEWS  README* 

}


