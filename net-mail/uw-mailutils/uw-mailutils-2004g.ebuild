# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/uw-mailutils/uw-mailutils-2004g.ebuild,v 1.3 2005/10/06 14:58:57 ferdy Exp $

inherit eutils flag-o-matic

MY_P="imap-${PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="This is a sample skeleton ebuild file"
HOMEPAGE="http://foo.bar.com/"
SRC_URI="ftp://ftp.cac.washington.edu/imap/${MY_P}.tar.Z"

LICENSE="as-is"
SLOT="0"
KEYWORDS="alpha x86"
IUSE=""

DEPEND="virtual/libc
	!<=net-mail/uw-imap-2004g"

src_unpack() {
	unpack ${A}
	chmod -R ug+w ${S}

	cd ${S}

	epatch ${FILESDIR}/${P}.patch || die "epatch failed"

	sed -i -e "s|\`cat \$C/CFLAGS\`|${CFLAGS}|g" \
		src/mailutil/Makefile \
		src/mtest/Makefile || die "sed failed patching Makefile CFLAGS."

	append-flags -fPIC
}

src_compile() {
	yes | make lnp EXTRACFLAGS="${CFLAGS}" SSLTYPE=none || die
}

src_install() {
	into /usr
	dobin mailutil/mailutil mtest/mtest
	doman src/mailutil/mailutil.1
}
