# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/devfsd/devfsd-1.3.25-r8.ebuild,v 1.9 2004/10/05 15:48:54 vapier Exp $

inherit eutils flag-o-matic

DESCRIPTION="Daemon for the Linux Device Filesystem"
HOMEPAGE="http://www.atnf.csiro.au/~rgooch/linux/"
SRC_URI="ftp://ftp.atnf.csiro.au/pub/people/rgooch/linux/daemons/devfsd/devfsd-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc ppc64 s390 sparc x86"
IUSE="uclibc"

DEPEND="virtual/libc"
PROVIDE="virtual/dev-manager"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}

	cd ${S}
	epatch ${FILESDIR}/${P}-kernel-2.5.patch
	epatch ${FILESDIR}/${P}-pic.patch
	use uclibc && epatch ${FILESDIR}/${P}-no-nis.patch

	sed -e "s:-O2:${CFLAGS}:g" \
		-e 's:/usr/man:/usr/share/man:' \
		-e '32,34d;11,16d' -e '6c\' \
		-e 'DEFINES	:= -DLIBNSL="\\"/lib/libnsl.so.1\\""' \
		-i GNUmakefile
	use uclibc && sed -e 's|libnsl.so.1|libnsl.so.0|' -i GNUmakefile
}

src_compile() {
	make || die
}

src_install() {
	dodir /sbin /usr/share/man /etc
	make PREFIX=${D} install || die

	#config file is handled in baselayout
	rm -f ${D}/etc/devfsd.conf

	dodoc devfsd.conf INSTALL
}
