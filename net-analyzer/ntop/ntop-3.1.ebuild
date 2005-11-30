# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ntop/ntop-3.1.ebuild,v 1.1 2005/01/16 04:23:21 dragonheart Exp $

inherit gnuconfig eutils

DESCRIPTION="tool that shows network usage like top"
HOMEPAGE="http://www.ntop.org/ntop.html"
SRC_URI="mirror://sourceforge/ntop/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~hppa ~amd64 ~ppc64"
IUSE="ssl readline tcpd nls"

DEPEND="virtual/libc
	sys-apps/gawk
	>=sys-devel/libtool-1.4
	>=sys-libs/gdbm-1.8.0
	>=net-libs/libpcap-0.5.2
	>=media-libs/gd-2.0.22
	>=media-libs/libpng-1.2.5
	tcpd? ( >=sys-apps/tcp-wrappers-7.6-r4 )
	ssl? ( >=dev-libs/openssl-0.9.6 )
	readline? ( >=sys-libs/readline-4.1 )"

# Needed by xmldumpPlugin - couldn't get it to work
#	dev-libs/gdome2
#	>=dev-libs/glib-2"

pkg_setup() {
	enewgroup ntop
	enewuser ntop -1 /bin/false /var/lib/ntop ntop
}

src_unpack() {
	unpack ${A}
	mv ${WORKDIR}/ntop ${WORKDIR}/ntop-3.1
	cd ${S}
	gnuconfig_update
	epatch ${FILESDIR}/globals-core.c.diff || die "patch failed"
}

src_compile() {
	local myconf

	# Dodge include paths for glib.h, gdome.h and xmlversion.h
	sed -i -e "s:/usr/local/include:/usr/include/libxml2/libxml -I/usr/include/glib-1.2 -I/usr/include/libgdome:g" \
		configure

	use readline || myconf="${myconf} --without-readline"
	use tcpd || myconf="${myconf} --with-tcpwrap"
	if use ssl
	then
		myconf="${myconf} --enable-sslv3 --enable-sslwatchdog"

	else
		myconf="${myconf} --without-ssl"
	fi

	econf ${myconf} `use_enable nls i18n` || die "configure problem"
	emake CPPFLAGS="${CXXFLAGS}" || die "compile problem"
}

src_install() {
	make DESTDIR=${D} install || die "install problem"

	# fixme: bad handling of plugins (in /usr/lib with unsuggestive names)
	# (don't know if there is a clean way to handle it)

	doman ntop.8

	dodoc AUTHORS CONTENTS ChangeLog MANIFESTO NEWS
	dodoc PORTING README SUPPORT_NTOP.txt THANKS docs/*

	mv ${D}/usr/share/ntop/html ${D}/usr/share/doc/${PF}
	rmdir ${D}/usr/share/ntop
	chown -R root:root ${D}/etc/ntop ${D}/usr/share/doc/${PF}/html \
		${D}/usr/lib/ntop

	dohtml ntop.html

	keepdir /var/lib/ntop
	fowner ntop:ntop /var/lib/ntop
	fperms 750 /var/lib/ntop

	exeinto /etc/init.d ; newexe ${FILESDIR}/ntop-init ntop
	insinto /etc/conf.d ; newins ${FILESDIR}/ntop-confd ntop

	echo NTOP_OPTS="-u ntop -P /var/lib/ntop" >> ${D}/etc/conf.d/ntop
}

