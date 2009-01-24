# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/uw-mailutils/uw-mailutils-2007e.ebuild,v 1.5 2009/01/24 18:20:16 dertobi123 Exp $

inherit eutils flag-o-matic

MY_P="imap-${PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Mail utilities from the UW"
HOMEPAGE="http://www.washington.edu/imap/"
SRC_URI="ftp://ftp.cac.washington.edu/imap/${MY_P}.tar.Z"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ppc ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="virtual/libc
	!<mail-client/pine-4.64-r1"
RDEPEND="${DEPEND}
	!<net-mail/uw-imap-${PV}"

src_unpack() {
	unpack ${A}
	chmod -R ug+w "${S}"

	cd "${S}"

	epatch "${FILESDIR}/${PN}-2004g.patch" || die "epatch failed"

	sed -i -e "s|\`cat \$C/CFLAGS\`|${CFLAGS}|g" \
		src/mailutil/Makefile \
		src/mtest/Makefile || die "sed failed patching Makefile CFLAGS."

	append-flags -fPIC
}

src_compile() {
	local port=slx
	use elibc_FreeBSD && port=bsf
	yes | make "${port}" EXTRACFLAGS="${CFLAGS}" SSLTYPE=none || die
}

src_install() {
	into /usr
	dobin mailutil/mailutil mtest/mtest
	doman src/mailutil/mailutil.1
}
