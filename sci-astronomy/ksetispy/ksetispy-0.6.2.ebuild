# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-astronomy/ksetispy/ksetispy-0.6.2.ebuild,v 1.1.1.1 2005/11/30 10:01:52 chriswhite Exp $

inherit kde

DESCRIPTION="Monitors the progress of the SETI@home client, using the same interface as SETI Spy for Windows"
HOMEPAGE="http://ksetispy.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 amd64"
IUSE=""

DEPEND=">=kde-base/kdelibs-3
	sci-astronomy/setiathome"
need-kde 3
