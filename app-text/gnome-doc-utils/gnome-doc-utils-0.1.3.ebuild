# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/gnome-doc-utils/gnome-doc-utils-0.1.3.ebuild,v 1.17 2005/09/24 04:14:25 vapier Exp $

inherit gnome2

DESCRIPTION="A collection of documentation utilities for the Gnome project"
HOMEPAGE="http://www.gnome.org"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-libs/libxml2-2.6.12
	>=dev-libs/libxslt-1.1.8"

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

