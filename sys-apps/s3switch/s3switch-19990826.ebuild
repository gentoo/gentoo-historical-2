# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/s3switch/s3switch-19990826.ebuild,v 1.1.1.1 2005/11/30 09:56:46 chriswhite Exp $

DESCRIPTION="S3 video chipset output selection utility"
HOMEPAGE="http://www.probo.com/timr/savage40.html"
SRC_URI="http://www.probo.com/timr/s3ssrc.zip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S=${WORKDIR}

src_install() {
	dobin s3switch || die
	doman s3switch.1x
}
