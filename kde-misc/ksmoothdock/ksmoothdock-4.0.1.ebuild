# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/ksmoothdock/ksmoothdock-4.0.1.ebuild,v 1.5 2006/10/05 20:51:42 gustavoz Exp $

inherit kde

S="${WORKDIR}/${PN}"

DESCRIPTION="KSmoothDock is a dock program for KDE with smooth parabolic zooming."
HOMEPAGE="http://ksmoothdock.sourceforge.net"
SRC_URI="mirror://sourceforge/ksmoothdock/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

need-kde 3.4
