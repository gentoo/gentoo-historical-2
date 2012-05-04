# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gnome-devel-docs/gnome-devel-docs-3.2.1.ebuild,v 1.2 2012/05/04 17:51:45 jdhore Exp $

EAPI="4"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Documentation for developing for the GNOME desktop environment"
HOMEPAGE="http://developer.gnome.org/"

LICENSE="FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=""
DEPEND="dev-libs/libxslt
	virtual/pkgconfig
	sys-devel/gettext
	app-text/gnome-doc-utils
	app-text/docbook-xml-dtd:4.1.2
	app-text/docbook-xml-dtd:4.2"

G2CONF="${G2CONF} --disable-scrollkeeper"
DOCS="AUTHORS ChangeLog NEWS README"
# This ebuild does not install any binaries
# FIXME: Docs don't validate
RESTRICT="test binchecks strip"
