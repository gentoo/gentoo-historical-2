# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmrproject/libmrproject-0.10.ebuild,v 1.3 2003/11/18 20:17:17 spider Exp $

inherit gnome.org

IUSE="doc nls python postgres"

DESCRIPTION="MrProject library"
HOMEPAGE="http://mrproject.codefactory.se/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~sparc ~ppc ~alpha"

RDEPEND=">=dev-libs/glib-2.0.4
	>=dev-libs/libxml2-2.4.7
	>=gnome-extra/libgsf-1.4
	python? ( >=dev-python/pygtk-2 )
	postgres? ( dev-db/postgresql )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	nls? ( >=sys-devel/gettext-0.11.4 )
	doc? ( >=dev-util/gtk-doc-0.10 )"

# FIXME : ugly hack for #29301
addwrite /usr/share/pygtk/2.0/codegen

src_compile() {

	econf \
		`use_enable nls` \
		`use_enable python` \
		`use_enable doc gtk-doc` \
		`use_enable postgres` \
		${myconf} || die

	emake || die

}

src_install() {

	einstall || die

	dodoc AUTHORS COPYING ChangeL* INSTALL NEWS  README*

}
