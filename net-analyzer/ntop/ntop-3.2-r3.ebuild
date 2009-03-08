# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ntop/ntop-3.2-r3.ebuild,v 1.13 2009/03/08 10:31:35 cla Exp $

EAPI="2"

inherit eutils autotools

DESCRIPTION="tool that shows network usage like top"
HOMEPAGE="http://www.ntop.org/ntop.html"
SRC_URI="mirror://sourceforge/ntop/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ~ia64 ppc ~ppc64 sh sparc s390 x86"
IUSE="ipv6 nls snmp ssl tcpd zlib"

COMMON_DEPEND="sys-apps/gawk
	>=sys-libs/gdbm-1.8.0
	net-libs/libpcap
	>=media-libs/gd-2.0.22
	>=media-libs/libpng-1.2.5
	snmp? ( net-analyzer/net-snmp[ipv6] )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r4 )
	zlib? ( sys-libs/zlib )"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/libtool-1.4"

# Needed by xmldumpPlugin - couldn't get it to work
#	dev-libs/gdome2
#	>=dev-libs/glib-2"

RDEPEND="${COMMON_DEPEND}
	media-gfx/graphviz"

pkg_setup() {
	if use snmp ; then
		ewarn "snmp plugin is under development and upstream does not recommend"
		ewarn "it for usage in production environment."
		if ! use ipv6 ; then
			echo
			eerror "snmp plugin has compilation problems without ipv6 support."
			eerror "For additional information see bug #121497."
			die "snmp without ipv6 is broken"
		fi
	fi
	enewgroup ntop
	enewuser ntop -1 -1 /var/lib/ntop ntop
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/globals-core.c.diff
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-snmp.patch
	eautoreconf

	sed -i \
		-e "s@/usr/local/bin/dot@/usr/bin/dot@" report.c || die "sed failed"
}

src_configure() {
	# force disable xmldumpPlugin
	export \
		ac_cv_header_glib_h=no \
		ac_cv_header_glibconfig_h=no \
		ac_cv_header_gdome_h=no \
		ac_cv_lib_glib_g_date_julian=no \
		ac_cv_lib_xml2_xmlCheckVersion=no \
		ac_cv_lib_gdome_gdome_di_saveDocToFile=no

	econf \
		$(use_enable ipv6) \
		$(use_enable nls i18n) \
		$(use_enable snmp) \
		$(use_with ssl) $(use_enable ssl sslv3) $(use_enable ssl sslwatchdog) \
		$(use_with tcpd) \
		$(use_with zlib) \
		|| die "configure problem"
}

src_install() {
	emake DESTDIR="${D}" install || die "install problem"

	keepdir /var/lib/ntop

	dodoc AUTHORS CONTENTS ChangeLog MANIFESTO NEWS
	dodoc PORTING README SUPPORT_NTOP.txt THANKS $(find docs -type f)

	newinitd "${FILESDIR}"/ntop-initd ntop
	newconfd "${FILESDIR}"/ntop-confd ntop
}

pkg_postinst() {
	fowners ntop:ntop /var/lib/ntop
	fperms 750 /var/lib/ntop

	elog "You need to set a password first by running"
	elog "ntop --set-admin-password"
}
