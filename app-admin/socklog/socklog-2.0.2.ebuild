# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/socklog/socklog-2.0.2.ebuild,v 1.1 2005/04/12 01:06:03 vapier Exp $

inherit toolchain-funcs flag-o-matic

DESCRIPTION="small secure replacement for syslogd with automatic log rotation"
HOMEPAGE="http://smarden.org/socklog/"
SRC_URI="http://smarden.org/socklog/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="static"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-process/runit-0.13.1"
PROVIDE="virtual/logger"

S=${WORKDIR}/admin/${P}

src_unpack() {
	unpack ${A}
	cd ${S}

	use static && append-ldflags -static
	echo "$(tc-getCC) ${CFLAGS}" > src/conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > src/conf-ld
}

src_compile() {
	cd src
	emake || die "make failed"
}

src_install() {
	cd src
	dobin tryto uncat socklog-check || die "dobin"
	dosbin socklog socklog-conf || die "dosbin"

	cd "${S}"
	dodoc package/{CHANGES,README}
	dohtml doc/*.html
	doman man/*
}
