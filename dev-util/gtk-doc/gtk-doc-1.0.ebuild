# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gtk-doc/gtk-doc-1.0.ebuild,v 1.1 2003/01/21 23:20:06 foser Exp $

inherit gnome.org

S=${WORKDIR}/${P}
DESCRIPTION="GTK+ Documentation Generator"
HOMEPAGE="http://www.gtk.org/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc "

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=app-text/openjade-1.3.1
	>=app-text/docbook-xml-dtd-4.1
	>=app-text/docbook-sgml-dtd-3.1
	>=app-text/docbook-dsssl-stylesheets-1.40
	>=sys-devel/perl-5
	dev-libs/libxslt
	>=dev-libs/libxml2-2.3.6"

src_compile() {
	local myconf

	if [ "${DEBUGBUILD}" ]
	then
		myconf="--enable-debug=yes"
	else
		myconf="--enable-debug=no"
	fi
	
	econf ${myconf}
	emake || die
}

src_install() {
	einstall

	dodoc AUTHORS ChangeLog COPYING INSTALL README* NEWS 
	docinto doc
	dodoc doc/README doc/*.txt
}
