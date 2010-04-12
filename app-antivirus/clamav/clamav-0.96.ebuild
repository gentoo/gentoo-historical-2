# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/clamav/clamav-0.96.ebuild,v 1.3 2010/04/12 13:12:18 fauli Exp $

EAPI=2

inherit eutils flag-o-matic fixheadtails multilib versionator

# for when rc1 is appended to release candidates:
MY_PV=$(replace_version_separator 3 '');
MY_P="${PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Clam Anti-Virus Scanner"
HOMEPAGE="http://www.clamav.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="bzip2 clamdtop iconv milter selinux ipv6"

COMMON_DEPEND="bzip2? ( app-arch/bzip2 )
	milter? ( || ( mail-filter/libmilter mail-mta/sendmail ) )
	iconv? ( virtual/libiconv )
	clamdtop? ( sys-libs/ncurses )
	>=sys-libs/zlib-1.2.1-r3
	>=sys-apps/sed-4"

DEPEND="${COMMON_DEPEND}
	>=dev-util/pkgconfig-0.20"

RDEPEND="${COMMON_DEPEND}
	selinux? ( sec-policy/selinux-clamav )
	sys-apps/grep"

PROVIDE="virtual/antivirus"

RESTRICT="test"

pkg_setup() {
	enewgroup clamav
	enewuser clamav -1 -1 /dev/null clamav
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.95.1-nls.patch"
}

src_configure() {
	has_version =sys-libs/glibc-2.2* && filter-lfs-flags

	ht_fix_file configure
	econf  \
		$(use_enable bzip2) \
		$(use_enable ipv6) \
		$(use_enable clamdtop) \
		$(use_enable milter) \
		$(use_with iconv) \
		--disable-experimental \
		--enable-id-check \
		--disable-zlib-vcheck \
		--with-dbdir=/var/lib/clamav || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS NEWS README ChangeLog FAQ
	newconfd "${FILESDIR}/clamd.conf" clamd
	newinitd "${FILESDIR}/clamd.rc" clamd

	dodir /var/run/clamav
	keepdir /var/run/clamav
	fowners clamav:clamav /var/run/clamav
	dodir /var/log/clamav
	keepdir /var/log/clamav
	fowners clamav:clamav /var/log/clamav

	# Modify /etc/clamd.conf to be usable out of the box
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

	if use milter; then
		# And again same for /etc/clamav-milter.conf
		# MilterSocket one to include ' /' because there is a 2nd line for
		# inet: which we want to leave
		dodoc "${FILESDIR}/clamav-milter.README.gentoo"

		sed -i -e "s:^\(Example\):\# \1:" \
			-e "s:.*\(PidFile\) .*:\1 /var/run/clamav/clamav-milter.pid:" \
			-e "s+^\#\(ClamdSocket\) .*+\1 unix:/var/run/clamav/clamd.sock+" \
			-e "s:.*\(User\) .*:\1 clamav:" \
			-e "s+^\#\(MilterSocket\) /.*+\1 unix:/var/run/clamav/clamav-milter.sock+" \
			-e "s:^\#\(AllowSupplementaryGroups\).*:\1 yes:" \
			-e "s:^\#\(LogFile\) .*:\1 /var/log/clamav/clamav-milter.log:" \
			"${D}"/etc/clamav-milter.conf
	fi

	if use milter ; then
		cat << EOF >> "${D}"/etc/conf.d/clamd
MILTER_NICELEVEL=19
START_MILTER=no
EOF
	fi

	diropts ""
	dodir /etc/logrotate.d
	insopts -m0644
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate ${PN}
}

pkg_postinst() {
	if use milter ; then
		elog "For simple instructions how to setup the clamav-milter"
		elog "read the clamav-milter.README.gentoo in /usr/share/doc/${PF}"
		elog
	fi
	ewarn "The soname for libclamav has changed in clamav-0.95."
	ewarn "If you have upgraded from that or earlier version, it is"
	ewarn "recommended to run revdep-rebuild, in order to fix anything"
	ewarn "that links against libclamav.so library."
}
