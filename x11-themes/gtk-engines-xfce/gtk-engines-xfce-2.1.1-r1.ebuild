# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-xfce/gtk-engines-xfce-2.1.1-r1.ebuild,v 1.4 2005/01/02 16:45:50 bcowan Exp $

inherit gtk-engines2

MY_P=${P/gtk-engines-xfce/gtk-xfce-engine}

IUSE=""
DESCRIPTION="GTK+2 XFCE Theme Engine"
SRC_URI="mirror://sourceforge/xfce/${MY_P}.tar.gz"
HOMEPAGE="http://xfce.sourceforge.net/"
KEYWORDS="~x86 ppc ~sparc ~alpha"
LICENSE="GPL-2"
SLOT="2"

DEPEND=">=x11-libs/gtk+-2"

S=${WORKDIR}/${MY_P}
