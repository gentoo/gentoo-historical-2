# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/dante/dante-1.1.15-r2.ebuild,v 1.12 2005/08/17 18:54:59 killerfox Exp $

inherit fixheadtails eutils

DESCRIPTION="A free socks4,5 and msproxy implementation"
HOMEPAGE="http://www.inet.no/dante/"
SRC_URI="ftp://ftp.inet.no/pub/socks/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ~ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="tcpd debug selinux pam"

RDEPEND="virtual/libc
	pam? ( sys-libs/pam )
	tcpd? ( sys-apps/tcp-wrappers )
	selinux? ( sec-policy/selinux-dante )
	userland_GNU? ( sys-apps/shadow )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4
	sys-devel/libtool
	>=sys-devel/automake-1.9"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}_pre1-socksify.patch
	epatch ${FILESDIR}/${P}-bindresvport.patch
	epatch ${FILESDIR}/${P}-optionalpam.patch
	epatch ${FILESDIR}/${P}-getipnodebyname.patch

	ht_fix_file configure configure.ac
	sed -i \
		-e 's:/etc/socks\.conf:/etc/socks/socks.conf:' \
		-e 's:/etc/sockd\.conf:/etc/socks/sockd.conf:' \
		doc/{faq.ps,faq.tex,sockd.8,sockd.conf.5,socks.conf.5}
}

src_compile() {
	libtoolize --copy --force
	econf \
		`use_enable debug` \
		`use_enable tcpd libwrap` \
		`use_with pam` \
		--with-socks-conf=/etc/socks/socks.conf \
		--with-sockd-conf=/etc/socks/sockd.conf \
		|| die "bad ./configure"
	# the comments in the source say this is only useful for 2.0 kernels ...
	# well it may fix 2.0 but it breaks with 2.6 :)
	[ "${KV:0:3}" == "2.6" ] && sed -i 's:if HAVE_LINUX_ECCENTRICITIES:if 0:' include/common.h
	emake || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install || die

	# bor: comment libdl.so out it seems to work just fine without it
	sed -i -e 's:libdl\.so::' ${D}/usr/bin/socksify || die 'sed failed'

	# default configuration files
	insinto /etc/socks
	doins ${FILESDIR}/sock?.conf
	cd ${D}/etc/socks && {
		use pam && epatch ${FILESDIR}/sockd.conf-with-pam.patch
		use tcpd && epatch ${FILESDIR}/sockd.conf-with-libwrap.patch
	}
	cd ${S}

	# our init script
	exeinto /etc/init.d
	newexe ${FILESDIR}/dante-sockd-init dante-sockd
	insinto /etc/conf.d
	newins ${FILESDIR}/dante-sockd-conf dante-sockd

	# install documentation
	dodoc BUGS CREDITS NEWS README SUPPORT TODO VERSION
	docinto txt
	cd doc
	dodoc README* *.txt SOCKS4.*
	docinto example
	cd ../example
	dodoc *.conf
}

pkg_postinst() {
	enewuser sockd -1 -1 /etc/socks daemon
}
