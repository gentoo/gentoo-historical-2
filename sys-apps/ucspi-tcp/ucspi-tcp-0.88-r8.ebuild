# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ucspi-tcp/ucspi-tcp-0.88-r8.ebuild,v 1.17 2004/10/23 05:45:56 mr_bones_ Exp $

inherit eutils gcc

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://cr.yp.to/ucspi-tcp.html"
SRC_URI="http://cr.yp.to/${PN}/${P}.tar.gz
	ipv6? ( http://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.diff13.bz2 )
	mirror://qmail/ucspi-rss.diff
	ssl? ( http://www.nrg4u.com/qmail/ucspi-tcp-ssl-20020705.patch.gz
		http://www.netmonks.ca/gentoo/patches/ucspi-tcp-0.88-ipv6-ssl-nm1.patch.bz2 )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 ppc64 ~ppc-macos"
IUSE="ssl ipv6 selinux"

DEPEND="virtual/libc
	ssl? ( >=dev-libs/openssl-0.9.6g )"
RDEPEND="selinux? ( sec-policy/selinux-ucspi-tcp )"
PROVIDE="virtual/inetd"

src_unpack() {
	unpack ${A}
	cd ${S}
	if use ipv6; then
		epatch ${WORKDIR}/ucspi-tcp-0.88-ipv6.diff13
	fi
	if use ssl; then
		# this is a merged thingy. Thanks to Stephen Olesen <slepp.netmonks.ca>
		# (bug #32007)
		if use ipv6 ; then
			epatch ${WORKDIR}/ucspi-tcp-0.88-ipv6-ssl-nm1.patch
		else
			epatch ${WORKDIR}/ucspi-tcp-ssl-20020705.patch
		fi
	fi
	epatch ${FILESDIR}/${PV}-errno.patch
	epatch ${DISTDIR}/ucspi-rss.diff
	epatch ${FILESDIR}/${PV}-head-1.patch

	echo "$(gcc-getCC) ${CFLAGS}" > conf-cc
	echo "$(gcc-getCC) ${LDFLAGS}" > conf-ld
	echo "/usr/" > conf-home

	# allow larger responses
	sed -i 's|if (text.len > 200) text.len = 200;|if (text.len > 500) text.len = 500;|g' ${S}/rblsmtpd.c
}

src_compile() {
	emake || die
}

src_install() {
	dobin tcpserver tcprules tcprulescheck argv0 recordio tcpclient *\@ tcpcat mconnect mconnect-io addcr delcr fixcrio rblsmtpd || die
	doman *.[15]
	dodoc CHANGES FILES README SYSDEPS TARGETS TODO VERSION
	insinto /etc/tcprules.d/
	newins ${FILESDIR}/tcprules-Makefile Makefile
}

pkg_postinst() {
	einfo "We have started a move to get all tcprules files into"
	einfo "/etc/tcprules.d/, where we have provided a Makefile to"
	einfo "easily update the CDB file."
}
