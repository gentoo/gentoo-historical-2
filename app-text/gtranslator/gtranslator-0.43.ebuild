# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gtranslator/gtranslator-0.43.ebuild,v 1.5 2002/12/09 04:17:44 manson Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="A gettext po file editor for GNOME"
SRC_URI="http://www.gtranslator.org/download/releases/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.gtranslator.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc "

DEPEND=">=gnome-base/gnome-libs-1.2
	( >=gnome-base/gconf-1.0
	<gnome-base/gconf-1.1 )
	>=gnome-extra/gal-0.11.99
	>=app-text/scrollkeeper-0.1.4
	=dev-libs/glib-1.2*
	=x11-libs/gtk+-1.2*
	>=gnome-base/oaf-0.6.8
	>=gnome-base/ORBit-0.5.14
	( >=gnome-base/gnome-vfs-1.0.5
	<gnome-base/gnome-vfs-2.0.0 )
	>=dev-libs/libxml-1.8.17"

RDEPEND="nls? ( sys-devel/gettext )"

src_compile() {
	local myopts

	use nls || myopts="--disable-nls"
	
	./configure \
		--host=${CHOST} \
		--disable-debug \
		--prefix=/usr \
		
		${myopts} || die "./configure failed"
	
	emake || die
}

src_install() {
	cd ${S}/help/C

	mv Makefile Makefile.orig
	sed -e 's:scrollkeeper-update.*::g' Makefile.orig > Makefile
	rm Makefile.orig

	cd ${S}

	make DESTDIR=${D} install || die

	dodoc ABOUT-NLS AUTHORS Changelog COPYING HACKING INSTALL NEWS README \
		THANKS TODO DEPENDS 
}

pkg_postinst() {
	echo ">>> Updating Scrollkeeper database..."
	scrollkeeper-update >/dev/null 2>&1
}

pkg_postrm() {
	echo ">>> Updating Scrollkeeper database..."
	scrollkeeper-update >/dev/null 2>&1
}
