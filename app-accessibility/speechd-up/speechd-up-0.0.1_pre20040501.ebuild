# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-accessibility/speechd-up/speechd-up-0.0.1_pre20040501.ebuild,v 1.2 2004/05/01 18:17:24 squinky86 Exp $

DESCRIPTION="speechup screen reader with software synthesis"
HOMEPAGE="http://www.freebsoft.org/speechd-up"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/glibc"

DEPENDS="${RDEPEND}
	>=sys-devel/automake-1.7.8
	>=sys-devel/autoconf-2.58"

inherit cvs eutils

ECVS_SERVER="cvs.freebsoft.org:/var/lib/cvs"
ECVS_MODULE="speechd-up"
ECVS_TOP_DIR="${DISTDIR}/cvs-src/${PN}"
S=${WORKDIR}/${ECVS_MODULE}

src_compile() {
	aclocal || die
	autoconf || die
	autoheader || die
	automake -a || die
	automake || die
	epatch ${FILESDIR}/speechd-up-gentoo.patch
	econf || die
	emake CFLAGS="${CFLAGS}" CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	einstall || die
}
