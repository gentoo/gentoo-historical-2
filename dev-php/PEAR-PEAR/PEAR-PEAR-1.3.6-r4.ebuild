# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PEAR/PEAR-PEAR-1.3.6-r4.ebuild,v 1.1 2006/01/18 06:37:04 sebastian Exp $

inherit depend.php

ARCHIVE_TAR="1.3.1"
CONSOLE_GETOPT="1.2"
PEAR="1.3.6"
XML_RPC="1.4.5"

[ -z "${PEAR_CACHEDIR}" ] && PEAR_CACHEDIR="/tmp/pear/cache"

DESCRIPTION="PEAR Base System (PEAR, Archive_Tar, Console_Getopt, XML_RPC)."
HOMEPAGE="http://pear.php.net/"
SRC_URI="http://pear.php.net/get/Archive_Tar-${ARCHIVE_TAR}.tgz
		http://pear.php.net/get/Console_Getopt-${CONSOLE_GETOPT}.tgz
		http://pear.php.net/get/XML_RPC-${XML_RPC}.tgz
		http://pear.php.net/get/PEAR-${PEAR}.tgz"

LICENSE="PHP"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""

# we deliberately force people to remove their old PEAR installations,
# and any package which may have put an old-style PEAR installation onto
# the box

DEPEND="dev-lang/php
		!dev-php/php
		!dev-php/php-cgi
		!dev-php/mod_php
		!<dev-php/PEAR-PEAR-1.3.6-r2
		!dev-php/PEAR-Archive_Tar
		!dev-php/PEAR-Console_Getopt
		!dev-php/PEAR-XML_RPC"

pkg_setup() {
	# we call this here, to ensure that the eclass picks the right
	# version of php for the job
	require_php_cli

	# we check that PHP was compiled with the correct USE flags
	if [[ ${PHP_VERSION} == "4" ]] ; then
		require_php_with_use cli pcre expat zlib
	else
		require_php_with_use cli pcre xml zlib
	fi
}

src_install() {
	require_php_cli

	# Prevent SNMP related sandbox violoation.
	addpredict /usr/share/snmp/mibs/.index
	addpredict /var/lib/net-snmp/

	mkdir -p "${WORKDIR}/PEAR/XML/RPC"

	# Install PEAR Package.
	cp -r "${WORKDIR}/PEAR-${PEAR}/OS" "${WORKDIR}/PEAR/"
	cp -r "${WORKDIR}/PEAR-${PEAR}/PEAR" "${WORKDIR}/PEAR/"
	cp "${WORKDIR}/PEAR-${PEAR}/PEAR.php" "${WORKDIR}/PEAR/PEAR.php"
	cp "${WORKDIR}/PEAR-${PEAR}/System.php" "${WORKDIR}/PEAR/System.php"

	# Prepare /usr/bin/pear script.
	cp "${WORKDIR}/PEAR-${PEAR}/scripts/pearcmd.php" "${WORKDIR}/PEAR/pearcmd.php"
	sed -i "s:@pear_version@:${PEAR}:g" "${WORKDIR}/PEAR/pearcmd.php"
	cp "${WORKDIR}/PEAR-${PEAR}/scripts/pear.sh" "${WORKDIR}/PEAR/pear"
	sed -i "s:@php_bin@:${PHPCLI}:g" "${WORKDIR}/PEAR/pear" || die
	sed -i "s:@bin_dir@:/usr/bin:g" "${WORKDIR}/PEAR/pear" || die
	sed -i "s:@php_dir@:/usr/share/php:g" "${WORKDIR}/PEAR/pear" || die

	# Install Archive_Tar Package.
	cp -r "${WORKDIR}/Archive_Tar-${ARCHIVE_TAR}/Archive" "${WORKDIR}/PEAR/Archive"

	# Install Console_Getopt Package.
	cp -r "${WORKDIR}/Console_Getopt-${CONSOLE_GETOPT}/Console" "${WORKDIR}/PEAR/"

	# Install XML_RPC Package.
	cp "${WORKDIR}/XML_RPC-${XML_RPC}/RPC.php" "${WORKDIR}/PEAR/XML/RPC.php"
	cp "${WORKDIR}/XML_RPC-${XML_RPC}/Server.php" "${WORKDIR}/PEAR/XML/RPC/Server.php"

	# Finalize installation.
	cd "${WORKDIR}/PEAR"
	insinto /usr/share/php
	doins -r Archive Console OS PEAR XML *.php
	dobin pear

	insinto /etc
	doins "${FILESDIR}/pear.conf"
	sed -e "s|s:SOBSTLEN:\"SOBSTITUTEME\"|s:${#PHPCLI}:\"${PHPCLI}\"|g" -i "${D}/etc/pear.conf"

	keepdir "${PEAR_CACHEDIR}"
	fperms 755 "${PEAR_CACHEDIR}"
}

pkg_postinst() {
	if has_version "<${PV}" ; then
		ewarn "The location of the local PEAR repository has been changed"
		ewarn "from /usr/lib/php to /usr/share/php."
	fi
}
