# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/kismet/kismet-2.8.1.ebuild,v 1.9 2003/09/07 00:19:18 msterret Exp $

DESCRIPTION="Kismet is a 802.11b wireless network sniffer."
HOMEPAGE="http://www.kismetwireless.net/"
SRC_URI="http://www.kismetwireless.net/code/${P}.tar.gz
	 kismet-inits-${PV}.tar.gz
	 ethereal? (http://www.ethereal.com/distribution/old-versions/ethereal-0.9.8.tar.bz2)"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~sparc ppc"
IUSE="acpi ipv6 gps ethereal"

DEPEND="gps? ( >=dev-libs/expat-1.95.4 media-gfx/imagemagick )"
RDEPEND="net-wireless/wireless-tools"
src_compile() {
	local myconf

	myconf="`use_enable acpi`
		`use_enable ipv6`
		`use_enable gps`"

	if [ -n "`use ethereal`" ]; then
		myconf="${myconf} --with-ethereal=${WORKDIR}/ethereal-0.9.8"

		cd ${WORKDIR}/ethereal-0.9.8/wiretap
		econf || die
		emake || die
	fi

	cd ${S}
	./configure \
	    --prefix=/usr \
            --host=${CHOST} \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info \
            --datadir=/usr/share \
            --sysconfdir=/etc/kismet \
            --localstatedir=/var/lib \
            ${myconf} || die "./configure failed"

	cd ${S}/conf
	cp -f kismet.conf kismet.conf.orig
	cp -f kismet_ui.conf kismet_ui.conf.orig
	sed -e "s:/usr/local:/usr:g; \
			s:=ap_manuf:=/etc/kismet/ap_manuf:g; \
			s:=client_manuf:=/etc/kismet/client_manuf:g" \
			kismet.conf.orig > kismet.conf
	sed -e "s:/usr/local:/usr:g" kismet_ui.conf.orig > kismet_ui.conf
	rm -f kismet.conf.orig kismet_ui.conf.orig

	cd ${S}
	make dep || die "make dep for kismet failed"
	emake || die "compile of kismet failed"
}

src_install () {
	dodir /etc/kismet
	dodir /usr/bin
	make prefix=${D}/usr \
		ETC=${D}/etc/kismet MAN=${D}/usr/share/man \
		SHARE=${D}/usr/share/${PN} install || die
	dodoc CHANGELOG FAQ README docs/*

	exeinto /etc/init.d
	newexe ${WORKDIR}/kismet.initd kismet
	insinto /etc/conf.d
	newins ${WORKDIR}/kismet.confd kismet
}
