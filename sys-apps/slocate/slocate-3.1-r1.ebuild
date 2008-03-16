# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/slocate/slocate-3.1-r1.ebuild,v 1.12 2008/03/16 08:41:57 vapier Exp $

inherit flag-o-matic eutils

DESCRIPTION="Secure way to index and quickly search for files on your system (drop-in replacement for 'locate')"
HOMEPAGE="http://slocate.trakker.ca/"
SRC_URI="http://slocate.trakker.ca/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="sys-apps/shadow"
RDEPEND="${DEPEND}
	!sys-apps/rlocate"

pkg_setup() {
	if [[ -n $(egetent group slocate) ]] && [[ -z $(egetent group locate) ]] ; then
		eerror "The 'slocate' group has been renamed to 'locate'."
		eerror "You seem to already have a 'slocate' group."
		eerror "Please rename it:"
		eerror "groupmod -n locate slocate"
		die "Change 'slocate' to 'locate'"
	fi
	enewgroup locate 245
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-incompat-warning.patch
	epatch "${FILESDIR}"/${P}-cron.patch
}

src_compile() {
	filter-lfs-flags
	emake -C src || die
}

src_install() {
	dobin src/slocate || die
	dodir /usr/bin
	dosym slocate /usr/bin/locate
	dosym slocate /usr/bin/updatedb

	exeinto /etc/cron.daily
	newexe debian/cron.daily slocate || die

	doman doc/*.1
	dosym slocate.1 /usr/share/man/man1/locate.1

	keepdir /var/lib/slocate

	dodoc Changelog README WISHLIST notes

	insinto /etc
	doins "${FILESDIR}"/updatedb.conf

	fowners root:locate /usr/bin/slocate
	fperms go-r,g+s /usr/bin/slocate

	chown -R root:locate "${D}"/var/lib/slocate
	fperms 0750 /var/lib/slocate
}

pkg_preinst() {
	if has_version '=sys-apps/slocate-2*' ; then
		rm -f "${ROOT}"/var/lib/slocate/slocate.db
		ewarn "The slocate database created by slocate-2.x is incompatible"
		ewarn "with slocate-3.x.  Make sure you run updatedb!"
	fi
}

pkg_postinst() {
	if [[ -f ${ROOT}/etc/cron.daily/slocate.cron ]]; then
		ewarn "If you merged slocate-2.7.ebuild, please remove"
		ewarn "/etc/cron.daily/slocate.cron since .cron has been removed"
		ewarn "from the filename"
		echo
	fi
}
