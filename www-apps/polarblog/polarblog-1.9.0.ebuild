# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/polarblog/polarblog-1.9.0.ebuild,v 1.2 2007/01/02 22:50:25 rl03 Exp $

inherit webapp

MY_PV=${PV//./}
S=${WORKDIR}/PB_v${MY_PV}

IUSE=""

DESCRIPTION="PolarBlog is an open source embedded weblog solution"
HOMEPAGE="http://polarblog.polarlava.com"
SRC_URI="http://polarblog.polarlava.com/releases/pb_v${MY_PV}.tgz"
KEYWORDS="~x86 ~ppc ~sparc"

RDEPEND="
	virtual/php
"

LICENSE="GPL-2"

src_install() {
	webapp_src_preinst

	dodoc CHANGES INSTALL README

	cp -R [[:lower:]][[:lower:]]* ${D}/${MY_HTDOCSDIR}
	webapp_serverowned ${MY_HTDOCSDIR}
	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_hook_script ${FILESDIR}/reconfig
	webapp_src_install
}
