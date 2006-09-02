# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/xrdp/xrdp-0.3.1.ebuild,v 1.2 2006/09/02 17:41:32 weeve Exp $

inherit eutils multilib

DESCRIPTION="An open source remote desktop protocol(rdp) server."
HOMEPAGE="http://xrdp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="net-misc/vnc"

DESTDIR="/usr/$(get_libdir)/${PN}"

pkg_setup() {
	if ! built_with_use net-misc/vnc server; then
		eerror
		eerror "You must have your VNC implementation (currently net-misc/vnc) built"
		eerror "with the \"server\" USE flag to use ${PN}."
		eerror
		die "Please rebuild net-misc/vnc with USE=server"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-respect-cflags.patch"
	epatch "${FILESDIR}/${P}-curdir.patch"

	sed -ie '/instfiles\/xrdp_control1.sh/ d' Makefile
	sed -ie "s:/usr/xrdp:${DESTDIR}:g" Makefile */Makefile
	# fix insecure rpath
	sed -ie "s:rpath,.:rpath,${DESTDIR}:" xrdp/Makefile
}


src_compile() {
	emake MYCFLAGS="${CFLAGS}" DESTDIR="${DESTDIR}" || die "emake failed"
}

src_install() {
	emake DESTDIRDEB="${D}" installdeb || die "emake installdeb failed"
	dodoc design.txt readme.txt "${D}${DESTDIR}/startwm.sh"
	doman "${D}/usr/man/"*/*
	keepdir /var/log/${PN}
	rm -rf "${D}${DESTDIR}/startwm.sh" "${D}/usr/man"
	exeinto "${DESTDIR}"
	doexe "${FILESDIR}/startwm.sh"
	newinitd "${FILESDIR}/${PN}-initd" ${PN}
	newconfd ${FILESDIR}/${PN}-confd ${PN}
	sed -i "s:LIBDIR:$(get_libdir):" "${D}/etc/init.d/${PN}"
}
