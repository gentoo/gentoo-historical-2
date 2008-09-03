# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/apcupsd/apcupsd-3.12.4.ebuild,v 1.9 2008/09/03 07:25:44 opfer Exp $

WEBAPP_MANUAL_SLOT="yes"
inherit eutils webapp

DESCRIPTION="APC UPS daemon with integrated tcp/ip remote shutdown"
HOMEPAGE="http://www.apcupsd.org/"
SRC_URI="mirror://sourceforge/apcupsd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE="doc snmp usb cgi threads ncurses nls"

DEPEND="doc? ( virtual/latex-base dev-tex/latex2html )
	cgi? ( >=media-libs/gd-1.8.4 )
	ncurses? ( sys-libs/ncurses )
	nls? ( sys-devel/gettext )
	snmp? ( net-analyzer/net-snmp )"
RDEPEND="${DEPEND}
	virtual/mta"

pkg_setup() {
	use cgi && webapp_pkg_setup
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PV}/apcupsd.in.patch
	epatch "${FILESDIR}"/${PV}/etc.patch
	epatch "${FILESDIR}"/${PV}/exit-status-build.patch
	epatch "${FILESDIR}"/${PV}/no-strip.patch
	epatch "${FILESDIR}"/${PV}/no-parallel.patch
	epatch "${FILESDIR}"/${PV}/${PN}-snmp.patch
}

src_compile() {
	local myconf
	use cgi && myconf="${myconf} --enable-cgi --with-cgi-bin=${MY_CGIBINDIR}"
	use usb && myconf="${myconf} --with-upstype=usb --with-upscable=usb --enable-usb"
	use !usb && myconf="${myconf} --with-upstype=apcsmart --with-upscable=apcsmart --disable-usb"

	# We force the DISTNAME to gentoo so it will use gentoo's layout also
	# when installed on non-linux systems.
	DISTNAME=gentoo APCUPSD_MAIL=/usr/sbin/sendmail ./configure \
		--prefix=/usr \
		--sbindir=/sbin \
		--mandir=/usr/share/man \
		--sysconfdir=/etc/apcupsd \
		--with-pwrfail-dir=/etc/apcupsd \
		--with-lock-dir=/var/lock \
		--with-pid-dir=/var/run \
		--with-log-dir=/var/log \
		--with-net-port=6666 \
		--with-nis-port=3551 \
		--enable-net \
		--enable-oldnet \
		--enable-master-slave \
		$(use_enable ncurses powerflute) \
		$(use_enable threads pthreads) \
		$(use_enable snmp net-snmp) \
		$(use_enable nls) \
		${myconf} \
		|| die
	emake || die "emake failed"

	if use doc; then
		einfo "Building full documentation..."
		cd "${S}"/doc/latex
		make texcheck tex web pdf
	fi
}

src_install() {
	use cgi && webapp_src_preinst

	emake DESTDIR="${D}" install || die "installed failed"
	rm -f "${D}"/etc/init.d/halt

	insinto /etc/apcupsd
	newins examples/safe.apccontrol safe.apccontrol

	dodoc ChangeLog* ReleaseNotes
	mv doc/apctest.man doc/apctest.8; doman doc/apctest.8

	if use doc; then
		einfo "Installing full documentation..."
		newdoc doc/latex/apcupsd.pdf manual.pdf
		dohtml -r doc/latex/apcupsd/*
	fi

	if use cgi; then
		mv "${D}"/etc/apcupsd/apcupsd.css "${D}"${MY_CGIBINDIR}
		webapp_src_install
	fi
}

pkg_postinst() {
	if use cgi; then
		einfo If you are upgrading from a previous version, please note
		einfo that the CGI interface is now installed using webapp-config.
		einfo /var/www/apcupsd is no longer present.
		webapp_pkg_postinst
	fi
}

pkg_prerm() {
	use cgi && webapp_pkg_prerm
}
