# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/emerge-delta-webrsync/emerge-delta-webrsync-3.5.1-r2.ebuild,v 1.6 2007/03/10 14:51:44 vapier Exp $

inherit eutils

DESCRIPTION="emerge-webrsync using patches to minimize bandwidth"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/index.xml"
SRC_URI="mirror://gentoo/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ~ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=">=sys-apps/portage-2.1.1-r1
	>=dev-util/diffball-0.6.5
	x86? ( app-arch/tarsync )"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}/" || die "failed cping ${P}"
	epatch "${FILESDIR}"/3.5.1-metadata.patch
	epatch "${FILESDIR}"/3.5.1-md5sum.patch
	epatch "${FILESDIR}"/3.5.1-post_sync.patch
}

src_compile() { :; }

src_install() {
	newbin ${P} ${PN} || die "failed copying ${P}"
	keepdir /var/delta-webrsync
	fperms 0770 /var/delta-webrsync
}

pkg_preinst() {
	chgrp portage "${D}"/var/delta-webrsync
}
