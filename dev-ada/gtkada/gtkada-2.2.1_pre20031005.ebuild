# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ada/gtkada/gtkada-2.2.1_pre20031005.ebuild,v 1.1 2003/10/06 00:29:20 dholm Exp $

inherit gnat

DESCRIPTION="Gtk+ bindings to the Ada language"
HOMEPAGE="http://libre.act-europe.fr/GtkAda"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GMGPL"
SLOT="1"
KEYWORDS="~x86 ~ppc"
IUSE="nls opengl"

DEPEND="dev-lang/gnat
	>=x11-libs/gtk+-2.2.0"
RDEPEND=""

src_compile() {
	local myconf
	myconf=""

	use nls    || myconf="${myconf} --disable-nls"
	use opengl && myconf="${myconf} --with-GL=auto"

	sed -i -e "s|-I\$prefix/include|-I/usr/lib/ada/adainclude|" \
		src/gtkada-config.in
	sed -i -e "s|-L\$prefix/include|-L/usr/lib/ada/adalib|" \
		src/gtkada-config.in

	econf ${myconf} || die "./configure failed"

	make GNATFLAGS="${ADACFLAGS}" || die
}

src_install() {
	make prefix=${D}/usr \
		incdir=${D}/usr/lib/ada/adainclude/gtkada \
		libdir=${D}/usr/lib/ada/adalib/gtkada \
		alidir=${D}/usr/lib/ada/adalib/gtkada install \
		|| die

	dosym /usr/lib/ada/adalib/gtkada/libgtkada_glade-2.2.so.1 /usr/lib
	dosym /usr/lib/ada/adalib/gtkada/libgtkada_gl-2.2.so.1 /usr/lib
	dosym /usr/lib/ada/adalib/gtkada/libgnomeada-2.2.so.1 /usr/lib
	dosym /usr/lib/ada/adalib/gtkada/libgtkada_glade.so /usr/lib
	dosym /usr/lib/ada/adalib/gtkada/libgtkada-2.2.so.1 /usr/lib
	dosym /usr/lib/ada/adalib/gtkada/libgtkada_gl.so /usr/lib
	dosym /usr/lib/ada/adalib/gtkada/libgnomeada.so /usr/lib
	dosym /usr/lib/ada/adalib/gtkada/libgtkada.so /usr/lib

	#arrange docs properly
	dodoc ANNOUNCE AUTHORS COPYING README
	cd ${D}/usr
	mv doc/${Name}/* share/${PN}/examples/ share/doc/${PF}
	rm -rf doc/ share/${PN}/
	cd ${S} #in case need to add anything afterwards
}

