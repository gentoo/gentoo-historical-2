# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/ringtonetools/ringtonetools-2.18.ebuild,v 1.2 2003/11/15 08:04:39 strider Exp $

DESCRIPTION="Ringtone Tools is a program for creating ringtones and logos for mobile phones"
HOMEPAGE="http://ringtonetools.mikekohn.net/"
SRC_URI="http://www.mikekohn.com/ringtonetools/${P}.tar.gz"
DEPEND="virtual/glibc"
IUSE=""
SLOT="0"
LICENSE="ringtonetools"
KEYWORDS="x86"

src_compile() {
	emake || die
}

src_install() {
	exeinto /usr/bin
	doexe ringtonetools
	insinto /usr/share/${P}
	doins samples/*
	dodoc docs/*
}
