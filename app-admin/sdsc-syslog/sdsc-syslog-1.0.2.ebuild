# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/sdsc-syslog/sdsc-syslog-1.0.2.ebuild,v 1.3 2004/06/24 21:37:38 agriffis Exp $

DESCRIPTION="SDSC Secure Syslog provides RFC3080 and RFC3081 logging services"
HOMEPAGE="http://security.sdsc.edu/software/sdsc-syslog/"
SRC_URI="mirror://sourceforge/sdscsyslog/sdscsyslogd-${PV}-src.tgz"
RESTRICT="nomirror"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86"
S=${WORKDIR}/sdscsyslogd-${PV}

# beep		= support BEEP (through RoadRunner)
# debug		= include debug info
# doc		= include documentation
# static    = link with RoadRunner statically
IUSE="beep debug doc static"

RDEPEND="beep? ( >=net-libs/roadrunner-0.9.1 )
	virtual/glibc
	dev-libs/libxml2
	sys-libs/zlib
	>=dev-libs/glib-2"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.15.0
	doc? ( >=app-doc/doxygen-1.3.2 )
	sys-apps/gawk
	sys-devel/flex
	sys-devel/bison
	>=sys-devel/automake-1.5
	>=sys-devel/autoconf-2.52"

PROVIDE="virtual/logger"

use debug && RESTRICT="${RESTRICT} nostrip"

src_compile() {
	local myconf
	use beep && ( \
		use static && myconf=`use_enable beep static-rr` \
			|| myconf=`use_with beep librr` \
	)

	econf \
		${myconf} \
		`use_enable debug debug` \
		`use_enable debug testing` \
		`use_with doc doxygen` \
		|| die "configure failed"

	# Build the logger itself ...
	emake all || die "emake failed"

	# ... and optionally generate HTML documentation
	use doc && ( emake docs || "emake failed" )
}

src_install() {
	# Makefiles seem to be OK
	einstall || die

	# Gzip potential man pages
	prepallman

	# Include normal documentation
	dodoc AUTHORS docs/TODO

	# move a few /usr/share/SDSCSyslogd files
	dodir /etc
	mv ${D}/usr/share/SDSCSyslogd/syslogd.conf* ${D}/etc
	mv ${D}/usr/share/SDSCSyslogd/* ${D}/usr/share/doc/${PF}
	rmdir ${D}/usr/share/SDSCSyslogd

	# ... and optionally doxygen-generated one
	use doc && dohtml docs/html/*
}


pkg_postinst() {

	einfo "See /etc/syslogd.conf.sample for client configuration and"
	einfo "/etc/syslogd.conf.sample-loghost for server configuration"
}
