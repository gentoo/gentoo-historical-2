# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gtk-engines-xfce/gtk-engines-xfce-2.1.3.ebuild,v 1.3 2004/04/27 20:32:54 pvdabeel Exp $

inherit gtk-engines2

MY_P=${P/gtk-engines-xfce/gtk-xfce-engine}

IUSE=""
DESCRIPTION="GTK+2 XFCE Theme Engine"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
HOMEPAGE="http://xfce.sourceforge.net/"
KEYWORDS="ia64 ~x86 ppc ~sparc ~alpha"
LICENSE="GPL-2"
SLOT="2"

DEPEND=">=x11-libs/gtk+-2"

S=${WORKDIR}/${MY_P}
