# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/netperf/netperf-2.4.4.ebuild,v 1.6 2008/02/11 14:01:50 armin76 Exp $

inherit eutils flag-o-matic autotools

MY_P=${P/_rc/-rc}

DESCRIPTION="Network performance benchmark including tests for TCP, UDP, sockets, ATM and more."
#SRC_URI="ftp://ftp.netperf.org/netperf/experimental/${MY_P}.tar.gz"
SRC_URI="ftp://ftp.netperf.org/netperf/${MY_P}.tar.gz
		mirror://gentoo/netperf-2.4.4-svn_trunk_20071205.patch.bz2"
KEYWORDS="alpha ~amd64 ia64 ppc ppc64 sparc x86"

HOMEPAGE="http://www.netperf.org/"
LICENSE="netperf"
SLOT="0"
IUSE=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i 's:^\(#define DEBUG_LOG_FILE "\)/tmp/netperf.debug:\1/var/log/netperf.debug:' src/netserver.c
	epatch "${WORKDIR}"/${P}-svn_trunk_20071205.patch
	epatch "${FILESDIR}"/${PN}-2.4.0-gcc41.patch
	epatch "${FILESDIR}"/${PN}-CVE-2007-1444.patch
	epatch "${FILESDIR}"/${PN}-fix-scripts.patch

	# Fixing paths in scripts
	sed -i -e 's:^\(NETHOME=\).*:\1"/usr/bin":' \
			doc/examples/sctp_stream_script \
			doc/examples/tcp_range_script \
			doc/examples/tcp_rr_script \
			doc/examples/tcp_stream_script \
			doc/examples/udp_rr_script \
			doc/examples/udp_stream_script

	eautoconf
}

src_install () {
	einstall || die

	# move netserver into sbin as we had it before 2.4 was released with its
	# autoconf goodness
	dodir /usr/sbin
	mv "${D}"/usr/{bin,sbin}/netserver || die

	# init.d / conf.d
	newinitd "${FILESDIR}"/${PN}-2.2-init netperf
	newconfd "${FILESDIR}"/${PN}-2.2-conf netperf

	# documentation and example scripts
	dodoc AUTHORS ChangeLog NEWS README Release_Notes
	dodir /usr/share/doc/${PF}/examples
	#Scripts no longer get installed by einstall
	cp doc/examples/*_script "${D}"/usr/share/doc/${PF}/examples
}
