# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/gnucash-docs/gnucash-docs-2.2.0.ebuild,v 1.9 2010/01/06 20:27:48 ranger Exp $

GCONF_DEBUG=no

inherit gnome2

DESCRIPTION="Documentation package for GnuCash"
HOMEPAGE="http://www.gnucash.org/"
SRC_URI="mirror://sourceforge/gnucash/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2 FDL-1.1"
KEYWORDS="alpha amd64 ppc ~ppc64 sparc x86"

IUSE=""

RDEPEND="gnome-extra/yelp
	!<=app-office/gnucash-2.2.1"

DEPEND="${RDEPEND}
	>=dev-libs/libxml2-2.5.10
	  dev-libs/libxslt
	>=app-text/scrollkeeper-0.3.4
	  app-text/docbook-xsl-stylesheets
	 =app-text/docbook-xml-dtd-4.1.2*"
