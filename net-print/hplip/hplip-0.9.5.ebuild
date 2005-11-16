# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/hplip/hplip-0.9.5.ebuild,v 1.3 2005/11/16 09:25:05 lu_zero Exp $

inherit eutils

DB_V=1.5-20050925
DESCRIPTION="HP Linux Imaging and Printing System. Includes net-print/hpijs, scanner drivers and service tools."
HOMEPAGE="http://hpinkjet.sourceforge.net/"
SRC_URI="mirror://sourceforge/hpinkjet/${P}.tar.gz
	foomaticdb? ( http://www.linuxprinting.org/download/foomatic/foomatic-db-hpijs-${DB_V}.tar.gz )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc ~x86"
IUSE="foomaticdb snmp X qt ppds scanner cups usb"

DEPEND="dev-lang/python
	snmp? ( >=net-analyzer/net-snmp-5.0.9 )
	!net-print/hpijs
	!net-print/hpoj"

RDEPEND="virtual/ghostscript
	>=dev-lang/python-2.2.0
	scanner? (
		>=media-gfx/sane-backends-1.0.9
		|| (
			X? ( >=media-gfx/xsane-0.89 )
			>=media-gfx/sane-frontends-1.0.9
		)
	)
	qt? ( >=dev-python/PyQt-3.11 =x11-libs/qt-3* )
	usb? ( >=dev-libs/libusb-0.1.10a sys-apps/hotplug )
	foomaticdb? ( net-print/foomatic )
	cups? ( net-print/cups )
	${DEPEND}"

src_unpack() {
	unpack ${A}
	sed -i -e "s:(uint32_t)0xff000000) >> 24))):(uint32_t)0xff000000) >> 24):" \
		${S}/scan/sane/mfpdtf.h
}
src_compile() {
	myconf="${myconf} --disable-cups-install --disable-foomatic-install"

	use snmp || myconf="${myconf} --disable-network-build"

	econf ${myconf} || die "Error: econf failed!"
	emake || die "Error: emake failed!"
}


src_install() {
	make DESTDIR=${D} install

	exeinto /etc/init.d
	newexe ${FILESDIR}/hplip.init.d hplip

	if use scanner; then
		insinto /etc/sane.d
		echo "hpaio" > dll.conf
		doins dll.conf

		dodir /usr/lib/sane
		dosym /usr/lib/libsane-hpaio.la /usr/lib/sane/libsane-hpaio.la
		dosym /usr/lib/libsane-hpaio.so /usr/lib/sane/libsane-hpaio.so
		dosym /usr/lib/libsane-hpaio.so.1 /usr/lib/sane/libsane-hpaio.so.1
		dosym /usr/lib/libsane-hpaio.so.1.0.0 /usr/lib/sane/libsane-hpaio.so.1.0.0
	else
		rm -f ${D}/usr/lib/libsane-hpaio.la
		rm -f ${D}/usr/lib/libsane-hpaio.so
		rm -f ${D}/usr/lib/libsane-hpaio.so.1
		rm -f ${D}/usr/lib/libsane-hpaio.so.1.0.0
	fi

	if use ppds; then
		dodir /usr/share
		mv ${S}/prnt/hpijs/ppd ${D}/usr/share
	fi

	if use cups && use ppds ; then
		dodir /usr/share/cups/model
		dosym /usr/share/ppd /usr/share/cups/model/foomatic-ppds
	fi

	[ -e /usr/bin/foomatic-rip ] && rm -f ${D}/usr/bin/foomatic-rip

	if use foomaticdb ; then
		cd ../foomatic-db-hpijs-${DB_V}
		econf || die "econf failed"
		rm -fR data-generators/hpijs-rss
		make || die
		make DESTDIR=${D} install || die
	fi

	dodir /usr/share/applications
	mv ${D}/usr/share/hplip/data/hplip.desktop ${D}/usr/share/applications
}
