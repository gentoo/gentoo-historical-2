# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /home/cvsroot/gentoo-x86/net-libs/libfwbuilder/libfwbuilder-0.10.8.ebuild,v 1.0

MY_PN=${PN/lib/}
DESCRIPTION="A firewall GUI"
SRC_URI="mirror://sourceforge/${MY_PN}/${P}.tar.gz"
HOMEPAGE="http://fwbuilder.sourceforge.net"
S=${WORKDIR}/${P}

KEYWORDS="x86 sparc sparc64"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-libs/libsigc++-1.0
	>=dev-libs/libxslt-1.0.7
	>=net-analyzer/ucd-snmp-4.2.3
	ssl? ( dev-libs/openssl )"
RDEPEND=${DEPEND}

src_unpack() {
	unpack ${A}
	cd ${S}/src/fwbuilder && \
		patch -p0 <${FILESDIR}/FWReference.cc-gcc3-gentoo.patch || die
}

src_compile() {
	local myconf
	
	use static && myconf="${myconf} --disable-shared --enable-static=yes"
	use ssl || myconf="${myconf} --without-openssl"

	./autogen.sh \
		--prefix=/usr \
		--host=${CHOST} \
		${myconf} || die "./configure failed"

	if [ "`use static`" ] ; then
		emake LDFLAGS="-static" || die "emake LDFLAGS failed"
	else
		emake || die "emake failed"
	fi
}

src_install() {
	emake DESTDIR=${D} install || die "emake install failed"
	prepalldocs
}
