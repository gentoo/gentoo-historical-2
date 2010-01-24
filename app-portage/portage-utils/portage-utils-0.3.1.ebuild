# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/portage-utils/portage-utils-0.3.1.ebuild,v 1.2 2010/01/24 21:19:28 vapier Exp $

inherit flag-o-matic toolchain-funcs

DESCRIPTION="small and fast portage helper tools written in C"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="static"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i -e 's:\[\[:[:' -e 's:\]\]:]:' Makefile
}

src_compile() {
	tc-export CC
	use static && append-ldflags -static
	emake || die
}

src_install() {
	emake install DESTDIR="${D}" || die
	prepalldocs

	exeinto /etc/portage/bin
	doexe "${FILESDIR}"/post_sync || die
	insinto /etc/portage/postsync.d
	doins "${FILESDIR}"/q-reinitialize || die
}

pkg_postinst() {
	elog "/etc/portage/postsync.d/q-reinitialize has been installed for convenience"
	elog "If you wish for it to be automatically run at the end of every --sync simply chmod +x /etc/portage/postsync.d/q-reinitialize"
	elog "Normally this should only take a few seconds to run but file systems such as ext3 can take a lot longer."
	elog "If ever you find this to be an inconvenience simply chmod -x /etc/portage/postsync.d/q-reinitialize"
}
