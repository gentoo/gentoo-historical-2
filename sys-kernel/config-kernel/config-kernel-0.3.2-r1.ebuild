# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/config-kernel/config-kernel-0.3.2-r1.ebuild,v 1.4 2004/08/08 00:48:30 slarti Exp $

inherit distutils

DESCRIPTION="Kernel environment configuration tool"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="http://dev.gentoo.org/~latexer/files/koutput/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
DEPEND=">=sys-apps/sed-4"
RDEPEND="virtual/python"
KEYWORDS="x86"
IUSE=""

src_unpack() {
	unpack ${A}

	sed -i -e 's:^KBUILD_OUTPUT_PREFIX=.*:KBUILD_OUTPUT_PREFIX="":' ${S}/05kernel
}

src_install() {
	distutils_src_install
	dobin ${S}/config-kernel
	doman ${S}/config-kernel.1
	dodoc ChangeLog

	if [ ! -e /etc/env.d/05kernel ]
	then
		insinto /etc/env.d
		doins 05kernel
	fi
}
