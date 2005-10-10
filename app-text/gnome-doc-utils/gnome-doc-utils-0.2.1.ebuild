# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnome-doc-utils/gnome-doc-utils-0.2.1.ebuild,v 1.10 2005/10/10 08:10:39 hardave Exp $

inherit python gnome2

DESCRIPTION="A collection of documentation utilities for the Gnome project"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.8
	>=dev-lang/python-2"

DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool"

DOCS="AUTHORS ChangeLog NEWS README"

USE_DESTDIR="1"

src_unpack() {

	unpack ${A}
	cd ${S}
	# don't run scrollkeeper until gnome2_pkg_postinst
	gnome2_omf_fix doc/xslt/Makefile.in \
				   doc/gnome-doc-make/Makefile.in \
				   gnome-doc-utils.make

}

pkg_postinst() {
	python_mod_optimize ${ROOT}/usr/share/xml2po
}

pkg_postrm() {
	python_mod_cleanup ${ROOT}/usr/share/xml2po
}
