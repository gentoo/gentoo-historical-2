# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/snobol/snobol-0.99.4.ebuild,v 1.4 2006/02/15 06:59:39 robbat2 Exp $

DESCRIPTION="Phil Budne's port of Macro SNOBOL4 in C, for modern machines"
HOMEPAGE="http://www.snobol4.org/csnobol4/"
SRC_URI="mirror://snobol4/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
DEPEND="sys-devel/gcc
		sys-devel/m4"
RDEPEND=""

src_unpack() {
	unpack ${A}
	sed '/autoconf/s:autoconf:./autoconf:g' -i ${S}/configure
	echo "OPT=${CFLAGS}" >${S}/local-config
	echo "ADD_CPPFLAGS(-DUSE_STDARG_H)" >>${S}/local-config
	echo "BINDEST=/usr/bin/snobol4" >>${S}/local-config
	echo "MANDEST=/usr/share/man/man4/snobol4.1" >>${S}/local-config
	echo "SNOLIB_DIR=/usr/lib/snobol4" >>${S}/local-config
}

src_compile() {
	# WARNING
	# The configure script is NOT what you expect
	emake || die "emake failed"
	emake doc/snobol4.1 || die "emake doc/snobol4.1 failed"
}

src_install() {
	into /usr
	newbin xsnobol4 snobol4
	dodir /usr/lib/snobol4
	insinto /usr/lib/snobol4
	doins snolib.a snolib/bq.sno

	doman doc/*.1
	dohtml doc/*.html
	rm doc/*.html
	dodoc doc/*.ps doc/*.doc
}
