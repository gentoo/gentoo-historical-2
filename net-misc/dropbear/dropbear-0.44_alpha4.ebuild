# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/dropbear/dropbear-0.44_alpha4.ebuild,v 1.1 2004/09/22 19:00:28 vapier Exp $

inherit gnuconfig eutils

MY_P="${P/_alpha/test}"
DESCRIPTION="small SSH 2 server designed for small memory environments"
HOMEPAGE="http://matt.ucc.asn.au/dropbear/"
SRC_URI="http://matt.ucc.asn.au/dropbear/releases/${MY_P}.tar.bz2
	http://matt.ucc.asn.au/dropbear/testing/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-*"
IUSE="zlib multicall static"

DEPEND="zlib? ( sys-libs/zlib )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	gnuconfig_update
	epatch ${FILESDIR}/${PV}-install.patch
}

src_compile() {
	econf `use_enable zlib` || die

	if use multicall ; then
		sed -i \
			-e '/define DROPBEAR_MULTI/s:/\* *::' \
			-e '/define DROPBEAR_MULTI/s:\*/::' \
			options.h
		if use static ; then
			emake dropbearmultistatic || die "multi static failed"
		else
			emake dropbearmulti || die "multi failed"
		fi
	else
		emake || die "make failed"
	fi
}

src_install() {
	if use multicall ; then
		local multibin="dropbearmulti"
		use static && multibin="static${multibin}"
		dodir /usr/bin /usr/sbin
		dobin ${multibin} || die "dropbearmulti"
		dosym ${multibin} /usr/bin/dropbearkey || die
		dosym ${multibin} /usr/bin/dropbearconvert || die
		dosym ${multibin} /usr/bin/dbclient || die
		dosym ../bin/${multibin} /usr/sbin/dropbear || die
	else
		make install DESTDIR=${D} || die
	fi
	exeinto /etc/init.d ; newexe ${FILESDIR}/dropbear.init.d dropbear
	insinto /etc/conf.d ; newins ${FILESDIR}/dropbear.conf.d dropbear
	dodoc CHANGES README TODO SMALL
}
