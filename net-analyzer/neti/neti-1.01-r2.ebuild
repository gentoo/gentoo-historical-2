# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/neti/neti-1.01-r2.ebuild,v 1.3 2007/04/28 17:41:13 swegener Exp $

DESCRIPTION="NETI@Home research project from GATech"
HOMEPAGE="http://www.neti.gatech.edu"
SRC_URI="mirror://sourceforge/neti/${P}.tar.gz"
KEYWORDS="~ppc x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="zlib java"

RDEPEND="java? ( || ( >=virtual/jdk-1.2 >=virtual/jre-1.2 ) )
	net-analyzer/wireshark
	virtual/libc"

DEPEND="java? ( >=virtual/jdk-1.2 )
	net-libs/libpcap"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# start-stop-daemon asks for this
	sed -i -e "1i\#\!/bin/sh" NETIStart || die "sed NETIStart failed"
}

src_compile() {
	econf \
		`use_with zlib` \
		 || die "failed to configure"

	emake NETILogParse neti \
		|| die "failed to make"

	if use java;
	then
		emake javadir=/usr/share/${PN} classjava.stamp
	fi
}

src_install() {
	emake DESTDIR="${D}" install-sbinPROGRAMS install-sbinSCRIPTS \
		install-sysconfDATA install-man || die "install failed"

	if use java;
	then
		emake javadir=/usr/share/${PN} \
			 DESTDIR="${D}" install-javaJAVA install-javaDATA || die "java install failed"
	fi

	dobin /usr/bin
	echo java -cp /usr/share/${PN} NETIMap > "${D}"/usr/bin/NETIMap
	fperms ugo+x /usr/bin/NETIMap
	dodoc COPYING
	newinitd "${FILESDIR}"/neti-init neti
	sed -i -e s/ethereal/shark/g "${D}"/etc/init.d/neti "${D}"/usr/sbin/NETIStart
}
