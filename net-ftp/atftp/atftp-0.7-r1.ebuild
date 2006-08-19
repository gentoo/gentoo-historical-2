# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/atftp/atftp-0.7-r1.ebuild,v 1.5 2006/08/19 18:09:59 weeve Exp $

inherit eutils flag-o-matic

DEBIAN_PV="11"
DEBIAN_A="${PN}_${PV}-${DEBIAN_PV}.diff.gz"

DESCRIPTION="Advanced TFTP implementation client/server"
HOMEPAGE="ftp://ftp.mamalinux.com/pub/atftp/"
SRC_URI="ftp://ftp.mamalinux.com/pub/atftp/${P}.tar.gz
		http://ftp.debian.org/debian/pool/main/a/${PN}/${DEBIAN_A}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 sparc ~x86"
IUSE="selinux tcpd readline pcre"

RDEPEND="tcpd? ( sys-apps/tcp-wrappers )
		selinux? ( sec-policy/selinux-tftpd )
		readline? ( sys-libs/readline )
		pcre? ( dev-libs/libpcre )"
DEPEND="${RDEPEND}
		!virtual/tftp"
PROVIDE="virtual/tftp"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"
	epatch "${DISTDIR}"/${DEBIAN_A}
	epatch "${FILESDIR}"/${P}-pcre.patch
	epatch "${FILESDIR}"/${P}-password.patch
	epatch "${FILESDIR}"/${P}-tests.patch
	epatch "${FILESDIR}"/${P}-glibc24.patch
	# remove upstream's broken CFLAGS
	sed -i.orig -e \
	  '/^CFLAGS="-g -Wall -D_REENTRANT"/s,".*","",g' \
	  ${S}/configure
}

src_compile() {
	append-flags -D_REENTRANT -DRATE_CONTROL
	econf \
		$(use_enable tcpd libwrap) \
		$(use_enable readline libreadline) \
		$(use_enable pcre libpcre) \
		--enable-mtftp \
		|| die "./configure failed"
	emake CFLAGS="${CFLAGS}" || die
}

src_install() {
	emake install DESTDIR="${D}" || die "Installation failed"
	newinitd "${FILESDIR}"/atftp.init atftp
	newconfd "${FILESDIR}"/atftp.confd atftp

	dodoc README* BUGS FAQ Changelog INSTALL TODO
	dodoc ${S}/docs/*

	docinto test
	cd ${S}/test
	dodoc load.sh mtftp.conf pcre_pattern.txt test.sh test_suite.txt
}
