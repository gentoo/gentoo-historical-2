# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/numactl/numactl-2.0.7-r1.ebuild,v 1.3 2012/03/22 19:13:11 vapier Exp $

EAPI="4"

inherit eutils toolchain-funcs multilib

DESCRIPTION="Utilities and libraries for NUMA systems"
HOMEPAGE="http://oss.sgi.com/projects/libnuma/"
SRC_URI="ftp://oss.sgi.com/www/projects/libnuma/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="perl"

RDEPEND="perl? ( dev-lang/perl )"

src_prepare() {
	echo "printf $(get_libdir)" > getlibdir
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" BENCH_CFLAGS=""
}

src_test() {
	if [ -d /sys/devices/system/node ]; then
		einfo "The only generically safe test is regress2."
		einfo "The other test cases require 2 NUMA nodes."
		cd test
		./regress2 || die "regress2 failed!"
	else
		ewarn "You do not have baseline NUMA support in your kernel, skipping tests."
	fi
}

src_install() {
	emake install prefix="${ED}/usr"
	# delete man pages provided by the man-pages package #238805
	rm -rf "${ED}"/usr/share/man/man[25]
	doman *.8 # makefile doesnt get them all
	dodoc README TODO CHANGES DESIGN
	if ! use perl ; then
		rm "${ED}"/usr/bin/numastat "${ED}"/usr/share/man/man8/numastat.8 || die
	fi
}
