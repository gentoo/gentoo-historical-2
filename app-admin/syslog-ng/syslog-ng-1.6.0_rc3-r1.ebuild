# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/syslog-ng/syslog-ng-1.6.0_rc3-r1.ebuild,v 1.13 2004/06/24 21:39:18 agriffis Exp $

# The release candidates are named syslog-ng-1.6.0rc1 for example
MY_P=${P/_/}
S=${WORKDIR}/${MY_P}
DESCRIPTION="syslog replacement with advanced filtering features"
HOMEPAGE="http://www.balabit.com/products/syslog_ng/"
SRC_URI="http://www.balabit.com/downloads/syslog-ng/${PV%.*}/src/old/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha hppa amd64 ia64"
IUSE="tcpd"

RDEPEND=">=dev-libs/libol-0.3.9
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )"
DEPEND="${RDEPEND}
	sys-devel/flex"
PROVIDE="virtual/logger"

src_unpack() {
	unpack ${A}
	cd ${S}/doc/sgml
	tar xfz syslog-ng.html.tar.gz
}

src_compile() {
	local myconf
	use tcpd && myconf="--enable-tcp-wrapper"

	econf ${myconf} || die "econf failed"
	emake prefix=${D}/usr all || die "emake failed"
}

src_install() {
	einstall || die

	prepallman

#	rm -rf ${D}/usr/share/man
#	doman doc/{syslog-ng.8,syslog-ng.conf.5}

	dodoc AUTHORS ChangeLog INSTALL NEWS PORTS README
	dodoc doc/{syslog-ng.conf.sample,syslog-ng.conf.demo,stresstest.sh}
	dodoc doc/sgml/{syslog-ng.dvi,syslog-ng.ps,syslog-ng.sgml,syslog-ng.txt}
	dodoc contrib/syslog2ng
	dohtml doc/sgml/syslog-ng.html/*

	# Install default configuration
	dodir /etc/syslog-ng
	insinto /etc/syslog-ng
	newins ${FILESDIR}/syslog-ng.conf.gentoo syslog-ng.conf

	# Install snippet for logrotate, which may or may not be installed
	dodir /etc/logrotate.d
	insinto /etc/logrotate.d
	newins ${FILESDIR}/syslog-ng.logrotate syslog-ng

	exeinto /etc/init.d
	newexe ${FILESDIR}/syslog-ng.rc6 syslog-ng
}

pkg_postinst() {
	einfo "As of syslog-ng-1.6.0_rc1-r1, this ebuild now installs a"
	einfo "default configuration instead of a sample configuration.  It"
	einfo "should now be usable out of the box."
	einfo "To convert your existing syslog.conf for use with syslog-ng,"
	einfo "use the syslog2ng script in /usr/share/doc/${PF}."
}
