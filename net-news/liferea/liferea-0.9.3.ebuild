# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/liferea/liferea-0.9.3.ebuild,v 1.4 2005/09/01 11:17:05 herbs Exp $

inherit gnome2

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo/etc feeds"
HOMEPAGE="http://liferea.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="mozilla gtkhtml"

RDEPEND=">=x11-libs/gtk+-2
	>=dev-libs/libxml2-2.5.10
	mozilla? ( www-client/mozilla
		gtkhtml? ( =gnome-extra/libgtkhtml-2* )
	)
	!mozilla? ( =gnome-extra/libgtkhtml-2* )
	>=gnome-base/gconf-2"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS="README AUTHORS ChangeLog COPYING"

