# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/komics/komics-1.4-r1.ebuild,v 1.1 2005/01/02 14:27:22 motaboy Exp $

inherit kde eutils

DESCRIPTION="Komics - a KDE panel applet for fetching comics strips from web."
HOMEPAGE="http://www.orson.it/~domine/komics/"
SRC_URI="http://www.orson.it/~domine/komics/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE=""

S=${WORKDIR}/komics

DEPEND="dev-perl/HTML-Parser
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/HTML-Tagset"
need-kde 3

src_unpack() {
	kde_src_unpack

	epatch ${FILESDIR}/${P}-gcc3.4.patch
	epatch ${FILESDIR}/${P}-Makefiles.patch
	epatch ${FILESDIR}/${P}-RightClickMenu.patch
}

