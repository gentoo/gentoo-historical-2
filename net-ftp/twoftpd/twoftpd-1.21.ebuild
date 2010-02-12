# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/twoftpd/twoftpd-1.21.ebuild,v 1.7 2010/02/12 09:46:37 bangert Exp $

inherit toolchain-funcs

DESCRIPTION="Simple secure efficient FTP server by Bruce Guenter"
HOMEPAGE="http://untroubled.org/twoftpd/"
SRC_URI="http://untroubled.org/twoftpd/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-libs/bglibs-1.026
	>=net-libs/cvm-0.32"
RDEPEND="sys-apps/ucspi-tcp
	sys-process/daemontools
	>=net-libs/cvm-0.32"

src_compile() {
	echo "/usr/sbin" > conf-bin
	echo "/usr/share/man" > conf-man
	echo "$(tc-getCC) ${CFLAGS} -I/usr/include/bglibs" > conf-cc
	echo "$(tc-getCC) -L/usr/lib/bglibs" > conf-ld
	emake || die "make failed"
}

src_install() {
	dodir /usr/sbin
	dodir /usr/share/man/man1

	emake install install_prefix="${D}" || die "install failed"

	dodoc ANNOUNCEMENT ChangeLog NEWS README TODO VERSION
	dodoc twoftpd.run twoftpd-log.run
}
