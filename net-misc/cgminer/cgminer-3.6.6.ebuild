# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/cgminer/cgminer-3.6.6.ebuild,v 1.1 2013/10/26 13:16:31 blueness Exp $

EAPI=5

inherit autotools flag-o-matic

DESCRIPTION="Bitcoin CPU/GPU/FPGA/ASIC miner in C"
HOMEPAGE="http://bitcointalk.org/?topic=28402.msg357369 http://github.com/ckolivas/cgminer"
SRC_URI="http://ck.kolivas.org/apps/cgminer/${P}.tar.bz2"
#SRC_URI="https://github.com/ckolivas/cgminer/archive/v${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples hardened ncurses opencl adl scrypt
	avalon bflsc bitforce icarus klondike modminer"

REQUIRED_USE="|| ( opencl avalon bflsc bitforce icarus klondike modminer )
	adl? ( opencl )
	scrypt? ( opencl )"

DEPEND="net-misc/curl
	dev-libs/jansson
	adl? ( x11-libs/amd-adl-sdk )
	ncurses? ( sys-libs/ncurses )
	opencl? ( virtual/opencl )
	avalon? ( virtual/libusb:1 )
	bflsc? ( virtual/libusb:1 )
	bitforce? ( virtual/libusb:1 )
	icarus? ( virtual/libusb:1 )
	modminer? ( virtual/libusb:1 )"
RDEPEND="${DEPEND}"

src_prepare() {
	ln -s /usr/include/ADL/* ADL_SDK/
	eautoreconf
}

src_configure() {
	use hardened && append-cflags "-nopie"

	econf $(use_with ncurses curses) \
		$(use_enable opencl) \
		$(use_enable adl) \
		$(use_enable scrypt) \
		$(use_enable avalon) \
		$(use_enable bflsc) \
		$(use_enable bitforce) \
		$(use_enable icarus) \
		$(use_enable klondike) \
		$(use_enable modminer)
	# sanitize directories (is this still needed?)
	sed -i 's~^\(\#define CGMINER_PREFIX \).*$~\1"'"${EPREFIX}/usr/lib/cgminer"'"~' config.h
}

src_install() { # How about using some make install?
	dobin cgminer
	if use doc; then
		dodoc AUTHORS NEWS README API-README
		use opencl && dodoc GPU-README
		use scrypt && dodoc SCRYPT-README
		use icarus || use bitforce || use modminer && dodoc FPGA-README
		use avalon || use bflsc && dodoc ASIC-README
	fi

	if use modminer; then
		insinto /usr/lib/cgminer/modminer
		doins bitstreams/*.ncd
		dodoc bitstreams/COPYING_fpgaminer
	fi
	if use opencl; then
		insinto /usr/lib/cgminer
		doins *.cl
	fi
	if use examples; then
		docinto examples
		dodoc api-example.php miner.php API.java api-example.c example.conf
	fi
}
