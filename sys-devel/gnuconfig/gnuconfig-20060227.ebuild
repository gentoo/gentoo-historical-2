# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/gnuconfig/gnuconfig-20060227.ebuild,v 1.2 2006/03/16 00:03:52 vapier Exp $

inherit eutils

DESCRIPTION="Updated config.sub and config.guess file from GNU"
HOMEPAGE="http://savannah.gnu.org/projects/config"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc-macos ppc64 s390 sh sparc x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	unpack ${A}
	epatch "${WORKDIR}"/*.patch
}

src_compile() { :;}

src_install() {
	insinto /usr/share/${PN}
	doins config.{sub,guess} || die
	fperms +x /usr/share/${PN}/config.{sub,guess}
	dodoc ChangeLog
}
