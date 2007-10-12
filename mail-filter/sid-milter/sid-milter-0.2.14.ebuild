# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/sid-milter/sid-milter-0.2.14.ebuild,v 1.1 2007/10/12 22:04:46 mrness Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A milter-based application provide Sender-ID service"
HOMEPAGE="http://sourceforge.net/projects/sid-milter/"
SRC_URI="mirror://sourceforge/sid-milter/${P}.tar.gz"

LICENSE="Sendmail-Open-Source"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openssl
	>=sys-libs/db-3.2
	|| ( mail-filter/libmilter mail-mta/sendmail )"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup milter
	enewuser milter -1 -1 -1 milter
}

src_unpack() {
	unpack "${A}"

	sed -e "s:@@CFLAGS@@:${CFLAGS}:" \
		"${FILESDIR}/gentoo.config.m4" > "${S}/devtools/Site/site.config.m4" \
		|| die "failed to generate site.config.m4"
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	newinitd "${FILESDIR}/sid-filter.init" sid-filter \
		|| die "newinitd failed"
	newconfd "${FILESDIR}/sid-filter.conf" sid-filter \
		|| die "newconfd failed"

	dodir /usr/bin
	emake -j1 DESTDIR="${D}" SUBDIRS=sid-filter \
		SBINOWN=root SBINGRP=root UBINOWN=root UBINGRP=root \
		install || die "make install failed"

	# man build is broken; do man page installation by hand
	doman */*.8

	# some people like docs
	dodoc RELEASE_NOTES *.txt
}

pkg_postinst() {
	pkg_setup # create milter user
}
