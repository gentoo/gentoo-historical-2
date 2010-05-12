# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpcap/libpcap-1.1.1.ebuild,v 1.5 2010/05/12 20:04:45 ranger Exp $

EAPI=2
inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="A system-independent library for user-level network packet capture"
HOMEPAGE="http://www.tcpdump.org/"
SRC_URI="http://www.tcpdump.org/release/${P}.tar.gz
	http://www.jp.tcpdump.org/release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ppc64 ~s390 ~sh ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="bluetooth ipv6 libnl"

RDEPEND="!virtual/libpcap
	bluetooth? ( || ( net-wireless/bluez net-wireless/bluez-libs ) )
	libnl? ( dev-libs/libnl )"
DEPEND="${RDEPEND}
	sys-devel/flex"

PROVIDE="virtual/libpcap"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.1-cross-linux.patch"
	eautoreconf
}

src_configure() {
	econf $(use_enable ipv6) \
		$(use_with libnl) \
		$(use_enable bluetooth)
}

src_compile() {
	emake all shared || die "compile problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	# We need this to build pppd on G/FBSD systems
	if [[ "${USERLAND}" == "BSD" ]]; then
		insinto /usr/include
		doins pcap-int.h || die "failed to install pcap-int.h"
	fi

	# We are not installing README.{Win32,aix,hpux,tru64} (bug 183057)
	dodoc CREDITS CHANGES VERSION TODO README{,.dag,.linux,.macosx,.septel} || die
}
