# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_auth_pam/mod_auth_pam-1.1.1-r1.ebuild,v 1.1 2007/07/29 16:15:21 phreak Exp $

inherit eutils apache-module

DESCRIPTION="PAM authentication module for Apache."
HOMEPAGE="http://pam.sourceforge.net/mod_auth_pam/"
SRC_URI="http://pam.sourceforge.net/mod_auth_pam/dist/${PN}-2.0-${PV}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ppc ~sparc x86"
IUSE=""

DEPEND="sys-libs/pam"
RDEPEND="${DEPEND}"

APXS2_ARGS="-c ${PN}.c -lpam"
APACHE2_EXECFILES=".libs/mod_auth_sys_group.so"

APACHE2_MOD_CONF="10_${PN}"
APACHE2_MOD_DEFINE="AUTH_PAM"

DOCFILES="INSTALL README doc/*"

need_apache

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e 's/servicename = "httpd"/servicename = "apache2"/' "${PN}.c"
}

src_compile() {
	apache-module_src_compile
	${APXS2} -c mod_auth_sys_group.c
}

src_install() {
	apache-module_src_install
	insinto /etc/pam.d
	newins "${FILESDIR}/apache2.pam" apache2
}

pkg_postinst() {
	apache-module_pkg_postinst

	local gid=`grep ^shadow: /etc/group | cut -d: -f3`
	einfo
	einfo "If the system is configured with the shadow authentication method"
	einfo "the following commands must be executed by root to make /etc/shadow"
	einfo "accessible by the Apache webserver:"
	einfo
	if [[ -z "${gid}" ]] ; then
		einfo "    # groupadd shadow"
		einfo "    # gpasswd -a apache shadow"
	fi
	einfo "    # chgrp shadow /etc/shadow"
	einfo "    # chmod 640 /etc/shadow"
	einfo
}
