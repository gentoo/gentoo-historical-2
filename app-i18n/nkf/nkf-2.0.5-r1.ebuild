# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/nkf/nkf-2.0.5-r1.ebuild,v 1.2 2005/05/12 19:00:56 gmsoft Exp $

inherit gcc eutils perl-module distutils

MY_P="${PN}${PV//./}"
DESCRIPTION="Network Kanji code conversion Filter with UTF-8/16 support"
HOMEPAGE="http://sourceforge.jp/projects/nkf/"
SRC_URI="http://www01.tcp-ip.or.jp/~furukawa/nkf_utf8/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~amd64 ~ppc64 ~ia64 hppa"
IUSE="perl cjk python"

DEPEND="virtual/libc"

S=${WORKDIR}/${MY_P}

src_compile() {
	emake CC="$(gcc-getCC)" CFLAGS="${CFLAGS}" nkf || die
	if use perl; then
		cd ${S}/NKF.mod
		perl-module_src_compile
		perl-module_src_test
	fi
	if use python; then
		cd ${WORKDIR}
		epatch ${FILESDIR}/nkf-python.patch
		cd ${S}/NKF.python
		distutils_src_compile
		distutils_src_test
	fi
}

src_install() {
	dobin nkf || die
	doman nkf.1
	if use cjk; then
		dodir /usr/share/man/ja/man1
		insinto /usr/share/man/ja/man1
		./nkf -e nkf.1j > nkf.1
		doins nkf.1
	fi
	dodoc INSTALL* nkf.doc
	if use perl; then
		cd ${S}/NKF.mod
		perl-module_src_install
	fi
	if use python; then
		cd ${S}/NKF.python
		distutils_src_install
	fi
}
