# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libsrtp/libsrtp-1.4.4-r1.ebuild,v 1.1 2009/04/15 04:17:53 volkmar Exp $

EAPI="2"

inherit eutils

MY_PN="srtp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Open-source implementation of the Secure Real-time Transport Protocol (SRTP)"
HOMEPAGE="http://srtp.sourceforge.net/srtp.html"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~ppc ~x86"
IUSE="aesicm console debug doc syslog"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	# generate a shared lib
	epatch "${FILESDIR}"/${P}-shared.patch
}

src_configure() {
	# stdout: default error output for messages in debug
	# kernel-linux: breaks the build
	# gdoi: disabled by upstream and breaks the build
	econf \
		--enable-stdout \
		--disable-kernel-linux \
		--disable-gdoi \
		$(use_enable aesicm generic-aesicm) \
		$(use_enable console) \
		$(use_enable debug) \
		$(use_enable syslog)
}

src_compile() {
	# target all is building test
	emake ${PN}.a ${PN}.so || die "emake failed"
}

src_test() {
	# getopt returns an int, not a char
	sed -i -e "s/char q/int q/" \
		test/rdbx_driver.c test/srtp_driver.c test/dtls_srtp_driver.c \
		|| die "fixing getopt errors failed"

	# test/rtpw_test.sh is assuming . is in $PATH
	sed -i -e "s:\$RTPW :./\$RTPW :" test/rtpw_test.sh \
		|| die "patching test/rtpw_test.sh failed"

	# test/rtpw.c is using /usr/share/dict/words assuming it exists
	# using test/rtpw.c guaratees the file exists in any case
	sed -i -e "s:/usr/share/dict/words:rtpw.c:" test/rtpw.c \
		|| die "patching test/rtpw.c failed"

	emake test || die "building test failed"
	emake -j1 runtest || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc CHANGES README TODO || die "dodoc failed"

	if use doc; then
		# libsrtp.pdf can also be generated with doxygen
		# but it would be a waste of time as an up-to-date version is built
		dodoc doc/*.txt doc/${PN}.pdf || die "dodoc failed"
	fi
}
