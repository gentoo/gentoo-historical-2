# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libpcap/libpcap-1.0.1_pre20090812.ebuild,v 1.5 2010/06/11 12:28:54 ssuominen Exp $

EAPI=2
inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="A system-independent library for user-level network packet capture"
HOMEPAGE="http://www.tcpdump.org/"
MY_P=${PN}-${PV/_pre/-}
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}
#	SRC_URI="http://www.tcpdump.org/release/${P}.tar.gz
#		http://www.jp.tcpdump.org/release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="bluetooth ipv6 libnl"

RDEPEND="!virtual/libpcap
	bluetooth? ( net-wireless/bluez )
	libnl? ( dev-libs/libnl )"
DEPEND="${RDEPEND}
	sys-devel/flex"
PROVIDE="virtual/libpcap"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.0.0-cross-linux.patch"
	epatch "${FILESDIR}/${PN}-1.0.1_pre20090812-poll-cpu-usage.patch"
	epatch "${FILESDIR}"/${PN}-1.0.1-autoconf.patch #281690
	echo ${PV} > VERSION # Avoid CVS in version
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
	emake DESTDIR="${D}" install install-shared || die "emake install failed"

	dosym libpcap$(get_libname ${PV}) /usr/$(get_libdir)/libpcap$(get_libname 1)
	dosym libpcap$(get_libname ${PV}) /usr/$(get_libdir)/libpcap$(get_libname)

	# We need this to build pppd on G/FBSD systems
	if [[ "${USERLAND}" == "BSD" ]]; then
		insinto /usr/include
		doins pcap-int.h || die "failed to install pcap-int.h"
	fi

	# We are not installing README.{Win32,aix,hpux,tru64} (bug 183057)
	dodoc CREDITS CHANGES VERSION TODO README{,.dag,.linux,.macosx,.septel} || die
}
