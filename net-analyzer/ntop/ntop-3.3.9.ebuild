# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ntop/ntop-3.3.9.ebuild,v 1.1 2009/02/16 22:17:28 mrness Exp $

inherit eutils autotools

DESCRIPTION="tool that shows network usage like top"
HOMEPAGE="http://www.ntop.org/ntop.html"
SRC_URI="mirror://sourceforge/ntop/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="ipv6 nls ssl tcpd"
#snmp support is disabled

#snmp? ( net-analyzer/net-snmp )
COMMON_DEPEND="sys-apps/gawk
	dev-lang/perl
	sys-libs/gdbm
	net-libs/libpcap
	media-libs/gd
	media-libs/libpng
	net-analyzer/rrdtool
	ssl? ( dev-libs/openssl )
	tcpd? ( sys-apps/tcp-wrappers )
	sys-libs/zlib
	dev-libs/geoip"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/libtool-1.4
	net-misc/wget" # needed for downloading GeoIP data

# Needed by xmldumpPlugin - couldn't get it to work
#	dev-libs/gdome2
#	>=dev-libs/glib-2"
RDEPEND="${COMMON_DEPEND}
	media-fonts/corefonts
	media-gfx/graphviz"

pkg_setup() {
	# snmp doesn't compile in this release, disabled for now
	#if use snmp ; then
	#	ewarn "snmp plugin is under development and upstream does not recommend"
	#	ewarn "it for usage in production environment."
	#	if ! use ipv6 ; then
	#		echo
	#		eerror "snmp plugin has compilation problems without ipv6 support."
	#		eerror "For additional information see bug #121497."
	#		die "snmp without ipv6 is broken"
	#	else
	#		if ! built_with_use net-analyzer/net-snmp ipv6 ; then
	#			echo
	#			eerror "You have both ipv6 and snmp enabled."
	#			eerror "This require ipv6 support in net-analyzer/net-snmp."
	#			eerror "However, net-analyzer/net-snmp was compiled with ipv6 flag disabled."
	#			eerror "Please, re-emerge net-analyzer/net-snmp with USE=\"ipv6\"."
	#			die "net-analyzer/net-snmp was build without ipv6."
	#		fi
	#	fi
	#fi

	enewgroup ntop
	enewuser ntop -1 -1 /var/lib/ntop ntop
}

src_unpack() {
	unpack ${A}

	cd "${S}"

	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-external-geoip.patch
	cat acinclude.m4.in acinclude.m4.ntop > acinclude.m4
	eautoreconf
}

src_compile() {
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
		$(use_with ssl) $(use_enable ssl sslwatchdog) \
		$(use_with tcpd tcpwrapper) \
		--with-rrd-home=/usr/lib \
		--disable-snmp \
		|| die "configure problem"
		# $(use_enable snmp)
	emake || die "compile problem"
}

src_install() {
	LC_ALL=C # apparently doesn't work with some locales (#191576 and #205382)
	emake DESTDIR="${D}" install || die "install problem"

	keepdir /var/lib/ntop &&
		fowners ntop:ntop /var/lib/ntop &&
		fperms 750 /var/lib/ntop &&
		mv "${D}"/etc/ntop/Geo*.dat "${D}"/var/lib/ntop ||
		die "failed to prepare /var/lib/ntop dir"

	dodoc AUTHORS CONTENTS ChangeLog MANIFESTO NEWS
	dodoc PORTING README SUPPORT_NTOP.txt THANKS $(find docs -type f)

	newinitd "${FILESDIR}"/ntop-initd ntop
	newconfd "${FILESDIR}"/ntop-confd ntop
}

pkg_postinst() {
	elog "You need to set a password first by running"
	elog "ntop --set-admin-password"
}
