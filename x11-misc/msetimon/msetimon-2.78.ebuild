# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/msetimon/msetimon-2.78.ebuild,v 1.1 2005/06/04 12:38:37 pyrania Exp $

MY_P=${PN}-i386-linux-lib6c-${PV/./-}
DESCRIPTION="A GUI utility for monitoring the SETI@Home client"
NAME="msetimon"
SRC_URI="mirror://sourceforge/msetimon/${MY_P}.tar.gz"
HOMEPAGE="http://msetimon.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc"
IUSE=""

DEPEND="virtual/x11"

S=${WORKDIR}/${MY_P}

src_install () {
	dobin msetimon || die "install failed"
	dodoc README_msetimon.txt
}
