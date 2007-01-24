# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/flexlm/flexlm-9.5-r1.ebuild,v 1.3 2007/01/24 14:16:07 genone Exp $

inherit eutils

DESCRIPTION="Macrovision FLEXlm license manager and utils"
HOMEPAGE="http://www.macrovision.com/services/support/flexlm/lmgrd.shtml"
SRC_URI="http://www.macrovision.com/services/support/flexlm/enduser.pdf
	x86? (
		ftp://ftp.globes.com/flexlm/unix/v${PV}/i86_s8/lmgrd.Z
		ftp://ftp.globes.com/flexlm/unix/v${PV}/i86_s8/lmutil.Z
	)
	amd64? (
		ftp://ftp.globes.com/flexlm/unix/v${PV}/amd64_s8/lmgrd.Z
		ftp://ftp.globes.com/flexlm/unix/v${PV}/amd64_s8/lmutil.Z
	)"

LICENSE="as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="nostrip"

DEPEND="virtual/libc"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}

	mv lmutil-${ARCH}-${PV} lmutil
	mv lmgrd-${ARCH}-${PV} lmgrd

	cp ${DISTDIR}/enduser.pdf ${S}
}

src_install () {
	# executables
	dodir /opt/flexlm/bin
	exeinto /opt/flexlm/bin
	doexe lmgrd lmutil

	dosym lmutil /opt/flexlm/bin/lmcksum
	dosym lmutil /opt/flexlm/bin/lmdiag
	dosym lmutil /opt/flexlm/bin/lmdown
	dosym lmutil /opt/flexlm/bin/lmhostid
	dosym lmutil /opt/flexlm/bin/lmremove
	dosym lmutil /opt/flexlm/bin/lmreread
	dosym lmutil /opt/flexlm/bin/lmstat
	dosym lmutil /opt/flexlm/bin/lmver

	# documentation
	dodoc enduser.pdf

	# init files
	newinitd ${FILESDIR}/flexlm-init flexlm
	newconfd ${FILESDIR}/flexlm-conf flexlm

	# environment
	doenvd ${FILESDIR}/90flexlm

	# empty dir for licenses
	keepdir /etc/flexlm
}

pkg_postinst() {
	enewgroup flexlm
	enewuser flexlm -1 /bin/bash /opt/flexlm flexlm -c "FlexLM server user"
	elog "FlexLM installed. Config is in /etc/conf.d/flexlm"
	elog "Default location for license file is /etc/flexlm/license.dat"
}
