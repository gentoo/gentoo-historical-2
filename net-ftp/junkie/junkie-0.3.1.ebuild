# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/junkie/junkie-0.3.1.ebuild,v 1.6 2005/01/25 17:29:04 greg_g Exp $

inherit gnome2

S=${WORKDIR}/${PN}${PV}
DESCRIPTION="Junkie - GTK2 FTP Client"
SRC_URI="mirror://sourceforge/${PN}/${PN}${PV}.tar.bz2"
HOMEPAGE="http://sourceforge.net/projects/junkie"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ~ppc ~sparc"
IUSE=""

DEPEND=">=x11-libs/gtk+-2.0.3
		>=dev-libs/glib-2.0.0"

DOC="AUTHORS COPYING ChangeLog INSTALL NEWS README"
