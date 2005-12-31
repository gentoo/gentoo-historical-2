# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/autoconf-archive/autoconf-archive-2005.12.20.ebuild,v 1.1 2005/12/31 08:34:56 vapier Exp $

inherit eutils

MY_PV=${PV//./-}
DESCRIPTION="GNU Autoconf Macro Archive"
HOMEPAGE="http://autoconf-archive.cryp.to/"
SRC_URI="http://autoconf-archive.cryp.to/${PN}-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND=""
RDEPEND="sys-devel/automake
	sys-devel/autoconf"

S=${WORKDIR}/${PN}-${MY_PV}

src_install() {
	make install DESTDIR="${D}" || die
	dodir /usr/share/doc
	mv "${D}"/usr/share/{${PN},doc/${PF}} || die
}
