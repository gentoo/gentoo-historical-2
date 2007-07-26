# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/tcpdump/tcpdump-3.9.6-r1.ebuild,v 1.3 2007/07/26 22:07:18 gustavoz Exp $

inherit flag-o-matic toolchain-funcs eutils

DESCRIPTION="A Tool for network monitoring and data acquisition"
HOMEPAGE="http://www.tcpdump.org/"
SRC_URI="http://www.tcpdump.org/release/${P}.tar.gz
	http://www.jp.tcpdump.org/release/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="ssl ipv6 samba"

DEPEND="net-libs/libpcap
	ssl? ( >=dev-libs/openssl-0.9.6m )"

pkg_setup() {
	if use samba ; then
		ewarn
		ewarn "CAUTION !!! CAUTION !!! CAUTION"
		ewarn
		ewarn "You're about to compile tcpdump with samba printing support"
		ewarn "Upstream tags it as 'possibly-buggy SMB printer'"
		ewarn "So think twice whether this is fine with you"
		ewarn
		ewarn "CAUTION !!! CAUTION !!! CAUTION"
		ewarn
		ewarn "(Giving you 10 secs to think about it)"
		ewarn
		ebeep 5
		epause 5
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	# bug 168916 - off-by-one heap overflow in 802.11 printer
	epatch "${FILESDIR}"/${PN}-3.9.5-print-802_11.c.diff

	# bug #184815 - <= 3.9.6 BGP dissector integer overflow
	epatch "${FILESDIR}"/${P}-bgp-integer-overflow.patch
}

src_compile() {
	# tcpdump needs some optymalization. see bug #108391
	( ! is-flag -O? || is-flag -O0 ) && append-flags -O

	replace-flags -O[3-9] -O2
	filter-flags -finline-functions

	# Fix wrt bug #48747
	if [[ $(gcc-major-version) -gt 3 ]] || \
		[[ $(gcc-major-version) -eq 3 && $(gcc-minor-version) -ge 4 ]]
	then
		filter-flags -funit-at-a-time
		append-flags -fno-unit-at-a-time
	fi

	local myconf
	if ! use ssl ; then
		myconf="--without-crypto"
	fi

	econf --with-user=tcpdump \
		$(use_enable ipv6) \
		$(use_enable samba smb) \
		${myconf} || die "configure failed"

	make CCOPT="$CFLAGS" || die "make failed"
}

pkg_preinst() {
	enewgroup tcpdump || die "Failed to add group tcpdump"
	enewuser tcpdump -1 -1 -1 tcpdump || die "Failed to add user tcpdump"
}

src_install() {
	dosbin tcpdump
	doman tcpdump.1
	dodoc *.awk
	dodoc README FILES VERSION CHANGES CREDITS TODO
}
