# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/tgt/tgt-0.9.10.ebuild,v 1.2 2009/12/01 13:16:49 alexxy Exp $

EAPI="2"

inherit flag-o-matic linux-info

DESCRIPTION="Linux SCSI target framework (tgt)"
HOMEPAGE="http://stgt.berlios.de/"
SRC_URI="http://stgt.berlios.de/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ibmvio infiniband fcp fcoe"

DEPEND="dev-perl/config-general
		infiniband? (
				sys-infiniband/libibverbs
				sys-infiniband/librdmacm
				)"
RDEPEND="${DEPEND}
		sys-apps/sg3_utils"

src_configure() {
	local myconf
	use ibmvio && myconf="${myconf} IBMVIO=1"
	use infiniband && myconf="${myconf} ISCSI_RDMA=1"
	use fcp && 	myconf="${myconf} FCP=1"
	use fcoe && myconf="${myconf} FCOE=1"
}

src_compile() {
	emake -C usr/ KERNELSRC="${KERNEL_DIR}" ISCSI=1 ${myconf}
}

src_install() {
	emake  install-programs install-scripts install-doc DESTDIR="${D}" || die "install failed"
	doinitd "${FILESDIR}/tgtd"
	dodir "${D}/etc/tgt"
}
