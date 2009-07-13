# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-portage/gentoolkit/gentoolkit-0.2.4.5.ebuild,v 1.8 2009/07/13 15:00:44 josejx Exp $

EAPI=2

inherit eutils python

DESCRIPTION="Collection of administration scripts for Gentoo"
HOMEPAGE="http://www.gentoo.org/proj/en/portage/tools/index.xml"
SRC_URI="mirror://gentoo/${P}.tar.gz http://dev.gentoo.org/~fuzzyray/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 -x86-fbsd"

DEPEND="sys-apps/portage
	dev-lang/python[xml]
	dev-lang/perl
	sys-apps/grep"
RDEPEND="${DEPEND}"
RESTRICT="test"

src_install() {
	emake DESTDIR="${D}" install-gentoolkit || die "install-gentoolkit failed"

	# Create cache directory for revdep-rebuild
	dodir /var/cache/revdep-rebuild
	keepdir /var/cache/revdep-rebuild
	fowners root:root /var/cache/revdep-rebuild
	fperms 0700 /var/cache/revdep-rebuild
}

pkg_postinst() {
	# Make sure that our ownership and permissions stuck
	chown root:root "${ROOT}/var/cache/revdep-rebuild"
	chmod 0700 "${ROOT}/var/cache/revdep-rebuild"

	python_mod_optimize /usr/lib/gentoolkit

	einfo
	elog "The default location for revdep-rebuild files has been moved"
	elog "to /var/cache/revdep-rebuild when run as root."
	einfo
	einfo "Another alternative to equery is app-portage/portage-utils"
	einfo
	einfo "For further information on gentoolkit, please read the gentoolkit"
	einfo "guide: http://www.gentoo.org/doc/en/gentoolkit.xml"
	einfo
}

pkg_postrm() {
	python_mod_cleanup /usr/lib/gentoolkit
}
