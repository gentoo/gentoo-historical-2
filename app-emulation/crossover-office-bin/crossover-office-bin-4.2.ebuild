# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/crossover-office-bin/crossover-office-bin-4.2.ebuild,v 1.9 2006/09/24 10:11:33 vapier Exp $

inherit eutils

DESCRIPTION="specialized version of wine for MS Office"
HOMEPAGE="http://www.codeweavers.com/site/products/cxoffice/"
SRC_URI="install-crossover-standard-${PV}.sh"

LICENSE="CROSSOVER"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="nas"
RESTRICT="fetch nostrip"

RDEPEND="sys-libs/glibc
	x11-libs/libXrandr
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXmu
	x11-libs/libXxf86dga
	x11-libs/libXxf86vm
	dev-util/desktop-file-utils
	nas? ( media-libs/nas )
	amd64? ( app-emulation/emul-linux-x86-xlibs )"

S=${WORKDIR}

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE}"
	einfo "and place ${A} in ${DISTDIR}"
}

pkg_setup() {
	! built_with_use dev-lang/perl ithreads \
		&& die "you need to have perl built with USE=ithreads"
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

pkg_postinst() {
	einfo "Run /opt/cxoffice/bin/cxsetup as normal user to create"
	einfo "bottles and install Windows applications."
}
