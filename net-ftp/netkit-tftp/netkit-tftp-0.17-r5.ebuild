# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/netkit-tftp/netkit-tftp-0.17-r5.ebuild,v 1.3 2008/03/21 14:57:41 ranger Exp $

inherit eutils toolchain-funcs

DESCRIPTION="the tftp server included in netkit"
SRC_URI="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/netkit-tftp-0.17.tar.gz"
HOMEPAGE="ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/"

KEYWORDS="amd64 ~mips ~ppc ppc64 ~sparc x86"
IUSE=""
LICENSE="BSD"
SLOT="0"

DEPEND="!virtual/tftp
		virtual/inetd"
PROVIDE="virtual/tftp"

src_unpack() {
	unpack $A
	cd "${S}"

	# Change default man directory
	sed -i -e 's:MANDIR="$PREFIX/man":MANDIR="$PREFIX/share/man":' \
			-e 's:^LDFLAGS=::' configure

	# don't prestrip binaries
	find -name Makefile -exec sed -i -e 's,install -s,install,' \{\} \;

	# Solve QA warning by including string.h
	epatch "${FILESDIR}"/memset.patch
	epatch "${FILESDIR}"/${P}-tftp-connect-segfault.patch
	epatch "${FILESDIR}"/${P}-tftp-manpage-typo.patch
	epatch "${FILESDIR}"/${P}-tftp-fix-put-zero-size.diff
}

src_compile() {
	./configure --prefix=/usr --installroot="${D}" \
				--with-c-compiler="$(tc-getCC)" || die
	emake || die
}

src_install() {
	dodir /usr/bin /usr/sbin
	doman tftp/tftp.1 tftpd/tftpd.8
	make install || die

	dodoc "${FILESDIR}"/{tftp-dgram,tftp-stream} BUGS ChangeLog README
	einfo "Take a look at /usr/share/doc/${PF}/tftp-* files"
	einfo "for sample xinetd configuration files."
}
