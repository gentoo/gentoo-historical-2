# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/multiimonc/multiimonc-0.3.5.ebuild,v 1.5 2005/03/06 16:12:15 hansmi Exp $

inherit eutils

DESCRIPTION="A wxWidgets-based client for fli4l"
SRC_URI="http://www.fli4l.de/german/extern/multiimonc/MultiImonC-${PV}.tar.bz2"
HOMEPAGE="http://www.hansmi.ch/software/multiimonc"

S="${WORKDIR}/MultiImonC-${PV}"

KEYWORDS="x86 ppc amd64 sparc"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND="=x11-libs/wxGTK-2.4*
		virtual/libc
		virtual/x11"

src_compile() {
	econf || die "could not configure"
	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install || die "install problem"
}

