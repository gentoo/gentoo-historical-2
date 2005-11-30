# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/smbkit/smbkit-0.0.1.20050521.ebuild,v 1.1 2005/06/06 07:12:34 fafhrd Exp $

inherit gnustep

S=${WORKDIR}/${PN}-${PV}

DESCRIPTION="SMBKit offers a samba library and headers for GNUstep."
HOMEPAGE="http://www.gnustep.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

KEYWORDS="x86 ~ppc"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}
	net-fs/samba"
RDEPEND="${GS_RDEPEND}
	net-fs/samba"

egnustep_install_domain "System"

