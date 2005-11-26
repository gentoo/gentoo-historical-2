# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libXprintAppUtil/libXprintAppUtil-0.99.1.ebuild,v 1.2 2005/11/26 09:38:07 blubb Exp $

# Must be before x-modular eclass is inherited
#SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org XprintAppUtil library"
#HOMEPAGE="http://foo.bar.com/"
#SRC_URI="ftp://foo.bar.com/${P}.tar.bz2"
#LICENSE=""
#SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~s390 ~sparc ~x86"
#IUSE="X gnome"
RDEPEND="x11-libs/libX11
	x11-libs/libXp
	x11-libs/libXprintUtil"
DEPEND="${RDEPEND}"
