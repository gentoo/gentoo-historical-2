# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/liferea/liferea-0.4.6b.ebuild,v 1.4 2004/06/25 00:57:18 agriffis Exp $

inherit gnome2

DESCRIPTION="News Aggregator for RDF/RSS/CDF/Atom/Echo/etc similar to FeedReader."
HOMEPAGE="http://liferea.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.0.0
	>=dev-libs/libxml2-2.5
	=gnome-extra/libgtkhtml-2*
	>=gnome-base/gnome-vfs-2
	>=gnome-base/gconf-2"

DOCS="README AUTHORS ChangeLog COPYING"
