# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/aclock/aclock-0.2.3.ebuild,v 1.1.1.1 2005/11/30 10:02:20 chriswhite Exp $

inherit gnustep

DESCRIPTION="A clock!"
HOMEPAGE="http://www.linuks.mine.nu/aclock/"
SRC_URI="http://www.linuks.mine.nu/aclock/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"

IUSE=""
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "Local"
