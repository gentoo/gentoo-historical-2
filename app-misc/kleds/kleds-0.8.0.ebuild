# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/kleds/kleds-0.8.0.ebuild,v 1.1 2004/10/03 19:39:36 centic Exp $

inherit kde
need-kde 3.0

DESCRIPTION="A KDE applet that displays the keyboard lock states."
HOMEPAGE="http://www.hansmatzen.de/english/kleds.html"
SRC_URI="http://www.hansmatzen.de/software/kleds/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~sparc ~amd64"
IUSE=""

S="${WORKDIR}/kleds-${PV}"
