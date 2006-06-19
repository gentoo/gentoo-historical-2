# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/emerge-delta-webrsync/emerge-delta-webrsync-3.3.ebuild,v 1.7 2006/06/19 20:02:13 zmedico Exp $

DESCRIPTION="emerge-webrsync using patches to minimize bandwidth"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/index.xml"
SRC_URI="mirror://gentoo/${P}
	http://dev.gentoo.org/~zmedico/portage/archives/${P}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha ~amd64 ~hppa ia64 ~mips ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/portage
	>=dev-util/diffball-0.6.5
	x86? ( app-arch/tarsync )"

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}/" || die "failed cping $P"
	sed -i -e 's:aparently:apparently:' "${WORKDIR}/${P}" || die "failed correcting minor typo"
}

src_compile() { :; }

src_install() {
	newbin "${WORKDIR}/${P}" "${PN}" || die "failed copying ${P}"
	dodir /var/delta-webrsync
	fperms 0770 /var/delta-webrsync
}

pkg_preinst() {
	chgrp portage ${IMAGE}/var/delta-webrsync
}
