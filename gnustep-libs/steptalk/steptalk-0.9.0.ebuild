# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/steptalk/steptalk-0.9.0.ebuild,v 1.1 2006/03/25 22:32:38 grobian Exp $

inherit gnustep

DESCRIPTION="StepTalk is the official GNUstep scripting framework."
HOMEPAGE="http://www.gnustep.org/experience/StepTalk.html"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/libs/${P/steptalk/StepTalk}.tar.gz"

KEYWORDS="~ppc ~x86"
LICENSE="LGPL-2.1"
SLOT="0"

IUSE="doc"
DEPEND="${GS_DEPEND}"
RDEPEND="${GS_RDEPEND}"
S="${WORKDIR}/${P/steptalk/StepTalk}"

egnustep_install_domain "System"

src_install() {
	cd ${S}
	egnustep_env
	egnustep_install || die

	if use doc ; then
		egnustep_env
		cd Documentation
		mkdir -p ${TMP}/tmpdocs
		mv *.* ${TMP}/tmpdocs
		mv Reference ${TMP}/tmpdocs
		mkdir -p ${D}$(egnustep_install_domain)/Library/Documentation/Developer/${PN/stept/StepT}
		mv ${TMP}/tmpdocs/* ${D}$(egnustep_install_domain)/Library/Documentation/Developer/${PN/stept/StepT}
		cd ..
	fi
	egnustep_package_config
}
