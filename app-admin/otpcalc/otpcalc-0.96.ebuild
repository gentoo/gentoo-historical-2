# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/otpcalc/otpcalc-0.96.ebuild,v 1.11 2005/04/24 21:55:05 wormo Exp $

DESCRIPTION="A One Time Password and S/Key calculator for X"
HOMEPAGE="http://killa.net/infosec/otpCalc/"
SRC_URI="http://killa.net/infosec/otpCalc/otpCalc-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 alpha ~ppc"
IUSE=""

DEPEND="=x11-libs/gtk+-1.2*
	virtual/x11
	virtual/libc"

S=${WORKDIR}/${P/c/C}

src_unpack() {
	unpack ${A}
	sed -i -e "s/VERSION/${PV}/g" ${S}/otpCalc.man
	sed -i "s#-s -O3#${CFLAGS}#g" ${S}/Makefile.in
}

src_install() {
	newman otpCalc.man otpCalc.1
	dobin otpCalc || die
}
