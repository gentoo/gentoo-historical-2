# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/sg3_utils/sg3_utils-1.26.ebuild,v 1.1 2008/06/25 17:33:58 robbat2 Exp $

inherit eutils

DESCRIPTION="Apps for querying the sg SCSI interface"
HOMEPAGE="http://www.torque.net/sg/"
SRC_URI="http://www.torque.net/sg/p/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
DEPEND="sys-devel/libtool"
RDEPEND="sys-apps/sdparm"
PDEPEND=">=sys-apps/rescan-scsi-bus-1.24"

src_install() {
	dodoc ChangeLog AUTHORS COVERAGE CREDITS README*
	dodoc doc/README.doc examples/*.txt
	newdoc scripts/README README.scripts
	make install DESTDIR="${D}" || die "make install failed"
	dosbin scripts/{scsi,sas}*
}
