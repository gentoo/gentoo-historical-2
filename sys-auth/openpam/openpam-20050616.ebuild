# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-auth/openpam/openpam-20050616.ebuild,v 1.3 2006/10/05 11:13:57 flameeyes Exp $

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit multilib flag-o-matic autotools

DESCRIPTION="Open source PAM library."
HOMEPAGE="http://www.openpam.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86-fbsd"
IUSE="debug"

RDEPEND="!virtual/pam"
DEPEND="sys-devel/make
	dev-lang/perl"
PDEPEND="sys-freebsd/freebsd-pam-modules"

PROVIDE="virtual/pam"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${PN}-20050201-gentoo.patch"
	epatch "${FILESDIR}/${PN}-20050201-nbsd.patch"
	epatch "${FILESDIR}/${P}-redef.patch"

	sed -i -e 's:-Werror::' "${S}/configure.ac"

	eautoreconf
	elibtoolize
}

src_compile() {
	econf \
		--disable-dependency-tracking \
		--with-modules-dir=/$(get_libdir)/security \
		${myconf} || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR=${D} install

	dodoc CREDITS HISTORY MANIFEST RELNOTES README
}
