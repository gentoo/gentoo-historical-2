# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gal/gal-1.99.2.ebuild,v 1.1 2003/03/13 23:22:21 liquidx Exp $

IUSE="doc"

inherit libtool

S="${WORKDIR}/${P}"
DESCRIPTION="The Gnome Application Libraries"
# also appears in gnome.org, but their latest is only 1.99.1 - 13 Mar 03
SRC_URI="ftp://ftp.ximian.com/pub/ximian-evolution-beta/source/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="2"
KEYWORDS="~x86"

RDEPEND=">=gnome-base/libgnomeprint-2.2.0
	>=gnome-base/libgnomeprintui-2.2.1
    >=gnome-base/libglade-2.0
    >=gnome-base/libgnomeui-2.0
    >=gnome-base/libgnomecanvas-2.0
    >=dev-libs/libxml2-2.0"
    
DEPEND="sys-devel/gettext
        doc? ( dev-util/gtk-doc )
        ${RDEPEND}"

src_compile() {
	elibtoolize

	local myconf=""

    if [ -n "`use doc`" ]; then
       myconf="${myconf} --enable-gtk-doc"
    else 
       myconf="${myconf} --disable-gtk-doc"
    fi

	econf ${myconf} || die
	emake || die
}

src_install() {
	make prefix=${D}/usr \
	     sysconfdir=${D}/etc \
	     localstatedir=${D}/var/lib	\
	     install || die

	dodoc AUTHORS COPYING ChangeLog NEWS README
}

