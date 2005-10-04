# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/dansguardian-dgav/dansguardian-dgav-6.4.3.ebuild,v 1.1 2005/10/04 21:01:07 mrness Exp $

inherit eutils

DG_PN=${PN/-*/}
AV_PN=${PN/*-/}
DG_PV=2.8.0.6

DESCRIPTION="DansGuardian with Anti-Virus plugin"
HOMEPAGE="http://sourceforge.net/projects/dgav/"
SRC_URI="http://mirror.dansguardian.org/downloads/2/Stable/${DG_PN}-${DG_PV}.source.tar.gz
	mirror://sourceforge/${AV_PN}/${DG_PN}-${DG_PV}-antivirus-${PV}.patch.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""
DEPEND="!net-proxy/dansguardian
	virtual/libc
	net-libs/libesmtp
	app-antivirus/clamav"

S="${WORKDIR}/${DG_PN}-${DG_PV}"

src_unpack() {
	unpack ${A}

	cd ${S} || die "source dir not found"
	epatch ${FILESDIR}/dansguardian-xnaughty-2.7.6-1.diff
	epatch ../${DG_PN}-${DG_PV}-antivirus-${PV}.patch

	#fix path to gentoo clamd socket
	sed -i -e "s:clamdsocket *= *'/tmp/clamd':clamdsocket = '/var/run/clamav/clamd.sock':" configure
}

src_compile() {
	./configure \
		--prefix= \
		--installprefix=${D} \
		--mandir=/usr/share/man/ \
		--cgidir=/var/www/localhost/cgi-bin/ \
		--with-av-engine=clamdscan \
		--runas_usr=clamav --runas_grp=clamav || die "./configure failed"
	emake OPTIMISE="${CFLAGS}" || die "emake failed"
}

src_install() {
	if [ -d "/etc/logrotate.d" ]; then
		dodir /etc/logrotate.d
	fi
	make install || die "make install failed"

	exeinto /etc/init.d
	newexe ${FILESDIR}/dansguardian.init dansguardian
	rm -rf ${D}/etc/rc.d
	sed -i -e 's/rc.d\///' ${D}/etc/dansguardian/logrotation #Fixing location of initscript

	dodoc README*

	#Create log directory
	diropts -m0700 -o clamav
	keepdir /var/log/dansguardian
}
