# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libfwbuilder/libfwbuilder-1.0.2-r1.ebuild,v 1.1 2004/01/13 08:31:23 aliz Exp $

IUSE="ssl snmp"

DESCRIPTION="A firewall GUI (library functions)"
SRC_URI="mirror://sourceforge/fwbuilder/${P}.tar.gz"
HOMEPAGE="http://www.fwbuilder.org/"
S=${WORKDIR}/${P}

KEYWORDS="~x86 ~sparc ~amd64"
LICENSE="GPL-2"
SLOT="0"

DEPEND="sys-devel/libtool
	sys-devel/autoconf
	=dev-libs/glib-1.2*
	>=dev-libs/libxml2-2.4.19
	!=dev-libs/libxml2-2.4.25
	>=dev-libs/libxslt-1.0.15
	snmp? ( virtual/snmp )
	ssl? ( dev-libs/openssl )"

src_unpack() {
	unpack ${A} ; cd ${S}

	epatch ${FILESDIR}/${P}-libxml2.patch
}

src_compile() {
	./autogen.sh \
		--prefix=/usr \
		--host=${CHOST} \
		`use_with ssl openssl` || die "./configure failed"

	emake || die "emake failed"
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	prepalldocs
}
