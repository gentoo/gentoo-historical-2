# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/icu/icu-3.6-r2.ebuild,v 1.6 2008/02/07 10:40:15 armin76 Exp $

inherit eutils

DESCRIPTION="IBM Internationalization Components for Unicode"
HOMEPAGE="http://ibm.com/software/globalization/icu/"
SRC_URI="ftp://ftp.software.ibm.com/software/globalization/icu/${PV}/icu4c-${PV/./_}-src.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="debug"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}/source

src_unpack() {
	unpack ${A}
	# Bug 208001
	epatch "${FILESDIR}"/${PN}-3.6-regexp-CVE-2007-4770+4771.diff
}

src_compile() {
	econf --enable-static $(use_enable debug) || die "econf failed"
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dohtml ../readme.html ../license.html
}
