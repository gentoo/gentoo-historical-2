# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/clamav/clamav-0.82-r1.ebuild,v 1.6 2005/03/10 14:39:35 ticho Exp $

inherit eutils flag-o-matic

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="http://www.clamav.net/"
SRC_URI="mirror://sourceforge/clamav/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc amd64 hppa ~alpha ~ppc64"
IUSE="crypt milter selinux"

DEPEND="virtual/libc
	crypt? ( >=dev-libs/gmp-4.1.2 )
	>=sys-libs/zlib-1.2.1-r3
	>=net-misc/curl-7.10.0
	net-dns/libidn"
RDEPEND="selinux? ( sec-policy/selinux-clamav )"
PROVIDE="virtual/antivirus"

#S="${WORKDIR}/${P/_/}"

pkg_setup() {
	enewgroup clamav
	enewuser clamav -1 /bin/false /dev/null clamav
	pwconv || die
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-MS05-002-false-positive-fix.patch || die
}

src_compile() {
	has_version =sys-libs/glibc-2.2* && filter-lfs-flags

	local myconf

	# we depend on fixed zlib, so we can disable this check to prevent redundant
	# warning (bug #61749)
	myconf="${myconf} --disable-zlib-vcheck"

	use milter && myconf="${myconf} --enable-milter"
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
	echo
	einfo "NOTE: As of clamav-0.80, the config file for clamd is no longer"
	einfo "      /etc/clamav.conf, but /etc/clamd.conf. Adjust your"
	einfo "      configuration accordingly before (re)starting clamd."
	echo
	ewarn "Warning: clamd and/or freshclam have not been restarted."
	ewarn "You should restart them with: /etc/init.d/clamd restart"
	echo
	if use milter ; then
		einfo "For simple instructions howto setup the clamav-milter..."
		einfo ""
		einfo "less /usr/share/doc/${PF}/clamav-milter.README.gentoo.gz"
		echo
	fi
}
