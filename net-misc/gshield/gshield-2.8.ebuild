# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/gshield/gshield-2.8.ebuild,v 1.1 2002/10/17 16:56:38 chouser Exp $

# re-capitalize gShield
P=gShield-${P#*-}

DESCRIPTION="iptables firewall configuration system"
HOMEPAGE="http://muse.linuxmafia.org/gshield.html"
SRC_URI="ftp://muse.linuxmafia.org/pub/gShield/v2/${P}.tgz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86"
DEPEND="sys-apps/iptables"

src_install () {
	# config files
	mkdir -p ${D}/etc/gshield
	cp -a * ${D}/etc/gshield
	ln -s gshield ${D}/etc/firewall

	# get rid of docs from config
	rm -rf ${D}/etc/gshield/{Changelog,INSTALL,LICENSE,docs}

	# move non-config stuff out of config, but make symlinks
	mkdir -p ${D}/usr/share/gshield/routables
	for q in gShield-version gShield.rc tools sourced routables/routable.rules
	do
		mv ${D}/etc/gshield/$q ${D}/usr/share/gshield/
		ln -s /usr/share/gshield/$q ${D}/etc/gshield/$q
	done
	chmod -R u+rwX ${D}/etc/gshield

	# install init script
	mkdir -p ${D}/etc/init.d
	cp ${FILESDIR}/gshield.init ${D}/etc/init.d/gshield
	chmod -R u+rwx ${D}/etc/init.d/gshield

	# docs
	dodoc Changelog INSTALL LICENSE docs/*
}

pkg_postinst () {
	einfo
	einfo "Before running /etc/init.d/gshield or adding it to a runlevel with"
	einfo "rc-update, be sure to edit the firewall config file so that it will"
	einfo "work for your site:"
	einfo "  ${EDITOR} /etc/gshield/gShield.conf"
	einfo
}
