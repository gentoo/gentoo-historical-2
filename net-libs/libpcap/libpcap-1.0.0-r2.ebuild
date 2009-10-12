# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpcap/libpcap-1.0.0-r2.ebuild,v 1.9 2009/10/12 09:03:00 jer Exp $

inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="A system-independent library for user-level network packet capture"
HOMEPAGE="http://www.tcpdump.org/"
SRC_URI="http://www.tcpdump.org/release/${P}.tar.gz
	http://www.jp.tcpdump.org/release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="ipv6 bluetooth"

RDEPEND="!virtual/libpcap
	bluetooth? ( || ( net-wireless/bluez net-wireless/bluez-libs ) )"
DEPEND="${RDEPEND}
	sys-devel/flex"
PROVIDE="virtual/libpcap"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-cross-linux.patch"
	epatch "${FILESDIR}/${P}-install-bindir.patch"
	epatch "${FILESDIR}/${P}-install-headers.patch"
	epatch "${FILESDIR}/${P}-optional-bluetooth.patch"
	epatch "${FILESDIR}/${P}-LDFLAGS.patch"
	epatch "${FILESDIR}/${P}-freebsd-pic.patch"
	eautoreconf
}

src_compile() {
	econf $(use_enable ipv6) \
		$(use_enable bluetooth)
	emake all shared || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install install-shared || die "emake install failed"

	dosym libpcap.so.${PV:0:5} /usr/$(get_libdir)/libpcap.so.1
	dosym libpcap.so.${PV:0:5} /usr/$(get_libdir)/libpcap.so

	# We need this to build pppd on G/FBSD systems
	if [[ "${USERLAND}" == "BSD" ]]; then
		insinto /usr/include
		doins pcap-int.h || die "failed to install pcap-int.h"
	fi

	# We are not installing README.{Win32,aix,hpux,tru64} (bug 183057)
	dodoc CREDITS CHANGES VERSION TODO README{,.dag,.linux,.macosx,.septel}
}
