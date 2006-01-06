# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/crossover-office-bin/crossover-office-bin-3.0.1.ebuild,v 1.4 2006/01/06 22:37:25 vapier Exp $

inherit eutils

DESCRIPTION="specialized version of wine for MS Office"
HOMEPAGE="http://www.codeweavers.com/site/products/cxoffice/"
SRC_URI="install-crossover-standard-${PV}.sh"

LICENSE="CROSSOVER"
SLOT="0"
KEYWORDS="-* ~x86"
IUSE="nas"
RESTRICT="fetch nostrip"

RDEPEND="virtual/x11
	nas? ( media-libs/nas )
	sys-libs/glibc"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}"
	einfo "and place ${A} in ${DISTDIR}"
}

src_unpack() {
	unpack_makeself
}

src_install() {
	dodir /opt/cxoffice
	cp -r * "${D}"/opt/cxoffice || die "cp failed"
	rm -r "${D}"/opt/cxoffice/setup.{sh,data}
	insinto /opt/cxoffice/etc
	doins support/templates/cxoffice.conf
}
