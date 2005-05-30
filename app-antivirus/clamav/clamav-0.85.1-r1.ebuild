# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/clamav/clamav-0.85.1-r1.ebuild,v 1.2 2005/05/30 20:22:46 ticho Exp $

inherit eutils flag-o-matic

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="http://www.clamav.net/"
SRC_URI="mirror://sourceforge/clamav/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~amd64 ~hppa ~alpha ~ppc64 ~ia64"
IUSE="crypt milter selinux"

DEPEND="virtual/libc
	crypt? ( >=dev-libs/gmp-4.1.2 )
	milter? ( mail-mta/sendmail )
	>=sys-libs/zlib-1.2.1-r3
	>=net-misc/curl-7.10.0
	net-dns/libidn
	>=sys-apps/sed-4"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-clamav )
	sys-apps/grep"
PROVIDE="virtual/antivirus"

pkg_setup() {
	if use milter; then
		if [ ! -e /usr/lib/libmilter.a ] ; then
			ewarn "In order to enable milter support, clamav needs sendmail with enabled milter"
			ewarn "USE flag. Either recompile sendmail with milter USE flag enabled, or disable"
			ewarn "this flag for clamav as well to disable milter support."
			die "need milter-enabled sendmail"
		fi
	fi
	enewgroup clamav
	enewuser clamav -1 /bin/false /dev/null clamav
	pwconv || die
}

src_compile() {
	has_version =sys-libs/glibc-2.2* && filter-lfs-flags

	local myconf

	# we depend on fixed zlib, so we can disable this check to prevent redundant
	# warning (bug #61749)
	myconf="${myconf} --disable-zlib-vcheck"
	# use id utility instead of /etc/passwd parsing (bug #72540)
	myconf="${myconf} --enable-id-check"
	use milter && myconf="${myconf} --enable-milter"

	econf ${myconf} --with-dbdir=/var/lib/clamav || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS BUGS NEWS README ChangeLog FAQ INSTALL
	newconfd ${FILESDIR}/clamd.conf clamd
	newinitd ${FILESDIR}/clamd.rc.new clamd
	dodoc ${FILESDIR}/clamav-milter.README.gentoo

	dodir /var/run/clamav
	keepdir /var/run/clamav
	fowners clamav:clamav /var/run/clamav
	dodir /var/log/clamav
	keepdir /var/log/clamav
	fowners clamav:clamav /var/log/clamav

	# Change /etc/clamd.conf to be usable out of the box
	sed -i -e "s:^\(Example\):\# \1:" \
		-e "s:.*\(PidFile\) .*:\1 /var/run/clamav/clamd.pid:" \
		-e "s:.*\(LocalSocket\) .*:\1 /var/run/clamav/clamd.sock:" \
		-e "s:.*\(User\) .*:\1 clamav:" \
		-e "s:^\#\(LogFile\) .*:\1 /var/log/clamav/clamd.log:" \
		-e "s:^\#\(LogTime\).*:\1:" \
		${D}/etc/clamd.conf

	# Do the same for /etc/freshclam.conf
	sed -i -e "s:^\(Example\):\# \1:" \
		-e "s:.*\(PidFile\) .*:\1 /var/run/clamav/freshclam.pid:" \
		-e "s:.*\(DatabaseOwner\) .*:\1 clamav:" \
		-e "s:^\#\(LogFile\) .*:\1 /var/log/freshclam.log:" \
		-e "s:^\#\(LogTime\).*:\1:" \
		${D}/etc/freshclam.conf

	if use milter ; then
		echo "START_MILTER=no" \
			>> ${D}/etc/conf.d/clamd
		echo "MILTER_SOCKET=\"/var/run/clamav/clmilter.sock\"" \
			>>${D}/etc/conf.d/clamd
		echo "MILTER_OPTS=\"-m 10\"" \
			>>${D}/etc/conf.d/clamd
	fi
}

pkg_postinst() {
	echo
	ewarn "As of 0.85-r1, all settings from /etc/conf.d/clamd are ignored, except for"
	ewarn "START_CLAMD, START_FRESHCLAM and MILTER related options. All settings are"
	ewarn "read from /etc/clamd.conf and /etc/freshclam.conf, so double-check these two files."
	echo
	ewarn "Warning: clamd and/or freshclam have not been restarted."
	ewarn "You should restart them with: /etc/init.d/clamd restart"
	echo
	if use milter ; then
		einfo "For simple instructions howto setup the clamav-milter..."
		einfo ""
		einfo "zless /usr/share/doc/${PF}/clamav-milter.README.gentoo.gz"
		echo
	fi
}
