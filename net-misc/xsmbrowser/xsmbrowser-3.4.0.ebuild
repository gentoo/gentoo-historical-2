# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/xsmbrowser/xsmbrowser-3.4.0.ebuild,v 1.7 2004/06/09 22:34:37 agriffis Exp $

DESCRIPTION="GUI SMB browser with preview written in expect"
HOMEPAGE="http://www.public.iastate.edu/~chadspen/xsmbrowser.html"
LICENSE="GPL-2"
RDEPEND="virtual/x11
	 net-fs/samba
	 dev-tcltk/expect"
KEYWORDS="x86 ~sparc ~amd64"
SLOT="0"
SRC_URI="http://www.public.iastate.edu/~chadspen/${P}.tar.gz"
S=${WORKDIR}/${P}

pkg_setup() {
	if ! use X; then
		eerror " "
		eerror "You must have X in your USE flags.  Expect must be compiled with X support."
		eerror "Without X support, xSMBrowser will not function."
		eerror " "
		eerror "If expect is already merged, you probably have to remerge it with USE=\"X\"."
		eerror " "
		die "You must have USE=\"X\"."
	fi
}

src_install() {
	dobin ${S}/xsmbrowser || die "xsmbrowser dobin failed"

	# fix the default pixmap path
	dosed s:\"pixmaps\":\"/usr/share/pixmaps/xsmbrowser\": \
		/usr/bin/xsmbrowser || die "Pixmap path fix failed"

	insinto /usr/share/pixmaps/xsmbrowser
	doins ${S}/pixmaps/* || die "Pixmap doins failed"
}
