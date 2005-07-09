# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/resin/resin-3.0.8-r1.ebuild,v 1.6 2005/07/09 17:50:29 swegener Exp $

inherit java-pkg eutils

DESCRIPTION="A fast Servlet 2.4 and JSP 2.0 engine with EJB and distributed session load balancing."
SRC_URI="http://www.caucho.com/download/${P}.tar.gz"
HOMEPAGE="http://www.caucho.com"
KEYWORDS="x86 ~ppc ~sparc amd64 ppc64"
LICENSE="GPL-2"
SLOT="0"
DEPEND="!net-www/resin-ee"
RDEPEND=">=virtual/jdk-1.3
		dev-lang/perl"
IUSE=""

RESIN_HOME="/opt/resin"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}/wrapper.pl.diff
}

pkg_preinst() {
	enewgroup resin
	enewuser resin -1 /bin/bash /opt/resin resin
	chown -R resin:resin ${D}${RESIN_HOME}
	chown -R resin:resin ${D}/var/log/${PN}
	chown -R resin:resin ${D}/etc/resin
	# when updating from resin 2, move things to there new location
	if [ ! -L ${RESIN_HOME}/conf ]; then
		if [ ! -d /etc/resin ]; then
			mkdir /etc/resin
			chown resin:resin /etc/resin
		fi
		mv ${RESIN_HOME}/conf/ /etc/resin/conf.old
	fi
}

src_compile() {
	./configure --prefix=${D}${RESIN_HOME}
	make
}

src_install() {
	dodir ${RESIN_HOME} /etc/resin
	cp -r libexec bin webapps doc ${D}${RESIN_HOME}

	dodir /etc/resin
	cp -r conf/* ${D}/etc/resin/
	dosym /etc/resin ${RESIN_HOME}/conf

	dodir /var/log/${PN}
	dosym /var/log/${PN} ${RESIN_HOME}/logs
	keepdir /var/log/${PN}/

	# INIT SCRIPTS AND ENV
	insinto /etc/init.d ; insopts -m0750 ; newins ${FILESDIR}/${PV}/resin.init resin
	insinto /etc/conf.d ; insopts -m0755 ; newins ${FILESDIR}/${PV}/resin.conf resin
	insinto /etc/env.d  ; insopts -m0755 ; doins ${FILESDIR}/${PV}/21resin

	dodoc LICENSE readme.txt
	java-pkg_dojar ${S}/lib/*.jar

	dosym /usr/share/${PN}/lib ${RESIN_HOME}/lib
}

pkg_postinst() {
	einfo
	einfo " NOTICE!"
	einfo " User and group 'resin' have been added."
	einfo
	einfo " FILE LOCATIONS:"
	einfo " 1.  Resin home directory: ${RESIN_HOME}"
	einfo "     Contains application data, configuration files."
	einfo " 2.  Runtime settings: /etc/conf.d/resin"
	einfo "     Contains CLASSPATH and JAVA_HOME settings."
	einfo " 3.  Logs:  /var/log/resin/"
	einfo " 4.  Executables, libraries:  /usr/share/resin/"
	einfo
	einfo "If you are updating from resin-2* your old configuration files"
	einfo "have been moved to /etc/resin/conf.old"
	einfo
	einfo " STARTING AND STOPPING RESIN:"
	einfo "   /etc/init.d/resin start"
	einfo "   /etc/init.d/resin stop"
	einfo "   /etc/init.d/resin restart"
	einfo
	einfo " NETWORK CONFIGURATION:"
	einfo " By default, Resin runs on port 8080.  You can change this"
	einfo " value by editing ${RESIN_HOME}/conf/resin.conf."
	einfo
	einfo " To test Resin while it's running, point your web browser to:"
	einfo " http://localhost:8080/"
	einfo
	einfo " Resin cannot run on port 80 as non-root (as of this time)."
	einfo " The best way to get Resin to respond on port 80 is via port"
	einfo " forwarding -- by installing a firewall on the machine running"
	einfo " Resin or the network gateway.  Simply redirect port 80 to"
	einfo " port 8080."
	einfo
	einfo " BUGS:"
	einfo " Please file any bugs at http://bugs.gentoo.org/ or else it"
	einfo " may not get seen.  Thank you."
	einfo
}

pkg_postrm() {
	einfo "You may want to remove the resin user and group"
}

