# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/clamav/clamav-0.75.1.ebuild,v 1.7 2004/09/23 04:46:00 vapier Exp $

inherit eutils flag-o-matic

#MY_P="${PN}-0.70-rc"
MY_P="${P}"
DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="http://www.clamav.net/"
SRC_URI="mirror://sourceforge/clamav/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc sparc x86"
IUSE="milter crypt"

DEPEND="virtual/libc
	crypt? ( >=dev-libs/gmp-4.1.2 )"
PROVIDE="virtual/antivirus"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup clamav
	enewuser clamav -1 /bin/false /dev/null clamav
	pwconv || die
}

src_compile() {
	has_version =sys-libs/glibc-2.2* && filter-lfs-flags

	local myconf
	use milter && myconf="--enable-milter"
	econf ${myconf} --with-dbdir=/var/lib/clamav || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS NEWS README ChangeLog TODO FAQ INSTALL
	exeinto /etc/init.d ; newexe ${FILESDIR}/clamd.rc clamd
	insinto /etc/conf.d ; newins ${FILESDIR}/clamd.conf clamd
	dodoc ${FILESDIR}/clamav-milter.README.gentoo
}

pkg_postinst() {
	einfo ""
	ewarn "Warning: clamd and/or freshclam have not been restarted."
	ewarn "You should restart them with: /etc/init.d/clamd restart"
	einfo ""
	if use milter ; then
		einfo "For simple instructions howto setup the clamav-milter..."
		einfo ""
		einfo "less /usr/share/doc/${PF}/clamav-milter.README.gentoo.gz"
	fi
}
