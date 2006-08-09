# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/mico/mico-2.3.11-r1.ebuild,v 1.2 2006/08/09 18:37:22 cardoe Exp $

inherit eutils qt3

IUSE="ssl tcl qt3 gtk postgres"

DESCRIPTION="A freely available and fully compliant implementation of the CORBA standard"
HOMEPAGE="http://www.mico.org/"
SRC_URI="http://www.mico.org/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

DEPEND="virtual/libc
	>=sys-devel/flex-2.5.2
	>=sys-devel/bison-1.22
	ssl? ( dev-libs/openssl )
	tcl? ( dev-lang/tcl )
	qt3? ( $(qt_min_version 3.3) )
	postgres? ( dev-db/postgresql )"

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-build-fix.patch
}

src_compile() {
	local myopts="--enable-final
		--disable-mini-stl"
#		--enable-life
#		--enable-externalize"

	use ssl && myopts="${myopts} --with-ssl=/usr" \
		|| myopts="${myopts} --without-ssl"
	use tcl && myopts="${myopts} --with-tcl=/usr" \
		|| myopts="${myopts} --without-tcl"
	use qt3 && myopts="${myopts} --with-qt=${QTDIR}" \
		|| myopts="${myopts} --without-qt"
	use gtk && myopts="${myopts} --with-gtk=/usr" \
		|| myopts="${myopts} --without-gtk"
	use postgres && myopts="${myopts} --with-pgsql=/usr" \
		|| myopts="${myopts} --without-pgsql"

	econf ${myopts} || die "configure failed"

	# Rather not emake here, as is a memory hog
	make || die "make failed"
}

src_install() {
	make INSTDIR=${D}/usr SHARED_INSTDIR=${D}/usr install || die

	dodir /usr/share/
	mv ${D}/usr/man ${D}/usr/share
	dodir /usr/share/doc/
	mv ${D}/usr/doc ${D}/usr/share/doc/${P}

	dodoc CHANGES* CONVERT FAQ INSTALL* LICENSE* MANIFEST README* ROADMAP TODO VERSION
}
