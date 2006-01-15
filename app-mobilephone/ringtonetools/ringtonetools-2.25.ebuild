# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-mobilephone/ringtonetools/ringtonetools-2.25.ebuild,v 1.5 2006/01/15 11:07:07 hansmi Exp $

DESCRIPTION="program for creating ringtones and logos for mobile phones"
HOMEPAGE="http://ringtonetools.mikekohn.net/"
SRC_URI="http://downloads.mikekohn.net/ringtonetools/${P}.tar.gz"

LICENSE="ringtonetools"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=""

src_compile() {
	emake FLAGS="${CFLAGS}" || die "make failed"
}

src_install() {
	dobin ringtonetools || die
	dodoc docs/*
	docinto samples
	dodoc samples/*
}
