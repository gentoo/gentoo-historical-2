# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/clamav/clamav-0.94.ebuild,v 1.3 2008/09/06 11:55:14 rich0 Exp $

inherit autotools eutils flag-o-matic fixheadtails multilib

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="http://www.clamav.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="bzip2 crypt iconv mailwrapper milter nls selinux test"

DEPEND="bzip2? ( app-arch/bzip2 )
	crypt? ( >=dev-libs/gmp-4.1.2 )
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )
	iconv? ( virtual/libiconv )
	nls? ( sys-devel/gettext )
	test? ( dev-libs/check )
	dev-libs/gmp
	>=sys-libs/zlib-1.2.1-r3
	>=sys-apps/sed-4"
RDEPEND="${DEPEND}
	selinux? ( sec-policy/selinux-clamav )
	sys-apps/grep"
PROVIDE="virtual/antivirus"

pkg_setup() {
	if use milter; then
		if [ ! -e /usr/$(get_libdir)/libmilter.a ] ; then
			ewarn "In order to enable milter support, clamav needs sendmail with enabled milter"
			ewarn "USE flag, or mail-filter/libmilter package."
		fi
	fi

	enewgroup clamav
	enewuser clamav -1 -1 /dev/null clamav
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-buildfix.patch
	epatch "${FILESDIR}"/${P}-nls.patch

	# If nls flag is disabled, gettext may not be available, but eautoreconf
	# needs this file (bug #218892).
	use nls || cp "${FILESDIR}"/lib-ld.m4 m4/

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	has_version =sys-libs/glibc-2.2* && filter-lfs-flags

	local myconf

	# we depend on fixed zlib, so we can disable this check to prevent redundant
	# warning (bug #61749)
	myconf="${myconf} --disable-zlib-vcheck"
	# use id utility instead of /etc/passwd parsing (bug #72540)
	myconf="${myconf} --enable-id-check"
	use milter && {
		myconf="${myconf} --enable-milter"
		use mailwrapper && \
			myconf="${myconf} --with-sendmail=/usr/sbin/sendmail.sendmail"
	}

	ht_fix_file configure
	econf ${myconf} \
		$(use_enable bzip2) \
		$(use_enable nls) \
		$(use_with iconv) \
		--disable-experimental \
		--with-dbdir=/var/lib/clamav || die
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS NEWS README ChangeLog FAQ
	newconfd "${FILESDIR}"/clamd.conf clamd
	newinitd "${FILESDIR}"/clamd.rc clamd
	dodoc "${FILESDIR}"/clamav-milter.README.gentoo

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
		-e "s:^\#\(LogTime\).*:\1 yes:" \
		-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
		"${D}"/etc/clamd.conf

	# Do the same for /etc/freshclam.conf
	sed -i -e "s:^\(Example\):\# \1:" \
		-e "s:.*\(PidFile\) .*:\1 /var/run/clamav/freshclam.pid:" \
		-e "s:.*\(DatabaseOwner\) .*:\1 clamav:" \
		-e "s:^\#\(UpdateLogFile\) .*:\1 /var/log/clamav/freshclam.log:" \
		-e "s:^\#\(NotifyClamd\).*:\1 /etc/clamd.conf:" \
		-e "s:^\#\(ScriptedUpdates\).*:\1 yes:" \
		-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
		"${D}"/etc/freshclam.conf

	if use milter ; then
		echo "
START_MILTER=no
MILTER_NICELEVEL=19" \
			>> "${D}"/etc/conf.d/clamd
		echo "MILTER_SOCKET=\"/var/run/clamav/clmilter.sock\"" \
			>>"${D}"/etc/conf.d/clamd
		echo "MILTER_OPTS=\"-m 10 --timeout=0\"" \
			>>"${D}"/etc/conf.d/clamd
	fi

	diropts ""
	dodir /etc/logrotate.d
	insopts -m0644
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_postinst() {
	echo
	if use milter ; then
		elog "For simple instructions how to setup the clamav-milter"
		elog "read /usr/share/doc/${PF}/clamav-milter.README.gentoo.gz"
		echo
	fi
	ewarn "The soname for libclamav has changed in clamav-0.94."
	ewarn "If you have upgraded from that or earlier version, it is"
	ewarn "recommended to run revdep-rebuild, in order to fix anything"
	ewarn "that links against libclamav.so library."
	echo
}
