# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/apotheke/apotheke-0.2.ebuild,v 1.2 2002/12/18 22:17:40 bass Exp $

inherit gnome2

S="${WORKDIR}/${P}"
IUSE=""
DESCRIPTION="A seperate Nautilus view, which gives you detailed information about CVS managed directories."
SRC_URI="ftp://ftp.berlios.de/pub/apotheke/${P}.tar.gz"
HOMEPAGE="http://apotheke.berlios.de/"
LICENSE="GPL-2"
DEPEND=">=nautilus-2"
SLOT="0"
KEYWORDS="x86 sparc "

DOCS="AUTHORS ChangeLog COPYING INSTALL NEWS README"
