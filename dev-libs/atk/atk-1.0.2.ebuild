# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/atk/atk-1.0.2.ebuild,v 1.9 2003/02/04 06:03:58 spider Exp $

IUSE="doc"
inherit debug

S=${WORKDIR}/${P}
DESCRIPTION="Gnome Accessibility Toolkit"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v2.0/${P}.tar.bz2"
HOMEPAGE="http://developer.gnome.org/projects/gap/"

SLOT="1"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ppc sparc "

RDEPEND=">=dev-libs/glib-2.0.3"

DEPEND="${RDEPEND}
	doc? ( >=dev-util/gtk-doc-0.9-r2 )
	>=dev-util/pkgconfig-0.12.0"

src_compile() {
# since no other of gtk pango and glib use this, remove it. its not recommended either
#	libtoolize --copy --force
	local myconf
	use doc \
		&& myconf="${myconf} --enable-gtk-doc" \
		|| myconf="${myconf} --disable-gtk-doc"
	 
	econf \
		--enable-debug \
		${myconf} || die

## Since glib fails with debug, we debug here too

	emake || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS 
}
