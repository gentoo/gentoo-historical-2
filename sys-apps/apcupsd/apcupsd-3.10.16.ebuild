# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/apcupsd/apcupsd-3.10.16.ebuild,v 1.1 2004/11/12 01:07:37 tantive Exp $

inherit eutils

DESCRIPTION="APC UPS daemon with integrated tcp/ip remote shutdown"
HOMEPAGE="http://www.sibbald.com/apcupsd/"
SRC_URI="mirror://sourceforge/apcupsd/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~ppc ~sparc"
IUSE="doc snmp usb apache2"

DEPEND=">=sys-apps/baselayout-1.8.4
	virtual/libc
	virtual/mta
	snmp? ( virtual/snmp )
	>=media-libs/gd-1.8.4
	sys-libs/ncurses"
RDEPEND="${DEPEND}
	usb? ( sys-apps/hotplug )"

XPIDDIR=/var/run
XLOGDIR=/var/log
XLOCKDIR=/var/lock
XSYSCONFDIR=/etc/apcupsd
XPWRFAILDIR=${XSYSCONFDIR}

src_unpack() {
	unpack ${A}
	cd ${S}/platforms/gentoo
	epatch ${FILESDIR}/${PV}/apcupsd.in.patch
	cd ${S}
	if has_version net-analyzer/ucd-snmp; then
	    epatch ${FILESDIR}/${PV}/ucd-snmp.patch
	    fi
}

src_compile() {
	local myconf
	use snmp && myconf="--enable-net-snmp"
	APCUPSD_MAIL=/usr/sbin/sendmail ./configure \
		--prefix=/usr \
		--sbindir=/usr/sbin \
		--sysconfdir=${XSYSCONFDIR} \
		--with-pwrfail-dir=${XPWRFAILDIR} \
		--with-lock-dir=${XLOCKDIR} \
		--with-pid-dir=${XPIDDIR} \
		--with-log-dir=${XLOGDIR} \
		--with-upstype=usb \
		--with-upscable=usb \
		--with-serial-dev=/dev/usb/hiddev[0-9] \
		--with-net-port=6666 \
		--with-nis-port=3551 \
		--enable-usb \
		--enable-net \
		--enable-oldnet \
		--enable-master-slave \
		--enable-powerflute \
		--enable-pthreads \
		--with-css-dir=/var/www/apcupsd \
		--with-cgi-bin=/var/www/apcupsd \
		--enable-cgi \
		${myconf} \
		|| die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die "installed failed"

	use apache2 || insinto /etc/apache/conf/addon-modules
	use apache2 || newins  ${FILESDIR}/${PV}/apache.conf apcupsd.conf

	use apache2 && insinto /etc/apache2/conf/modules.d
	use apache2 && newins ${FILESDIR}/${PV}/apache.conf 60_apcupsd.conf

	insinto /etc/apcupsd
	newins examples/safe.apccontrol safe.apccontrol

	cd ${D}/etc/apcupsd
	epatch ${FILESDIR}/${PV}/smtp.patch

	ln -s onbattery powerout

	if use doc
	then
		einfo "Installing full documentation into /usr/share/doc/${P}..."
		cd ${S}/doc
		dodoc README.*
		docinto developers_manual
		dodoc developers_manual/*
		docinto logo
		dodoc logo/*
		docinto manual
		dodoc manual/*
		docinto old_documents
		dodoc old_documents/*
		docinto vim
		dodoc vim/*
	fi
}
