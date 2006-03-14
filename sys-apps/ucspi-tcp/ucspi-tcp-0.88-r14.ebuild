# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ucspi-tcp/ucspi-tcp-0.88-r14.ebuild,v 1.2 2006/03/14 19:06:46 hansmi Exp $

inherit eutils toolchain-funcs fixheadtails

IPV6_PATCH="diff17"

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="http://cr.yp.to/ucspi-tcp.html"
SRC_URI="
	http://cr.yp.to/${PN}/${P}.tar.gz
	ipv6? ( http://www.fefe.de/ucspi/ucspi-tcp-0.88-ipv6.${IPV6_PATCH}.bz2 )
	mirror://qmail/ucspi-rss.diff
	ssl? (
		!ipv6? ( http://www.nrg4u.com/qmail/ucspi-tcp-ssl-20050405.patch.gz )
		ipv6? ( mirror://ucspi-tcp-0.88-ipv6-ssl-20050405.patch )
	)
"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="ssl ipv6 selinux doc"
RESTRICT="test"

DEPEND="virtual/libc
		ssl? ( >=dev-libs/openssl-0.9.6g )"
RDEPEND="${DEPEND}
		doc? ( app-doc/ucspi-tcp-man )
		selinux? ( sec-policy/selinux-ucspi-tcp )"
PROVIDE="virtual/inetd"

src_unpack() {
	unpack ${A}
	cd ${S}

	if use ipv6; then
		epatch ${WORKDIR}/ucspi-tcp-0.88-ipv6.${IPV6_PATCH}
		# Fixes bug 18892
		epatch ${FILESDIR}/${PV}-bigendian.patch
		epatch ${FILESDIR}/${PV}-tcprules.patch
	fi

	if use ssl; then
		if use ipv6 ; then
			# Rediffed patch by hansmi@g.o
			# -> broken, hansmi on 2006-03-14
			# epatch ${DISTDIR}/ucspi-tcp-0.88-ipv6-ssl-20050405.patch
			echo
			ewarn "SSL support disabled when using IPv6!"
			ewarn "Please supply us a patch or wait until someone else does."
			ebeep
			echo
		else
			epatch ${DISTDIR}/ucspi-tcp-ssl-20050405.patch.gz
		fi
	fi

	if use !ssl && use !ipv6; then
		epatch ${FILESDIR}/${PV}-errno.patch
	fi

	epatch ${DISTDIR}/ucspi-rss.diff
	epatch ${FILESDIR}/${PV}-rblsmtpd-ignore-on-RELAYCLIENT.patch

	# Bug 98726
	#epatch ${FILESDIR}/${PV}-limits.patch
	#use ipv6 && epatch ${FILESDIR}/${PV}-limits-ipv6.patch

	ht_fix_file Makefile

	echo "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
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
	dodoc README.tcpserver-limits-patch
	insinto /etc/tcprules.d/
	newins ${FILESDIR}/tcprules-Makefile Makefile
}

pkg_postinst() {
	einfo "We have started a move to get all tcprules files into"
	einfo "/etc/tcprules.d/, where we have provided a Makefile to"
	einfo "easily update the CDB file."
}
