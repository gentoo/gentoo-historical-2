# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/addresses/addresses-0.4.6-r1.ebuild,v 1.1 2004/11/12 03:49:45 fafhrd Exp $

inherit gnustep eutils

S=${WORKDIR}/${P/a/A}

DESCRIPTION="Addresses is a Apple Addressbook work alike (standalone and for GNUMail)"
HOMEPAGE="http://giesler.biz/bjoern/en/sw_addr.html"
#SRC_URI="mirror://gentoo/${P/a/A}.tar.gz"
#SRC_URI="http://dev.gentoo.org/~fafhrd/gnustep/apps/${P/a/A}.tar.gz"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/contrib/${P/a/A}.tar.gz"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~x86 ~ppc"

IUSE="${IUSE}"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"

egnustep_install_domain "Local"

src_unpack() {
	egnustep_env
	unpack ${A}
	cd ${S}
	if [ -z "${GNUSTEP_FLATTENED}" ]; then
		epatch ${FILESDIR}/nonflattened.patch
	fi
	epatch ${FILESDIR}/address-user-root.patch
}

