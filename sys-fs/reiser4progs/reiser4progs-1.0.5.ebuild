# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/reiser4progs/reiser4progs-1.0.5.ebuild,v 1.6 2007/01/04 18:27:03 flameeyes Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"

inherit toolchain-funcs autotools

MY_P=${PN}-${PV/_p/-}
DESCRIPTION="reiser4progs: mkfs, fsck, etc..."
HOMEPAGE="http://www.namesys.com/v4/v4.html"
SRC_URI="ftp://ftp.namesys.com/pub/reiser4progs/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 -sparc x86"
IUSE="static debug readline"

DEPEND="~sys-libs/libaal-${PV}
	readline? ( sys-libs/readline )"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"

	eautoreconf

	cat <<-EOF > run-ldconfig
		#!/bin/sh
		true
	EOF
}

src_compile() {
	econf \
		$(use_enable static full-static) \
		$(use_enable static mkfs-static) \
		$(use_enable static fsck-static) \
		$(use_enable static debugfs-static) \
		$(use_enable static measurefs-static) \
		$(use_enable static cpfs-static) \
		$(use_enable static resizefs-static) \
		$(use_enable debug) \
		$(use_with readline) \
		--enable-libminimal \
		--sbindir=/sbin \
		|| die "configure failed"
	emake || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS CREDITS ChangeLog NEWS README THANKS TODO
	#resizefs binary doesnt exist in this release
	rm -f "${D}"/usr/share/man/man8/resizefs*

	# move shared libs to /
	dodir /$(get_libdir)
	mv "${D}"/usr/$(get_libdir)/lib*.so* "${D}"/$(get_libdir)/ || die
	gen_usr_ldscript libreiser4-minimal.so libreiser4.so librepair.so
}
