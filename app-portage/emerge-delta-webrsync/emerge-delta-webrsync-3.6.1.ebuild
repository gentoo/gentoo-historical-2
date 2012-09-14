# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/emerge-delta-webrsync/emerge-delta-webrsync-3.6.1.ebuild,v 1.1 2012/09/14 07:54:53 zmedico Exp $

EAPI=4
DESCRIPTION="emerge-webrsync using patches to minimize bandwidth"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/index.xml"
SRC_URI="http://git.overlays.gentoo.org/gitweb/?p=proj/portage.git;a=blob_plain;f=misc/emerge-delta-webrsync;hb=bb9186cd81d707593ea386d17321bd594d847126 -> ${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND="
	app-shells/bash
	>=sys-apps/portage-2.1.10
	>=dev-util/diffball-0.6.5"

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}/${P}" "${WORKDIR}/" || die
}

src_install() {
	newbin ${P} ${PN} || die
	keepdir /var/delta-webrsync
	fperms 0770 /var/delta-webrsync
}

pkg_preinst() {
	chgrp portage "${ED}"/var/delta-webrsync
	has_version "$CATEGORY/$PN"
	WAS_PREVIOUSLY_INSTALLED=$?
}

pkg_postinst() {
	if [[ $WAS_PREVIOUSLY_INSTALLED != 0 ]] && \
		! has_version app-arch/tarsync ; then
		elog "For maximum emerge-delta-webrsync" \
			"performance, install app-arch/tarsync."
	fi
}
