# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-misc/kleds/kleds-0.7.1.ebuild,v 1.2 2002/07/25 17:20:02 seemant Exp $
inherit kde-base || die

S="${WORKDIR}/kleds-${PV}"
need-kde 3.0 

DESCRIPTION="A KDE applet that displays the keyboard lock states."
SRC_URI="http://www.hansmatzen.de/software/kleds/${P}.tar.gz"
HOMEPAGE="http://www.hansmatzen.de/english/kleds.html"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
