# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/fenris/fenris-0.07m-r1.ebuild,v 1.1 2004/01/09 01:07:25 liquidx Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Fenris is a tracer, GUI debugger, analyzer, partial decompiler and much more"
HOMEPAGE="http://razor.bindview.com/tools/fenris/"
# dev-snapshot: http://lcamtuf.coredump.cx/fenris/fenris.tgz (2004/01/08)
SRC_URI="mirror://gentoo/${P}-r1.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=sys-apps/portage-2.0.47-r10
	sys-libs/libtermcap-compat
	app-misc/screen
	sys-libs/ncurses
	dev-libs/openssl
	sys-kernel/linux-headers
	sys-devel/gdb"

RDEPEND="sys-apps/gawk"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/makefile.diff
	epatch ${FILESDIR}/build.diff
	epatch ${FILESDIR}/${P}-debian.patch
	epatch ${FILESDIR}/${P}-noansiart.patch # disable ascii art
	epatch ${FILESDIR}/${P}-dress.c.patch # update for latest binutils
	epatch ${FILESDIR}/${P}-speedup.patch # to speed up makefile
}

src_compile() {
	# We need to obtain libc version, this should be a reliable way :)
	# because internal script doesn't detect libc version during the emerge
	LIBC=`ls /lib/libc-* | awk -F- '{print $2}' | awk -F.so '{print $1}'`

	make all CFLAGS="$CFLAGS" LIBCVER=${LIBC} || die
}

src_install() {

	# We are doing make install by hand
	cd ${S}
	dodir /usr/share/fenris

	# Man pages
	doman doc/man/*

	# Documents
	dodir /usr/share/fenris/doc
	insinto /usr/share/fenris/doc
	doins doc/*

	# Fingeprints
	insinto /etc
	doins fnprints.dat

	# Executables
	into /usr
	dobin fenris fprints getfprints ragnarok fenris-bug \
		ragsplit dress aegir nc-aegir spliter.pl
}

pkg_postinst() {
	einfo "These new tools are installed in /usr/bin:"
	einfo "fenris fprints getfprints ragnarok fenris-bug ragsplit "
	einfo "dress aegir nc-aegir spliter.pl"
	einfo "Please refer to the manpage for fenris for further information"
}
