# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/poweriso/poweriso-1.1.ebuild,v 1.2 2007/02/28 14:03:32 herbs Exp $

inherit eutils

DESCRIPTION="Utility to extract, list and convert PowerISO DAA image files"
HOMEPAGE="http://www.poweriso.com/"
SRC_URI="http://www.${PN}.com/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}

src_install()
{
	dobin poweriso
}
