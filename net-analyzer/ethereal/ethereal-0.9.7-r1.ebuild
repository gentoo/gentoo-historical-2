# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ethereal/ethereal-0.9.7-r1.ebuild,v 1.2 2002/12/10 21:19:30 mholzer Exp $

IUSE="gtk ipv6 snmp ssl gtk2"

S=${WORKDIR}/${P}
DESCRIPTION="A commercial-quality network protocol analyzer"
SRC_URI="http://www.ethereal.com/distribution/old-versions/${P}.tar.bz2"
HOMEPAGE="http://www.ethereal.com/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

RDEPEND=">=sys-libs/zlib-1.1.4
	( gtk2? >=dev-libs/glib-2.0.4 :
		=dev-libs/glib-1.2* )
	snmp? ( >=net-analyzer/ucd-snmp-4.2.5 )
	gtk2? ( =x11-libs/gtk+-2.0* )
	gtk? ( =x11-libs/gtk+-1.2* )
	ssl? ( >=dev-libs/openssl-0.9.6e )"

DEPEND="${RDEPEND}
	sys-devel/perl
	sys-devel/bison
	sys-devel/flex
	>=net-libs/libpcap-0.7.1"

src_unpack() {

	unpack ${A}
	cd ${S}

	# gcc related configure script braindamage
	mv configure configure.broken
	sed "s|-I/usr/local/include||" configure.broken > configure
	chmod +x ./configure

}

src_compile() {
	local myconf
	use gtk || myconf="${myconf} --disable-ethereal"
# carefully override the -gtk option if gtk2 is set.	
	use gtk2 && myconf="--enable-gtk2"  
	use ssl || myconf="${myconf} --without-ssl"
	use snmp || myconf="${myconf} --without-ucdsnmp"
	use ipv6 && myconf="${myconf} --enable-ipv6"

	if use snmp
	    then addwrite "/usr/share/snmp/mibs/"
	fi    
	
	econf \
		--enable-pcap \
		--enable-zlib \
		--enable-tethereal \
		--enable-editcap \
		--enable-mergecap \
		--enable-text2cap \
		--enable-idl2eth \
		--enable-dftest \
		--enable-randpkt \
		--sysconfdir=/etc/ethereal \
		--with-plugindir=/usr/lib/ethereal/plugins/${PV} \
		${myconf} || die "bad ./configure"
                
	emake || die "compile problem"
}

src_install() {
	dodir /usr/lib/ethereal/plugins/${PV}

	einstall \
		datadir=${D}/usr/share \
		sysconfdir=${D}/etc/ethereal \
		plugindir=${D}/usr/lib/ethereal/plugins/${PV} || die

	dodoc AUTHORS COPYING ChangeLog INSTALL.* NEWS README* TODO
}
