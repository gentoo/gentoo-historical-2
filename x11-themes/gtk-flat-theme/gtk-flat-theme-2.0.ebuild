# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-flat-theme/gtk-flat-theme-2.0.ebuild,v 1.3 2002/10/22 15:45:01 bjb Exp $

SLOT="0"
S=${WORKDIR}/${P}
DESCRIPTION="GTK 2 port of the FLAT theme"
SRC_URI="http://themes.freshmeat.net/redir/gtk2flat/31385/url_tgz/gtk2flat-default.tar.gz"
HOMEPAGE="http://themes.freshmeat.net/projects/gtk2flat"
KEYWORDS="x86 alpha"

DEPEND=">=x11-libs/gtk+-2.0.0"
RDEPEND=$DEPEND
LICENSE="GPL-2"

src_compile() {
	econf || die
	emake || die
}

src_install () {
	einstall || die
	dodoc AUTHORS COPYING ChangeLog INSTALL NEWS README
}

