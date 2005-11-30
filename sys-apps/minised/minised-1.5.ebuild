# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/minised/minised-1.5.ebuild,v 1.1.1.1 2005/11/30 09:55:58 chriswhite Exp $

DESCRIPTION="a smaller, cheaper, faster SED implementation"
HOMEPAGE="http://www.exactcode.de/oss/minised/"
SRC_URI="http://dl.exactcode.de/oss/minised/sed-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""

src_install() {
	newbin sed ${PN} || die "sed bin"
	newman sed.1 ${PN}.1
	dodoc BUGS README
}
