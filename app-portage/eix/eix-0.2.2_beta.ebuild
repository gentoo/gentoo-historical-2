# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/eix/eix-0.2.2_beta.ebuild,v 1.1 2005/03/19 19:23:22 hollow Exp $

inherit eutils flag-o-matic bash-completion

DESCRIPTION="Small utility for searching ebuilds with indexing for fast results"
HOMEPAGE="http://sourceforge.net/projects/eix"
SRC_URI="mirror://sourceforge/eix/${PN}-${PV}.tar.bz2 http://frexx.de/eix/${PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc"
IUSE="debug"

DEPEND="sys-devel/gcc
	virtual/libc"
RDEPEND="sys-apps/portage
	virtual/libc"

src_compile() {
	aclocal
	libtoolize --force --copy
	autoconf

	use debug && append-flags -g
	econf || die "configure failed"

	emake || die "emake	failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dobashcompletion contrib/eix.bash-completion ${PN}
}

pkg_postinst() {
	einfo "Please run '/usr/bin/eix -u' to setup the portage search database."
	einfo "The database file will be located at /var/cache/eix"
}
