# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnome-doc-utils/gnome-doc-utils-0.6.1.ebuild,v 1.15 2008/03/09 22:44:13 leio Exp $

inherit python eutils gnome2

DESCRIPTION="A collection of documentation utilities for the Gnome project"
HOMEPAGE="http://www.gnome.org/"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.6.12
	 >=dev-libs/libxslt-1.1.8
	 >=dev-lang/python-2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.28
	>=dev-util/pkgconfig-0.9"

DOCS="AUTHORS ChangeLog NEWS README"
USE_DESTDIR="1"

pkg_setup() {
	G2CONF="--disable-scrollkeeper"

	if ! built_with_use dev-libs/libxml2 python; then
		eerror "Please re-emerge dev-libs/libxml2 with the python use flag set"
		die "dev-libs/libxml2 needs python use flag"
	fi
}

pkg_postinst() {
	python_mod_optimize "${ROOT}"/usr/share/xml2po
	gnome2_pkg_postinst
}

pkg_postrm() {
	python_mod_cleanup "${ROOT}"/usr/share/xml2po
	gnome2_pkg_postrm
}
